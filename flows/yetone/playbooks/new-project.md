# 新项目接入 yetone flow

1. `path/to/sstack/bin/sstack-init . --flow yetone --preset <typescript|python|shell>`
2. 填写 `docs/design.md`：要解决什么、不解决什么、已经拍板的取舍。早期与人（或与模型）讨论过的决定，记在这里，而不是只留在聊天记录里。
3. 把 `AGENTS.md` 里的目录和验证习惯改成你的仓库实况。`CLAUDE.md` 保持两行，不要把细则贴回去。
4. `LESSONS.md` 先保持模板约定；有了第一次「修过又坏」或「验证太薄」再追加真正的条目。
5. 若有社区贡献，按 `docs/contributors.md` 执行闸门。
6. 需要持续值守时，按 `loops/` 三条提示词启动周期任务，并阅读 `run-the-loops.md`。不是每个项目都要一上来就开三条 loop。
7. `bash scripts/verify.sh` 接到 CI。合并说明里写实际跑过的命令。
