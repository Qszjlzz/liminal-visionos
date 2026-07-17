import SwiftUI

private struct JourneyStep: Identifiable {
    let id = UUID()
    let phase: String
    let detail: String
}

struct DashboardView: View {
    @EnvironmentObject private var store: DemoStore
    @Binding var selectedTab: RootTab

    private var journeySteps: [JourneyStep] {
        [
            JourneyStep(phase: "01 评估", detail: "把疼痛位置、情绪和功能限制放在同一张视图里。"),
            JourneyStep(phase: "02 推荐", detail: store.latestRecommendation.reason),
            JourneyStep(phase: "03 沉浸", detail: "Vision Pro 主端接手呼吸同步、认知转移与场景引导。"),
            JourneyStep(phase: "04 共享", detail: "疗程结束后自动生成报告，同步给医生与家属。")
        ]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                hero

                HStack(alignment: .top, spacing: 16) {
                    statusBoard
                    recommendationPanel
                        .frame(width: 330)
                }

                HStack(alignment: .top, spacing: 16) {
                    pathwayCard
                    supportPreview
                        .frame(width: 330)
                }
            }
            .padding(24)
        }
        .background(Color.clear)
        .navigationTitle("呼吸岛")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var hero: some View {
        ZStack {
            Image("OceanSanctuary")
                .resizable()
                .scaledToFill()
                .overlay(AppTheme.heroGradient)

            LinearGradient(
                colors: [AppTheme.midnight.opacity(0.88), AppTheme.deepSea.opacity(0.52), Color.clear],
                startPoint: .leading,
                endPoint: .trailing
            )

            BreathingHalo(color: AppTheme.moon, diameter: 390)
                .offset(x: 300, y: -30)

            HStack(alignment: .center, spacing: 24) {
                VStack(alignment: .leading, spacing: 14) {
                    SectionEyebrow(text: "Vision Pro 主疗程")

                    Text("把疼痛高峰前的 12 分钟，变成可被引导的沉浸节律。")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white)

                    Text("当前推荐病种模式：\(store.currentAssessment.conditionType.rawValue)，今日建议优先完成一次 \(store.latestRecommendation.scene.name) 疗程。")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.78))

                    HStack(spacing: 12) {
                        Button("开始评估") {
                            selectedTab = .assessment
                        }
                        .buttonStyle(PrimaryActionStyle())
                        .frame(maxWidth: 190)

                        Button("按推荐进入治疗") {
                            selectedTab = .therapy
                        }
                        .buttonStyle(SecondaryActionStyle())
                        .frame(maxWidth: 210)
                    }

                    HStack(spacing: 12) {
                        heroFact(title: "推荐场景", value: store.latestRecommendation.scene.name)
                        heroFact(title: "引导目标", value: "稳定呼吸")
                        heroFact(title: "目标时长", value: "\(store.latestRecommendation.scene.durationMinutes) 分钟")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 12) {
                    Image("LiminalPosterV2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 215)
                        .shadow(color: AppTheme.deepSea.opacity(0.60), radius: 24, x: 0, y: 16)

                    StatusPill(text: "呼吸同步中", color: AppTheme.aqua)
                }
                .padding(.trailing, 8)
            }
            .padding(26)
        }
        .frame(minHeight: 328)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.20), lineWidth: 1)
        )
        .shadow(color: AppTheme.midnight.opacity(0.46), radius: 30, x: 0, y: 18)
    }

    private func heroFact(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.70))
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var statusBoard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                SectionEyebrow(text: "今日总览")

                Text("主端窗口负责把评估、推荐、治疗和反馈串成一条可演示的空间疗程。")
                    .font(.system(size: 23, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white)

                HStack(spacing: 12) {
                    MetricBadge(label: "连续使用", value: "\(store.streakDays) 天")
                    MetricBadge(label: "累计疗程", value: "\(store.completedSessions) 次")
                    MetricBadge(label: "最近降幅", value: String(format: "%.1f 分", store.lastPainDelta))
                }

                VStack(alignment: .leading, spacing: 12) {
                    detailRow(title: "当前痛感", body: "\(store.currentAssessment.intensityLabel)，\(store.currentAssessment.emotionState.rawValue)，\(store.currentAssessment.functionalLimit.rawValue)")
                    detailRow(title: "病种焦点", body: store.currentAssessment.conditionType.clinicalFocus)
                }
            }
        }
    }

    private var recommendationPanel: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionEyebrow(text: "推荐场景")

                SceneSignatureView(scene: store.latestRecommendation.scene, compact: true)
                    .frame(height: 132)

                Text(store.latestRecommendation.scene.name)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white)

                Text(store.latestRecommendation.scene.subtitle)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(AppTheme.moon)

                Text(store.latestRecommendation.expectedOutcome)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.78))

                HStack(spacing: 8) {
                    StatusPill(text: "\(store.latestRecommendation.scene.durationMinutes) 分钟", color: AppTheme.aqua)
                    StatusPill(text: "主端优先", color: AppTheme.coral)
                }

                Divider()
                    .overlay(Color.white.opacity(0.10))

                detailRow(title: "呼吸节律", body: store.latestRecommendation.scene.breathingPattern)
                detailRow(title: "安全提醒", body: store.latestRecommendation.safetyNote)
            }
        }
    }

    private var pathwayCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 4) {
                SectionEyebrow(text: "疗程闭环")

                Text("从评估到共享，比赛演示可以一条线走完。")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 8)

                ForEach(journeySteps) { step in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(step.phase)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.moon)
                        Text(step.detail)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.76))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 10)

                    if step.id != journeySteps.last?.id {
                        Divider()
                            .overlay(Color.white.opacity(0.08))
                    }
                }
            }
        }
    }

    private var supportPreview: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionEyebrow(text: "陪伴与共享")

                Text("家属与医生")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white)

                InsetPanel {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("最新陪伴")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.moon)
                        Text(store.companionMessages.first?.message ?? "家属留言会在这里同步显示。")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.76))
                    }
                }

                HStack(spacing: 12) {
                    Button("看报告") {
                        selectedTab = .report
                    }
                    .buttonStyle(PrimaryActionStyle())

                    Button("医护回看在 iPad") {
                        selectedTab = .report
                    }
                    .buttonStyle(SecondaryActionStyle())
                }
            }
        }
    }

    private func detailRow(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.moon)
            Text(body)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.76))
        }
    }
}
