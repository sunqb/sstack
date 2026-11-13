# 新项目接入 poteto flow

人类只需对编码 agent 说：

```
用 sstack 的 poteto 流程接管这个项目
```

由 agent 执行 `sstack-poteto-adopt`：探测技术栈、运行 `sstack-init`（不要加 `--with tla,e2e`）、按代码库写真实的 `AGENTS.md` 与功能地图、按技能里的标准判定是否写 TLA+ 或 UI 走查、自己跑 `verify`，并把证据交回。不要把这些命令拆给人类去跑。

preset 示例配置要合并进项目，不要覆盖已有依赖或构建文件。
