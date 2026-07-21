/*
  The textual messages UI — the port of message.pde.
  Fade speeds are the original per-frame values; they are scaled by
  dt * 27fps in fadeIn/fadeOut so the pacing matches the sketch.
*/

import { W, H, FPS, clamp } from "./core";

const FONT = "Georgia, 'Times New Roman', serif";

export class Message {
  private alpha = 0;

  constructor(private ctx: CanvasRenderingContext2D) {}

  setAlpha(a: number) {
    this.alpha = a;
  }

  fadeIn(speed: number, dt: number) {
    this.alpha = clamp(this.alpha + speed * dt * FPS, 0, 255);
  }

  fadeOut(speed: number, dt: number) {
    this.alpha = clamp(this.alpha - speed * dt * FPS, 0, 255);
  }

  private text(
    msg: string,
    x: number,
    y: number,
    size: number,
    color: string,
    maxWidth?: number,
  ) {
    const ctx = this.ctx;
    ctx.save();
    ctx.font = `${size}px ${FONT}`;
    ctx.textAlign = "center";
    ctx.textBaseline = "middle";
    ctx.fillStyle = color;
    if (maxWidth) {
      // Simple word wrap
      const words = msg.split(" ");
      const lines: string[] = [];
      let line = "";
      for (const w of words) {
        const test = line ? `${line} ${w}` : w;
        if (ctx.measureText(test).width > maxWidth && line) {
          lines.push(line);
          line = w;
        } else {
          line = test;
        }
      }
      if (line) lines.push(line);
      const lh = size * 1.35;
      const y0 = y - ((lines.length - 1) * lh) / 2;
      lines.forEach((l, i) => ctx.fillText(l, x, y0 + i * lh));
    } else {
      ctx.fillText(msg, x, y);
    }
    ctx.restore();
  }

  say(msg: string) {
    this.text(msg, W / 2, H / 2, 40, `rgba(255,255,255,${this.alpha / 255})`);
  }

  subtitle(msg: string) {
    this.text(
      msg,
      W / 2,
      H / 2 + 40,
      20,
      `rgba(255,255,255,${this.alpha / 255})`,
    );
  }

  alert(msg: string, red: boolean) {
    this.text(msg, W / 2, H / 2, 40, red ? "rgb(255,0,0)" : "rgb(80,80,255)");
  }

  countdown(max: number, s: number) {
    const x = W - 80;
    const y = 30;
    const ctx = this.ctx;
    ctx.save();
    ctx.fillStyle = "rgb(0,0,0)";
    ctx.fillRect(x - 50, y - 25, 100, 50);
    ctx.restore();
    this.text(String(max - Math.floor(s)), x, y, 40, "rgb(255,0,0)");
  }
}
