---
name: sstack-poteto-adopt
description: 用 sstack 的 poteto 流程接管或接入当前项目。在用户说「用 sstack 的 poteto 流程接管这个项目」、要落地 poteto、或把项目改成检查优先的工作流时使用。由 agent 执行 init、按标准判定并自行补上 TLA+ 或 UI 走查、改写文档并跑绿 verify；不要创建 LESSONS.md，不要使用 --with tla,e2e。
---

# sstack-poteto-adopt

在当前工作目录（项目根）把 poteto flow 真正落地。你亲自做完，最后只向人类交付证据。

## 步骤

1. 解析 SSTACK_ROOT（见 `$SSTACK_ROOT/SSTACK.md` 或本技能 symlink 的真实路径）。若项目已有 `.sstack/flow` 且不是 `poteto`，停下说明，不要混装。
2. 探测技术栈（与 `sstack-init` 相同）：`package.json` → typescript；`pyproject.toml` / `requirements.txt` / `setup.py` 等 → python；`pom.xml` / `build.gradle` / `build.gradle.kts` → java；`go.mod` → go；否则 shell。多种信号同时存在则选最能代表本仓库的一个，并在证据里写明选择。
3. 缺了跑 verify 所需要的工具时，先尝试自己安装（例如 `go`、`node`/`npm`、`python3`、`ruff`/`mypy`/`pytest`、`mvn`/`gradle`、JDK）。装不上就记录下来。**但是**：一旦下面第 6 步判定需要 TLA+ 或第 7 步判定需要 UI 走查，对应工具不得以「缺失则 skip」结束，必须安装成功或把失败当作阻塞。
4. 执行：
   `$SSTACK_ROOT/bin/sstack-init . --flow poteto --preset <detected>`
   不要加 `--force`。**不要加 `--with tla,e2e`。** poteto 由本技能判定是否建模、是否做 UI 走查，不走开关。不要初始化 yetone 文件。
5. **不要留下模板占位符。** 阅读代码、测试、已有 README 和目录结构，重写：
   - `AGENTS.md`：真实的构建 / 测试 / verify 命令和目录说明；必须保留并写清下面的自动规则（不可删）：
     - 用户一旦纠正你，立即按 `sstack-poteto-correct` 把纠正写成确定性检查，并更新 `docs/corrections.md`，不要等人类提醒，不要创建 `LESSONS.md`。
     - 声称完成之前必须自己跑 `bash scripts/verify.sh`，把输出当作证据。构建通过不等于完成。
     - 若有形式化模型：改到被建模的流程时，先更新 `spec/` 里的模型，再改代码；verify 必须跑 TLC。
   - `docs/features.md`：从**用户视角**列出真实功能、操作步骤、可观察预期、现有或将补的验证方式。没有依据的示例行删掉。
   - `docs/corrections.md`：保留表头；只有真有已落地检查时才写数据行。
6. **形式化验证判定**（必做，写进证据）。对照下面的标准，检查本仓库是否存在需要建模的流程：
   - 多步状态机，例如订单、支付、审批、会话的生命周期
   - 并发、重试、幂等
   - 缓存或副本一致性
   - 权限模型
   - 任何「出错代价高、而普通测试到不了全部交错」的流程
   - 核心算法：优先考虑 Lean 证明或性质测试；若它仍是有状态协议，同时写 TLA+

   **若任一条适用：**
   - 在 `spec/` 下为这些流程写 TLA+ 规格（`*.tla` + 配套 `*.cfg`）。状态空间要小到几秒内能跑完，并写出关键安全不变性（必要时再加活性）。
   - 自己安装 TLC：运行 `$SSTACK_ROOT/bin/sstack-install-tlc .`（若缺 JDK，该脚本会先试系统包管理器，失败则下载便携 Eclipse Temurin JRE 到 `~/.sstack/tools/jdk`；并把 `tools/tla2tools.jar` 与 `tools/tlc` 放到项目里）。不要把安装推给人类，也不要因为 apt 失败就停下来——先跑这个脚本。
   - 在项目里创建 `.sstack/require-tlc`（内容任意，存在即生效）。这样 `scripts/verify.sh` 会把 TLC 当成**必跑**步骤：缺工具、缺规格或缺 `.cfg` 都是失败，而不是 skip。
   - 在 `docs/features.md` 写明模型 ↔ 代码的对应（哪个规格描述哪段代码 / 哪个用户流程）。

   **若一条都不适用：**
   - 不要生成空规格。在 `AGENTS.md` 写**一句**说明：为什么当前没有形式化模型；并写明一旦出现上述流程，必须重新判定并补上模型。
7. **UI 运行时验证判定**（必做）。若项目有用户界面（web / 桌面 / 移动），默认补上运行时 / 截图走查（优先 Playwright，按技术栈也可换等价工具），把它接到 `scripts/verify.sh`，并创建 `.sstack/require-e2e`。配置应能自行拉起应用（例如 Playwright `webServer`），不要依赖人类先 export 一个 URL。没有 UI 的库则不要硬加 e2e。
8. 跑 `bash scripts/verify.sh`。失败则修复代码、模型、测试或配置，再跑，直到全绿或你能指出无法在本次修复的阻塞（缺权限、失败输出原文）。若第 6 步决定了建模，输出里必须出现 TLC 的 `pass:`，不得以 skip 交差。
9. 向人类只报告：选用的 preset、形式化判定结果（建了哪些模型，或为什么没有）、UI 走查是否接入、改写了哪些文档、verify 的 passed/skipped/failed、仍然缺的工具。不要让人类去执行上述任何一步。
