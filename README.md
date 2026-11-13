# sstack

sstack 是一套**给编码 agent 用的工作流技能包**。人类只说用哪一种流程，并在最后审查证据；探测技术栈、写入文档、跑验证、把纠正变成检查，都由 AI 执行。

它把两种已经公开、但互相不同的方法论做成**互不混用**的 flow：

| | `poteto` | `yetone` |
| --- | --- | --- |
| 来源 | poteto（土豆姐，pstack 作者）公开的「少写文档、多写检查」 | yetone（[@yetone](https://github.com/yetone)）公开的 Magpie 维护方式与仓库文件 |
| 中枢 | 确定性检查（类型、lint、测试、verify） | `LESSONS.md` 错题本，以及从中升格的硬规则 |
| 教训怎么落 | 每次纠正先变成一条会失败的检查；`docs/corrections.md` 只留对照表。**不建 `LESSONS.md`** | 定期复盘已合并工作，写成「规则 + 原因 + 证据 + Seen」；满 3 个不同日期升格到 `docs/code-standards.md` |
| Agent 文档 | 很短的 `AGENTS.md`，只保留判断原则和如何跑 verify | 极瘦的 `CLAUDE.md`（只 `@` 两份文件）+ 作为路由表的 `AGENTS.md` |
| 日常节奏 | 对照功能地图改、跑一条 `verify`、全绿再交付 | 可选的并行 loop 盯入口与反馈；人留下 UI/UX 与拍板；验证必须实际跑过 |
| 适合 | 想把 agent 的重复错误直接卡死在工具链里 | 想让 agent 长期维护仓库，并用错题本自我迭代 |

两种 flow 分目录存放（`flows/poteto/`、`flows/yetone/`），一次只接入一套。共享、且不携带哲学的部分（安装器、语言 preset、`verify` 入口、可选 TLA+ / e2e）在 `core/`。agent 的总入口是 [SSTACK.md](SSTACK.md)。

## 本地使用

一次性把技能装进你的编码 agent，之后只要对 AI 说话。

```sh
git clone https://github.com/sunqb/sstack.git ~/sstack
export PATH="$HOME/sstack/bin:$PATH"   # 可写入 ~/.bashrc 或 ~/.zshrc
sstack-install-skills                  # 默认安装给 Claude Code、Cursor、pi、Codex
```

macOS / Linux 用 bash 或 zsh。Windows 请在 WSL 或 Git Bash 里执行上面的命令（安装器是 bash 脚本）。

`sstack-install-skills` 会把技能 symlink 到各工具会自动扫描的目录（路径均来自官方文档，不是猜测）：

- Claude Code：`~/.claude/skills/`
- Cursor：`~/.cursor/skills/`
- pi：`~/.pi/agent/skills/`
- Codex：`~/.agents/skills/`（当前推荐），并额外链到仍被识别的旧路径 `~/.codex/skills/`

可用 `--agent claude|cursor|pi|codex|all` 和 `--flow poteto|yetone|all` 缩小范围。再跑一次是安全的。

然后打开任意项目，对 pi、Claude Code、Cursor 或 Codex 说一句：

```
用 sstack 的 poteto 流程接管这个项目
```

或：

```
用 sstack 的 yetone 流程接管这个项目
```

agent 会自己探测技术栈、调用安装器、按代码库写出真实的 `AGENTS.md` 等文档、跑 `verify`，并把证据交给你。之后你只要继续对话：纠正它时，它应按当前 flow 自动把纠正写成检查或错题本条目，并在声称完成前自己跑验证。

若某个 agent 还没装上技能，把这句备用提示连路径一起发给它：

```
读 ~/sstack/SSTACK.md，按 poteto 流程接管当前项目
```

（yetone 则把其中的 poteto 改成 yetone。）

## 各 preset 会提供什么

- **typescript**（Node / 前端）：严格的 `tsconfig.strict.json`、ESLint flat 配置（import 边界、禁止高风险 API、自定义规则示例）、`package.scripts.example.json`（合并进你的 `package.json`，不会丢一个假的依赖清单进仓库）。
- **python**（后端 / 脚本）：`pyproject.sstack.toml`，含 ruff、mypy / pyright、pytest。空项目可改名为 `pyproject.toml`；已有项目请合并对应的 `[tool.*]` 表。
- **java**（Maven / Gradle）：`checkstyle.xml`、Spotless 片段，以及 ArchUnit 分层边界测试示例。请把插件合并进已有 `pom.xml` 或 `build.gradle(.kts)`，不要覆盖构建文件。verify 优先使用 `./mvnw` 或 `./gradlew`，跑编译与测试；若已配置 Spotless / Checkstyle 再跑对应检查。
- **go**：`.golangci.yml`（含 depguard 依赖边界与 forbidigo 禁止 API 的示例）。verify 跑 `gofmt -l`（有输出即失败）、`go vet ./...`、`go test ./...`；已安装 `golangci-lint` 时再跑它。
- **shell**（其他语言或纯脚本）：`Makefile.sstack.example`，以及 `scripts/verify.d/` 扩展点，把任意检查挂到同一条 verify 上。

## 助手脚本

人类日常不需要调用这些命令。它们是给 agent 用的：

- `bin/sstack-install-skills`：把技能装进本机 agent 的发现目录。
- `bin/sstack-init`：把某一套 flow 的模板装进目标项目，不覆盖已有文件。必须显式指定 `--flow poteto|yetone`。`--preset` 可省略并由自动检测决定（`package.json` → typescript；`pyproject.toml` / `requirements.txt` 等 → python；`pom.xml` / `build.gradle(.kts)` → java；`go.mod` → go；否则 shell；多种信号同时出现则报错）。`--with tla,e2e` 默认关闭。
- 项目里的 `scripts/verify.sh`：唯一验收入口。工具缺失则跳过；已启用的步骤失败则整体失败。

## 仓库结构

```
SSTACK.md                # agent 总入口（先读这个）
skills/sstack/           # 路由技能
bin/sstack-install-skills
bin/sstack-init
core/                    # verify、preset、addon（与方法论无关）
flows/poteto/skills/     # sstack-poteto-adopt/correct/verify/garden
flows/yetone/skills/     # sstack-yetone-adopt/lesson/retro/verify
```

每个 flow 目录里的 `README.md` 写哲学和来源。yetone flow 的来源列表（Magpie 仓库文件、X 原帖、二手转写及其不确定点）见 [flows/yetone/README.md](flows/yetone/README.md)。

## 许可

MIT，见 [LICENSE](LICENSE)。
