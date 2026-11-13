---
name: sstack-poteto-adopt
description: 用 sstack 的 poteto 流程接管或接入当前项目。在用户说「用 sstack 的 poteto 流程接管这个项目」、要落地 poteto、或把项目改成检查优先的工作流时使用。由 agent 执行 init、改写文档、补齐工具并跑绿 verify；不要创建 LESSONS.md。
---

# sstack-poteto-adopt

在当前工作目录（项目根）把 poteto flow 真正落地。你亲自做完，最后只向人类交付证据。

## 步骤

1. 解析 SSTACK_ROOT（见 `$SSTACK_ROOT/SSTACK.md` 或本技能 symlink 的真实路径）。若项目已有 `.sstack/flow` 且不是 `poteto`，停下说明，不要混装。
2. 探测技术栈（与 `sstack-init` 相同）：`package.json` → typescript；`pyproject.toml` / `requirements.txt` / `setup.py` 等 → python；`pom.xml` / `build.gradle` / `build.gradle.kts` → java；`go.mod` → go；否则 shell。多种信号同时存在则选最能代表本仓库的一个，并在证据里写明选择。
3. 缺了跑 verify 所需要的工具时，先尝试自己安装（例如 `go`、`node`/`npm`、`python3`、`ruff`/`mypy`/`pytest`、`mvn`/`gradle`、JDK）。装不上就记录下来，继续用「工具缺失则 skip」的 verify，不要把安装步骤推给人类。
4. 执行：
   `$SSTACK_ROOT/bin/sstack-init . --flow poteto --preset <detected>`
   不要加 `--force`。不要初始化 yetone 文件。
5. **不要留下模板占位符。** 阅读代码、测试、已有 README 和目录结构，重写：
   - `AGENTS.md`：真实的构建 / 测试 / verify 命令和目录说明；必须保留并写清下面两条自动规则（不可删）：
     - 用户一旦纠正你，立即按 `sstack-poteto-correct` 把纠正写成确定性检查，并更新 `docs/corrections.md`，不要等人类提醒，不要创建 `LESSONS.md`。
     - 声称完成之前必须自己跑 `bash scripts/verify.sh`，把输出当作证据。构建通过不等于完成。
   - `docs/features.md`：从**用户视角**列出真实功能、操作步骤、可观察预期、现有或将补的验证方式。没有依据的示例行删掉。
   - `docs/corrections.md`：保留表头；只有真有已落地检查时才写数据行。
6. 跑 `bash scripts/verify.sh`。失败则修复代码、测试或配置，再跑，直到全绿或你能指出无法在本次修复的阻塞（缺权限、缺无法安装的工具、失败输出原文）。
7. 向人类只报告：选用的 preset、改写了哪些文档、verify 的 passed/skipped/failed、仍然缺的工具。不要让人类去执行上述任何一步。
