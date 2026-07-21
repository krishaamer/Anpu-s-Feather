# Anpu’s Feather — web

The playable web version of Anpu’s Feather. Plain TypeScript + Canvas 2D,
bundled with [Vite](https://vitejs.dev). No framework, ~25 KB of JS.

```sh
npm install
npm run dev       # development server with hot reload
npm run build     # type-check + production build into dist/
npm run preview   # serve the production build locally
```

## How it works

It is a module-by-module port of the original Processing sketch in
[`../../archive/`](../../archive/). Each `.pde` class became a TypeScript
module:

| Module | Role |
|--------|------|
| `main.ts` | Boot, letterbox the fixed 1600×900 canvas into the window, run loop |
| `experience.ts` | Scene director (the port of `feather.pde` + `scenes.pde`) |
| `narrative.ts` | Scene sequencing and timing |
| `skeleton.ts` | Plays back the recorded Kinect movement files; blends the hands toward the pointer |
| `pointer.ts` | Pointer/touch input — the Kinect stand-in |
| `river.ts`, `pyramid.ts`, `deity`-style visuals | Backdrops |
| `user.ts` | Light-heart particle cloud and heavy-heart rings |
| `scales.ts` | Feather-weighing physics |
| `qa.ts` | The YES/NO question |
| `wisdom.ts` | Wisdom-card composition + save (native share sheet on mobile) |
| `message.ts`, `music.ts` | Text overlays and soundtrack |

Assets (art, music, recorded skeleton data) live in `public/assets/` and are
copied verbatim from the original installation. The music was downsampled to
mono 22 kHz to shrink the download.

The pointer replaces the Kinect: your spirit’s hands follow it, movement keeps
the feather aloft, and buttons can be answered by click/tap or by moving a
hand into them.
