import SwiftUI

struct AssessmentFlowView: View {
    @EnvironmentObject private var store: DemoStore
    @Binding var selectedTab: RootTab

    @State private var conditionType: ConditionType = .burn
    @State private var painLocation: PainLocation = .woundArea
    @State private var painQuality: PainQuality = .burning
    @State private var emotionState: EmotionState = .anxious
    @State private var functionalLimit: FunctionalLimit = .basicMovement
    @State private var intensity: Double = 7
    @State private var frequency = "每 4-6 分钟一波"
    @State private var trigger = "换药 / 宫缩 / 活动牵拉"
    @State private var showRecommendation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("功能性疼痛评估")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white)
                        Text("不只问 0-10 分，而是把疼痛位置、性质、情绪和活动能力放在一起看。")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.76))
                    }
                }

                selectionCard(title: "病种模式", options: ConditionType.allCases, selection: $conditionType)
                selectionCard(title: "疼痛位置", options: PainLocation.allCases, selection: $painLocation)
                selectionCard(title: "疼痛性质", options: PainQuality.allCases, selection: $painQuality)
                selectionCard(title: "情绪状态", options: EmotionState.allCases, selection: $emotionState)
                selectionCard(title: "功能状态", options: FunctionalLimit.allCases, selection: $functionalLimit)

                GlassCard {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("主观疼痛强度")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                            Spacer()
                            Text(String(format: "%.0f / 10", intensity))
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundStyle(AppTheme.coral)
                        }

                        Slider(value: $intensity, in: 0...10, step: 1)
                            .tint(AppTheme.aqua)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("频率 / 节奏")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                            TextField("例如：持续性钝痛，每 5 分钟加重一次", text: $frequency)
                                .textInputAutocapitalization(.never)
                                .padding(14)
                                .background(Color.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("诱因 / 情境")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                            TextField("例如：换药、下床活动、夜间、宫缩增强", text: $trigger)
                                .textInputAutocapitalization(.never)
                                .padding(14)
                                .background(Color.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                    }
                }

                Button("生成个性化方案") {
                    let assessment = PainAssessment(
                        conditionType: conditionType,
                        painLocation: painLocation,
                        painQuality: painQuality,
                        intensity: intensity,
                        frequency: frequency,
                        trigger: trigger,
                        emotionState: emotionState,
                        functionalLimit: functionalLimit
                    )
                    store.submitAssessment(assessment)
                    showRecommendation = true
                }
                .buttonStyle(PrimaryActionStyle())
            }
            .padding(20)
        }
        .background(Color.clear)
        .navigationTitle("疼痛评估")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showRecommendation) {
            RecommendationDetailView(selectedTab: $selectedTab)
                .environmentObject(store)
        }
        .onAppear {
            let assessment = store.currentAssessment
            conditionType = assessment.conditionType
            painLocation = assessment.painLocation
            painQuality = assessment.painQuality
            emotionState = assessment.emotionState
            functionalLimit = assessment.functionalLimit
            intensity = assessment.intensity
            frequency = assessment.frequency
            trigger = assessment.trigger
        }
    }

    private func selectionCard<Option: CaseIterable & Identifiable & RawRepresentable>(
        title: String,
        options: Option.AllCases,
        selection: Binding<Option>
    ) -> some View where Option.RawValue == String {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 10)], spacing: 10) {
                    ForEach(Array(options)) { option in
                        Button {
                            selection.wrappedValue = option
                        } label: {
                            SecondaryChip(text: option.rawValue, selected: selection.wrappedValue.id == option.id)
                        }
                        .buttonStyle(ChipButtonStyle())
                    }
                }
            }
        }
    }
}
