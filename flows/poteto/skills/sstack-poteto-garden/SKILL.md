---
name: sstack-poteto-garden
description: 在 poteto 流程项目里做定期打扫：对照功能地图与 corrections.md 检查漂移，审查是否出现新的需建模流程，清理失效检查，并跑绿 verify。触及已建模流程或新增符合标准的流程时，先改/补 spec/ 再改代码，verify 必须跑 TLC。
---

# sstack-poteto-garden

把代码库当作花园来打理。你来改，人类只看证据。

1. 读 `docs/features.md` 与代码：过时的功能行删掉或更新；有功能无检查的补上检查。
2. 重新做一次 adopt 技能里的「形式化验证判定」。已有模型与代码不一致的，**先改 `spec/`，再改代码**（若这次只是模型过时，至少先让模型与当前合法行为一致）。新出现、符合标准却还没有模型的流程，补上规格、安装 TLC、写入 `.sstack/require-tlc`，并更新功能地图中的模型 ↔ 代码对应。以前写过「为何暂不建模」的那一行，若条件已变，改掉它。
3. 若项目后来有了 UI 却还没有运行时走查，按 adopt 技能的 UI 规则补上，并加上 `.sstack/require-e2e`。
4. 读 `docs/corrections.md`：对应检查已删除的行一并删掉；同类重复纠正说明规则不够强，收紧它而不是再加一行空话。
5. 删除确定不再使用的代码与测试；不要顺手做大重构。
6. 跑 `bash scripts/verify.sh`，修复你引入的失败。只要存在 `.sstack/require-tlc`，输出里必须有 TLC 的 `pass:`。
7. 报告改了什么、verify 输出，以及仍然故意留下的 skip。
