/*
  Draw the user — the port of user.pde.
  -- Light heart: a cloud of particles magnetically drawn to the hands and feet
  -- Heavy heart: concentric fading rings and drooping bezier arcs
  -- Hands: two small circles used while answering the question

  Original reference: https://www.openprocessing.org/sketch/866735
*/

import { Vec3, W, H, FPS, map, clamp, random, JOINTS } from "./core";

const NUM_PARTICLES = 3000;

export type UserMode = "light" | "heavy" | "questions";

export class User {
  private fillAlpha = 0;
  private runOnce = false;

  private xpos = new Float32Array(NUM_PARTICLES);
  private ypos = new Float32Array(NUM_PARTICLES);
  private vx = new Float32Array(NUM_PARTICLES);
  private vy = new Float32Array(NUM_PARTICLES);
  private ax = new Float32Array(NUM_PARTICLES);
  private ay = new Float32Array(NUM_PARTICLES);

  constructor(private points: Vec3[]) {}

  fadeIn(dt: number) {
    this.fillAlpha = clamp(this.fillAlpha + dt * FPS, 0, 255);
  }

  fadeOut(dt: number) {
    this.fillAlpha = clamp(this.fillAlpha - dt * FPS, 0, 255);
  }

  /** Advance the particle simulation (light mode only). */
  simulate() {
    if (!this.runOnce) {
      for (let i = 0; i < NUM_PARTICLES; i++) {
        this.xpos[i] = random(-500, 500);
        this.ypos[i] = random(-500, 500);
      }
      this.runOnce = true;
    }

    const p = this.points;
    const magnetism = 30.0;
    const principle = 0.95;
    // Attractors: left hand, right hand, right foot, left foot
    const a1 = p[4],
      a2 = p[7],
      a3 = p[14],
      a4 = p[11];

    for (let i = 0; i < NUM_PARTICLES; i++) {
      const x = this.xpos[i];
      const y = this.ypos[i];
      const d1 = Math.hypot(a1.x - x, a1.y - y) || 1;
      const d2 = Math.hypot(a2.x - x, a2.y - y) || 1;
      const d3 = Math.hypot(a3.x - x, a3.y - y) || 1;
      const d4 = Math.hypot(a4.x - x, a4.y - y) || 1;

      // Same attractor-selection quirks as the original sketch: each particle
      // chases whichever joint it is nearest, with force scaled by 1/d1².
      let tx = a1;
      if (d1 < 50 || (d1 < d2 && d1 < d3 && d1 < d4)) tx = a2;
      if (d2 < 50 || (d2 < d1 && d2 < d3 && d2 < d4)) tx = a3;
      if (d3 < 50 || (d3 < d1 && d3 < d4 && d3 < d2)) tx = a4;
      if (d4 < 50 || (d4 < d1 && d4 < d2 && d4 < d3)) tx = a1;

      this.ax[i] = (magnetism * (tx.x - x)) / (d1 * d1);
      this.ay[i] = (magnetism * (tx.y - y)) / (d1 * d1);

      this.vx[i] = (this.vx[i] + this.ax[i]) * principle;
      this.vy[i] = (this.vy[i] + this.ay[i]) * principle;
      this.xpos[i] += this.vx[i];
      this.ypos[i] += this.vy[i];
    }
  }

  draw(ctx: CanvasRenderingContext2D, mode: UserMode) {
    if (mode === "light") {
      ctx.save();
      ctx.translate(W / 2, H / 2);
      this.drawLight(ctx);
      ctx.restore();
    } else if (mode === "heavy") {
      ctx.save();
      ctx.translate(W / 2, H / 2 + 100);
      ctx.scale(0.38, 0.38);
      this.drawHeavy(ctx);
      ctx.restore();
    } else {
      // Full scale so the circles sit exactly where the gesture hit-test
      // (and the visitor's pointer) is.
      ctx.save();
      ctx.translate(W / 2, H / 2);
      this.drawHands(ctx);
      ctx.restore();
    }
  }

  private drawLight(ctx: CanvasRenderingContext2D) {
    const alphaScale = this.fillAlpha / 255;
    for (let i = 0; i < NUM_PARTICLES; i++) {
      const sokudo = Math.hypot(this.vx[i], this.vy[i]);
      const r = clamp(map(sokudo, 0, 5, 0, 255), 0, 255) | 0;
      const g = clamp(map(sokudo, 0, 5, 64, 255), 0, 255) | 0;
      const b = clamp(map(sokudo, 0, 5, 128, 255), 0, 255) | 0;
      ctx.fillStyle = `rgba(${r},${g},${b},${0.24 * alphaScale})`;
      ctx.fillRect(this.xpos[i], this.ypos[i], 2, 2);
    }

    // Joint dots
    ctx.fillStyle = `rgba(255,255,255,${alphaScale})`;
    for (let i = 0; i < JOINTS; i++) {
      ctx.beginPath();
      ctx.arc(this.points[i].x, this.points[i].y, 4, 0, Math.PI * 2);
      ctx.fill();
    }
  }

