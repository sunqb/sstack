# core：与方法论无关的共享件

这里只放两种 flow 都能用、且不携带 poteto / yetone 哲学的东西：

- `bin/sstack-init`（仓库根下）与本目录的preset 探测、文件安装逻辑
- `scripts/verify.sh`：按项目里实际存在的工具跑类型检查、lint、测试；缺失则跳过
- `presets/`：TypeScript、Python、Java、Go、通用 shell 的起步配置
- `addons/`：TLA+ 与 Playwright / 性质测试示例，供手工或 yetone 侧通过 `--with tla,e2e` 拷贝。poteto 不靠这个开关：由技能判定后直接在项目里写 `spec/` 或 e2e，并用 `sstack-install-tlc` 安装 TLC。

选哪一种方法论、写什么 agent 文档、如何记录教训，全部在 `flows/` 里，互不混用。
