---
name: sstack-yetone-adopt
description: 用 sstack 的 yetone 流程接管或接入当前项目。在用户说「用 sstack 的 yetone 流程接管这个项目」或要落地 LESSONS.md 错题本工作流时使用。由 agent 执行 init、按代码库写真实文档并跑验证；不要改用 poteto 的 corrections.md。
---

# sstack-yetone-adopt

在当前项目根落地 yetone flow。你亲自做完，人类只审查证据。

## 步骤

1. 解析 SSTACK_ROOT。若 `.sstack/flow` 已存在且不是 `yetone`，停下说明，不要混装。
2. 按 `sstack-init` 的规则探测技术栈；多种信号并存时选一个并在证据里写明。
3. 缺工具时先尝试自己安装；装不上就记录并继续。
4. 执行：`$SSTACK_ROOT/bin/sstack-init . --flow yetone --preset <detected>`。不要写入 poteto 的 `docs/corrections.md` 或 `docs/features.md`。
5. **按代码库改成真实文档，不要留下空洞占位：**
   - `CLAUDE.md` 保持两行：`@AGENTS.md` 与 `@LESSONS.md`。
   - `AGENTS.md`：路由到本仓库真实路径；必须保留并写清下面两条自动规则：
     - 改代码之前先读 `LESSONS.md` 和 `docs/code-standards.md`。
     - 用户纠正你、或你发现「又修了一遍 / 不该合 / 验证太薄」时，立即按 `sstack-yetone-lesson` 写入错题本（有证据才写；Seen 按不同日期计数；满 3 天升格），不要等人类提醒。不要创建 `docs/corrections.md` 来代替错题本。
     - 声称完成或合并之前，必须自己跑 `bash scripts/verify.sh`，并写清跑了什么、哪些未跑。
   - `docs/design.md`：只写能从仓库里看出来的已有方向；编不出来就标明「未决」，不要虚构拍板。
   - `LESSONS.md`：保留文首格式约定。只有从 git 历史或测试里拿得到证据的教训才写成条目；没有证据就不要编。
6. 跑 `bash scripts/verify.sh`。失败则修复或清楚报告阻塞。
7. 向人类只报告：preset、写了哪些文档、是否有真实教训条目、verify 输出、缺的工具。