  private ring(
    ctx: CanvasRenderingContext2D,
    x: number,
    y: number,
    alpha: number,
  ) {
    ctx.strokeStyle = `rgba(255,255,255,${(alpha / 255) * (this.fillAlpha / 255)})`;
    ctx.beginPath();
    ctx.arc(x, y, 60, 0, Math.PI * 2);
    ctx.stroke();
  }

  private droop(
    ctx: CanvasRenderingContext2D,
    from: Vec3,
    cx: number,
    cy: number,
    to: Vec3,
    alpha: number,
  ) {
    ctx.strokeStyle = `rgba(255,255,255,${(alpha / 255) * (this.fillAlpha / 255)})`;
    ctx.beginPath();
    ctx.moveTo(from.x, from.y);
    ctx.bezierCurveTo(cx, cy, to.x, to.y, to.x, to.y);
    ctx.stroke();
  }

  private drawHeavy(ctx: CanvasRenderingContext2D) {
    const p = this.points;
    const x1 = (p[4].x + p[3].x) / 2;
    const x2 = (p[3].x + p[2].x) / 2;
    const x3 = (p[2].x + p[0].x) / 2;
    const x4 = (p[6].x + p[7].x) / 2;
    const x5 = (p[5].x + p[6].x) / 2;
    const x6 = (p[0].x + p[5].x) / 2;
    const y7 = p[0].y - 30;
    const y8 = y7 + 20;
    const y9 = (y7 + y8) / 2;
    const y10 = (p[4].y + y8) / 2;
    const y11 = (p[7].y + y8) / 2;
    const y12 = (p[4].y + y10) / 2;
    const y13 = (y7 + y10) / 2;
    const y14 = p[15].y + (p[15].y - (p[16].y + 20));

    ctx.lineWidth = 10;

    this.ring(ctx, p[4].x, p[4].y, 255);
    this.ring(ctx, p[7].x, p[7].y, 255);
    this.ring(ctx, x1, y12, 210);
    this.ring(ctx, x4, y12, 210);
    this.ring(ctx, p[3].x, y10, 180);
    this.ring(ctx, p[6].x, y11, 180);
    this.ring(ctx, x2, y13, 150);
    this.ring(ctx, x5, y13, 150);
    this.ring(ctx, p[2].x, y7, 120);
    this.ring(ctx, p[5].x, y7, 120);
    this.ring(ctx, p[0].x, p[0].y, 90);

    // Drooping arcs from the torso out past the knees to the feet
    this.droop(ctx, p[8], p[10].x - 400, p[10].y - 350, p[11], 210);
    this.droop(ctx, p[8], p[13].x + 400, p[13].y - 350, p[14], 210);
    this.droop(ctx, p[8], p[10].x - 300, p[10].y - 280, p[11], 170);
    this.droop(ctx, p[8], p[13].x + 300, p[13].y - 280, p[14], 170);
    this.droop(ctx, p[8], p[10].x - 200, p[10].y - 200, p[11], 190);
    this.droop(ctx, p[8], p[13].x + 200, p[13].y - 200, p[14], 190);

    this.ring(ctx, x3, y9, 70);
    this.ring(ctx, x6, y9, 70);
    this.ring(ctx, p[16].x + 40, p[16].y + 20, 70);
    this.ring(ctx, p[16].x - 40, p[16].y + 20, 70);
    this.ring(ctx, p[16].x + 40, p[15].y, 70);
    this.ring(ctx, p[16].x - 40, p[15].y, 70);
    this.ring(ctx, p[15].x + 40, y14, 70);
    this.ring(ctx, p[15].x - 40, y14, 70);
  }

  private drawHands(ctx: CanvasRenderingContext2D) {
    ctx.strokeStyle = `rgba(255,255,255,${this.fillAlpha / 255})`;
    ctx.lineWidth = 10;
    for (const hand of [this.points[4], this.points[7]]) {
      ctx.beginPath();
      ctx.arc(hand.x, hand.y, 10, 0, Math.PI * 2);
      ctx.stroke();
    }
  }
}
