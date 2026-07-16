---
name: breath-island-visionos-dev
description: Develop, redesign, and verify the 呼吸岛 / BreathIsland visionOS app. Use when working on this project in Xcode, updating SwiftUI or RealityKit views, running the Apple Vision Pro Simulator, capturing simulator screenshots, or using Chrome, GitHub, and Apple references to guide product and UI decisions.
---

# Breath Island VisionOS Dev

Develop this project as a Vision Pro-first product.

## Core stance

- Treat `visionOS` as the primary runtime. iPhone is only a companion surface for陪伴与医生共享.
- Keep file edits and generated artifacts inside the `呼吸岛` folder.
- Preserve clinical wording as `辅助缓解` / `非药物辅助工具` / `建议咨询医生`; avoid cure claims.

## Workflow

1. Read `references/workflow.md` before major edits or simulator validation.
2. For UI work, start from these files:
   - `BreathIsland/ContentView.swift`
   - `BreathIsland/Theme.swift`
   - `BreathIsland/DashboardView.swift`
   - `BreathIsland/TherapyHubView.swift`
   - `BreathIsland/ImmersiveTherapyView.swift`
3. Build with `xcodebuild` before claiming success.
4. Reinstall the rebuilt app into the Apple Vision Pro simulator before relaunching it.
5. Save validation screenshots into the root `呼吸岛` folder with descriptive names.
6. Use Apple docs and GitHub as primary implementation references. Use Chrome/Xiaohongshu for style calibration and trend-checking, not as the sole product source.

## UI direction

- Aim for `医疗可信 + 沉浸疗愈`, not a generic phone dashboard floating in space.
- Prefer a spatial control-console layout over a copied mobile tab bar.
- Use deep-sea blue, fog white, cyan, and restrained coral accents.
- Show the three treatment scenes visually.
- Keep one strong primary action per screen when possible.

## Validation

- Ensure the build passes.
- Verify at least one simulator launch after meaningful UI or flow changes.
- In the handoff, mention the exact build command and screenshot path used for verification.
