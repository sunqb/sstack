# poteto flow

这是 sstack 对 poteto（土豆姐，pstack 作者）公开思路的可复用落地：**少写 markdown，多写检查**。本目录与 `flows/yetone/` 隔离，不要把 yetone 的 `LESSONS.md` 错题本做法混进来。

## 哲学

投资倒金字塔：

1. **确定性代码守卫**（最底层、最先做）：类型、lint、自定义 lint、import 边界、测试。agent 被纠正一次，就把同样的错误变成一条过不去的规则。
2. **验证**：按用户视角驱动应用；用功能地图对照预期；关键流程可选用 TLA+；用性质测试覆盖关系而不是单个例子；用截图或录像当证据。大多数 token 应花在这里。
3. **散文**（最少、最薄）：一份很短的 `AGENTS.md`，只写需要判断力的原则，以及如何构建、测试、跑 `verify`。

铁律：

- 每次纠正都变成确定性检查或 lint，而不是再写一行「不要再犯」。
- **不使用 `LESSONS.md` 作为教训堆放处。** 只用 `docs/corrections.md` 做「纠正 → 现已强制执行它的检查」对照表。没有检查的条目等于还没落地。
- 禁止约 99% 的注释。把代码库当作花园来打理。
- 一条 `scripts/verify.sh` 必须全绿，工作才算完成。构建通过不等于验证通过。

本 flow 是通用工作流，不绑定任何具体产品或技术栈。语言配置通过 `sstack-init --preset` 安装；TLA+ 与 Playwright 通过 `--with tla,e2e` 按需打开。

## 本 flow 会装入项目的文件

| 文件 | 作用 |
| --- | --- |
| `AGENTS.md` | 最短操作说明与判断原则 |
| `docs/features.md` | 用户视角功能地图 |
| `docs/corrections.md` | 纠正 → 检查对照表 |
| `docs/sstack/playbooks/` | 给人看的短流程 |
| `skills/` | 给 agent 用的技能说明 |

给 agent 的技能在 `skills/`：`sstack-poteto-adopt`、`sstack-poteto-correct`、`sstack-poteto-verify`、`sstack-poteto-garden`。共享的 `scripts/verify.sh` 与 preset / addon 来自 `core/`，不属于某一种哲学。

## 来源说明

思路来自 poteto 关于「把纠正变成确定性检查、散文放在最后、验证消耗大多数 token」的公开分享，由 sstack 改写成与具体 agent 运行时无关的项目模板。本仓库不是 pstack 插件，也不复制其技能实现。
