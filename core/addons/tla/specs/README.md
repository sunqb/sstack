# TLA+ 附加件（可选）

这是一个与业务无关的「有容量上限的资源池」骨架：请求、获得、释放、撤回，以及互斥与容量不变性。状态空间很小，几秒内应能跑完。

安装 [TLA+ tools](https://github.com/tlaplus/tlaplus/releases) 并确保 `tlc` 或 `tlc2` 在 PATH 中之后，`scripts/verify.sh` 会在发现 `*.tla` 与对应 `*.cfg` 时自动跑模型检查。也可以手动执行：

```sh
tlc -config specs/ResourcePool.cfg specs/ResourcePool.tla
```

把常量与不变性改成你自己的关键流程，不要只保留这个示例。工具未安装时，verify 会跳过这一步而不是失败。
