# 新项目接入 poteto flow

1. 在空目录运行：`path/to/sstack/bin/sstack-init . --flow poteto --preset <typescript|python|shell>`
2. 需要形式化模型或截图走查时加上 `--with tla,e2e`。
3. 把 preset 里的示例配置合并进项目（TypeScript 用 `package.scripts.example.json`，Python 用 `pyproject.sstack.toml`），不要覆盖已有依赖声明。
4. 填写 `AGENTS.md` 里的构建 / 测试命令和目录说明。
5. 在 `docs/features.md` 先写下即将做的用户路径，再写代码。
6. 把 `bash scripts/verify.sh` 接到本地习惯和 CI。全绿之前不合并、不发布。
