---
name: sstack-yetone-loop
description: 按 yetone flow 的 loops/ 提示词执行周期维护：处理入口、过滤反馈、或复盘并更新 LESSONS.md。合并前必须实际运行验证。
---

# sstack-yetone-loop

1. 只执行用户指定的那一条 loop（01 入口、02 反馈、或 03 错题本）。不要在一次会话里兼职三条。
2. 打开对应的 `loops/*.md`，遵守其中的「做什么 / 不做什么 / 做完要回复」。
3. 修复或合并之前：在真实环境复现，拉下代码实际运行，跑 `bash scripts/verify.sh`。做不到就不要合并，改为回复缺了什么。
4. 第 2 条 loop：先过滤无关内容，再把相关反馈交给主模型。
5. 第 3 条 loop：按 `LESSONS.md` 格式写教训；屏蔽贡献者只向维护者提议。
6. 不要推翻 `docs/design.md` 里已拍板的决定。UI/UX 拿不准时交给人。
7. 在回复和提交说明里写清实际跑过的命令；没跑的写未跑。
