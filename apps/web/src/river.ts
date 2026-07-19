/*
  The Nile river — the port of river.pde.
  The original drew a grid of pulsing ellipses rotated flat into a 3D floor;
  here the same wave field is projected as a pseudo-3D floor receding toward
  a horizon.
*/

import { W, H, FPS, map, clamp } from "./core";

const COLORS: [number, number, number][] = [
  [0x83, 0xa0, 0xff],
  [0x51, 0x73, 0xdf],
  [0x19, 0x4d, 0xf4],
  [0x0a, 0x34, 0xbc],
];

export class River {
  private theta = 0;
  private strokeAlpha = 220;
  private fillAlpha = 170;
  private readonly cols = 25;
  private readonly rows = 45;
  private readonly speed = 0.0223;

  constructor(private ctx: CanvasRenderingContext2D) {}

  update(dt: number) {
    const ctx = this.ctx;
    const gap = W / this.cols;
    const horizon = H * 0.42;

    ctx.save();
    let theta2 = Math.PI / 6;
    for (let j = 0; j < this.rows; j++) {
      const [r, g, b] = COLORS[j % COLORS.length];
      ctx.fillStyle = `rgba(${r},${g},${b},${this.fillAlpha / 255})`;
      theta2 += (Math.PI * 2) / 36;
      const offSetY = map(Math.sin(theta2), -1, 1, 0, Math.PI * 2);

      // Rows recede: far rows are drawn smaller and packed near the horizon.
      const t = (j + 0.5) / this.rows; // 0 = far, 1 = near
      const persp = 0.22 + 0.78 * t * t;
      const y = horizon + (H - horizon + 80) * t * t;

      for (let i = 0; i < this.cols; i++) {
        const offSetX = ((Math.PI * 2) / this.rows) * i;
        const x = W / 2 + (i + 0.5 - this.cols / 2) * gap * (0.5 + persp);
        const sz =
          map(Math.sin(this.theta + offSetX + offSetY), -1, 1, 5, gap * 1.5) *
          persp;
        ctx.beginPath();
        ctx.ellipse(x, y, sz / 2, (sz / 2) * 0.45, 0, 0, Math.PI * 2);
        ctx.fill();
      }
    }
    ctx.restore();

    this.theta -= this.speed * dt * FPS;
  }

  fadeIn(dt: number) {
    this.fillAlpha = clamp(this.fillAlpha + dt * FPS, 0, 255);
    this.strokeAlpha = clamp(this.strokeAlpha + dt * FPS, 0, 255);
  }

  fadeOut(dt: number) {
    this.fillAlpha = clamp(this.fillAlpha - dt * FPS, 0, 255);
    this.strokeAlpha = clamp(this.strokeAlpha - dt * FPS, 0, 255);
  }
}
