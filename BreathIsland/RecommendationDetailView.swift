import SwiftUI

struct RecommendationDetailView: View {
    @EnvironmentObject private var store: DemoStore
    @Binding var selectedTab: RootTab

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("AI 推荐结果")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white)
                        Text(store.latestRecommendation.scene.name)
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.aqua)
                        Text(store.latestRecommendation.reason)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.76))
                    }
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: 14) {
                        detailRow(title: "疗程计划", body: store.latestRecommendation.sessionPlan)
                        detailRow(title: "预期收益", body: store.latestRecommendation.expectedOutcome)
                        detailRow(title: "安全提示", body: store.latestRecommendation.safetyNote)
                    }
                }

                GlassCard {
                    HStack(spacing: 12) {
                        MetricBadge(label: "推荐场景", value: store.latestRecommendation.scene.name)
                        MetricBadge(label: "时长", value: "\(store.latestRecommendation.scene.durationMinutes) 分钟")
                        MetricBadge(label: "节律", value: store.latestRecommendation.scene.breathingPattern)
                    }
                }

                Button("进入 VR 治疗入口") {
                    selectedTab = .therapy
                }
                .buttonStyle(PrimaryActionStyle())
            }
            .padding(20)
        }
        .background(Color.clear)
        .navigationTitle("推荐方案")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func detailRow(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white)
            Text(body)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.76))
        }
    }
}
