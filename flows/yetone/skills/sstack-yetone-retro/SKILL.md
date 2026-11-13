---
name: sstack-yetone-retro
description: 在 yetone 流程项目里做定期复盘：查看近期提交，找出又修了一遍、不该合并、验证太薄的事项，按格式写入 LESSONS.md，并在达到门槛时升格。用户说复盘、夜间审查、清错题本时使用。
---

# sstack-yetone-retro

1. 查看近期已合并提交（git log / diff）。只问三件事：是否后来又修了一遍、是否不该合、验证是否太薄。
2. 按 `sstack-yetone-lesson` 的格式写入或更新 `LESSONS.md`。没有证据的不要编。
3. 达到 3 个不同日期的条目立刻升格。
4. 跑 `bash scripts/verify.sh`，把复盘条目和 verify 输出作为证据交给人类。
5. 不要推翻 `docs/design.md` 里已拍板的决定。
