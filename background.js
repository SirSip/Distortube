const defaults = { enabled: true, alwaysOn: true, aging: true, intensity: 55, noise: 32, scanlines: 38, rgb: 28, glitch: 18, tracking: 30, blur: 14, color: 26, agingSpeed: 50 };

chrome.runtime.onInstalled.addListener(async () => {
  const current = await chrome.storage.sync.get(defaults);
  await chrome.storage.sync.set(current);
});
