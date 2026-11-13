# E2E / 截图走查附加件（可选）

`e2e/walkthrough.spec.ts` 按功能地图走一条用户路径并截图到 `e2e/evidence/`（该目录已在 sstack 的 `.gitignore` 中）。默认不访问任何需要登录的真实站点。

启用方式：

```sh
npm install -D @playwright/test
npx playwright install
SSTACK_E2E_BASE_URL=http://127.0.0.1:4173 bash scripts/verify.sh
```

未设置 `SSTACK_E2E_BASE_URL`（或 `PLAYWRIGHT_BASE_URL`）时，verify 会跳过这一步。把走查步骤改成你的 `docs/features.md` 里的真实路径。

同目录还有 `properties.example.ts`（fast-check）和 `test_properties_example.py`（hypothesis）作为性质测试示例，默认不纳入 Playwright 运行。把它们接到项目自己的测试命令之后，verify 才会执行。
