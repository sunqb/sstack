---
name: sstack-yetone-lesson
description: 在 yetone 流程项目里把一条教训写入或更新 LESSONS.md（规则 + 原因 + 证据 + Seen 日期）。同一条在 3 个或更多个不同日期被看到时升格到 docs/code-standards.md。用户纠正你、或发现重复错误时使用。
---

# sstack-yetone-lesson

用户纠正你或你发现重复失误时立刻执行。

1. 先读完整的 `LESSONS.md` 和 `docs/code-standards.md`。
2. 新条目必须是：加粗规则、原因、证据（commit / issue / 复现）、`Seen N× (YYYY-MM-DD, …)`。没有证据不要写。
3. 若命中已有规则，只增加一个新的日期和证据。同一天不重复计数。
4. 一条教训被至少 3 个不同日期看到时：把规则搬进 `docs/code-standards.md`，并在 `LESSONS.md` 的 “Moved to the code standards” 建索引。
5. 不要改成 poteto 式的 `docs/corrections.md`。能同时补上会失败的测试或 lint 时一起做，并在证据里链过去。
6. 需要的话再跑 `bash scripts/verify.sh`，把结果交给人类。
