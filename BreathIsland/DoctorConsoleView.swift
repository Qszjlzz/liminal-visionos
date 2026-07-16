import Charts
import SwiftUI

struct DoctorConsoleView: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                headerCard

                HStack(alignment: .top, spacing: 16) {
                    insightsCard
                    VStack(spacing: 16) {
                        assessmentCard
                        monitoringTrendCard
                    }
                    .frame(width: 380)
                }
            }
            .padding(20)
        }
        .background(Color.clear)
        .navigationTitle("医生端")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerCard: some View {
        GlassCard {
            HStack(alignment: .top, spacing: 18) {
                VStack(alignment: .leading, spacing: 14) {
                    SectionEyebrow(text: "临床总览")

                    Text("医生端数据中台")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white)

                    Text("把疼痛评估、VR 治疗、生物反馈和依从性放到同一张临床视图里。")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.76))

                    HStack(spacing: 12) {
                        MetricBadge(label: "起始疼痛", value: store.currentAssessment.intensityLabel)
                        MetricBadge(label: "推荐场景", value: store.latestRecommendation.scene.name)
                        MetricBadge(label: "最近降幅", value: String(format: "%.1f 分", store.lastPainDelta))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                InsetPanel {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("当前分层")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.moon)
                        Text(store.currentAssessment.intensity >= 8 ? "优先镇痛评估" : "可继续数字疗法辅助")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white)
                        Text("建议把 \(store.latestRecommendation.scene.name) 作为本轮主要场景，并持续观察功能活动恢复。")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.74))
                    }
                }
            }
        }
    }

    private var insightsCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionEyebrow(text: "临床洞察")

                Text("当前风险与建议")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white)

                ForEach(store.doctorInsights) { insight in
                    InsetPanel {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(insight.title)
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.white)
                                Spacer()
                                Text(insight.level.rawValue)
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundStyle(color(for: insight.level))
                            }
                            Text(insight.detail)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.white.opacity(0.74))
                        }
                    }
                }
            }
        }
    }

    private var assessmentCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionEyebrow(text: "评估摘要")

                Text("本次评估摘要")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white)

                HStack(spacing: 12) {
                    MetricBadge(label: "心率下降", value: String(format: "%.0f bpm", heartRateDrop))
                    MetricBadge(label: "HRV 提升", value: String(format: "%.0f ms", hrvGain))
                    MetricBadge(label: "呼吸放缓", value: String(format: "%.0f 次/分", breathingRateDrop))
                }

                InsetPanel {
                    VStack(alignment: .leading, spacing: 10) {
                        detail(title: "疼痛位置", value: store.currentAssessment.painLocation.rawValue)
                        detail(title: "疼痛性质", value: store.currentAssessment.painQuality.rawValue)
                        detail(title: "频率", value: store.currentAssessment.frequency)
                        detail(title: "诱因", value: store.currentAssessment.trigger)
                        detail(title: "功能目标", value: "从 \(store.currentAssessment.functionalLimit.rawValue) 提升 1 个等级")
                        detail(title: "下一步", value: store.latestReport.nextStep)
                    }
                }
            }
        }
    }

    private var monitoringTrendCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionEyebrow(text: "趋势判断")

                Text("治疗后趋势")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white)

                Chart {
                    ForEach(store.biofeedbackSamples) { sample in
                        LineMark(
                            x: .value("时间", sample.timestamp),
                            y: .value("疗程后疼痛", sample.painAfter)
                        )
                        .foregroundStyle(AppTheme.aqua)
                        .interpolationMethod(.catmullRom)

                        LineMark(
                            x: .value("时间", sample.timestamp),
                            y: .value("呼吸频率", sample.breathingRate / 2)
                        )
                        .foregroundStyle(AppTheme.coral)
                        .interpolationMethod(.catmullRom)
                    }
                }
                .frame(height: 160)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)

                InsetPanel {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("临床备注")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.moon)
                        Text("当前走势显示治疗后疼痛与呼吸频率同步下降，可继续沿用本轮节律和场景。")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.76))
                    }
                }
            }
        }
    }

    private func detail(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.moon)
            Text(value)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.76))
        }
    }

    private func color(for level: DoctorInsight.InsightLevel) -> Color {
        switch level {
        case .stable: return AppTheme.aqua
        case .watch: return AppTheme.deepSea
        case .priority: return AppTheme.coral
        }
    }

    private var heartRateDrop: Double {
        guard let first = store.biofeedbackSamples.first?.heartRate,
              let last = store.biofeedbackSamples.last?.heartRate else { return 0 }
        return max(0, first - last)
    }

    private var hrvGain: Double {
        guard let first = store.biofeedbackSamples.first?.hrv,
              let last = store.biofeedbackSamples.last?.hrv else { return 0 }
        return max(0, last - first)
    }

    private var breathingRateDrop: Double {
        guard let first = store.biofeedbackSamples.first?.breathingRate,
              let last = store.biofeedbackSamples.last?.breathingRate else { return 0 }
        return max(0, first - last)
    }
}
