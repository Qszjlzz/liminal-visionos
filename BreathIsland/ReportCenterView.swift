import Charts
import SwiftUI

private enum ReportPanel: String, CaseIterable, Identifiable {
    case biofeedback = "生物反馈"
    case companion = "家属陪伴"
    case report = "治疗报告"

    var id: String { rawValue }
}

struct ReportCenterView: View {
    @EnvironmentObject private var store: DemoStore
    @State private var panel: ReportPanel = .biofeedback

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                headerCard
                panelPicker

                switch panel {
                case .biofeedback:
                    biofeedbackPanel
                case .companion:
                    companionPanel
                case .report:
                    reportPanel
                }
            }
            .padding(20)
        }
        .background(Color.clear)
        .navigationTitle("反馈与报告")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerCard: some View {
        GlassCard {
            HStack(alignment: .top, spacing: 18) {
                VStack(alignment: .leading, spacing: 14) {
                    SectionEyebrow(text: "疗程回顾")

                    Text("把疗程前后的生理变化、家属陪伴和医生建议收在一处。")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white)

                    Text(store.latestReport.summary)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.76))

                    HStack(spacing: 12) {
                        MetricBadge(label: "疗程场景", value: store.latestReport.recommendation.scene.name)
                        MetricBadge(label: "疗程后疼痛", value: String(format: "%.1f 分", store.latestReport.biofeedback.last?.painAfter ?? store.currentAssessment.intensity))
                        MetricBadge(label: "心率终点", value: String(format: "%.0f bpm", store.latestReport.biofeedback.last?.heartRate ?? 0))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                SceneSignatureView(scene: store.latestReport.recommendation.scene)
                    .frame(width: 280, height: 180)
                    .overlay(alignment: .topLeading) {
                        Text("主疗程焦点")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.90))
                            .padding(12)
                    }
            }
        }
    }

    private var panelPicker: some View {
        HStack(spacing: 10) {
            ForEach(ReportPanel.allCases) { item in
                Button {
                    panel = item
                } label: {
                    Text(item.rawValue)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(panel == item ? Color.white : Color.white.opacity(0.74))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 11)
                        .background(
                            panel == item
                            ? LinearGradient(colors: [AppTheme.aqua, AppTheme.coral], startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(colors: [Color.white.opacity(0.10), Color.white.opacity(0.05)], startPoint: .leading, endPoint: .trailing),
                            in: Capsule()
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var biofeedbackPanel: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                GlassCard {
                    VStack(alignment: .leading, spacing: 14) {
                        SectionEyebrow(text: "生理指标")

                        Text("心率与 HRV")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white)

                        Chart {
                            ForEach(store.biofeedbackSamples) { sample in
                                LineMark(
                                    x: .value("时间", sample.timestamp),
                                    y: .value("心率", sample.heartRate)
                                )
                                .foregroundStyle(AppTheme.coral)
                                .interpolationMethod(.catmullRom)

                                LineMark(
                                    x: .value("时间", sample.timestamp),
                                    y: .value("HRV", sample.hrv)
                                )
                                .foregroundStyle(AppTheme.aqua)
                                .interpolationMethod(.catmullRom)
                            }
                        }
                        .frame(height: 220)
                        .chartXAxis(.hidden)
                        .chartYAxis {
                            AxisMarks(position: .leading) { _ in
                                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                                    .foregroundStyle(Color.white.opacity(0.12))
                                AxisTick()
                                    .foregroundStyle(Color.white.opacity(0.26))
                                AxisValueLabel()
                                    .foregroundStyle(Color.white.opacity(0.68))
                            }
                        }

                        HStack(spacing: 12) {
                            MetricBadge(label: "心率下降", value: String(format: "%.0f bpm", heartRateDrop))
                            MetricBadge(label: "HRV 提升", value: String(format: "%.0f ms", hrvGain))
                            MetricBadge(label: "呼吸放缓", value: String(format: "%.0f 次/分", breathingRateDrop))
                        }
                    }
                }
                .frame(maxWidth: .infinity)

                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        SectionEyebrow(text: "疗程判断")
                        InsetPanel {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("本次目标")
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                                    .foregroundStyle(AppTheme.moon)
                                Text("本次引导目标：建立可跟随的呼吸节律与陪伴感，不代表临床疗效。")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.white.opacity(0.76))
                            }
                        }

                        InsetPanel {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("陪伴状态")
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                                    .foregroundStyle(AppTheme.moon)
                                Text(store.companionMessages.first?.message ?? "当前无陪伴留言。")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.white.opacity(0.76))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }

                        InsetPanel {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("下一次启动时机")
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                                    .foregroundStyle(AppTheme.moon)
                                Text("建议在下一次疼痛明显上升前 5 分钟进入 \(store.latestRecommendation.scene.name) 疗程。")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.white.opacity(0.76))
                            }
                        }
                    }
                }
                .frame(width: 320)
            }

            GlassCard {
                VStack(alignment: .leading, spacing: 14) {
                    SectionEyebrow(text: "主观疼痛")

                    Text("疼痛降幅轨迹")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white)

                    Chart {
                        ForEach(store.biofeedbackSamples) { sample in
                            AreaMark(
                                x: .value("时间", sample.timestamp),
                                y: .value("疗程后疼痛", sample.painAfter)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [AppTheme.aqua.opacity(0.6), AppTheme.mint.opacity(0.18)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            LineMark(
                                x: .value("时间", sample.timestamp),
                                y: .value("疗程后疼痛", sample.painAfter)
                            )
                            .foregroundStyle(AppTheme.moon)
                        }
                    }
                    .frame(height: 220)
                    .chartXAxis(.hidden)
                    .chartYAxis {
                        AxisMarks(position: .leading) { _ in
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                                .foregroundStyle(Color.white.opacity(0.12))
                            AxisTick()
                                .foregroundStyle(Color.white.opacity(0.26))
                            AxisValueLabel()
                                .foregroundStyle(Color.white.opacity(0.68))
                        }
                    }
                }
            }
        }
    }

    private var companionPanel: some View {
        GlassCard {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 14) {
                    SectionEyebrow(text: "陪伴同步")

                    Text("家属同步参与")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white)

                    Text("iPad 端可同步 VR 画面，留言将作为低刺激语音片段在疗程中穿插播放。")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.76))

                    ForEach(store.companionMessages) { message in
                        InsetPanel {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("\(message.sender) · \(message.role)")
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                        .foregroundStyle(Color.white)
                                    Spacer()
                                    Text(message.mood)
                                        .font(.system(size: 12, weight: .bold, design: .rounded))
                                        .foregroundStyle(AppTheme.moon)
                                }
                                Text(message.message)
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.white.opacity(0.76))
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 12) {
                    SceneSignatureView(scene: store.latestRecommendation.scene, compact: true)
                        .frame(width: 280, height: 150)
                    InsetPanel {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("副屏角色")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundStyle(AppTheme.moon)
                            Text("陪伴副屏负责同步场景、提示下一次呼吸节律和低刺激提醒。")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.white.opacity(0.76))
                        }
                    }
                }
            }
        }
    }

    private var reportPanel: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionEyebrow(text: "医生回看")

                Text("治疗报告")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white)

                Text(store.latestReport.summary)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.76))

                InsetPanel {
                    VStack(alignment: .leading, spacing: 10) {
                        detailRow(title: "医生备注", body: store.latestReport.doctorNotes)
                        detailRow(title: "下一步建议", body: store.latestReport.nextStep)
                    }
                }

                HStack(spacing: 12) {
                    MetricBadge(label: "病种模式", value: store.latestReport.assessment.conditionType.shortLabel)
                    MetricBadge(label: "场景", value: store.latestReport.recommendation.scene.name)
                    MetricBadge(label: "活动等级", value: "\(store.latestReport.assessment.functionalLimit.score) 级")
                }
            }
        }
    }

    private func detailRow(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.moon)
            Text(body)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.76))
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
