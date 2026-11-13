---
name: sstack-verify
description: 在 poteto flow 项目里跑 scripts/verify.sh，对照 docs/features.md 做运行时验证，收集证据。缺检查时先补检查再宣称完成。
---

# sstack-verify

1. 在项目根运行 `bash scripts/verify.sh`。
2. 报告 passed / skipped / failed。解释每一项 skip 是否可接受。任何 fail 都意味着工作未完成。
3. 打开 `docs/features.md`，核对应改动的用户路径：步骤、可观察预期、验证方式。
4. 需要截图时，设置 `SSTACK_E2E_BASE_URL` 再跑 verify 或 Playwright，把证据放到约定目录。
5. 若功能地图有条目却没有对应检查，先补检查，再声称完成。
6. 不要用「构建通过」或口头保证代替 verify 输出。
