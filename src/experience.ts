/*
  The scene director — the port of feather.pde + scenes.pde.
  One Experience instance is one complete journey; restarting creates a
  fresh instance so every run begins clean.
*/

import { W, H } from "./core";
import { Assets } from "./assets";
import { Pointer } from "./pointer";
import { Narrative } from "./narrative";
import { Message } from "./message";
import { Music } from "./music";
import { River } from "./river";
import { Pyramid } from "./pyramid";
import { User } from "./user";
import { Scales } from "./scales";
import { QA } from "./qa";
import { Wisdom } from "./wisdom";
import { Skeleton } from "./skeleton";

export class Experience {
  private story = new Narrative();
  private skeleton: Skeleton;
  private message: Message;
  private music: Music;
  private river: River;
  private pyramid: Pyramid;
  private user: User;
  private scales: Scales;
  private qa: QA;
  private wisdom: Wisdom;
  private capture: HTMLCanvasElement;
  private captureCtx: CanvasRenderingContext2D;
  private captureStarted = false;
  private clock = 0; // total run time, drives blinking animations

  constructor(
    private ctx: CanvasRenderingContext2D,
    assets: Assets,
    private pointer: Pointer,
    private saveButton: HTMLButtonElement,
    private onRestart: () => void,
  ) {
    this.capture = document.createElement("canvas");
    this.capture.width = W;
    this.capture.height = H;
    this.captureCtx = this.capture.getContext("2d")!;

    this.skeleton = new Skeleton(assets.recordings, pointer);
    this.message = new Message(ctx);
    this.music = new Music(assets.music);
    this.river = new River(ctx);
    this.pyramid = new Pyramid(ctx, assets.images);
    this.user = new User(this.skeleton.points);
    this.scales = new Scales(ctx, this.skeleton.points, assets.images);
    this.qa = new QA(ctx, this.skeleton.points);
    this.wisdom = new Wisdom(ctx, assets.images, this.capture);

    this.saveButton.onclick = () => this.wisdom.download();
    this.story.setMode("intro");
  }

  start() {
    this.music.play();
  }

  stop() {
    this.music.end();
  }

  /** Testing shortcuts kept from the original: 1-7 jump scenes, R resets
      scene time, arrows cycle the recorded movements, M mutes. */
  onKey(key: string) {
    const jump: Record<string, Parameters<Narrative["setMode"]>[0]> = {
      "1": "intro",
      "2": "questions",
      "3": "scales",
      "4": "heavy",
      "5": "light",
      "6": "wisdom",
      "7": "outro",
    };
    if (jump[key]) this.story.setMode(jump[key]);
    if (key === "r" || key === "R") this.story.resetTime();
    if (key === "ArrowRight") this.skeleton.nextRecording();
    if (key === "ArrowLeft") this.skeleton.prevRecording();
    if (key === "m" || key === "M") this.music.toggleMute();
  }

  update(dt: number) {
    this.clock += dt;
    this.story.update(dt);
    this.skeleton.update(dt);
    this.pyramid.tick(dt);
    this.pointer.decay();

    const t = this.story.time();
    switch (this.story.mode()) {
      case "intro":
        this.intro(t, dt);
        break;
      case "questions":
        this.questions(t, dt);
        break;
      case "light":
        this.light(t, dt);
        break;
      case "heavy":
        this.heavy(t, dt);
        break;
      case "scales":
        this.scalesScene(t, dt);
        break;
      case "wisdom":
        this.wisdomScene(t, dt);
        break;
      case "outro":
        this.outro(t, dt);
        break;
    }

    this.saveButton.classList.toggle(
      "visible",
      this.story.mode() === "wisdom" && t > 5.2,
    );
  }

  private clear() {
    this.ctx.fillStyle = "#000";
    this.ctx.fillRect(0, 0, W, H);
  }

  /** Translucent black wash: leaves motion trails like the original. */
  private fade(alpha: number) {
    this.ctx.fillStyle = `rgba(0,0,0,${alpha})`;
    this.ctx.fillRect(0, 0, W, H);
  }

