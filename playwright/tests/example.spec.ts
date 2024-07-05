import { test, expect } from '../fixture';

test('get starsdsdted link', async ({ webApp }) => {
  // Expects page to have a heading with the name of Installation.
  await expect(webApp.getByRole('heading', { name: 'Installation' })).toBeVisible();
});


test('get startsdsdsded link', async ({ webApp }) => {
  // Expects page to have a heading with the name of Installation.
  await expect(webApp.getByRole('heading', { name: 'Installation' })).toBeHidden();
});


test('get startesdsdd link', async ({ webApp }) => {
  // Expects page to have a heading with the name of Installation.
  await expect(webApp.getByRole('heading', { name: 'Installation' })).toBeVisible();
});
