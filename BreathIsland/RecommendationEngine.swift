import Foundation

enum RecommendationEngine {
    static func recommend(for assessment: PainAssessment, scenes: [TherapyScene]) -> TherapyRecommendation {
        let name: String
        switch assessment.conditionType {
        case .burn: name = "冰火对抗"
        case .labor: name = "海浪呼吸"
        case .cancer, .chronic: name = "星屿冥想"
        case .postoperative: name = assessment.emotionState == .anxious || assessment.intensity >= 7 ? "海浪呼吸" : "星屿冥想"
        }
        let scene = scenes.first(where: { $0.name == name }) ?? scenes[0]
        let duration = assessment.intensity >= 8 ? scene.durationMinutes + 3 : scene.durationMinutes
        let safety = assessment.intensity >= 9
            ? "当前疼痛极高，请把本功能作为辅助工具并同步联系医护。"
            : "原型为非药物辅助引导，不替代助产团队判断；异常时请暂停、退出沉浸并呼叫医护。"
        return TherapyRecommendation(
            scene: scene,
            reason: "根据疼痛情境、情绪状态与陪伴条件，优先安排 \(scene.name) 的 \(duration) 分钟非药物辅助引导。",
            sessionPlan: "先完成安全锚点，再进入 \(scene.breathingPattern) 的沉浸节律；波峰只保留呼吸提示，恢复期交给陪伴留言。",
            expectedOutcome: "本次引导目标：在演示模拟时间线中建立可跟随的呼吸节律与陪伴感，不代表临床疗效。",
            safetyNote: safety,
            explanationFactors: ["疼痛情境：\(assessment.conditionType.rawValue) / \(assessment.painQuality.rawValue)", "情绪状态：\(assessment.emotionState.rawValue)", "功能与陪伴：\(assessment.functionalLimit.rawValue)，可启用陪伴副屏"]
        )
    }
}
