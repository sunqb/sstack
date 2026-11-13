#!/usr/bin/env bash
# sstack verify: run whatever checks this project actually has.
# Missing tools or configs are skipped. A step that runs and fails fails the script.
set -u
set -o pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 1

passed=0
skipped=0
failed=0
failures=()

is_exec() { command -v "$1" >/dev/null 2>&1; }

require_tlc() { [ -f .sstack/require-tlc ]; }
require_e2e() { [ -f .sstack/require-e2e ]; }

# Prefer a project-local tools/tlc wrapper: it can use a portable JDK at
# ~/.sstack/tools/jdk even when `java` is not on PATH.
# Prints a command prefix as one line of words
# (either "./tools/tlc", "tlc", "tlc2", or "java -XX:+UseParallelGC -cp JAR tlc2.TLC").
find_tlc_invocation() {
  if [ -x ./tools/tlc ]; then
    printf '%s\n' ./tools/tlc
    return 0
  fi
  if is_exec tlc; then
    printf '%s\n' tlc
    return 0
  fi
  if is_exec tlc2; then
    printf '%s\n' tlc2
    return 0
  fi
  if [ -x "${HOME:-}/.sstack/tools/jdk/bin/java" ]; then
    export PATH="${HOME}/.sstack/tools/jdk/bin:${PATH}"
  fi
  if is_exec java; then
    local jar
    for jar in \
      "${TLA2TOOLS_JAR:-}" \
      "./tools/tla2tools.jar" \
      "${HOME:-}/.sstack/tools/tla2tools.jar"
    do
      [ -n "$jar" ] && [ -f "$jar" ] || continue
      printf 'java -XX:+UseParallelGC -cp %s tlc2.TLC\n' "$jar"
      return 0
    done
  fi
  return 1
}

skip() {
  printf 'skip: %s (%s)\n' "$1" "$2"
  skipped=$((skipped + 1))
}

pass() {
  printf 'pass: %s\n' "$1"
  passed=$((passed + 1))
}

fail() {
  printf 'fail: %s\n' "$1"
  failed=$((failed + 1))
  failures+=("$1")
}

run_named() {
  local name="$1"
  shift
  local log
  log="$(mktemp)"
  if "$@" >"$log" 2>&1; then
    pass "$name"
    rm -f "$log"
    return 0
  fi
  fail "$name"
  cat "$log"
  rm -f "$log"
  return 1
}

has_npm_script() {
  local script="$1"
  python3 -c '
import json, sys
try:
    data = json.load(open("package.json"))
except Exception:
    sys.exit(1)
s = (data.get("scripts") or {}).get(sys.argv[1], "") or ""
sys.exit(0 if str(s).strip() else 1)
' "$script" 2>/dev/null
}

npm_script_is_placeholder() {
  python3 -c '
import json, re, sys
try:
    data = json.load(open("package.json"))
except Exception:
    sys.exit(1)
s = (data.get("scripts") or {}).get("test", "") or ""
sys.exit(0 if re.search(r"no test specified", s, re.I) else 1)
' 2>/dev/null
}

has_eslint_config() {
  local f
  for f in eslint.config.js eslint.config.mjs eslint.config.cjs eslint.config.ts; do
    [ -f "$f" ] && return 0
  done
  return 1
}

looks_like_js_project() { [ -f package.json ]; }

looks_like_python_project() {
  [ -f pyproject.toml ] || [ -f requirements.txt ] || [ -f requirements-dev.txt ] \
    || [ -f setup.cfg ] || [ -f setup.py ] || [ -f pyproject.sstack.toml ]
}

looks_like_java_project() {
  [ -f pom.xml ] || [ -f build.gradle ] || [ -f build.gradle.kts ]
}

looks_like_go_project() { [ -f go.mod ]; }

file_mentions() {
  local pattern="$1"
  shift
  local f
  for f in "$@"; do
    [ -f "$f" ] || continue
    grep -Eiq -- "$pattern" "$f" && return 0
  done
  return 1
}

# --- TypeScript / JavaScript ---
if looks_like_js_project; then
  if has_npm_script typecheck; then
    run_named "npm run typecheck" npm run typecheck
  elif [ -f tsconfig.json ] || [ -f tsconfig.strict.json ]; then
    if [ -x node_modules/.bin/tsc ]; then
      run_named "tsc --noEmit" ./node_modules/.bin/tsc --noEmit
    elif command -v tsc >/dev/null 2>&1; then
      run_named "tsc --noEmit" tsc --noEmit
    else
      skip "typecheck" "found tsconfig but tsc is not installed"
    fi
  else
    skip "typecheck" "package.json present but no typecheck script or tsconfig"
  fi

  if has_npm_script lint; then
    run_named "npm run lint" npm run lint
  elif has_eslint_config; then
    if [ -x node_modules/.bin/eslint ]; then
      run_named "eslint" ./node_modules/.bin/eslint .
    elif command -v eslint >/dev/null 2>&1; then
      run_named "eslint" eslint .
    else
      skip "lint" "found eslint config but eslint is not installed"
    fi
  else
    skip "lint" "no lint script or eslint config"
  fi

  if has_npm_script test && ! npm_script_is_placeholder; then
    run_named "npm test" npm test
  elif [ -x node_modules/.bin/vitest ] || [ -f vitest.config.ts ] || [ -f vitest.config.js ]; then
    if [ -x node_modules/.bin/vitest ]; then
      run_named "vitest" ./node_modules/.bin/vitest run
    else
      skip "test" "vitest config found but vitest is not installed"
    fi
  elif [ -f jest.config.js ] || [ -f jest.config.ts ] || [ -f jest.config.mjs ]; then
    if [ -x node_modules/.bin/jest ]; then
      run_named "jest" ./node_modules/.bin/jest
    else
      skip "test" "jest config found but jest is not installed"
    fi
  else
    skip "test" "no usable npm test / vitest / jest setup (placeholder npm test is ignored)"
  fi
