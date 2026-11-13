---
name: sstack-poteto-verify
description: 在 poteto 流程项目里跑 scripts/verify.sh，对照 docs/features.md 收集证据（测试输出、TLC 结果、截图、跳过原因）。若项目声明了形式化模型或 UI 走查，这些步骤必须实际跑过，不能 skip。
---

# sstack-poteto-verify

1. 在项目根运行 `bash scripts/verify.sh`。
2. 报告 passed / skipped / failed。解释每一项 skip 是否可接受。任何 fail 都意味着未完成；先修再跑，除非有你无法排除的外部阻塞。
3. 若存在 `.sstack/require-tlc` 或 `spec/*.tla`：必须看到 TLC 的 `pass:`。出现 skip 或因缺少 TLC / `.cfg` 失败时，先安装（`$SSTACK_ROOT/bin/sstack-install-tlc .`）或修好规格，再跑，不要当作可接受的 skip。
4. 若存在 `.sstack/require-e2e`：必须实际跑 UI 走查。不要让人类手动 export URL；必要时补 Playwright `webServer` 或等价启动方式。
5. 对照 `docs/features.md` 里受影响的用户路径，以及其中的模型 ↔ 代码对应。
6. 功能地图有条目却没有对应检查时，先补检查再声称完成。
7. 把命令输出交给人类，不要用「构建通过」或口头保证代替。
