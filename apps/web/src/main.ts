/*
  Anpu's Feather — web edition.
  An interactive experience inviting you to think about your life before
  death. Originally created by Lei Lin and Kris Haamer with Processing and
  a Kinect at NCKU ICID Digital Design class, Tainan, Taiwan, April 2020.
  Ported to the browser: the pointer is your body now.
*/

import { W, H, MIN_ASPECT, setViewport } from "./core";
import { loadAssets } from "./assets";
import { Pointer } from "./pointer";
import { Experience } from "./experience";

const canvas = document.getElementById("stage") as HTMLCanvasElement;
const overlay = document.getElementById("overlay") as HTMLDivElement;
const rotate = document.getElementById("rotate") as HTMLDivElement;
const enterButton = document.getElementById("enter") as HTMLButtonElement;
const saveButton = document.getElementById("save-card") as HTMLButtonElement;
const ctx = canvas.getContext("2d")!;

// The world (W x H) fills the viewport. When the viewport is more portrait
// than MIN_ASPECT the world is centered and the rotate prompt is shown.
let view = { scale: 1, ox: 0, oy: 0, dpr: 1 };
let portrait = false;

function resize() {
  const vw = window.innerWidth;
  const vh = window.innerHeight;
  const dpr = Math.min(window.devicePixelRatio || 1, 2);
  canvas.width = Math.round(vw * dpr);
  canvas.height = Math.round(vh * dpr);

  // Size the world to the viewport aspect, then fit it (contain). Because the
  // world's aspect tracks the viewport, "contain" fills the screen exactly for
  // in-range aspects, and letterboxes only at the clamped extremes.
  setViewport(vw, vh);
  portrait = vw / vh < MIN_ASPECT;
  rotate.classList.toggle("show", portrait);

  const scale = Math.min(canvas.width / W, canvas.height / H);
  view = {
    scale,
    ox: (canvas.width - W * scale) / 2,
    oy: (canvas.height - H * scale) / 2,
    dpr,
  };
  ctx.setTransform(1, 0, 0, 1, 0, 0);
  ctx.fillStyle = "#000";
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  ctx.setTransform(view.scale, 0, 0, view.scale, view.ox, view.oy);
  ctx.fillRect(0, 0, W, H);
}

window.addEventListener("resize", resize);
window.addEventListener("orientationchange", resize);
resize();

const toVirtual = (cx: number, cy: number) => ({
  x: (cx * view.dpr - view.ox) / view.scale,
  y: (cy * view.dpr - view.oy) / view.scale,
});

const pointer = new Pointer(canvas, toVirtual);

async function boot() {
  const assets = await loadAssets((done, total) => {
    enterButton.textContent = `Loading… ${Math.round((done / total) * 100)}%`;
  });

  enterButton.disabled = false;
  enterButton.textContent = "Enter";

  let experience: Experience | null = null;

  const startExperience = () => {
    experience?.stop();
    experience = new Experience(ctx, assets, pointer, saveButton, () => {
      startExperience();
    });
    experience.start();
  };

  enterButton.addEventListener("click", () => {
    overlay.classList.add("hidden");
    startExperience();
  });

  window.addEventListener("keydown", (e) => {
    experience?.onKey(e.key);
  });

  let last = performance.now();
  const frame = (now: number) => {
    // Clamp dt so a background tab doesn't fast-forward the narrative
    const dt = Math.min((now - last) / 1000, 0.1);
    last = now;
    if (experience) {
      ctx.setTransform(view.scale, 0, 0, view.scale, view.ox, view.oy);
      experience.update(dt);
    }
    requestAnimationFrame(frame);
  };
  requestAnimationFrame(frame);
}

boot().catch((err) => {
  enterButton.textContent = "Failed to load";
  console.error(err);
});
