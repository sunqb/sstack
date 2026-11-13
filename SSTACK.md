# sstack：给 agent 的入口

你是编码 agent。人类只提出要用哪一种流程，并在最后审查证据。所有落地步骤由你执行，不要把命令丢回给人类去跑。

本文件位于 sstack 仓库根目录。**SSTACK_ROOT** 按下面顺序解析：本文件所在目录；环境变量 `SSTACK_ROOT`；`$HOME/sstack`（若其中有 `bin/sstack-init`）；当前技能 symlink 的真实路径向上找到含 `bin/sstack-init` 的目录。找不到就停下来说明，不要猜测。

sstack 有两套**互不混用**的方法论：

- **poteto**：确定性检查优先。纠正必须变成 lint / 测试 / 类型规则，只在 `docs/corrections.md` 留一行对照。禁止创建 `LESSONS.md`。
- **yetone**：以 `LESSONS.md` 错题本为中枢（规则 + 原因 + 证据 + Seen 日期；满 3 个不同日期升格到 `docs/code-standards.md`）。不要改用 poteto 的 `corrections.md` 代替错题本。

人类的一句话就是你的触发条件：

- 「用 sstack 的 poteto 流程接管这个项目」→ 立即执行 `flows/poteto/skills/sstack-poteto-adopt/SKILL.md`
- 「用 sstack 的 yetone 流程接管这个项目」→ 立即执行 `flows/yetone/skills/sstack-yetone-adopt/SKILL.md`
- 已接入 poteto 的项目里，用户纠正你 → `sstack-poteto-correct`
- 已接入 yetone 的项目里，需要记教训或复盘 → `sstack-yetone-lesson` / `sstack-yetone-retro`
- 用户要验证或审查证据 → 对应 flow 的 verify 技能
- 用户要定期打扫 poteto 项目 → `sstack-poteto-garden`

若尚未安装技能，仍然读取本文件并按上述路径打开对应 `SKILL.md` 后执行，效果相同。

助手脚本（由你来调用，不是给人类的日常手续）：

- `$SSTACK_ROOT/bin/sstack-init`：把所选 flow 的模板装进当前项目，不覆盖已有文件
- `$SSTACK_ROOT/bin/sstack-install-skills`：把技能安装到本机 agent 的发现目录，便于以后自动加载

不要混装两套 flow。项目里若已有 `.sstack/flow`，遵守它；与用户指定的不一致时先说明再停，不要擅自改。
