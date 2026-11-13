---
name: sstack-poteto-garden
description: 在 poteto 流程项目里做定期打扫：对照功能地图与 corrections.md 检查漂移，清理失效检查，把重复问题收紧成规则，并跑绿 verify。用户说打扫、维护花园、定期审查时使用。
---

# sstack-poteto-garden

把代码库当作花园来打理。你来改，人类只看证据。

1. 读 `docs/features.md` 与代码：过时的功能行删掉或更新；有功能无检查的补上检查。
2. 读 `docs/corrections.md`：对应检查已删除的行一并删掉；同类重复纠正说明规则不够强，收紧它而不是再加一行空话。
3. 删除确定不再使用的代码与测试；不要顺手做大重构。
4. 跑 `bash scripts/verify.sh`，修复你引入的失败。
5. 报告改了什么、verify 输出，以及仍然故意留下的 skip。
