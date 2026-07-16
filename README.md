# 呼吸岛 Liminal

> 面向 Apple Vision Pro 的沉浸式非药物疼痛辅助体验原型。

`呼吸岛 Liminal` 以 Vision Pro 作为治疗主端，将疼痛评估、规则推荐、沉浸疗程、生物反馈、家属陪伴和医生共享串成一条可演示的空间化闭环。

## 核心体验

- 功能性疼痛评估：综合疼痛部位、性质、情绪和功能受限程度。
- 本地推荐引擎：将烧伤、分娩、慢性痛/癌痛等情境映射到三种疗程。
- 三个沉浸场景：冰火对抗、海浪呼吸、星屿冥想。
- RealityKit 沉浸空间：疗程核心、呼吸节律与空间 HUD。
- 生物反馈与医生端：展示 Mock 心率、HRV、呼吸节律、疼痛变化、依从性及风险提示。
- 视觉与交互：深海疗愈场景、呼吸环、场景微动效、Vision Pro 悬停和按压反馈。

## 运行环境

- Xcode 16.4 或更高版本
- visionOS 2.5 Simulator（Apple Vision Pro）

打开 `BreathIsland.xcodeproj`，选择 `BreathIsland` Scheme 和 `Apple Vision Pro` Simulator 后运行即可。

## 验证命令

```bash
xcodebuild \
  -project BreathIsland.xcodeproj \
  -scheme BreathIsland \
  -destination 'platform=visionOS Simulator,name=Apple Vision Pro' \
  build
```

## 演示资料

- [参赛作品说明](《呼吸岛》初赛作品说明文档(1).docx)
- [交付与答辩指南](交付与答辩指南.md)
- Vision Pro 演示录屏为大型本地交付文件，未纳入源码仓库。
- [UI 调研与 Agent 建议](呼吸岛-UI调研与Agent建议.md)

## 原型说明

设备连接、生物反馈和临床数据均为本地 Mock，用于稳定呈现比赛所需的体验闭环。本项目是非药物疼痛辅助体验的设计验证，不构成诊断、治疗建议或医疗承诺。
