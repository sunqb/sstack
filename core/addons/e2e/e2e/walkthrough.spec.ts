import { test, expect } from "@playwright/test";
import path from "node:path";

const baseURL = process.env.SSTACK_E2E_BASE_URL ?? process.env.PLAYWRIGHT_BASE_URL;

test.describe("feature-map walkthrough", () => {
  test.skip(!baseURL, "Set SSTACK_E2E_BASE_URL to the running app before collecting evidence.");

  test("user can open the entry page", async ({ page }) => {
    await page.goto("/");
    await expect(page).toHaveTitle(/.+/);
    await page.screenshot({
      path: path.join("e2e", "evidence", "01-entry.png"),
      fullPage: true,
    });
  });
});
