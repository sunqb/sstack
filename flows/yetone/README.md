# yetone flow

这是 sstack 对 yetone（X / GitHub [@yetone](https://github.com/yetone)，[avante.nvim](https://github.com/yetone/avante.nvim)、[Magpie](https://github.com/yetone/magpie)、openai-translator 等项目作者）**已公开**的 AI 编程与维护方式的可复用落地。核心不是再写一份更长的规范，而是：**用 `LESSONS.md` 当错题本，按日复盘，把反复出现的教训升格成硬规则。**

本目录与 `flows/poteto/` 隔离。poteto flow 明确避免 `LESSONS.md`；本 flow 以它为中枢。不要把两套文件装进同一个项目。

关于中文姓名：公开资料中作者以 yetone 为名。本仓库**不猜测**其法定姓名。

## 公开实践里到底怎么用 LESSONS.md

以下机制来自 **yetone/magpie 仓库当前可见文件**（本工具包撰写时已直接读取），这是最稳妥的一手来源。

### 谁写、何时更新

`LESSONS.md` 文首写明：Magpie 的代码由 **agent 编写、审查、合并和发布**。**每天夜里**复盘当天的提交，专门看三类事：

- 哪些内容后来又被修过一遍（had to be fixed again）
- 哪些本来不该合并（shouldn't have merged）
- 哪些验证做得太薄（verified too thinly）

学到的东西写进 `LESSONS.md`。改代码之前要先读它。

与此对照的是 yetone 在 X 上分享的第三条 `/loop`（见下方「并行 loop」）：定期清理低质量或恶意代码，并把「不该合并的、验证不缜密的」等经验写进「经验」里，避免以后的 agent 再犯。仓库里与这条 loop 对应的落点就是 `LESSONS.md`（以及升格后的 `docs/code-standards.md`）。

**不确定（应如实对待）：**

- 文首说「Each night the day's commits are reviewed」，没有在仓库里再规定必须由哪一个具体会话执行；X 上的第三条 loop 负责清代码并沉淀经验。二者方向一致，但「夜间复盘」和「Loop 3」是不是同一个进程，公开材料没有写成一句定义，这里不强行等同。
- 人是否也直接改 `LESSONS.md`：yetone 自述晚上主要处理 UI/UX。没有看到「只有人能改错题本」或「人从不改错题本」的声明。

### 格式

文首规定每条教训的形态是：

1. **一条规则**（一句话，告诉以后的 agent 该怎么做）
2. **为什么**（可含用户可见后果）
3. **证据**（issue、commit、复现过程）
4. 可选的 **Done right**（后来做对的例子）
5. **`Seen N× (日期, 日期, …)`**：按「审查发现它的不同日期」计数，不是按出现次数随便加

实际文件里，规则按主题分组（例如阅读报告、修一类而非修一个样本、用户自己的文件与设置、验证、并发与测试、红测试与发布、合并与关闭等）。文末有 `## Moved to the code standards`，列出已经升格的规则。

模板见 `templates/LESSONS.md`。不要把 Magpie 的具体 bug 抄进你的项目。

### 何时阅读

- `AGENTS.md` 要求：**改代码之前先读 `LESSONS.md`**（最近合并工作里出过错的地方，以及本可以拦住它的规则）。
- `CLAUDE.md` 只有两行：`@AGENTS.md` 和 `@LESSONS.md`。细则不堆在入口文件里，避免启动上下文被长文淹没。

### 与 AGENTS.md / CLAUDE.md / code-standards 的关系

这是一套分层，而不是四份互相重复的说明书：

| 文件 | 角色 |
| --- | --- |
| `CLAUDE.md` | 极瘦入口，只用 `@` 把 Claude Code（或其他支持该语法的 agent）指到路由表和错题本 |
| `AGENTS.md` | **路由表**：做某类工作之前读哪一份文档（子系统设计、code-standards、社区 PR 规则、LESSONS） |
| `LESSONS.md` | **工作中的错题本**：带证据和 Seen 计数的近期教训 |
| `docs/code-standards.md` | **已升格的硬规则**：审查时逐条对照 |
| `docs/contributors.md` | 社区 PR 的危害闸门与作者屏蔽流程（agent **只提议**，维护者决定） |
| `docs/subsystems/` | 子系统设计参考；改已文档化的子系统前先读 |

升格门槛写在 `LESSONS.md` 文首，原文要点是：

> "Seen" counts the days a review found it. A lesson seen on 3 or more separate days moves into docs/code-standards.md.

同一条教训在 **3 个或更多个不同日期** 被复盘看到，才搬进 `docs/code-standards.md`。升格后仍可在 `LESSONS.md` 的 “Moved” 一节留下索引，规则正文以 code-standards 为准。

## 并行 loop 与人的角色

yetone 在 2026-10-13 左右的 X 主帖中称：没有魔法，用 Claude Code 和他所称的「官方的 Opus 5.5」执行 loop；并行跑图里的 3 个 loop，每晚抽一点时间处理 UI/UX，「然后就没活儿了」。主帖与三张提示词截图：https://x.com/yetone/status/2109855710444237018

三条 loop 的职责（按该帖截图的公开转写，以及后续评论文，归纳为可复用形态）：

1. **入口 A（代码协作与社区）**：看 issue / PR；不值得做的也要回复；PR 要逐行看逻辑，并且**把代码拉下来实际跑过**才合并，否则回复或关闭。同时看社区频道里的反馈。
2. **入口 B（公开社交反馈）**：盯产品相关讨论；有价值的建议或可复现 bug 才去做，做完上线后回复。先用**便宜的决策模型**判断是否相关，无关内容不要转给主模型。
3. **入口 C（熵减与错题本）**：在大量自动改动和合并之后，定期清理低质量或恶意代码，把教训写入经验（即 `LESSONS.md` 这一层），并按项目规则处理反复提交低质量代码的贡献者。

人留下的高杠杆工作，按作者自述主要是 **UI/UX 判断**。

后续动机说明见 https://x.com/yetone/status/2110089344187056263（产品作为本地 Agent 基础设施、早期依赖用户反馈、后来把 Provider / Agent 插件化等）。这是产品策略，不是错题本的文件格式。

### 评论区补充（二手转述，单独标注）

多家中文整理（见「来源」）称 yetone 在该主帖评论区还补充过：

- 给 agent **真实的多端环境**（macOS、Windows，以及 Windows 上的 Linux 虚拟机），修之前在出问题的系统上复现。
- 决策靠 Claude Code 的记忆，以及仓库里的设计文档；项目早期与模型的讨论被记下来，后来的取舍更贴近本人。
- 对外操作走 **browser use**，而不是只依赖社交平台 CLI。

这些补充**未能在本次编写时通过 X API 复核原帖**（该环境对上述两个 status 返回未授权）。因此它们记为「第三方对评论区的转述」，采用时请自行打开原帖核对。本 flow 的 playbook 会把「真实环境复现」「设计文档」写成可选项，而不是断言你必须拥有三台机器。

其他应标明的不确定点：

- 模型名称「Opus 5.5」按作者当时自述记录，本仓库不核实其对外商品名。
- 截图里的 `/loop` 提示词未写时间间隔。有第三方称在 Codex 上默认约 1 小时；这不是 yetone 的声明。
- 主帖里 Loop 3 提到把反复提交低质量代码的人「拉入黑名单」。仓库 `docs/contributors.md` 写的是：agent **只提议并附证据，维护者决定**。落地时以「人拍板」为准，不要让 agent 自行封禁。

## 本 flow 会装入项目的文件

| 文件 | 作用 |
| --- | --- |
| `CLAUDE.md` | 两行入口，指向 AGENTS.md 与 LESSONS.md |
| `AGENTS.md` | 阅读路由：先读哪份文档 |
| `LESSONS.md` | 错题本（规则 / 原因 / 证据 / Seen） |
| `docs/code-standards.md` | 已升格硬规则与验收清单 |
| `docs/design.md` | 产品与审美上已拍板的决定（设计记忆） |
| `docs/contributors.md` | 社区 PR 闸门；屏蔽由维护者决定 |
| `docs/subsystems/README.md` | 子系统设计索引 |
| `loops/` | 三条通用 loop 提示词模板（已去掉具体产品细节） |
| `docs/sstack/playbooks/` | 给人看的流程 |
| `skills/` | 给 agent 的技能说明 |

给 agent 的技能在 `skills/`：`sstack-yetone-adopt`、`sstack-yetone-lesson`、`sstack-yetone-retro`、`sstack-yetone-verify`。

共享的 `scripts/verify.sh` 仍来自 `core/`。yetone 实践还强调：**记录实际跑过什么**；没跑的检查要写明未跑，不要省略。合并或发布前应在真实环境里跑过，而不是只看构建。

## 来源

### 一手（撰写时直接核对）

- https://github.com/yetone/magpie/blob/main/LESSONS.md — 错题本机制、Seen、升格门槛、条目形态
- https://github.com/yetone/magpie/blob/main/AGENTS.md — 改代码前读 LESSONS；按工作类型指向设计、standards、contributors
- https://github.com/yetone/magpie/blob/main/CLAUDE.md — 仅 `@AGENTS.md` 与 `@LESSONS.md`
- https://github.com/yetone/magpie/blob/main/docs/code-standards.md — 升格后的硬规则与验收方式
- https://github.com/yetone/magpie/blob/main/docs/contributors.md — 危害先停审；屏蔽由维护者决定
- https://github.com/yetone/avante.nvim — 作者的 Neovim AI 编程插件（编辑器侧实践，与错题本文件是不同一层）
- https://github.com/yetone/magpie — 作者的本地 agent 路由与多模型网关

### 公开帖（请以打开后的原文为准）

- https://x.com/yetone/status/2109855710444237018 — 主帖与三张 `/loop` 截图
- https://x.com/yetone/status/2110089344187056263 — 后续关于为何采用这套工作流、以及插件化方向的说明

### 二手整理（只用其转写与评论区转述，不把第三方统计当事实）

- https://u1-lab.xiaoxia.io/yetone-loop-workflow/
- https://zhihao.wang/zh/marks/yetone-three-opus-loops
- https://linux.do/t/topic/3025235
- https://readcopilot.ionichina.com/articles/56107
- https://skills.tenten.co/docs/skills-atlas-yetone-feedback-agent-harness

第三方文章中的提交量、版本数、花费等数字，若未在仓库文件或作者原文中出现，本 flow **不采用**。`LESSONS.md` 文首关于某日提交与发布的数字属于仓库自述，也不自动套到你的项目上。
