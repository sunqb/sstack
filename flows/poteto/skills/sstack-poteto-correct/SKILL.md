---
name: sstack-poteto-correct
description: 在 poteto 流程项目中，把用户对 agent 的纠正变成一条确定性检查（lint、测试、类型或边界规则），更新 docs/corrections.md，并重跑 verify。用户说你写错了、别再这样、或指出回归时使用。不要创建 LESSONS.md。
---

# sstack-poteto-correct

用户纠正你时立刻执行，不要等另一次吩咐。

1. 用用户可观察的语言写清做错了什么。
2. 新增或收紧一条确定性检查（类型、lint、import 边界、测试、TLA+ 不变量、`scripts/verify.d/` 钩子）。先跑 `bash scripts/verify.sh`，确认这条检查会失败。
3. 修复产品代码，再跑 verify，直到全绿。
4. 在 `docs/corrections.md` 增加一行对照，状态为「已强制」。
5. 不要写教训散文，不要创建或更新 `LESSONS.md`。
6. 若无法写成检查，明确告诉人类「这条纠正还没落地」，而不是用 markdown 代替。把 verify 输出作为证据交出。
