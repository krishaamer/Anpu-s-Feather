/*
  Asset loading: images, music and the recorded skeleton movement files
  captured with a Kinect for the original 2020 installation.
*/

export interface Assets {
  images: Record<string, HTMLImageElement>;
  music: HTMLAudioElement;
  recordings: Record<string, string>;
}

const IMAGE_NAMES = [
  "feather",
  "scale",
  "pyramid0",
  "pyramid2",
  "pyramid3",
  "anubis1",
  "anubis2",
  "diagram1",
  "diagram2",
  "wisdom_card_bg",
] as const;

export const RECORDING_NAMES = [
  "wave1",
  "wave2",
  "pray1",
  "pray2",
  "swim1",
  "turn1",
  "dig1",
  "shrugging",
] as const;

const base = import.meta.env.BASE_URL;

function loadImage(name: string): Promise<[string, HTMLImageElement]> {
  return new Promise((resolve, reject) => {
    const img = new Image();
    img.onload = () => resolve([name, img]);
    img.onerror = () => reject(new Error(`Failed to load image ${name}`));
    img.src = `${base}assets/img/${name}.png`;
  });
}

async function loadRecording(name: string): Promise<[string, string]> {
  const res = await fetch(`${base}assets/data/${name}.txt`);
  if (!res.ok) throw new Error(`Failed to load recording ${name}`);
  return [name, await res.text()];
}

export async function loadAssets(
  onProgress: (done: number, total: number) => void,
): Promise<Assets> {
  const total = IMAGE_NAMES.length + RECORDING_NAMES.length;
  let done = 0;
  const tick = <T>(p: Promise<T>): Promise<T> =>
    p.then((v) => {
      onProgress(++done, total);
      return v;
    });

  const [imageEntries, recordingEntries] = await Promise.all([
    Promise.all(IMAGE_NAMES.map((n) => tick(loadImage(n)))),
    Promise.all(RECORDING_NAMES.map((n) => tick(loadRecording(n)))),
  ]);

  const music = new Audio(`${base}assets/audio/anpu.wav`);
  music.preload = "auto";
  music.loop = true;

  return {
    images: Object.fromEntries(imageEntries),
    music,
    recordings: Object.fromEntries(recordingEntries),
  };
}
