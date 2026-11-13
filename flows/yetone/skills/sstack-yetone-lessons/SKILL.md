---
name: sstack-yetone-lessons
description: 在 yetone flow 项目里阅读、追加或升格 LESSONS.md。按「规则 + 原因 + 证据 + Seen 日期」书写；满 3 个不同日期再搬进 docs/code-standards.md。
---

# sstack-yetone-lessons

1. 改代码之前先读完整的 `LESSONS.md` 和 `docs/code-standards.md`。
2. 复盘或纠正时，只追加符合文首格式的条目：加粗规则、原因、证据、`Seen N× (日期…)`。没有证据就不要写。
3. 若命中已有规则，只增加一个新的日期和证据。同一天不重复计数。
4. 当一条教训被至少 3 个不同日期看到：把规则搬进 `docs/code-standards.md`，并在 `LESSONS.md` 的 “Moved to the code standards” 建索引。
5. 不要改成 poteto 式的 `docs/corrections.md`，也不要删除 Seen 机制改成随笔。
6. 若能同时补上一条会失败的测试或 lint，一起做，并在该条教训的证据里链过去。
