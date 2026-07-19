/*
  Pyramid: background imagery — the port of pyramid.pde.
  Two pyramid photos frame the scene and Anubis blinks between two frames.
*/

import { W, H, FPS, clamp } from "./core";

export class Pyramid {
  private tintAlpha = 0;
  private clock = 0;

  constructor(
    private ctx: CanvasRenderingContext2D,
    private images: Record<string, HTMLImageElement>,
  ) {}

  tick(dt: number) {
    this.clock += dt;
  }

  setAlpha(a: number) {
    this.tintAlpha = a;
  }

  private withTint(draw: () => void) {
    const ctx = this.ctx;
    ctx.save();
    ctx.globalAlpha = this.tintAlpha / 255;
    draw();
    ctx.restore();
  }

  /** Pyramids on both sides + blinking Anubis in the center. */
  show() {
    this.withTint(() => {
      const ctx = this.ctx;
      const p0 = this.images["pyramid0"];
      const p2 = this.images["pyramid2"];
      ctx.drawImage(p0, W - p0.width, 0);
      ctx.drawImage(p2, 0, 0);

      // Anubis blinks at the original cadence (15 frames at 27fps).
      const anubis =
        this.clock % 1.1 < 0.55 ? this.images["anubis1"] : this.images["anubis2"];
      ctx.drawImage(
        anubis,
        W / 2 - anubis.width / 2,
        H / 2 - 100 - anubis.height / 2,
      );
    });
  }

  /** The wide pyramid panorama used in the light/heavy scenes. */
  showAlt() {
    this.withTint(() => {
      const img = this.images["pyramid3"];
      const scale = W / img.width;
      const w = W;
      const h = img.height * scale;
      this.ctx.drawImage(img, 0, H - h, w, h);
    });
  }

  fadeIn(dt: number) {
    this.tintAlpha = clamp(this.tintAlpha + 5 * dt * FPS, 0, 255);
  }

  fadeOut(dt: number) {
    this.tintAlpha = clamp(this.tintAlpha - 10 * dt * FPS, 0, 255);
  }
}
