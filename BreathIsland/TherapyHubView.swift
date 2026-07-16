import SwiftUI

struct TherapyHubView: View {
    @EnvironmentObject private var store: DemoStore
    @EnvironmentObject private var appModel: AppModel
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Binding var selectedTab: RootTab

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                devicePanel

                HStack(alignment: .top, spacing: 16) {
                    sceneGrid
                    sessionConsole
                        .frame(width: 360)
                }
            }
            .padding(24)
        }
        .background(Color.clear)
        .navigationTitle("VR 治疗入口")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var devicePanel: some View {
        ZStack(alignment: .bottomTrailing) {
            Image("OceanSanctuary")
                .resizable()
                .scaledToFill()
                .overlay(
                    LinearGradient(
                        colors: [AppTheme.midnight.opacity(0.92), AppTheme.deepSea.opacity(0.56), Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            BreathingHalo(color: AppTheme.aqua, diameter: 290)
                .offset(x: 64, y: -10)

            HStack(alignment: .top, spacing: 18) {
                VStack(alignment: .leading, spacing: 16) {
                    SectionEyebrow(text: "治疗控制台")

                    Text("Vision Pro 主端负责沉浸疗程，陪伴副屏与生物反馈做同步陪伴。")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white)

                    HStack(spacing: 12) {
                        statusBadge(title: "Vision Pro 主端", connected: store.deviceStatus.headsetConnected)
                        statusBadge(title: "陪伴副屏", connected: store.deviceStatus.phoneConnected)
                        statusBadge(title: "生物反馈", connected: store.deviceStatus.wearableConnected)
                    }

                    HStack(spacing: 8) {
                        StatusPill(text: immersiveLabel, color: immersiveColor)
                        StatusPill(text: "\(store.latestRecommendation.scene.durationMinutes) 分钟建议疗程", color: AppTheme.aqua)
                    }
                }

                InsetPanel {
                    VStack(alignment: .leading, spacing: 10) {
                        SectionEyebrow(text: "当前优先")
                        Text(store.latestRecommendation.scene.name)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white)
                        Text(store.latestRecommendation.expectedOutcome)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.74))
                    }
                }
            }
            .padding(22)
        }
        .frame(minHeight: 248)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(Color.white.opacity(0.20), lineWidth: 1)
        )
        .shadow(color: AppTheme.midnight.opacity(0.38), radius: 26, x: 0, y: 14)
    }

    private func statusBadge(title: String, connected: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(connected ? "已连接" : "未连接", systemImage: connected ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(connected ? AppTheme.aqua : AppTheme.coral)
            Text(title)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var sceneGrid: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionEyebrow(text: "场景库")

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(store.therapyScenes) { scene in
                    sceneCard(scene)
                }
            }
        }
    }

    private func sceneCard(_ scene: TherapyScene) -> some View {
        let isRecommended = scene.name == store.latestRecommendation.scene.name

        return VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                SceneSignatureView(scene: scene)

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        StatusPill(text: scene.targetCondition.shortLabel, color: AppTheme.sceneAccent(for: scene))
                        Spacer()
                        if isRecommended {
                            StatusPill(text: "系统推荐", color: AppTheme.coral)
                        }
                    }

                    Spacer()

                    Label(scene.name, systemImage: scene.icon)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white)

                    Text(scene.subtitle)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.82))
                }
                .padding(18)
            }
            .frame(height: 184)

            VStack(alignment: .leading, spacing: 12) {
                Text(scene.description)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.76))
                    .fixedSize(horizontal: false, vertical: true)

                InsetPanel {
                    VStack(alignment: .leading, spacing: 6) {
                        therapyDetailRow(title: "呼吸节律", value: scene.breathingPattern)
                        therapyDetailRow(title: "视觉主题", value: scene.visualTheme)
                        therapyDetailRow(title: "适用重点", value: scene.targetCondition.clinicalFocus)
                    }
                }

                Spacer(minLength: 0)

                Group {
                    if isRecommended {
                        Button("按推荐启动") {
                            store.startTherapy(scene: scene)
                        }
                        .buttonStyle(PrimaryActionStyle())
                    } else {
                        Button("开始疗程") {
                            store.startTherapy(scene: scene)
                        }
                        .buttonStyle(SecondaryActionStyle())
                    }
                }
            }
            .padding(18)
        }
        .frame(maxWidth: .infinity, minHeight: 400, alignment: .topLeading)
        .background {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(AppTheme.cardGradient)
                )
        }
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(AppTheme.shellStroke, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var sessionConsole: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionEyebrow(text: "进行中")

                Text("疗程控制")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white)

                if let session = store.activeSession {
                    Text(session.scene.name)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(AppTheme.moon)

                    ProgressView(value: session.progress)
                        .tint(AppTheme.aqua)

                    HStack {
                        Text("当前阶段：\(session.currentStage)")
                        Spacer()
                        Text("\(Int(session.progress * 100))%")
                    }
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.white)

                    Text(session.note)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.76))

                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(Array(session.stages.enumerated()), id: \.offset) { index, stage in
                            HStack {
                                Circle()
                                    .fill(index <= session.stageIndex ? AppTheme.aqua : Color.white.opacity(0.12))
                                    .frame(width: 10, height: 10)
                                Text(stage)
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundStyle(index <= session.stageIndex ? Color.white : Color.white.opacity(0.52))
                            }
                        }
                    }

                    HStack(spacing: 12) {
                        Button(appModel.immersiveSpaceState == .open ? "退出沉浸空间" : "进入沉浸空间") {
                            Task {
                                await toggleImmersion()
                            }
                        }
                        .buttonStyle(SecondaryActionStyle())

                        Button(session.progress >= 0.72 ? "完成疗程" : "推进到下一阶段") {
                            store.advanceTherapy()
                        }
                        .buttonStyle(PrimaryActionStyle())
                    }
                } else {
                    SceneSignatureView(scene: store.latestRecommendation.scene, compact: true)
                        .frame(height: 138)

                    Text("选择一个主场景后，这里会显示阶段进度、沉浸入口和完成后的反馈跳转。")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.76))

                    InsetPanel {
                        VStack(alignment: .leading, spacing: 8) {
                            therapyDetailRow(title: "推荐优先", value: store.latestRecommendation.scene.name)
                            therapyDetailRow(title: "建议节律", value: store.latestRecommendation.scene.breathingPattern)
                            therapyDetailRow(title: "预期结果", value: store.latestRecommendation.expectedOutcome)
                        }
                    }

                    Button("按系统推荐立即开始") {
                        store.startTherapy(scene: store.latestRecommendation.scene)
                    }
                    .buttonStyle(PrimaryActionStyle())
                }
            }
        }
    }

    private func therapyDetailRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.moon)
            Text(value)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.74))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var immersiveLabel: String {
        switch appModel.immersiveSpaceState {
        case .closed:
            return "沉浸空间待启动"
        case .transitioning:
            return "沉浸空间切换中"
        case .open:
            return "沉浸空间已开启"
        }
    }

    private var immersiveColor: Color {
        switch appModel.immersiveSpaceState {
        case .closed:
            return AppTheme.coral
        case .transitioning:
            return AppTheme.moon
        case .open:
            return AppTheme.aqua
        }
    }

    @MainActor
    private func toggleImmersion() async {
        if appModel.immersiveSpaceState == .open {
            appModel.immersiveSpaceState = .transitioning
            await dismissImmersiveSpace()
            appModel.immersiveSpaceState = .closed
        } else {
            appModel.immersiveSpaceState = .transitioning
            let result = await openImmersiveSpace(id: appModel.immersiveSpaceID)
            if case .opened = result {
                appModel.immersiveSpaceState = .open
            } else {
                appModel.immersiveSpaceState = .closed
            }
        }
    }
}
