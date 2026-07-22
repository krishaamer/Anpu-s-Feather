# Anpu's Feather — Unity

A Unity 6 port of **Anpu's Feather**, faithful to the iOS Swift + Metal implementation and the original Processing sketch. Same narrative timings, physics quirks, art, music, and recorded Kinect movement data.

## Requirements

- **Unity 6000.6 Beta** — project is set to **6000.6.0b1** (changeset `bec83302551e`), which matches a common Hub install
- Install from Unity Hub → Installs → Install Editor → **Beta releases** → **6000.6.0b1** (or newer 6000.6.x)
- On first open Unity may regenerate `Packages/packages-lock.json` and refresh ProjectSettings; that is expected

## Quick start

1. Install **Unity 6000.6.0b1** (or later 6000.6) in Hub if you do not already have it
2. In Hub → **Projects** → **Add** → select `apps/unity`
3. Open the project with the 6000.6 editor
4. Open scene **`Assets/AnpusFeather/Scenes/Main.unity`**
5. Press **Play**, then **Enter** on the title screen

### Unity AI Assistant

Do **not** use the website “install to a local project” dialog until the project is listed in Hub and opened once. Instead:

1. Open `apps/unity` in the Unity Editor (6000.6+)
2. Toolbar **AI** → accept terms → **Agree and install Unity AI**,  
   **or** Window → Package Manager → **+** → Install package by name → `com.unity.ai.assistant`
3. Link the project to a Unity Cloud organization when prompted

Media is loaded from `Assets/StreamingAssets/Media/{img,data,audio}/`.

## Controls

| Input | Action |
|-------|--------|
| Mouse / touch | Move spirit; click/tap to interact |
| **Enter** (title) | Start the journey |
| **Save your wisdom card** (wisdom scene, t > 5.2s) | Export PNG to persistent data path |
| `1`–`7` | Jump to scene (intro, questions, scales, heavy, light, wisdom, outro) |
| `R` | Reset current scene timer |
| `←` / `→` | Previous / next skeleton recording |
| `M` | Mute / unmute music |

Portrait aspect ratios show a rotate-to-landscape overlay (aspect < 1.2).

## Architecture

Mirrors the iOS Metal port:

| Unity | iOS |
|-------|-----|
| `World.cs` | `Core.swift` |
| `DrawCanvas` + `GameRenderer` | `Renderer.swift` Canvas + Metal flush |
| `AssetStore.cs` | `Textures.swift` |
| `Experience.cs` | `Experience.swift` |
| `GameBootstrap.cs` | `App.swift` GameState + overlays |
| `AnpuUnlit.shader` | `Shaders.metal` |

- **Y-down** world coordinates, design height **900**, responsive width (aspect 1.2–2.6)
- **FPS = 27** scaling for fades and simulation (dt × 27)
- Persistent **scene** RenderTexture (trails in light-heart scene)
- Fixed **1600×900 capture** RenderTexture for wisdom card dance composite
- Immediate-mode 2D batching: color, textured, additive, soft point quads

## Project layout

```
apps/unity/
├── Assets/
│   ├── AnpusFeather/
│   │   ├── Scenes/Main.unity
│   │   ├── Scripts/          # All game logic (namespace AnpusFeather)
│   │   └── Shaders/AnpuUnlit.shader
│   └── StreamingAssets/Media/
├── Packages/manifest.json
└── ProjectSettings/          # Copied from Unity 6000.5 template, version pinned to 6000.6.0b4
```

## Save export

During the wisdom scene (after ~5.2s), **Save your wisdom card** writes `anpu-wisdom-card.png` to `Application.persistentDataPath`. In the Editor, the folder is revealed automatically.

## Credits

Same as the web/iOS apps — music “Anubis” by Lucha and R3VXS; wisdom quotes from [Sebayt](https://en.wikipedia.org/wiki/Sebayt) literature.
