/*
  QA: the Yes / No question — the port of qa.pde.
  Answer by clicking/tapping a button, or by moving your pointer (your
  spirit's hands) into one, just like reaching out in front of the Kinect.
*/

import { Vec3, W, H, FPS, clamp } from "./core";

const BTN = 280; // button size (350 in the original 1080p layout)
const MARGIN = 20;

export type Answer = "" | "YES" | "NO";

export class QA {
  private currentAnswer: Answer = "";
  private fillAlpha = 0;

  constructor(
    private ctx: CanvasRenderingContext2D,
    private points: Vec3[],
  ) {}

  // Button rects are derived from the live world width each frame so they
  // stay pinned to the top corners on any screen. NO: top-left, YES: top-right.
  private get noRect() {
    return { x: MARGIN, y: MARGIN };
  }
  private get yesRect() {
    return { x: W - BTN - MARGIN, y: MARGIN };
  }

  answer(): Answer {
    return this.currentAnswer;
  }

  answerReset() {
    this.currentAnswer = "";
  }

  ask() {
    this.button(this.noRect.x, this.noRect.y, "NO", `rgba(255,0,0,`);
    this.button(this.yesRect.x, this.yesRect.y, "YES", `rgba(0,0,255,`);
  }

  private button(x: number, y: number, label: string, rgbaPrefix: string) {
    const ctx = this.ctx;
    const a = this.fillAlpha / 255;
    ctx.save();
    ctx.fillStyle = `${rgbaPrefix}${a})`;
    ctx.fillRect(x, y, BTN, BTN);
    ctx.fillStyle = `rgba(255,255,255,${a})`;
    ctx.font = "60px Georgia, serif";
    ctx.textAlign = "center";
    ctx.textBaseline = "middle";
    ctx.fillText(label, x + BTN / 2, y + BTN / 2);
    ctx.restore();
  }

  private decide(d: Answer) {
    this.currentAnswer = d;
  }

  private hit(x: number, y: number, bx: number, by: number): boolean {
    return x > bx && x < bx + BTN && y > by && y < by + BTN;
  }

  /** Click / tap input. */
  enableButtons(clicks: { x: number; y: number }[]) {
    for (const c of clicks) {
      if (this.hit(c.x, c.y, this.yesRect.x, this.yesRect.y)) this.decide("YES");
      if (this.hit(c.x, c.y, this.noRect.x, this.noRect.y)) this.decide("NO");
    }
  }

  /** Hand-position input (skeleton space is centered on the screen). */
  enableGestures() {
    for (const hand of [this.points[4], this.points[7]]) {
      const x = hand.x + W / 2;
      const y = hand.y + H / 2;
      if (this.hit(x, y, this.yesRect.x, this.yesRect.y)) this.decide("YES");
      if (this.hit(x, y, this.noRect.x, this.noRect.y)) this.decide("NO");
    }
  }

  fadeIn(dt: number) {
    this.fillAlpha = clamp(this.fillAlpha + dt * FPS, 0, 255);
  }

  fadeOut(dt: number) {
    this.fillAlpha = clamp(this.fillAlpha - dt * FPS, 0, 255);
  }
}
