# sstack

sstack 是一套**通用**的开发工作流工具包：你后面做的每个项目都可以用同一套思路接入，而不绑定某个产品或语言。

它把两种已经公开、但互相不同的方法论做成**互不混用**的 flow，用同一个安装器选一个装进仓库：

| | `poteto` | `yetone` |
| --- | --- | --- |
| 来源 | poteto（土豆姐，pstack 作者）公开的「少写文档、多写检查」 | yetone（[@yetone](https://github.com/yetone)）公开的 Magpie 维护方式与仓库文件 |
| 中枢 | 确定性检查（类型、lint、测试、verify） | `LESSONS.md` 错题本，以及从中升格的硬规则 |
| 教训怎么落 | 每次纠正先变成一条会失败的检查；`docs/corrections.md` 只留对照表。**不建 `LESSONS.md`** | 定期复盘已合并工作，写成「规则 + 原因 + 证据 + Seen」；满 3 个不同日期升格到 `docs/code-standards.md` |
| Agent 文档 | 很短的 `AGENTS.md`，只保留判断原则和如何跑 verify | 极瘦的 `CLAUDE.md`（只 `@` 两份文件）+ 作为路由表的 `AGENTS.md` |
| 日常节奏 | 对照功能地图改、跑一条 `verify`、全绿再交付 | 可选的并行 loop 盯入口与反馈；人留下 UI/UX 与拍板；验证必须实际跑过 |
| 适合 | 想把 agent 的重复错误直接卡死在工具链里 | 想让 agent 长期维护仓库，并用错题本自我迭代 |

两种 flow 分目录存放（`flows/poteto/`、`flows/yetone/`），安装时只复制其中一套。共享、且不携带哲学的部分（安装器、语言 preset、`verify` 入口、可选 TLA+ / e2e）在 `core/`。

## 快速开始

```sh
git clone https://github.com/sunqb/sstack.git
path/to/sstack/bin/sstack-init /path/to/your-project --flow poteto
# 或
path/to/sstack/bin/sstack-init /path/to/your-project --flow yetone
```

**必须显式写 `--flow`。** 没有默认 flow，安装器也不会提问；漏写会列出可选值并退出。

可选参数：

```sh
sstack-init TARGET --flow poteto --preset typescript
sstack-init TARGET --flow yetone --preset python --with tla,e2e
```

- `--preset typescript|python|shell`：未指定时自动检测。存在 `package.json` → typescript；存在 `pyproject.toml` / `requirements.txt` / `setup.py` 等 → python；否则 → shell。两种信号同时出现时会要求你显式指定，不会猜。
- `--with tla,e2e`：可选附加件，默认不装。`tla` 是一个小的 TLA+ 资源池模型；`e2e` 是 Playwright 截图走查和性质测试示例。
- 安装器**不会覆盖已有文件**，再跑一次是安全的。

然后在项目根执行：

```sh
bash scripts/verify.sh
```

工具或配置不存在的步骤会被跳过；已经启用并跑起来的步骤失败，则整个 verify 失败。全绿之前不要把工作标成完成。

## 各 preset 会提供什么

- **typescript**（Node / 前端）：严格的 `tsconfig.strict.json`、ESLint flat 配置（import 边界、禁止高风险 API、自定义规则示例）、`package.scripts.example.json`（合并进你的 `package.json`，不会丢一个假的依赖清单进仓库）。
- **python**（后端 / 脚本）：`pyproject.sstack.toml`，含 ruff、mypy / pyright、pytest。空项目可改名为 `pyproject.toml`；已有项目请合并对应的 `[tool.*]` 表。
- **shell**（其他语言或纯脚本）：`Makefile.sstack.example`，以及 `scripts/verify.d/` 扩展点，把任意检查挂到同一条 verify 上。

## 仓库结构

```
bin/sstack-init          # 安装器
core/                    # 与方法论无关的共享件
  scripts/verify.sh
  presets/               # typescript, python, shell
  addons/                # tla, e2e
flows/poteto/            # 模板、playbooks、skills
flows/yetone/            # 模板、playbooks、skills（含 LESSONS.md 机制说明与来源）
```

每个 flow 目录里的 `README.md` 写哲学和来源。yetone flow 的来源列表（Magpie 仓库文件、X 原帖、二手转写及其不确定点）见 [flows/yetone/README.md](flows/yetone/README.md)。

## 许可

MIT，见 [LICENSE](LICENSE)。
