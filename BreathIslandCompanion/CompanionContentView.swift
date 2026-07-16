import SwiftUI
import Charts

private enum CompanionMode: String, CaseIterable, Identifiable { case family = "家属陪伴", clinician = "医护回看"; var id: String { rawValue } }

struct CompanionContentView: View {
    @EnvironmentObject private var store: DemoStore
    @State private var mode: CompanionMode = .family
    @State private var code = "240617"
    @State private var elapsed = 22
    @State private var message = "我在这里，跟着海浪慢慢呼气。"
    private var provider: SimulationSyncProvider { SimulationSyncProvider(configuration: .init(demoCode: code)) }
    private var sample: DemoSignalSample { provider.sample(at: elapsed) }
    var body: some View {
        NavigationStack {
            ScrollView { VStack(alignment: .leading, spacing: 20) {
                header
                Picker("角色", selection: $mode) { ForEach(CompanionMode.allCases) { Text($0.rawValue).tag($0) } }.pickerStyle(.segmented)
                stepper
                mode == .family ? familyView : clinicianView
            }.padding(24) }
            .background(AppTheme.pageGradient.ignoresSafeArea())
            .navigationTitle("呼吸岛 Companion")
        }.tint(AppTheme.aqua)
    }
    private var header: some View { GlassCard { HStack { VStack(alignment: .leading, spacing: 8) { Text("演示同步模式").font(.caption.weight(.bold)).foregroundStyle(AppTheme.mint); Text("分娩产痛同步陪伴").font(.title.bold()).foregroundStyle(.white); Text("使用相同 6 位演示码，双端生成一致疗程时间线；不代表真实实时通信。 ").foregroundStyle(.white.opacity(0.76)) }; Spacer(); Text(sample.phase.rawValue).font(.headline).foregroundStyle(.white).padding(14).background(AppTheme.aqua.opacity(0.25), in: RoundedRectangle(cornerRadius: 8)) } } }
    private var stepper: some View { HStack { TextField("6 位演示码", text: $code).textFieldStyle(.roundedBorder).frame(width: 170); Button { elapsed = max(0, elapsed - 1) } label: { Image(systemName: "chevron.left") }; Text("\(elapsed)s").monospacedDigit().foregroundStyle(.white); Button { elapsed += 1 } label: { Image(systemName: "chevron.right") }; Spacer(); Text("演示模拟数据").font(.caption.weight(.bold)).foregroundStyle(AppTheme.coral) }.padding(12).background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8)) }
    private var familyView: some View { VStack(alignment: .leading, spacing: 16) { GlassCard { VStack(alignment: .leading, spacing: 12) { Text(sample.phase.cue).font(.title2.bold()).foregroundStyle(.white); ProgressView(value: sample.contractionIntensity).tint(AppTheme.coral); Text("宫缩强度 \(Int(sample.contractionIntensity * 100))% · 呼吸 \(Int(sample.breathingRate)) 次/分").foregroundStyle(.white.opacity(0.78)); HStack { Button("同步呼吸") { elapsed += 4 }.buttonStyle(PrimaryActionStyle()); Button("安静陪伴") { message = "我会在这里，安静陪你度过这一段。" }.buttonStyle(SecondaryActionStyle()) } } }; GlassCard { VStack(alignment: .leading, spacing: 8) { Text("鼓励留言").font(.headline).foregroundStyle(.white); TextField("留言", text: $message).textFieldStyle(.roundedBorder); Text(message).foregroundStyle(.white.opacity(0.8)).padding(.top, 6) } } } }
    private var clinicianView: some View { VStack(alignment: .leading, spacing: 16) { HStack { MetricBadge(label: "起始疼痛", value: "7 / 10"); MetricBadge(label: "当前阶段", value: sample.phase.rawValue); MetricBadge(label: "风险状态", value: store.laborEngine.safetyEvent == .none ? "演示稳定" : store.laborEngine.safetyEvent.rawValue) }; GlassCard { VStack(alignment: .leading, spacing: 12) { Text("模拟生理趋势").font(.headline).foregroundStyle(.white); Chart { BarMark(x: .value("指标", "心率"), y: .value("数值", sample.heartRate)).foregroundStyle(AppTheme.coral); BarMark(x: .value("指标", "HRV"), y: .value("数值", sample.hrv)).foregroundStyle(AppTheme.aqua) }.frame(height: 180); Text("下一步：继续低刺激呼吸引导；若出现异常，人工接管并呼叫医护。原型演示规则，不构成临床决策。").foregroundStyle(.white.opacity(0.78)); Button("人工接管") { store.laborEngine.trigger(.abnormalSignal) }.buttonStyle(SecondaryActionStyle()) } } } }
}
