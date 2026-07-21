/*
  Music: control the soundtrack — the port of music.pde.
  Copyright-free music "Anubis" by Lucha and R3VXS.
*/

import { FPS } from "./core";

export class Music {
  private volume = 1.0;

  constructor(private sound: HTMLAudioElement) {}

  play() {
    this.volume = 1.0;
    this.sound.volume = this.volume;
    // Autoplay is gated behind the enter-button click, so this resolves.
    void this.sound.play().catch(() => {});
  }

  fadeOut(dt: number) {
    if (!this.sound.paused && this.volume > 0) {
      this.volume = Math.max(0, this.volume - 0.05 * dt * FPS);
      this.sound.volume = this.volume;
    }
  }

  end() {
    if (!this.sound.paused) this.sound.pause();
  }

  toggleMute() {
    this.sound.muted = !this.sound.muted;
  }
}
