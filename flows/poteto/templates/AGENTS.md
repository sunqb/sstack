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

## 自动执行（不要把这些步骤推给人类）

- 用户一旦纠正你（指出写错、回归、或「别再这样」），立即把纠正写成确定性检查（lint / 测试 / 类型 / 边界规则），先让 verify 因这条检查失败，再修代码直到全绿，并在 `docs/corrections.md` 留一行对照。不要等人类再说一次，不要创建 `LESSONS.md`。
- 在声称完成、可以合并或已经修好之前，必须自己跑 `bash scripts/verify.sh`，并把输出作为证据。构建通过不等于完成。
- 能写成检查的规则不要写进本文件。本文件只保留判断原则和上面的自动循环。
- 对照 `docs/features.md` 的可观察预期验证。少写注释。
