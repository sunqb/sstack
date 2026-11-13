# Go preset

`scripts/verify.sh` 在发现 `go.mod` 时会依次运行：

1. `gofmt -l`：若有未格式化的文件则失败
2. `go vet ./...`
3. `go test ./...`
4. 若已安装 `golangci-lint`，再跑 `golangci-lint run`

`go` 或 `go.mod` 不存在时跳过。`.golangci.yml` 含 depguard（依赖边界）与 forbidigo（禁止的 API）示例，请按项目包名修改后使用。若你的 golangci-lint 主版本与配置不合，以该工具的当前文档为准做一次迁移，不要删掉这两类规则。
