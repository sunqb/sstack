# 已有项目接入 yetone flow

`sstack-init` 不会覆盖已有文件。

1. `sstack-init /path/to/project --flow yetone`。若项目里已有 `AGENTS.md` 或 `CLAUDE.md`，把模板里的阅读路由手工合并进去：至少要能指向 `LESSONS.md` 与 `docs/code-standards.md`。
2. 若已有很长的 `CLAUDE.md`，不要把错题本全文贴进去。保持入口瘦，细则放独立文件。
3. 用最近一段时间的提交做一次复盘，按格式种下第一批 `LESSONS.md` 条目。没有证据的不要编。
4. 已经反复出现的问题（满 3 个不同日期）直接写入 `docs/code-standards.md`，并在 LESSONS 的 Moved 一节索引。
5. 把现有测试与 lint 接到 `scripts/verify.sh`。提交说明开始记录「跑了什么、没跑什么」。
6. 不要同时安装 poteto flow 的 `docs/corrections.md` 来「代替」错题本。两套方法论不要混在一个仓库里。
