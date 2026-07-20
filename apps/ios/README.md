# Anpu’s Feather — iOS (native, Metal)

A genuinely native iOS app — no web view. The whole experience is
re-implemented in Swift and rendered on the GPU with **Metal**: textured
quads for the art, flat-colored triangles for the vector figure and scales,
and GPU points for the 3,000-particle light-heart cloud. It plays the same
narrative, art, music and recorded-movement data as the other versions, with
touch standing in for the Kinect.

## Requirements

- **macOS with Xcode 15+** (Metal and the iOS toolchain are Apple-only)
- An iOS 15+ simulator or device

> This project was authored in a Linux cloud environment, which cannot compile
> or run iOS apps. It is committed as a complete, ready-to-open Xcode project;
> do a build in Xcode and address any environment-specific tweaks (signing,
> a possible first-build fix) on your Mac.

## Open & run

```sh
open apps/ios/AnpusFeather.xcodeproj
```

Pick a simulator or device and press **Run**. Set your Apple Developer team
under *Signing & Capabilities* to run on a device. The bundle id is
`co.haam.anpusfeather` — change it in the target’s build settings (or
`AnpusFeather/Info.plist` values) for your own account.

## How it’s built

```
AnpusFeather/
  App.swift            SwiftUI shell: MTKView host, native overlays, share sheet
  Info.plist           status bar hidden, landscape-first, full screen
  Metal/
    Shaders.metal      textured-quad, flat-color and point vertex/fragment pairs
    Renderer.swift      device, pipelines, a 2D command-batching Canvas, the
                        persistent offscreen scene + capture targets, ortho
                        projection, and the present blit
    Textures.swift      PNG loading, and text rasterized to straight-alpha
                        textures (tinted/faded at draw time)
  Game/                one file per original module — the same logic as the web
    Core, Input, Skeleton, Narrative, Message, River, Pyramid, User, Scales,
    QA, Wisdom, Music, Experience
  Resources/Media/     the shared art, recorded-movement .txt files and music
```

The renderer keeps a **persistent offscreen scene texture** rather than
clearing every frame, which is how the light-heart particle trails accumulate
(the web version relies on the same canvas-persistence trick). A second
offscreen **capture texture** accumulates the dance that the wisdom card
composites in; saving the card reads it back and hands a composed image to the
iOS share sheet.

The world is responsive in the same way as the web app: a fixed design height
with a width that tracks the screen’s aspect ratio, and a rotate-to-landscape
prompt on portrait phones.

## Notes

- **App icon:** none is bundled (a blank placeholder is used). Add an
  `Assets.xcassets` with an `AppIcon` set when you want one.
- **If Xcode ever reports the project can’t be opened**, the committed
  `project.pbxproj` was hand-authored; `project.yml` is included so you can
  regenerate the project with [XcodeGen](https://github.com/yonaskolb/XcodeGen)
  (`brew install xcodegen && cd apps/ios && xcodegen`).
