import { test as playwrightTest, expect } from '@playwright/test';

export const test = playwrightTest.extend({
  webApp: async ({ page }, use) => {
    await page.goto('https://playwright.dev/');
    await page.getByRole('link', { name: 'Get started' }).click();
    await use(page)
    console.log('teardown')
  },
})
export { expect };
