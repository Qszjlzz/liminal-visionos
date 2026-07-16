# Breath Island Workflow

## Project facts

- Project root: `/Users/qszjlzz/Desktop/移动应用比赛/呼吸岛`
- Xcode project: `BreathIsland.xcodeproj`
- App source: `BreathIsland/`
- Bundle id: `com.qszjlzz.BreathIsland`
- Vision Pro simulator device used during validation:
  - `Apple Vision Pro (F132E86E-D145-45EC-B9F7-82C76F082B54)`

## Product stance

- `呼吸岛` is a `visionOS / Vision Pro` product first.
- iPhone is only a companion channel for family support and doctor-facing sharing.
- The MVP story is:
  1. 疼痛评估
  2. 本地推荐
  3. Vision Pro 沉浸疗程
  4. 生物反馈与报告
  5. 医生/家属共享

## Key UI files

- `BreathIsland/ContentView.swift`
  - app shell, left rail, active viewport
- `BreathIsland/Theme.swift`
  - colors, glass surfaces, button styles
- `BreathIsland/DashboardView.swift`
  - main story entry and hero
- `BreathIsland/TherapyHubView.swift`
  - scene gallery and treatment control
- `BreathIsland/ImmersiveTherapyView.swift`
  - immersive content

## Build and simulator commands

Build:

```bash
xcodebuild -scheme BreathIsland -project '/Users/qszjlzz/Desktop/移动应用比赛/呼吸岛/BreathIsland.xcodeproj' -destination 'platform=visionOS Simulator,name=Apple Vision Pro' build
```

Install rebuilt app:

```bash
xcrun simctl install F132E86E-D145-45EC-B9F7-82C76F082B54 '/Users/qszjlzz/Library/Developer/Xcode/DerivedData/BreathIsland-bscugkwoxawwwpapbsqgxschenvx/Build/Products/Debug-xrsimulator/BreathIsland.app'
```

Launch app:

```bash
xcrun simctl launch F132E86E-D145-45EC-B9F7-82C76F082B54 com.qszjlzz.BreathIsland
```

Take screenshot:

```bash
xcrun simctl io F132E86E-D145-45EC-B9F7-82C76F082B54 screenshot '/Users/qszjlzz/Desktop/移动应用比赛/呼吸岛/visionos-ui-pass-v3.png'
```

## Research notes

Apple:

- visionOS apps should move naturally between windows and immersive space.
- SwiftUI is the main UI layer; RealityKit supports depth and immersion.

GitHub:

- `tobiasbueschel/awesome-visionOS`
- `divalue/Awesome-RealityKit`
- `tomkrikorian/TrekPath-visionOS`

Chrome / Xiaohongshu:

- The useful query used during research was `Vision Pro UI 设计`.
- Lightweight tab discovery worked reliably.
- Deep extraction from Xiaohongshu was flaky; prefer lightweight confirmation plus primary sources elsewhere.

## Design guidance for this project

- Tone: `医疗可信 + 沉浸疗愈 + 高级科技感`
- Avoid over-entertainment or game-like excess on the core treatment surfaces.
- Show scenes as distinct visual programs:
  - 冰火对抗
  - 海浪呼吸
  - 星屿冥想
- Keep medical text careful:
  - say `辅助缓解`
  - say `非药物辅助工具`
  - say `建议咨询医生`
  - do not promise cure or replacement of diagnosis

## Known pitfalls

- Rebuilds do not reach the simulator until the new app is reinstalled.
- The poster reference image is portrait-oriented. In wide heroes, treat it as a discrete artwork block, not a full-bleed background crop.
- A previous gray launch state was fixed by using generated Info.plist settings at the target level; avoid reintroducing a conflicting manual plist configuration unless necessary.

## Useful artifacts already in the project root

- Spec doc:
  - `《呼吸岛》初赛作品说明文档(1).docx`
- Reference poster:
  - `呼吸岛-参考海报.jpg`
- Verified simulator screenshot from the current UI pass:
  - `visionos-ui-pass-v3.png`