  private intro(t: number, dt: number) {
    this.clear();

    if (t < 2.5) {
      this.message.fadeIn(10, dt);
      this.river.update(dt);
    } else if (t < 3.5) {
      this.message.fadeOut(10, dt);
      this.river.update(dt);
    }
    if (t < 3.5) {
      this.message.say("Em heset net Anpu!");
      this.message.subtitle("Praise the God");
    }

    if (t >= 3.5 && t < 3.6) {
      this.message.setAlpha(0);
      this.river.update(dt);
    }

    if (t >= 3.6 && t < 8.9) {
      this.river.update(dt);
      this.river.fadeOut(dt);
      this.pyramid.show();
      this.pyramid.fadeIn(dt);
      if (t < 7) this.message.fadeIn(8, dt);
      else this.message.fadeOut(10, dt);
      this.message.say("I have been waiting for You");
    }

    if (t >= 8.9 && t < 12) {
      this.river.update(dt);
      this.river.fadeOut(dt);
      this.pyramid.show();
      this.pyramid.fadeOut(dt);
      if (t >= 11.9) this.message.setAlpha(0);
    }

    if (t >= 12 && t < 19) {
      if (t < 16) {
        this.message.fadeIn(8, dt);
        this.scales.fadeIn(dt);
      } else {
        this.message.fadeOut(8, dt);
        this.scales.fadeOut(dt);
      }
      this.scales.showDiagram(false);
      this.scales.startFrom("top");
      this.scales.update(dt, this.clock);
      this.message.say("How heavy is your heart?");
    }

    if (t > 19) {
      this.message.setAlpha(0);
      this.story.setMode("questions");
      this.skeleton.randomRecording();
    }
  }

  private questions(t: number, dt: number) {
    this.clear();

    if (t < 0.1) {
      this.qa.answerReset();
      this.message.setAlpha(0);
    }

    if (t >= 0.1 && t < 1) {
      this.message.fadeIn(8, dt);
      this.message.say("Have you cried this week?");
    }

    if (t >= 1) {
      this.qa.enableGestures();
      this.qa.enableButtons(this.pointer.takeClicks());

      this.message.say("Have you cried this week?");
      this.message.fadeOut(6, dt);

      this.pyramid.show();
      this.pyramid.fadeIn(dt);

      this.qa.ask();
      this.qa.fadeIn(dt);

      // Hands drawn last so they stay visible over Anubis
      this.user.draw(this.ctx, "questions");
      this.user.fadeIn(dt);

      if (this.qa.answer() === "YES") {
        this.message.setAlpha(0);
        this.story.setMode("light");
        return;
      }
      if (this.qa.answer() === "NO") {
        this.message.setAlpha(0);
        this.story.setMode("heavy");
        return;
      }
    }
  }

  private light(t: number, dt: number) {
    if (t < 0.1) {
      this.clear();
      this.message.setAlpha(0);
      this.pyramid.setAlpha(0);
      this.captureStarted = false;
    }

    if (t < 4.9) this.clear();

    if (t >= 0.1 && t < 0.5) this.message.alert("YES", false);

    if (t >= 0.5 && t < 3) {
      this.pyramid.showAlt();
      this.pyramid.fadeIn(dt);
      if (t < 2) this.message.fadeIn(8, dt);
      else this.message.fadeOut(8, dt);
      this.message.say("Your heart seems light");
    }

    if (t >= 3 && t < 3.1) this.message.setAlpha(0);

    if (t >= 3.2 && t < 4.9) {
      if (t < 4) this.message.fadeIn(30, dt);
      else this.message.fadeOut(30, dt);
      this.message.say("Show me");
    }
    if (t >= 4.9 && t < 5) this.message.setAlpha(0);

    if (t >= 4 && t < 19.9) {
      // Additive particles, no clearing: light accumulates like the original
      this.user.simulate();
      this.ctx.save();
      this.ctx.globalCompositeOperation = "lighter";
      this.user.draw(this.ctx, "light");
      this.ctx.restore();
      this.user.fadeIn(dt);
    }

    // Capture the dance for the wisdom card
    if (t >= 5 && t < 20) {
      if (!this.captureStarted) {
        this.captureStarted = true;
        this.captureCtx.fillStyle = "#000";
        this.captureCtx.fillRect(0, 0, W, H);
      }
      this.captureCtx.save();
      this.captureCtx.globalCompositeOperation = "lighter";
      this.user.draw(this.captureCtx, "light");
      this.captureCtx.restore();
    }

    if (t > 20) {
      this.message.setAlpha(0);
      this.story.setMode("scales");
    }
  }

