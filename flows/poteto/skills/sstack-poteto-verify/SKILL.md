---
name: sstack-poteto-verify
description: 在 poteto 流程项目里跑 scripts/verify.sh，对照 docs/features.md 收集证据（测试输出、截图、跳过原因）。用户要求验证、证明改好了、或审查完成时使用。
---

# sstack-poteto-verify

1. 在项目根运行 `bash scripts/verify.sh`。
2. 报告 passed / skipped / failed。解释每一项 skip 是否可接受。任何 fail 都意味着未完成；先修再跑，除非有你无法排除的外部阻塞。
3. 对照 `docs/features.md` 里受影响的用户路径：步骤和可观察预期是否成立。
4. 需要截图时设置 `SSTACK_E2E_BASE_URL` 再跑约定的走查，把证据放到 `e2e/evidence/` 或验证输出中引用的路径。
5. 功能地图有条目却没有对应检查时，先补检查再声称完成。
6. 把命令输出交给人类，不要用「构建通过」或口头保证代替。
