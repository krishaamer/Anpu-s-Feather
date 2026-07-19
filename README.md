# Anpu’s Feather 阿努比斯的羽毛

**▶ Play it in your browser** — an interactive experience inviting you to
think about your life before death.

## Story

You went on a trip on the Nile river before your death. You’re welcome by Anubis.

Based on Egyptian mythology we ask you to reflect upon your life and offer a token of wisdom (in the shape of a wisdom card).

Welcome, you have reached the entrance. How have you lived your life? This feather shows the weight of your heart.

## How to play

1. Answer Anubis’ question (**YES** or **NO**) — click a button or reach into it with your pointer
2. Show the heaviness of your heart by moving your pointer — your spirit’s hands follow it
3. Show the busyness of your life by keeping the feather aloft: movement lifts it, stillness lets it sink
4. Receive your wisdom card — a Sebayt saying chosen by where the feather came to rest — and save it as an image

Testing shortcuts (kept from the original): keys `1`–`7` jump between scenes,
`R` resets scene time, `←`/`→` cycle the recorded Kinect movements, `M` mutes.

## Run locally

```sh
npm install
npm run dev     # development server
npm run build   # production build in dist/
```

The app is plain TypeScript + Canvas, built with [Vite](https://vitejs.dev).
Pushes to `master` deploy to GitHub Pages automatically
(`.github/workflows/deploy.yml`).

## The original installation

This is a web port of the 2020 Processing + Kinect installation created by
Lei Lin and Kris Haamer at NCKU ICID Digital Design class, Tainan, Taiwan.
The original sketch, artwork and recorded skeleton data are preserved in
[`archive/`](archive/) — the web version reuses the same narrative, art,
music and movement recordings, with the pointer standing in for the Kinect.

## Anpu, Anubis, Protector of the graves
Anubis was commonly depicted in black color, symbolizing the black fertile soil of the Nile River Valley, a sign of life and regeneration [[1](https://books.google.com.tw/books?id=mHD4CgAAQBAJ&pg=PT192)]

## Mꜣꜥt, The Feather of Truth
Anubis uses an ostrich feather to seek Truth, Balance, Order, Harmony, and Justice. Light hearts would ascend, heavy ones be devoured [[2](https://en.wikipedia.org/wiki/Maat)]

## Credits

- Music: “Anubis” by Lucha and R3VXS (copyright-free) — [YouTube](https://www.youtube.com/watch?v=HrszBzkxtCM)
- Wisdom quotes: [Sebayt](https://en.wikipedia.org/wiki/Sebayt) pharaonic Egyptian wisdom literature,
  [Ramesside teaching on the immortality of writers](https://www.ucl.ac.uk/museums-static/digitalegypt/literature/authorspchb.html)
- Development journey: [GitHub project](https://github.com/krishaamer/Anpu-s-Feather)
