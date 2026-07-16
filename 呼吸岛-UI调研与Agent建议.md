# 呼吸岛 UI 调研与 Agent 建议

更新日期：2026-07-15

## 一、项目定位结论

- `呼吸岛` 应按 `Vision Pro 主端 + iPhone 辅助端` 来设计。
- 主端不是把手机应用放大到空间里，而是把 `评估 -> 推荐 -> 沉浸疗程 -> 生物反馈 -> 医生共享` 做成一个可演示的空间控制台。
- 医疗表达应保持克制，统一使用：
  - `辅助缓解`
  - `非药物辅助工具`
  - `建议咨询医生`

## 二、小红书风格结论

在 Chrome 中围绕 `Vision Pro UI 设计` 做了调研，页面可访问，但 Chrome 插件接管标签页不稳定，深层结构抓取不适合作为主流程。结合可见结果、参考海报和空间应用常见表达，适合本项目的方向是：

- 深海蓝 + 冷青 + 雾白
- 玻璃面板 + 白字高对比
- 纵深感强、不是普通后台
- 大图像资产直接参与界面叙事
- 产品气质偏 `疗愈科技`，不是游戏化娱乐
- 关键页要有 `一个强视觉主体 + 一组高密度指标`，而不是整页浅色卡片平铺

不建议：

- 普通移动端 Tab 样式直接漂浮到 Vision Pro
- 大量纯文字卡片堆叠
- 医疗产品做成互联网运营后台

## 三、Apple / GitHub 参考方向

### Apple visionOS

核心启发：

- 窗口与沉浸空间应自然切换
- SwiftUI 做主界面，RealityKit 提供空间深度
- 主窗口要像控制台，沉浸空间要像疗程环境，不要两边都只是卡片
- 重点继续看：
  - `Human Interface Guidelines for visionOS`
  - `Design great visionOS apps`
  - `Dive deep into volumes and immersive spaces`
  - `Creating immersive spaces in visionOS with SwiftUI`
  - `Combining 2D and 3D views in an immersive app`

### GitHub

建议继续参考：

- `tomkrikorian/awesome-visionOS`
- `1998code/SwiftGlass`
- `IvanCampos/SwiftFUI`

这些仓库适合继续看：

- visionOS 常见窗口/沉浸结构
- RealityKit 空间组织方式
- visionOS 原生玻璃材质如何做得更通透但不发灰
- SwiftUI + Charts + RealityKit 混合布局
- FUI / XR 视觉语汇如何变成可落地的 SwiftUI 组件

## 四、对呼吸岛最有帮助的 Skills / Agent

### 1. 本项目专用 Skill

已经创建：

- 名称：`breath-island-visionos-dev`
- 路径：`/Users/qszjlzz/Desktop/移动应用比赛/呼吸岛/skills/breath-island-visionos-dev`

用途：

- 统一项目定位
- 指定关键文件
- 固定 Xcode / Vision Pro Simulator 验证流程
- 避免后续 agent 把项目误判成 iPhone 主应用

### 2. UI 设计相关

- `figma-swiftui`
  - 适合 SwiftUI <-> Figma 双向同步
- `figma-generate-design`
  - 适合把页面结构整理成设计稿
- `visualize`
  - 适合快速做图表、实验性界面、对比展示

### 3. 测试 / 并行协作

- `multi_agent_v1.explorer`
  - 适合做代码结构审视、设计问题盘点
- `multi_agent_v1.worker`
  - 适合做独立验证、构建、截图、分模块实现

本轮测试建议：

- 用 `worker` 专门跑 `xcodebuild + simctl`
- 统一把验证产物放到 `呼吸岛/validation-artifacts`
- 通过 `--initial-tab dashboard|therapy|report|doctor` 直达页面截图

建议分工：

- 主 agent：做关键实现与整合
- explorer：指出视觉不一致和信息架构问题
- worker：跑构建、模拟器、截图、回归验证

## 五、当前 UI 继续优化的优先级

### P1

- 沉浸空间要更像真正疗程环境，而不是几个漂浮球体 + HUD
- 医生端要更像临床控制台，提升信息密度
- 报告页图表要更像医疗仪表，不是简单 demo chart

### P2

- 三个疗程场景需要更强的独立视觉识别
- 把海报风格扩展成应用内背景与卡面系统
- 增加答辩演示路径中的关键镜头感

### P3

- 用 GPT 生成额外场景海报资产
- 做治疗页/报告页更完整的状态动画

## 六、图片风格建议

参考海报说明这套风格可行：

- 大主体：Vision Pro 设备或疗程场景核心物
- 背景：深海/冷光/雾化空间
- 结构：中心主体 + 四周数据光幕
- 材质：玻璃、冷光、轻体积雾

如果后续继续用 GPT 生成图，建议关键词围绕：

- `deep ocean therapeutic technology`
- `Vision Pro medical immersive therapy`
- `glass dashboard`
- `cyan bioluminescent lighting`
- `clinical but calming`

更具体的视觉拆解：

- 主体设备或场景要放在画面中央偏下，形成视觉锚点
- 上半部分负责品牌、命名和价值陈述
- 中部悬浮信息层用少量高对比玻璃卡片，不要满屏
- 波纹、呼吸环、岛屿、海浪、星群这些元素更适合做 `场景签名`
- 图表和数据卡最好有深底，不要直接漂在浅玻璃上

## 七、建议的下一步

1. 补强 `ImmersiveTherapyView`
2. 为三种疗程生成独立视觉资产
3. 把答辩路线固化成一条 3 分钟演示脚本
4. 用测试 worker 持续做模拟器回归截图
5. 把验证命令沉淀到 `validation-artifacts` 路径下
