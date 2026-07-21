/*
  Shared constants, small helpers and types used across the experience.
  The original Processing sketch ran fullscreen; the web port renders into a
  responsive world that fills the viewport. Height is a fixed design unit
  (900) so every element keeps a consistent size, while width tracks the
  viewport's aspect ratio — so the scene fills the screen edge to edge
  instead of being letterboxed into a strip. `W`/`H` are live bindings that
  importers read each frame; `setViewport` updates them on resize.
*/

// Fixed design height. All layout is expressed relative to this and to W.
export const DESIGN_H = 900;

// Clamp how wide/narrow the world may get so the composition never breaks.
// Aspects outside this range letterbox minimally (wide) or trigger the
// rotate-to-landscape prompt (portrait, handled in main.ts).
export const MIN_ASPECT = 1.2;
export const MAX_ASPECT = 2.6;

// Live world dimensions, updated by setViewport() on every resize.
export let W = 1600;
export let H = DESIGN_H;

/** Update the world size to match the viewport's aspect ratio. */
export function setViewport(viewportW: number, viewportH: number) {
  const aspect = clamp(viewportW / viewportH, MIN_ASPECT, MAX_ASPECT);
  H = DESIGN_H;
  W = Math.round(DESIGN_H * aspect);
}

// The original sketch ran at 27fps and tuned all fades/easing per-frame.
// Multiplying per-frame values by dt * FPS keeps the original feel.
export const FPS = 27;

export interface Vec3 {
  x: number;
  y: number;
  z: number;
}

export const lerp = (a: number, b: number, t: number): number => a + (b - a) * t;

export const clamp = (v: number, lo: number, hi: number): number =>
  Math.min(hi, Math.max(lo, v));

// Processing's map(): no clamping, deliberate — the feather physics rely on it
export const map = (
  v: number,
  inLo: number,
  inHi: number,
  outLo: number,
  outHi: number,
): number => outLo + ((v - inLo) / (inHi - inLo)) * (outHi - outLo);

export const random = (lo: number, hi: number): number =>
  lo + Math.random() * (hi - lo);

/*
  Skeleton joint indices (17 joints, from the original Kinect setup):
  0 head, 1 neck, 2 left_shoulder, 3 left_elbow, 4 left_hand,
  5 right_shoulder, 6 right_elbow, 7 right_hand, 8 torso,
  9 left_hip, 10 left_knee, 11 left_foot, 12 right_hip, 13 right_knee,
  14 right_foot, 15 spine_mid, 16 spine_shoulder
*/
export const JOINTS = 17;
