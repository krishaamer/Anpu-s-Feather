/*
  Skeleton playback — the port of parser.pde.
  The original read one CSV line of 17 joints per frame, either live from a
  Kinect or from a recorded file. On the web we play back the bundled
  recordings, and blend the two hand joints toward the visitor's pointer so
  the body on screen responds to them: move the mouse and the spirit's hands
  follow; stay still and the recording takes over again.
*/

import { JOINTS, Vec3, lerp, clamp, FPS } from "./core";
import { Pointer } from "./pointer";
import { RECORDING_NAMES } from "./assets";

export class Skeleton {
  points: Vec3[] = [];
  private frames: Vec3[][] = [];
  private frameClock = 0;
  private recordingIndex = 0;
  private handBlend = 0; // 0 = pure recording, 1 = hands on pointer
  private names: string[] = [...RECORDING_NAMES];

  constructor(
    private recordings: Record<string, string>,
    private pointer: Pointer,
  ) {
    for (let i = 0; i < JOINTS; i++) this.points.push({ x: 0, y: 0, z: 0 });
    this.load(this.names[0]);
  }

  private load(name: string) {
    const text = this.recordings[name];
    this.frames = [];
    for (const line of text.split("\n")) {
      const pieces = line.split(",");
      if (pieces.length < JOINTS * 3) continue;
      const frame: Vec3[] = [];
      for (let i = 0; i < JOINTS * 3; i += 3) {
        frame.push({
          x: parseFloat(pieces[i]),
          y: parseFloat(pieces[i + 1]),
          z: parseFloat(pieces[i + 2]),
        });
      }
      this.frames.push(frame);
    }
    this.frameClock = 0;
  }

  nextRecording() {
    this.recordingIndex = (this.recordingIndex + 1) % this.names.length;
    this.load(this.names[this.recordingIndex]);
  }

  prevRecording() {
    this.recordingIndex =
      (this.recordingIndex - 1 + this.names.length) % this.names.length;
    this.load(this.names[this.recordingIndex]);
  }

  randomRecording() {
    this.recordingIndex = Math.floor(Math.random() * this.names.length);
    this.load(this.names[this.recordingIndex]);
  }

  currentRecording(): string {
    return this.names[this.recordingIndex];
  }

  /** Advance playback; dt in seconds. */
  update(dt: number) {
    if (this.frames.length === 0) return;
    this.frameClock += dt * FPS;
    const idx = Math.floor(this.frameClock) % this.frames.length;
    const frame = this.frames[idx];

    // Follow the pointer while it is active, drift back to the recording
    // after a couple of idle seconds.
    const target = this.pointer.idleSeconds() < 2 ? 1 : 0;
    this.handBlend = lerp(this.handBlend, target, clamp(dt * 3, 0, 1));

    // Pointer position in skeleton space (centered origin, y down).
    const px = this.pointer.x - 800;
    const py = this.pointer.y - 450;

    for (let i = 0; i < JOINTS; i++) {
      const p = this.points[i];
      p.x = frame[i].x;
      p.y = frame[i].y;
      p.z = frame[i].z;
    }

    // Blend hands (4 = left, 7 = right) toward the pointer, slightly apart
    // so the figure keeps two distinct hands.
    const b = this.handBlend;
    this.points[4].x = lerp(this.points[4].x, px - 50, b);
    this.points[4].y = lerp(this.points[4].y, py, b);
    this.points[7].x = lerp(this.points[7].x, px + 50, b);
    this.points[7].y = lerp(this.points[7].y, py, b);
  }
}
