---
name: sstack-yetone-verify
description: 在 yetone 流程项目里跑 scripts/verify.sh，并核对是否在真实环境做过验证、提交说明是否写清跑了什么。用户要求验证、证明已修好、或准备合并时使用。
---

# sstack-yetone-verify

1. 在项目根运行 `bash scripts/verify.sh`。
2. 报告 passed / skipped / failed，以及每一项 skip 的理由。fail 则先修再跑，除非有无法排除的外部阻塞。
3. 说明在哪份代码、哪个环境实际跑过；没跑的写成未跑。
4. 改代码前是否已读 `LESSONS.md` / `docs/code-standards.md`：若这次审查发现没读就改了，记一条教训而不是只口头提醒。
5. 把命令输出交给人类，不要用口头保证代替。
