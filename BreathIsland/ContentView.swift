import SwiftUI

enum RootTab: Hashable {
    case dashboard
    case assessment
    case therapy
    case report
    case doctor
}

private struct RailItem: Identifiable {
    let tab: RootTab
    let title: String
    let detail: String
    let systemImage: String

    var id: RootTab { tab }
}

struct ContentView: View {
    @EnvironmentObject private var store: DemoStore
    @EnvironmentObject private var appModel: AppModel
    @State private var selectedTab: RootTab
    private let railItems = [
        RailItem(tab: .dashboard, title: "总览", detail: "疗程故事线", systemImage: "house"),
        RailItem(tab: .assessment, title: "评估", detail: "疼痛与功能", systemImage: "waveform.path.ecg"),
        RailItem(tab: .therapy, title: "治疗", detail: "Vision Pro 主端", systemImage: "visionpro"),
        RailItem(tab: .report, title: "反馈", detail: "生物反馈报告", systemImage: "chart.xyaxis.line"),
        RailItem(tab: .doctor, title: "医生端", detail: "临床共享视图", systemImage: "stethoscope")
    ]

    init(initialTab: RootTab = .dashboard) {
        _selectedTab = State(initialValue: initialTab)
    }

    var body: some View {
        NavigationStack {
            HStack(alignment: .top, spacing: 18) {
                commandRail
                    .frame(width: 308)

                SurfaceViewport {
                    activeScreen
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
            }
            .padding(18)
            .frame(minWidth: 1380, minHeight: 900, alignment: .topLeading)
            .background(AppTheme.pageGradient.ignoresSafeArea())
        }
        .tint(AppTheme.aqua)
        .animation(.spring(response: 0.42, dampingFraction: 0.84), value: selectedTab)
    }

    private var commandRail: some View {
        VStack(spacing: 18) {
            brandPanel

            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    SectionEyebrow(text: "系统导航")

                    ForEach(railItems) { item in
                        railButton(item)
                    }
                }
            }

            GlassCard {
                VStack(alignment: .leading, spacing: 14) {
                    SectionEyebrow(text: "实时状态")

                    VStack(alignment: .leading, spacing: 10) {
                        statusLine(title: "当前病种", value: store.currentAssessment.conditionType.shortLabel)
                        statusLine(title: "推荐场景", value: store.latestRecommendation.scene.name)
                        statusLine(title: "沉浸空间", value: immersionStatusText)
                    }

                    Divider()
                        .overlay(Color.white.opacity(0.10))

                    VStack(alignment: .leading, spacing: 8) {
                        Text("最新目标")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white)

                        Text(store.latestReport.nextStep)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.74))
                    }
                }
            }
        }
    }

    private var brandPanel: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(AppTheme.railGradient)

            Image("LiminalPosterV2")
                .resizable()
                .scaledToFit()
                .frame(width: 136)
                .opacity(0.95)
                .padding(.trailing, 14)
                .padding(.bottom, 12)

            LinearGradient(
                colors: [Color.black.opacity(0.24), Color.black.opacity(0.78)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(alignment: .leading, spacing: 10) {
                SectionEyebrow(text: "呼吸岛 Liminal")

                Text("Vision Pro 疼痛数字疗法")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: 190, alignment: .leading)

                Text("主端负责沉浸疗程，陪伴与医生共享走副屏。")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.78))
                    .frame(maxWidth: 190, alignment: .leading)
            }
            .padding(22)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(AppTheme.shellStroke, lineWidth: 1)
        )
        .shadow(color: AppTheme.deepSea.opacity(0.24), radius: 28, x: 0, y: 16)
    }

    private func railButton(_ item: RailItem) -> some View {
        Button {
            selectedTab = item.tab
        } label: {
            HStack(spacing: 12) {
                Image(systemName: item.systemImage)
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 18)

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                    Text(item.detail)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(selectedTab == item.tab ? Color.white.opacity(0.82) : Color.white.opacity(0.62))
                }

                Spacer()
            }
            .foregroundStyle(Color.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                selectedTab == item.tab
                ? LinearGradient(colors: [AppTheme.aqua, AppTheme.coral], startPoint: .leading, endPoint: .trailing)
                : LinearGradient(colors: [Color.white.opacity(0.10), Color.white.opacity(0.05)], startPoint: .leading, endPoint: .trailing),
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(selectedTab == item.tab ? Color.white.opacity(0.18) : Color.white.opacity(0.08), lineWidth: 1)
            )
        }
        .buttonStyle(RailButtonStyle(isSelected: selectedTab == item.tab))
    }

    private func statusLine(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.60))
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white)
        }
    }

    private var immersionStatusText: String {
        switch appModel.immersiveSpaceState {
        case .closed:
            return "待启动"
        case .transitioning:
            return "切换中"
        case .open:
            return "已进入"
        }
    }

    @ViewBuilder
    private var activeScreen: some View {
        Group {
            switch selectedTab {
            case .dashboard:
                DashboardView(selectedTab: $selectedTab)
            case .assessment:
                AssessmentFlowView(selectedTab: $selectedTab)
            case .therapy:
                TherapyHubView(selectedTab: $selectedTab)
            case .report:
                ReportCenterView()
            case .doctor:
                DoctorConsoleView()
            }
        }
        .id(selectedTab)
        .transition(.opacity.combined(with: .scale(scale: 0.985)))
    }
}
