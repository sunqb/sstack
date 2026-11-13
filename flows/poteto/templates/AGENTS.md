# AGENTS.md

## 怎么跑

- 构建：`<填写构建命令，例如 npm run build>`
- 测试：`<填写测试命令，例如 npm test>`
- 验证：`bash scripts/verify.sh`（全绿才算完成；不要用「构建通过」代替）

## 目录

- `<src 或等价目录>`：`<一句话说明>`
- `<测试目录>`：`<一句话说明>`
- `docs/features.md`：用户视角功能地图，改功能先改这张表
- `docs/corrections.md`：纠正 → 已强制检查的对照表
- `scripts/verify.sh`：唯一验收入口；扩展钩子放 `scripts/verify.d/`

## 判断原则

- 能写成类型、lint 或测试的规则，不要写进本文件。本文件只保留需要判断力的原则。
- 被纠正时：先补一条会失败的检查，再修代码，最后在 `docs/corrections.md` 留一行对照。不要创建 `LESSONS.md`。
- 对照 `docs/features.md` 的可观察预期验证，而不是只断言实现细节。
- 少写注释。代码本身应能被读懂；例外只留给非显而易见的权衡。
- 未经 `verify` 全绿，不要声称工作已完成。
