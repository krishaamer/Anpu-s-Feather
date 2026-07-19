/*
  Narrative: controls the sequence of the experience — the port of
  narrative.pde. Scene time is tracked in seconds since the scene began.
*/

export type Mode =
  | "intro"
  | "questions"
  | "light"
  | "heavy"
  | "scales"
  | "wisdom"
  | "outro";

export class Narrative {
  private currentMode: Mode = "intro";
  private sceneTime = 0;

  update(dt: number) {
    this.sceneTime += dt;
  }

  time(): number {
    return this.sceneTime;
  }

  mode(): Mode {
    return this.currentMode;
  }

  setMode(m: Mode) {
    this.currentMode = m;
    this.sceneTime = 0;
  }

  resetTime() {
    this.sceneTime = 0;
  }
}
