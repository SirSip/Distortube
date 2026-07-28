# YouTube VHS

A Manifest V3 Chrome extension that composites a WebGL VHS renderer over YouTube's native HTML5 video. It never downloads, replaces, or modifies video data. Player controls, captions, and the rest of the YouTube UI remain native interactive elements.

## Install

1. Open `chrome://extensions` in Chrome.
2. Turn on **Developer mode**.
3. Select **Load unpacked**.
4. Choose this `youtube-vhs-extension` folder (the folder containing `manifest.json`).
5. Open or reload a YouTube watch page, Short, live stream, or `youtube.com/embed/...` player.
6. Use the extension toolbar popup to tune and persist the effect.

## Notes

- The effect uses an independent WebGL canvas and uploads the current decoded HTML5 video frame as a texture each animation frame. It is designed for 60 FPS on typical GPU-accelerated Chrome installations; video resolution, device GPU, and background-tab throttling determine actual frame rate.
- Aging Tape Mode starts at the selected baseline settings and ramps in extra damage over roughly 10 minutes at the default aging speed. Returning the player to the beginning resets that damage.
- The extension is intentionally constrained to `https://www.youtube.com/*`. Embedded players are covered when their own document is a `youtube.com/embed/...` URL.
- If WebGL or a video texture cannot be used, the renderer removes itself and leaves the original YouTube video visible.
