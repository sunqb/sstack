---
name: sstack-poteto-correct
description: 在 poteto 流程项目中，把用户对 agent 的纠正变成一条确定性检查（lint、测试、类型、边界规则或 TLA+ 模型），更新 docs/corrections.md，并重跑 verify。触及已建模流程或新增符合建模标准的流程时，先改/补 spec/ 再改代码，verify 必须跑 TLC。不要创建 LESSONS.md。
---

# sstack-poteto-correct

用户纠正你时立刻执行，不要等另一次吩咐。

1. 用用户可观察的语言写清做错了什么。
2. 若这次纠正触及已有 `spec/` 模型，或引入了新的、符合 adopt 技能「形式化验证判定」标准的流程（多步状态机、并发/重试/幂等、缓存或副本一致性、权限模型、测试覆盖不到的高代价交错）：**先更新或新增 TLA+ 规格，再改代码。** 确保 `.sstack/require-tlc` 存在，必要时运行 `$SSTACK_ROOT/bin/sstack-install-tlc .`。随后 `bash scripts/verify.sh` 必须实际跑 TLC，不能 skip。
3. 新增或收紧一条确定性检查（类型、lint、import 边界、测试、TLA+ 不变量、`scripts/verify.d/` 钩子）。先跑 `bash scripts/verify.sh`，确认这条检查会失败。
4. 修复产品代码（模型已在第 2 步更新），再跑 verify，直到全绿。
5. 在 `docs/corrections.md` 增加一行对照，状态为「已强制」。若动了模型，同步更新 `docs/features.md` 里的模型 ↔ 代码对应。
6. 不要写教训散文，不要创建或更新 `LESSONS.md`。
7. 若无法写成检查，明确告诉人类「这条纠正还没落地」，而不是用 markdown 代替。把 verify 输出作为证据交出。
