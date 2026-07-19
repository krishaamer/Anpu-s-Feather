/*
  Pointer input — the web replacement for the Kinect.
  Tracks position and movement speed in virtual canvas coordinates,
  plus how recently the visitor moved (used to blend between the
  recorded skeleton and direct pointer control).
*/

import { W, H, clamp } from "./core";

export class Pointer {
  x = W / 2;
  y = H / 2;
  speed = 0; // smoothed movement speed, virtual px per frame (27fps frame)
  lastMoveAt = -Infinity;
  private clicks: { x: number; y: number }[] = [];

  constructor(
    private canvas: HTMLCanvasElement,
    private toVirtual: (cx: number, cy: number) => { x: number; y: number },
  ) {
    canvas.addEventListener("pointermove", this.onMove);
    canvas.addEventListener("pointerdown", this.onDown);
  }

  private onMove = (e: PointerEvent) => {
    const p = this.toVirtual(e.clientX, e.clientY);
    const dx = p.x - this.x;
    const dy = p.y - this.y;
    const dist = Math.hypot(dx, dy);
    this.speed = this.speed * 0.85 + dist * 0.15;
    this.x = clamp(p.x, 0, W);
    this.y = clamp(p.y, 0, H);
    if (dist > 1) this.lastMoveAt = performance.now();
  };

  private onDown = (e: PointerEvent) => {
    const p = this.toVirtual(e.clientX, e.clientY);
    this.clicks.push(p);
    this.lastMoveAt = performance.now();
  };

  /** Seconds since the pointer last moved. */
  idleSeconds(): number {
    return (performance.now() - this.lastMoveAt) / 1000;
  }

  /** Consume and return clicks since the last call. */
  takeClicks(): { x: number; y: number }[] {
    const c = this.clicks;
    this.clicks = [];
    return c;
  }

  decay() {
    this.speed *= 0.92;
  }

  dispose() {
    this.canvas.removeEventListener("pointermove", this.onMove);
    this.canvas.removeEventListener("pointerdown", this.onDown);
  }
}
