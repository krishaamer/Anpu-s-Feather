# Anpu’s Feather 阿努比斯的羽毛

An interactive experience inviting you to think about your life before death.

## Story

You went on a trip on the Nile river before your death. You’re welcome by Anubis.

Based on Egyptian mythology we ask you to reflect upon your life and offer a token of wisdom (in the shape of a wisdom card).

Welcome, you have reached the entrance. How have you lived your life? This feather shows the weight of your heart.

## Repository layout

This repo holds four incarnations of the same experience:

| Path | What it is |
|------|------------|
| [`apps/web/`](apps/web/) | **The game.** A TypeScript + Vite + Canvas app that runs in any browser. This is the source of truth for gameplay and art. |
| [`apps/ios/`](apps/ios/) | **The native iOS app.** A from-scratch Swift + **Metal** implementation (no web view) — GPU-native rendering and speed, buildable in Xcode. |
| [`apps/unity/`](apps/unity/) | **The Unity port.** A C# port mirroring the iOS Metal architecture — immediate-mode canvas, persistent render targets, same timings and quirks. Requires Unity 6000.6 Beta. |
| [`archive/`](archive/) | **The original 2020 installation.** The Processing + Kinect sketch, preserved unchanged. |

All four share the same narrative, art, music and recorded-movement data.
The web, iOS, and Unity apps are independent implementations of it — the web app in
TypeScript + Canvas, the iOS app in Swift + Metal, the Unity app in C# + built-in RP.

## How to play

1. Answer Anubis’ question (**YES** or **NO**) — click/tap a button or reach into it with your pointer
2. Show the heaviness of your heart by moving your pointer — your spirit’s hands follow it
3. Show the busyness of your life by keeping the feather aloft: movement lifts it, stillness lets it sink
4. Receive your wisdom card — a Sebayt saying chosen by where the feather came to rest — and save it

Testing shortcuts (kept from the original): keys `1`–`7` jump between scenes,
`R` resets scene time, `←`/`→` cycle the recorded Kinect movements, `M` mutes.

## Quick start

```sh
# The web game
cd apps/web
npm install
npm run dev          # dev server
npm run build        # production build in apps/web/dist

# The native iOS app (requires macOS + Xcode)
open apps/ios/AnpusFeather.xcodeproj   # then pick a simulator/device and Run

# The Unity port (requires Unity 6000.6 Beta)
# Add apps/unity in Unity Hub, open with 6000.6, then Play Main.unity
```

Pushes to `master` deploy the web app to GitHub Pages automatically
(`.github/workflows/deploy.yml`).

## The original installation

The web version is a faithful port of the 2020 Processing + Kinect
installation created by Lei Lin and Kris Haamer at NCKU ICID Digital Design
class, Tainan, Taiwan. The original sketch, artwork and recorded skeleton
data live in [`archive/`](archive/) — the ports reuse the same narrative,
art, music and movement recordings, with the pointer standing in for the
Kinect.

## Anpu, Anubis, Protector of the graves
Anubis was commonly depicted in black color, symbolizing the black fertile soil of the Nile River Valley, a sign of life and regeneration [[1](https://books.google.com.tw/books?id=mHD4CgAAQBAJ&pg=PT192)]

## Mꜣꜥt, The Feather of Truth
Anubis uses an ostrich feather to seek Truth, Balance, Order, Harmony, and Justice. Light hearts would ascend, heavy ones be devoured [[2](https://en.wikipedia.org/wiki/Maat)]

## Credits

- Music: “Anubis” by Lucha and R3VXS (copyright-free) — [YouTube](https://www.youtube.com/watch?v=HrszBzkxtCM)
- Wisdom quotes: [Sebayt](https://en.wikipedia.org/wiki/Sebayt) pharaonic Egyptian wisdom literature,
  [Ramesside teaching on the immortality of writers](https://www.ucl.ac.uk/museums-static/digitalegypt/literature/authorspchb.html)
- Development journey: [GitHub project](https://github.com/krishaamer/Anpu-s-Feather)
