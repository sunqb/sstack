---
name: sstack
description: 在用户提到 sstack、poteto 流程、yetone 流程，或说「用 sstack 接管这个项目」时使用。先读 SSTACK.md，再路由到对应 flow 的 adopt/correct/lesson/verify 技能并亲自执行，不要让人类去跑命令。
---

# sstack

1. 解析 SSTACK_ROOT：本技能所在仓库（对 symlink 取真实路径，向上找到含 `bin/sstack-init` 和 `SSTACK.md` 的目录），或 `$SSTACK_ROOT`，或 `$HOME/sstack`。
2. 阅读 `$SSTACK_ROOT/SSTACK.md`。
3. 根据用户的话选择**一个** flow，打开对应技能并完整执行：
   - 接管 / 接入 / 落地 + poteto → `flows/poteto/skills/sstack-poteto-adopt/SKILL.md`
   - 接管 / 接入 / 落地 + yetone → `flows/yetone/skills/sstack-yetone-adopt/SKILL.md`
   - poteto 项目中的纠正、别再这样、你写错了 → `sstack-poteto-correct`
   - yetone 项目中记一条教训 → `sstack-yetone-lesson`
   - yetone 定期复盘 → `sstack-yetone-retro`
   - 验证、给证据、跑检查 → 该 flow 的 verify 技能
   - poteto 定期打扫 → `sstack-poteto-garden`
4. 两套 flow 隔离。不要同时写入 `docs/corrections.md` 和 `LESSONS.md` 来「各做一点」。
5. 你负责跑命令、改文件、收集证据。人类只看结果。
