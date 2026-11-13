import { defineConfig } from "@playwright/test";

const baseURL = process.env.SSTACK_E2E_BASE_URL ?? process.env.PLAYWRIGHT_BASE_URL;

export default defineConfig({
  testDir: "./e2e",
  outputDir: "./e2e/evidence",
  timeout: 30_000,
  use: {
    baseURL,
    screenshot: "only-on-failure",
  },
  testIgnore: ["**/properties.example.ts", "**/test_properties_example.py"],
});
