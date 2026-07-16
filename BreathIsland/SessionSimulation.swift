import Foundation
import SwiftUI

enum LaborSessionPhase: String, CaseIterable, Identifiable {
    case preparation = "疗程准备"
    case rise = "宫缩上升"
    case peak = "波峰"
    case recovery = "恢复"
    case review = "本次回顾"

    var id: String { rawValue }
    var cue: String {
        switch self {
        case .preparation: return "把注意力放在舒适的呼气上"
        case .rise: return "跟着浪线，缓慢吸气"
        case .peak: return "短句提示：呼气比吸气更长"
        case .recovery: return "波峰已过，让肩颈慢慢放松"
        case .review: return "记录感受，交还给照护团队"
        }
    }
}

struct DemoSessionConfiguration: Hashable {
    let demoCode: String
    let cycleSeconds: Int
    let baselinePain: Double

    init(demoCode: String = "240617", cycleSeconds: Int = 48, baselinePain: Double = 7) {
        let digits = demoCode.filter { $0.isNumber }
        self.demoCode = String(("000000" + digits).suffix(6))
        self.cycleSeconds = cycleSeconds
        self.baselinePain = baselinePain
    }
}

struct DemoSignalSample: Identifiable {
    let id = UUID()
    let elapsedSeconds: Int
    let phase: LaborSessionPhase
    let contractionIntensity: Double
    let breathingRate: Double
    let heartRate: Double
    let hrv: Double
    let painScore: Double
    let isSimulation = true
}

enum SafetyEvent: String, Identifiable {
    case none
    case elevatedPain = "疼痛明显升高"
    case dizziness = "眩晕"
    case panic = "恐慌"
    case abnormalSignal = "异常信号"

    var id: String { rawValue }
    var instruction: String {
        switch self {
        case .none: return ""
        default: return "此为原型演示规则，不构成诊断或临床决策。请暂停疗程、退出沉浸，并呼叫医护。"
        }
    }
}

protocol SessionSyncProvider {
    var configuration: DemoSessionConfiguration { get }
    func sample(at elapsedSeconds: Int) -> DemoSignalSample
}

struct SimulationSyncProvider: SessionSyncProvider {
    let configuration: DemoSessionConfiguration

    func sample(at elapsedSeconds: Int) -> DemoSignalSample {
        let position = max(0, elapsedSeconds) % configuration.cycleSeconds
        let normalized = Double(position) / Double(configuration.cycleSeconds)
        let phase: LaborSessionPhase
        let intensity: Double
        switch normalized {
        case ..<0.14: phase = .preparation; intensity = 0.12
        case ..<0.44: phase = .rise; intensity = 0.25 + (normalized - 0.14) / 0.30 * 0.55
        case ..<0.62: phase = .peak; intensity = 0.88
        case ..<0.88: phase = .recovery; intensity = 0.78 - (normalized - 0.62) / 0.26 * 0.60
        default: phase = .review; intensity = 0.14
        }
        let codeOffset = Double(Int(configuration.demoCode.suffix(2)) ?? 0) / 100
        let heartRate = 82 + intensity * 18 + codeOffset
        let hrv = 38 - intensity * 13 + codeOffset
        let breathing = 10 + intensity * 8
        let pain = min(10, configuration.baselinePain + intensity * 1.4)
        return DemoSignalSample(elapsedSeconds: elapsedSeconds, phase: phase, contractionIntensity: intensity, breathingRate: breathing, heartRate: heartRate, hrv: hrv, painScore: pain)
    }
}

@MainActor
final class LaborSessionEngine: ObservableObject {
    @Published private(set) var elapsedSeconds = 0
    @Published private(set) var sample: DemoSignalSample
    @Published var safetyEvent: SafetyEvent = .none
    @Published private(set) var isRunning = false
    let provider: SimulationSyncProvider
    private var timer: Timer?

    init(configuration: DemoSessionConfiguration = .init()) {
        provider = SimulationSyncProvider(configuration: configuration)
        sample = provider.sample(at: 0)
    }

    deinit { timer?.invalidate() }
    var configuration: DemoSessionConfiguration { provider.configuration }
    var phase: LaborSessionPhase { sample.phase }

    func start() {
        isRunning = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.advance() }
        }
    }

    func advance() {
        elapsedSeconds += 1
        sample = provider.sample(at: elapsedSeconds)
    }

    func pause() { isRunning = false; timer?.invalidate(); timer = nil }
    func reset() { pause(); elapsedSeconds = 0; sample = provider.sample(at: 0); safetyEvent = .none }
    func trigger(_ event: SafetyEvent) { safetyEvent = event; pause() }
    func clearSafety() { safetyEvent = .none }
}