  private heavy(t: number, dt: number) {
    this.clear();

    if (t < 0.1) {
      this.message.setAlpha(0);
      this.pyramid.setAlpha(0);
      this.captureStarted = false;
    }

    if (t >= 0.1 && t < 0.5) this.message.alert("NO", true);

    if (t >= 0.5 && t < 3) {
      this.pyramid.showAlt();
      this.pyramid.fadeIn(dt);
      if (t < 1.5) this.message.fadeIn(10, dt);
      else this.message.fadeOut(8, dt);
      this.message.say("Your heart must be heavy");
    }

    if (t >= 3 && t < 13) {
      this.pyramid.showAlt();
      this.pyramid.fadeIn(dt);
      // Figure drawn last so it stays visible over the pyramid haze
      this.user.draw(this.ctx, "heavy");
      this.user.fadeIn(dt);
    }

    if (t >= 3 && t < 3.1) this.message.setAlpha(0);
    if (t >= 3.1 && t < 6) {
      if (t < 5) this.message.fadeIn(8, dt);
      else this.message.fadeOut(8, dt);
      this.message.say("Show me");
    }

    if (t >= 6 && t < 13) {
      if (!this.captureStarted) {
        this.captureStarted = true;
        this.captureCtx.fillStyle = "#000";
        this.captureCtx.fillRect(0, 0, W, H);
      }
      this.user.draw(this.captureCtx, "heavy");
    }

    if (t > 13) {
      this.message.setAlpha(0);
      this.story.setMode("scales");
    }
  }

  private scalesScene(t: number, dt: number) {
    if (t < 0.1) {
      this.clear();
      this.message.setAlpha(0);
    }

    if (t >= 0.1 && t < 8) {
      this.fade(0.15); // soft trail as the feather drifts
      this.scales.showDiagram(true);
      this.scales.startFrom("middle");
      this.scales.update(dt, this.clock);
      this.scales.fadeIn(dt);
      this.message.countdown(8, t);
    }

    if (t >= 8 && t < 10.5) {
      this.clear();
      if (t < 9.5) this.message.fadeIn(8, dt);
      else this.message.fadeOut(8, dt);
      this.message.say("It's not time to die");
    }

    if (t > 10.5) {
      this.message.setAlpha(0);
      this.story.setMode("wisdom");
    }
  }

  private wisdomScene(t: number, dt: number) {
    this.clear();

    if (t < 0.1) {
      this.message.setAlpha(0);
      this.wisdom.getQuote(this.scales.getFeatherY());
    }

    if (t >= 0.1 && t < 5) {
      if (t < 4) this.message.fadeIn(8, dt);
      else this.message.fadeOut(8, dt);
      this.message.say("Sebayt");
      this.message.subtitle("Wisdom will guide your life");
    }

    if (t >= 5 && t < 5.1) this.message.setAlpha(0);

    if (t >= 5.2 && t < 40) {
      this.wisdom.showCard();
      this.wisdom.fadeIn(8, dt);
      // Click anywhere to move on once the card has been up for a while
      if (t > 10 && this.pointer.takeClicks().length > 0) {
        this.story.setMode("outro");
        return;
      }
    }

    if (t >= 40 && t < 42) {
      this.wisdom.showCard();
      this.wisdom.fadeOut(8, dt);
    }

    if (t > 42) {
      this.message.setAlpha(0);
      this.story.setMode("outro");
    }
  }

  private outro(t: number, dt: number) {
    this.clear();

    if (t < 0.1) this.message.setAlpha(0);

    if (t >= 0.1 && t < 6) {
      if (t < 3) this.message.fadeIn(4, dt);
      else {
        this.message.fadeOut(6, dt);
        this.music.fadeOut(dt);
      }
      this.message.say("Ankhek!");
      this.message.subtitle("May you live");
    }

    if (t > 6) {
      this.music.end();
      this.message.setAlpha(255);
      this.message.subtitle("Touch the water to live again");
      if (this.pointer.takeClicks().length > 0) {
        this.onRestart();
      }
    }
  }
}