else
  skip "javascript" "no package.json"
fi

# --- Python ---
if looks_like_python_project; then
  if is_exec ruff; then
    run_named "ruff check" ruff check .
  else
    skip "ruff" "ruff not installed"
  fi

  if is_exec mypy; then
    run_named "mypy" mypy .
  elif is_exec pyright; then
    run_named "pyright" pyright
  else
    skip "python typecheck" "mypy and pyright not installed"
  fi

  if is_exec pytest; then
    pytest_log="$(mktemp)"
    pytest >"$pytest_log" 2>&1
    pytest_rc=$?
    if [ "$pytest_rc" -eq 0 ]; then
      pass "pytest"
    elif [ "$pytest_rc" -eq 5 ]; then
      skip "pytest" "no tests collected"
    else
      fail "pytest"
      cat "$pytest_log"
    fi
    rm -f "$pytest_log"
  else
    skip "pytest" "pytest not installed"
  fi
else
  skip "python" "no pyproject.toml / requirements.txt / setup.py"
fi


# --- Java (Maven / Gradle) ---
if looks_like_java_project; then
  maven_cmd=""
  if [ -f pom.xml ]; then
    if [ -x ./mvnw ]; then
      maven_cmd="./mvnw"
    elif is_exec mvn; then
      maven_cmd="mvn"
    fi
    if [ -n "$maven_cmd" ]; then
      run_named "maven test" $maven_cmd -B -q test
      if file_mentions 'spotless' pom.xml; then
        run_named "maven spotless:check" $maven_cmd -B -q spotless:check
      else
        skip "maven spotless" "spotless not configured in pom.xml"
      fi
      if file_mentions 'checkstyle' pom.xml; then
        run_named "maven checkstyle:check" $maven_cmd -B -q checkstyle:check
      else
        skip "maven checkstyle" "checkstyle not configured in pom.xml"
      fi
    else
      skip "maven" "found pom.xml but mvnw/mvn is not available"
    fi
  fi

  gradle_cmd=""
  if [ -f build.gradle ] || [ -f build.gradle.kts ]; then
    if [ -x ./gradlew ]; then
      gradle_cmd="./gradlew"
    elif is_exec gradle; then
      gradle_cmd="gradle"
    fi
    if [ -n "$gradle_cmd" ]; then
      run_named "gradle test" $gradle_cmd --quiet test
      if file_mentions 'spotless' build.gradle build.gradle.kts settings.gradle settings.gradle.kts; then
        run_named "gradle spotlessCheck" $gradle_cmd --quiet spotlessCheck
      else
        skip "gradle spotless" "spotless not configured"
      fi
      if file_mentions 'checkstyle' build.gradle build.gradle.kts settings.gradle settings.gradle.kts; then
        run_named "gradle checkstyleMain" $gradle_cmd --quiet checkstyleMain
      else
        skip "gradle checkstyle" "checkstyle not configured"
      fi
    else
      skip "gradle" "found Gradle build file but gradlew/gradle is not available"
    fi
  fi
else
  skip "java" "no pom.xml or build.gradle(.kts)"
fi

# --- Go ---
if looks_like_go_project; then
  if ! is_exec go; then
    skip "go" "go toolchain is not installed"
  else
    go_files="$(find . \( -path './.git' -o -path './vendor' \) -prune -o -name '*.go' -type f -print | sed 's|^\./||' | sort)"
    if [ -z "$go_files" ]; then
      skip "gofmt" "no .go files"
    else
      unformatted="$(printf '%s\n' "$go_files" | xargs gofmt -l)"
      if [ -n "$unformatted" ]; then
        fail "gofmt -l"
        printf '%s\n' "$unformatted"
      else
        pass "gofmt -l"
      fi
    fi
    run_named "go vet" go vet ./...
    run_named "go test" go test ./...
    if is_exec golangci-lint; then
      run_named "golangci-lint" golangci-lint run
    else
      skip "golangci-lint" "golangci-lint not installed"
    fi
  fi
else
  skip "go" "no go.mod"
fi

