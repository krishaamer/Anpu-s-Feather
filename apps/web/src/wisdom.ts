/*
  Wisdom: store wisdom sayings and generate wisdom cards — the port of
  wisdom.pde.

  Quotes from Sebayt pharaonic Egyptian wisdom literature:
  https://en.wikipedia.org/wiki/Sebayt
  The 1200 BC Ramesside view on the immortality of the writer:
  https://www.ucl.ac.uk/museums-static/digitalegypt/literature/authorspchb.html
*/

import { W, H, FPS, map, clamp } from "./core";

const QUOTES = [
  "If you would only accomplish this, becoming expert in writing: Those writers of knowledge from the time of events after the gods, those who foretold the future, their names have become fixed for eternity, though they are gone, they have completed their lifespan, and all their kin are forgotten.",
  "They did not make for themselves a chapel of copper, or a stela for it of iron from the sky. They did not manage to leave heirs, from their children, to pronounce their names, but they have achieved heirs out of writings, out of the teachings in those.",
  "They are given the book as ritual-priest, The writing-board as loving-son. Teachings are their chapels, the writing-rush their child, and the block of stone the wife. From great to small, (all) are given as his children, for the writer, he is their leader.",
  "The doors of their chapels are undone, Their ka-priests have gone. Their tombstones are smeared with mud, their tombs are forgotten, but their names are read out on their scrolls, written when they were young. Being remembered makes them, to the limits of eternity.",
  "Be a writer - put it in your heart, and your name is created by the same. Scrolls are more useful than tombstones, than building a solid enclosure. They act as chapels and chambers, by the desire of the one pronouncing their name. For sure there is most use in the cemetery for a name in the mouths of men.",
  "A man is dead, his corpse is in the ground: when all his family are laid in the earth, It is writing that lets him be remembered, in the mouth of the reciter of the formula. Scrolls are more useful than a built house, than chapels on the west, they are more perfect than palace towers, longer-lasting than a monument in a temple.",
  "Is there anyone here like Hordedef? Is there another like Imhotep? There is no family born for us like Neferty, and Khety their leader. Let me remind you of the name of Ptahemdjehuty Khakheperraseneb. Is there another like Ptahhotep? Kaires too?",
  "Those who knew how to foretell the future, What came from their mouths took place, and may be found in (their) phrasing. They are given the offspring of others as heirs as if their (own) children. They hid their powers from the whole land, to be read in (their) teachings. They are gone, their names might be forgotten, but writing lets them be remembered.",
];

// Where the white photo window and quote area sit inside the 1000x800 card art
const CARD_WINDOW = { x: 97, y: 265, w: 363, h: 367 };
const CARD_QUOTE = { x: 545, y: 300, w: 355, h: 380 };

export class Wisdom {
  private alpha = 0;
  private quote = "";
  private hasRun = false;

  constructor(
    private ctx: CanvasRenderingContext2D,
    private images: Record<string, HTMLImageElement>,
    private capture: HTMLCanvasElement,
  ) {}

  /** The feather's height picks the saying: a light heart hears different wisdom. */
  getQuote(featherY: number): string {
    if (!this.hasRun) {
      this.hasRun = true;
      const choice = clamp(
        Math.floor(map(featherY, -480, 300, 0, QUOTES.length)),
        0,
        QUOTES.length - 1,
      );
      this.quote = QUOTES[choice];
    }
    return this.quote;
  }

  showCard() {
    this.drawCard(this.ctx, this.alpha / 255);
  }

  /** Render the finished card (used both on screen and for the PNG download). */
  drawCard(ctx: CanvasRenderingContext2D, alpha = 1) {
    const card = this.images["wisdom_card_bg"];
    const scale = Math.min((W * 0.62) / card.width, (H * 0.98) / card.height);
    const cw = card.width * scale;
    const ch = card.height * scale;
    const cx = W / 2 - cw / 2;
    const cy = H / 2 - ch / 2;

    ctx.save();
    ctx.globalAlpha = alpha;
    ctx.drawImage(card, cx, cy, cw, ch);

    // Composite the captured body image into the white window (center-crop
    // the 16:9 capture to the window's aspect ratio).
    const win = {
      x: cx + CARD_WINDOW.x * scale,
      y: cy + CARD_WINDOW.y * scale,
      w: CARD_WINDOW.w * scale,
      h: CARD_WINDOW.h * scale,
    };
    const srcAspect = this.capture.width / this.capture.height;
    const dstAspect = win.w / win.h;
    let sw = this.capture.width;
    let sh = this.capture.height;
    if (srcAspect > dstAspect) sw = sh * dstAspect;
    else sh = sw / dstAspect;
    const sx = (this.capture.width - sw) / 2;
    const sy = (this.capture.height - sh) / 2;
    ctx.drawImage(this.capture, sx, sy, sw, sh, win.x, win.y, win.w, win.h);

    // The saying, wrapped over the right-hand panel
    ctx.fillStyle = "rgb(230,222,200)";
    ctx.font = `${Math.round(19 * scale)}px Georgia, serif`;
    ctx.textAlign = "left";
    ctx.textBaseline = "top";
    const qx = cx + CARD_QUOTE.x * scale;
    const qy = cy + CARD_QUOTE.y * scale;
    const qw = CARD_QUOTE.w * scale;
    const lineHeight = 26 * scale;
    const words = this.quote.split(" ");
    let line = "";
    let y = qy;
    for (const w of words) {
      const test = line ? `${line} ${w}` : w;
      if (ctx.measureText(test).width > qw && line) {
        ctx.fillText(line, qx, y);
        y += lineHeight;
        line = w;
      } else {
        line = test;
      }
    }
    if (line) ctx.fillText(line, qx, y);
    ctx.restore();
  }

  /** Compose the finished card on black and hand it to the visitor. */
  async download() {
    const out = document.createElement("canvas");
    out.width = W;
    out.height = H;
    const octx = out.getContext("2d")!;
    octx.fillStyle = "#000";
    octx.fillRect(0, 0, W, H);
    this.drawCard(octx, 1);

    const now = new Date();
    const stamp = [
      now.getFullYear(),
      now.getMonth() + 1,
      now.getDate(),
      now.getHours(),
      now.getMinutes(),
      now.getSeconds(),
    ].join("_");
    const filename = `card_${stamp}.png`;

    const blob = await new Promise<Blob | null>((resolve) =>
      out.toBlob(resolve, "image/png"),
    );
    if (!blob) return;

    // On iOS (and other mobile browsers) an <a download> click is ignored, so
    // offer the native share sheet — the way to keep an image on a phone.
    const file = new File([blob], filename, { type: "image/png" });
    const nav = navigator as Navigator & {
      canShare?: (data: { files: File[] }) => boolean;
    };
    if (nav.canShare?.({ files: [file] })) {
      try {
        await navigator.share({ files: [file], title: "Your Wisdom Card" });
        return;
      } catch {
        // Visitor dismissed the sheet, or share failed — fall through to save.
      }
    }

    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.download = filename;
    a.href = url;
    a.click();
    URL.revokeObjectURL(url);
  }

  setAlpha(a: number) {
    this.alpha = a;
  }

  fadeIn(speed: number, dt: number) {
    this.alpha = clamp(this.alpha + speed * dt * FPS, 0, 255);
  }

  fadeOut(speed: number, dt: number) {
    this.alpha = clamp(this.alpha - speed * dt * FPS, 0, 255);
  }
}
