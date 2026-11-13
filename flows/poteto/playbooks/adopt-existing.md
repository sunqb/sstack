# 已有项目接入 poteto flow

`sstack-init` **不会覆盖已有文件**。重复运行是安全的。

1. `sstack-init /path/to/project --flow poteto`（可省略 `--preset`，存在 `package.json` 或 `pyproject.toml` / `requirements.txt` 时会自动检测；两种信号同时存在则必须显式指定）。
2. 查看输出里的 `skip:`：已有的 `AGENTS.md`、eslint 或 tsconfig 不会被替换。把模板里仍然有用的段落手工合并进去。
3. 确认项目根出现 `scripts/verify.sh`。若你已有同名脚本，把 sstack 的探测步骤并入现有脚本，或把旧逻辑做成 `scripts/verify.d/` 钩子。
4. 用 `docs/features.md` 梳理当前用户可见行为，先覆盖最容易回归的路径。
5. 把你已经在执行的类型检查、lint、测试命令接到 verify（`npm run typecheck` / `npm run lint` / `pytest` 等会被自动发现）。
6. 跑两次 `bash scripts/verify.sh`：先看哪些被 skip，再补上你真正需要的工具，而不是一次性打开所有 addon。
