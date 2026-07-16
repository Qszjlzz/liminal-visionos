# 《呼吸岛》Vision Pro 初赛开发计划

## 当前定位

- 主端：`visionOS / Apple Vision Pro`
- 辅助端：`iPhone Companion`，仅承担陪伴、同步和医生/家属查看
- 当前工程：`BreathIsland.xcodeproj`
- 当前状态：可在 `Apple Vision Pro` Simulator 中构建、安装、启动，并完成主窗口与沉浸空间演示

## 比赛演示主线

1. 进入主控窗口，展示今日疼痛闭环总览
2. 完成功能性疼痛评估
3. 生成本地规则推荐的治疗场景
4. 进入治疗控制台
5. 打开沉浸式治疗空间
6. 展示生物反馈变化与治疗报告
7. 切换到医生端视图查看趋势和风险提示

## 核心模块

### 1. 空间主控窗口

- 目标：成为 Vision Pro 中的主操作台
- 已完成：
  - 总览页
  - 评估页
  - 治疗页
  - 报告页
  - 医生端页
  - 深海主题主视觉、实体治疗场景插画与海报资产
  - 支持 `dashboard / assessment / therapy / report / doctor` 启动参数，便于分屏答辩

### 2. 疼痛评估

- 已完成：
  - 疼痛病种
  - 疼痛部位
  - 疼痛性质
  - 强度
  - 诱因
  - 情绪状态
  - 功能受限程度
  - 疗程前后的疼痛变化与风险建议均在报告、医生端汇总呈现

### 3. 本地推荐引擎

- 已完成：
  - 烧伤/灼痛 -> 冰火对抗
  - 分娩/焦虑 -> 海浪呼吸
  - 慢性痛/癌痛 -> 星屿冥想
  - 推荐理由、疗程时长、呼吸节律与安全提示

### 4. 治疗控制台

- 已完成：
  - 设备连接状态
  - 疗程阶段推进
  - 进入/退出沉浸空间按钮
  - 三个设备连接状态、疗程阶段推进及完成后的报告回写
  - 家属陪伴留言与同步建议

### 5. 沉浸式空间

- 已完成：
  - `ImmersiveSpace`
  - RealityKit 治疗核心、节律指引与 HUD 信息挂载
  - 冰火对抗、海浪呼吸、星屿冥想三种可辨识的空间构型与配色

### 6. 生物反馈与报告

- 已完成：
  - Mock 心率/HRV/呼吸频率/疼痛变化
  - 报告摘要
  - 医生端洞察
  - 时间序列曲线、疗程判断、下一次启动建议与风险分层

## MVP 边界

- 数据、设备连接与生物反馈均为本地演示 Mock；未接入真实 HealthKit、蓝牙硬件或临床系统。
- 本项目用于比赛原型展示，不构成诊疗工具；页面文案已避免治愈承诺，并保留医生协同提示。
- `iPhone Companion` 以 Vision Pro 主端内的陪伴状态和医生共享视图表现，未拆成独立 iOS 工程。

## 构建与验证

```bash
xcodebuild -scheme BreathIsland -project /Users/qszjlzz/Desktop/移动应用比赛/呼吸岛/BreathIsland.xcodeproj -destination 'platform=visionOS Simulator,name=Apple Vision Pro' build
```

当前更稳定的验证路径：

```bash
xcrun simctl boot "Apple Vision Pro"
xcrun simctl bootstatus F132E86E-D145-45EC-B9F7-82C76F082B54 -b
xcodebuild -project /Users/qszjlzz/Desktop/移动应用比赛/呼吸岛/BreathIsland.xcodeproj -scheme BreathIsland -configuration Debug -destination 'platform=visionOS Simulator,id=F132E86E-D145-45EC-B9F7-82C76F082B54' -derivedDataPath /Users/qszjlzz/Desktop/移动应用比赛/呼吸岛/validation-artifacts/DerivedData build
xcrun simctl install F132E86E-D145-45EC-B9F7-82C76F082B54 /Users/qszjlzz/Desktop/移动应用比赛/呼吸岛/validation-artifacts/DerivedData/Build/Products/Debug-xrsimulator/BreathIsland.app
xcrun simctl launch F132E86E-D145-45EC-B9F7-82C76F082B54 com.qszjlzz.BreathIsland --initial-tab therapy
```

说明：

- `BreathIslandApp.swift` 已支持 `--initial-tab`
- 可直接跳到 `dashboard / assessment / therapy / report / doctor`
- 这样比依赖系统辅助权限去点 Simulator UI 更可靠

## 已保存的关键文件

- 作品说明文档：
  - `《呼吸岛》初赛作品说明文档(1).docx`
- Vision Pro 运行截图：
  - `visionos-generated-plist.png`
  - `visionos-delayed.png`
