import Foundation
import SwiftUI

enum ConditionType: String, CaseIterable, Identifiable {
    case burn = "烧伤换药"
    case postoperative = "术后康复"
    case cancer = "癌症慢性痛"
    case labor = "分娩产痛"
    case chronic = "慢性疼痛"

    var id: String { rawValue }

    var shortLabel: String {
        switch self {
        case .burn: return "烧伤"
        case .postoperative: return "术后"
        case .cancer: return "癌痛"
        case .labor: return "分娩"
        case .chronic: return "慢性痛"
        }
    }

    var clinicalFocus: String {
        switch self {
        case .burn:
            return "高强度换药前的注意力转移与呼吸稳定"
        case .postoperative:
            return "活动前后的节律呼吸与安全恢复"
        case .cancer:
            return "长期痛感中的焦虑安抚与陪伴支持"
        case .labor:
            return "宫缩波峰下的呼吸同步与陪伴引导"
        case .chronic:
            return "居家日常中的可持续自我管理"
        }
    }

    var recommendedRelief: Double {
        switch self {
        case .burn: return 2.8
        case .postoperative: return 2.2
        case .cancer: return 2.0
        case .labor: return 2.6
        case .chronic: return 1.8
        }
    }
}

enum PainLocation: String, CaseIterable, Identifiable {
    case headNeck = "头颈"
    case chest = "胸部"
    case abdomen = "腹部"
    case back = "腰背"
    case limbs = "四肢"
    case pelvic = "骨盆/产道"
    case woundArea = "伤口区域"

    var id: String { rawValue }
}

enum PainQuality: String, CaseIterable, Identifiable {
    case burning = "灼痛"
    case stabbing = "刺痛"
    case dull = "钝痛"
    case pulling = "牵拉痛"
    case cramping = "阵痛"
    case throbbing = "搏动痛"

    var id: String { rawValue }
}

enum EmotionState: String, CaseIterable, Identifiable {
    case anxious = "焦虑"
    case fearful = "恐惧"
    case exhausted = "疲惫"
    case low = "低落"
    case calm = "平静"

    var id: String { rawValue }
}

enum FunctionalLimit: String, CaseIterable, Identifiable {
    case bedRest = "只能卧床"
    case basicMovement = "可完成基础活动"
    case shortWalk = "可短距离行走"
    case focusedWork = "可集中处理事务"
    case normalRoutine = "接近日常状态"

    var id: String { rawValue }

    var score: Int {
        switch self {
        case .bedRest: return 1
        case .basicMovement: return 2
        case .shortWalk: return 3
        case .focusedWork: return 4
        case .normalRoutine: return 5
        }
    }
}

struct PainAssessment: Identifiable {
    let id = UUID()
    var conditionType: ConditionType
    var painLocation: PainLocation
    var painQuality: PainQuality
    var intensity: Double
    var frequency: String
    var trigger: String
    var emotionState: EmotionState
    var functionalLimit: FunctionalLimit

    var intensityLabel: String {
        String(format: "%.0f / 10", intensity)
    }
}

struct TherapyScene: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let subtitle: String
    let targetCondition: ConditionType
    let durationMinutes: Int
    let visualTheme: String
    let breathingPattern: String
    let description: String
    let icon: String

    static let demoScenes: [TherapyScene] = [
        TherapyScene(
            name: "冰火对抗",
            subtitle: "高强度疼痛的注意力转移",
            targetCondition: .burn,
            durationMinutes: 12,
            visualTheme: "冰蓝峡湾",
            breathingPattern: "4 秒吸气 / 6 秒呼气",
            description: "通过冷热意象切换与空间穿越，让伤口注意力从外周拉回可控制的节律焦点。",
            icon: "snowflake"
        ),
        TherapyScene(
            name: "海浪呼吸",
            subtitle: "宫缩与节律同步引导",
            targetCondition: .labor,
            durationMinutes: 10,
            visualTheme: "潮汐海湾",
            breathingPattern: "随宫缩波峰渐快，波谷放慢",
            description: "把浪涌、呼吸和陪伴节奏绑定在一起，帮助分娩或焦虑型疼痛用户建立稳定节律。",
            icon: "water.waves"
        ),
        TherapyScene(
            name: "星屿冥想",
            subtitle: "慢性痛与癌痛的安抚陪伴",
            targetCondition: .cancer,
            durationMinutes: 15,
            visualTheme: "星夜群岛",
            breathingPattern: "5 秒吸气 / 5 秒呼气",
            description: "用低刺激视觉、温和叙事和家属语音插入，减轻持续性痛感中的紧绷与孤独。",
            icon: "sparkles"
        )
    ]
}

struct TherapyRecommendation: Identifiable {
    let id = UUID()
    let scene: TherapyScene
    let reason: String
    let sessionPlan: String
    let expectedOutcome: String
    let safetyNote: String
}

struct TherapySession {
    let scene: TherapyScene
    var progress: Double
    var stageIndex: Int
    var note: String
    let startedAt: Date

    let stages = [
        "建立安全锚点",
        "呼吸同步",
        "认知转移",
        "沉浸收束"
    ]

    var currentStage: String {
        stages[min(stageIndex, stages.count - 1)]
    }
}

struct BiofeedbackSample: Identifiable {
    let id = UUID()
    let heartRate: Double
    let hrv: Double
    let breathingRate: Double
    let painBefore: Double
    let painAfter: Double
    let timestamp: Date
    let label: String
}

struct PatientReport: Identifiable {
    let id = UUID()
    let assessment: PainAssessment
    let recommendation: TherapyRecommendation
    let biofeedback: [BiofeedbackSample]
    let summary: String
    let doctorNotes: String
    let nextStep: String
}

struct CompanionMessage: Identifiable {
    let id = UUID()
    let sender: String
    let role: String
    let message: String
    let mood: String
}

struct DoctorInsight: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let level: InsightLevel

    enum InsightLevel: String {
        case watch = "观察"
        case stable = "稳定"
        case priority = "优先处理"
    }
}

struct DeviceStatus {
    var phoneConnected: Bool
    var headsetConnected: Bool
    var wearableConnected: Bool
}