# --- Shell ---
if is_exec shellcheck; then
  filtered=()
  while IFS= read -r f; do
    [ -f "$f" ] || continue
    case "$f" in
      *.md) continue ;;
    esac
    if head -n 1 "$f" | grep -qE '^#!.*(bash|sh)'; then
      filtered+=("$f")
    elif [[ "$f" == *.sh ]]; then
      filtered+=("$f")
    fi
  done < <(find . \
    \( -path './.git' -o -path './node_modules' -o -path './.venv' -o -path './venv' \
       -o -path './dist' -o -path './build' \) -prune -o \
    -type f \( -name '*.sh' -o -path './scripts/*' \) -print | sed 's|^\./||' | sort)

  if [ "${#filtered[@]}" -eq 0 ]; then
    skip "shellcheck" "no shell scripts found"
  else
    run_named "shellcheck" shellcheck "${filtered[@]}"
  fi
else
  skip "shellcheck" "shellcheck not installed"
fi

# --- TLA+ ---
# Optional (default, including yetone): skip if no specs or no TLC.
# Required (poteto when .sstack/require-tlc is present): missing TLC, missing
# specs, or a spec without a matching .cfg is a failure, not a skip.
tla_files=()
while IFS= read -r f; do
  [ -n "$f" ] || continue
  tla_files+=("$f")
done < <(find . \( -path './.git' -o -path './node_modules' -o -path './tools' \) -prune -o -name '*.tla' -type f -print 2>/dev/null | sort)

if require_tlc && [ "${#tla_files[@]}" -eq 0 ]; then
  fail "tla+"
  printf 'required formal models (.sstack/require-tlc) but no .tla specs were found under spec/ or elsewhere\n'
elif [ "${#tla_files[@]}" -eq 0 ]; then
  skip "tla+" "no .tla specs"
else
  tlc_line=""
  if tlc_line="$(find_tlc_invocation)"; then
    # shellcheck disable=SC2206
    tlc_words=($tlc_line)
    for spec in "${tla_files[@]}"; do
      cfg="${spec%.tla}.cfg"
      name="tlc $(basename "$spec")"
      if [ -f "$cfg" ]; then
        run_named "$name" "${tlc_words[@]}" -config "$cfg" "$spec" || true
      elif require_tlc; then
        fail "$name"
        printf '%s has no matching .cfg\n' "$spec"
      else
        skip "$name" "no matching .cfg"
      fi
    done
  elif require_tlc; then
    fail "tla+"
    printf 'required formal models but TLC was not found. Install a JDK and run bin/sstack-install-tlc, or put tla2tools.jar at tools/tla2tools.jar\n'
  else
    skip "tla+" "found .tla specs but tlc/tlc2/tla2tools.jar is not available"
  fi
fi

# --- E2E / Playwright ---
# Optional (default): skip if no config, no browser runner, or no base URL.
# Required (poteto when .sstack/require-e2e is present): missing runner or
# missing tests is a failure. The project should start its own app (for
# example Playwright webServer) so a manually exported base URL is not required.
has_e2e_config=0
if [ -f playwright.config.ts ] || [ -f playwright.config.js ] || [ -d e2e ]; then
  has_e2e_config=1
fi

if require_e2e && [ "$has_e2e_config" -eq 0 ]; then
  fail "e2e"
  printf 'required UI verification (.sstack/require-e2e) but no playwright config or e2e/ directory was found\n'
elif [ "$has_e2e_config" -eq 0 ]; then
  skip "playwright" "no playwright config or e2e/ directory"
else
  pw_cmd=""
  if [ -x node_modules/.bin/playwright ]; then
    pw_cmd="./node_modules/.bin/playwright"
  elif command -v playwright >/dev/null 2>&1; then
    pw_cmd="playwright"
  fi
  if [ -z "$pw_cmd" ]; then
    if require_e2e; then
      fail "playwright"
      printf 'required UI verification but playwright is not installed\n'
    else
      skip "playwright" "playwright is not installed"
    fi
  elif require_e2e; then
    run_named "playwright" "$pw_cmd" test || true
  elif [ -z "${SSTACK_E2E_BASE_URL:-}" ] && [ -z "${PLAYWRIGHT_BASE_URL:-}" ]; then
    skip "playwright" "set SSTACK_E2E_BASE_URL (or PLAYWRIGHT_BASE_URL) to enable, or add Playwright webServer and .sstack/require-e2e"
  else
    run_named "playwright" "$pw_cmd" test || true
  fi
fi

# --- Extension hooks ---
hook_dir="scripts/verify.d"
if [ -d "$hook_dir" ]; then
  hook_found=0
  while IFS= read -r hook; do
    [ -n "$hook" ] || continue
    hook_found=1
    run_named "hook $(basename "$hook")" "$hook" || true
  done < <(find "$hook_dir" -maxdepth 1 -type f ! -name '.*' ! -name '*.md' -perm -u+x | sort)
  if [ "$hook_found" -eq 0 ]; then
    skip "verify.d" "no executable hooks"
  fi
fi

echo
echo "verify summary: passed=$passed skipped=$skipped failed=$failed"
if [ "$failed" -gt 0 ]; then
  printf '  failed steps: %s\n' "${failures[*]}"
  exit 1
fi
exit 0
