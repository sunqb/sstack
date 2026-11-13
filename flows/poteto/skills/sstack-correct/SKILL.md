---
name: sstack-correct
description: 把对 agent 的纠正变成一条确定性检查，并在 docs/corrections.md 留下对照。用于 poteto flow。不要只改文档，不要创建 LESSONS.md。
---

# sstack-correct

在 poteto flow 的项目里，把一次纠正落到强制检查上。

1. 用用户可观察的语言写清做错了什么。
2. 新增或收紧一条确定性检查（类型、lint、import 边界、测试、TLA+ 不变性、`scripts/verify.d/` 钩子）。先让 `bash scripts/verify.sh` 因这条检查而失败。
3. 修复产品代码，再跑 verify，直到全绿。
4. 在 `docs/corrections.md` 增加一行对照，状态为「已强制」。
5. 不要写教训散文，不要创建或更新 `LESSONS.md`（那是 yetone flow 的做法，与本 flow 隔离）。
6. 若无法写成检查，明确说这条纠正还没落地，而不是用 markdown 代替。
