/*
  Scales: calculate the weight of the heart — the port of scales.pde.
  The feather rises when the visitor moves (a busy life keeps it aloft)
  and sinks when they are still. Its resting height selects the wisdom.
*/

import { Vec3, W, H, FPS, map, random } from "./core";

export class Scales {
  private tintAlpha = 0;
  private t = 0;
  private xn1 = 0;
  private xn2 = 0;
  private yn1 = 0;
  private yn2 = 0;
  private featherY = -300;
  private readonly easing = 0.01;
  private diagramVisible = true;
  private from: "top" | "middle" = "middle";

  constructor(
    private ctx: CanvasRenderingContext2D,
    private points: Vec3[],
    private images: Record<string, HTMLImageElement>,
  ) {}

  showDiagram(sd: boolean) {
    this.diagramVisible = sd;
  }

  startFrom(t: "top" | "middle") {
    this.from = t;
  }

  getFeatherY(): number {
    return this.featherY;
  }

  update(dt: number, clock: number) {
    const p = this.points;

    // Average movement of both hands since the previous frame
    const xdist1 = Math.abs(p[4].x - this.xn1);
    this.xn1 = p[4].x;
    const xdist2 = Math.abs(p[7].x - this.xn2);
    this.xn2 = p[7].x;
    const ydist1 = Math.abs(p[4].y - this.yn1);
    this.yn1 = p[4].y;
    const ydist2 = Math.abs(p[7].y - this.yn2);
    this.yn2 = p[7].y;
    const avdist = (xdist1 + xdist2 + ydist1 + ydist2) / 4;

    // Movement lifts the feather (toward -300), stillness sinks it (toward 500)
    let val = map(-avdist, -30, 0, -300, 500);
    if (val === 100) val = random(100, 300);
    if (val < 0) val = random(-480, -100);

    if (Math.abs(val - this.featherY) > 100) {
      this.featherY += (val - this.featherY) * this.easing * dt * FPS;
    } else {
      this.t += 0.2 * dt * FPS;
      this.featherY += Math.sin(this.t) * 5 * dt * FPS;
    }

    const ctx = this.ctx;
    ctx.save();
    ctx.globalAlpha = this.tintAlpha / 255;

    const feather = this.images["feather"];
    const fw = feather.width * 0.6;
    const fh = feather.height * 0.6;
    const y = this.from === "top" ? this.featherY : this.featherY + H / 2;
    ctx.drawImage(feather, W / 2 - fw / 2, y - fh / 2, fw, fh);

    if (this.diagramVisible) this.drawDiagram(clock);
    ctx.restore();
  }

  private drawDiagram(clock: number) {
    const ctx = this.ctx;
    // Alternate the two instruction diagrams (10 frames at 27fps each)
    const img =
      clock % 0.74 < 0.37 ? this.images["diagram1"] : this.images["diagram2"];

    ctx.fillStyle = "rgb(0,0,0)";
    ctx.fillRect(W / 2 + 350, H / 2 + 150, 300, 300);
    ctx.drawImage(img, W / 2 + 350, H / 2 + 150);

    // The tall scales artwork on the left
    ctx.drawImage(this.images["scale"], -50, -100);
  }

  fadeIn(dt: number) {
    this.tintAlpha = Math.min(255, this.tintAlpha + dt * FPS);
  }

  fadeOut(dt: number) {
    this.tintAlpha = Math.max(0, this.tintAlpha - dt * FPS);
  }
}
