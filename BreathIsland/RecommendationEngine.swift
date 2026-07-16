import Foundation

enum RecommendationEngine {
    static func recommend(for assessment: PainAssessment, scenes: [TherapyScene]) -> TherapyRecommendation {
        let chosenScene: TherapyScene

        switch assessment.conditionType {
        case .burn:
            chosenScene = scenes.first(where: { $0.name == "冰火对抗" }) ?? scenes[0]
        case .labor:
            chosenScene = scenes.first(where: { $0.name == "海浪呼吸" }) ?? scenes[1]
        case .cancer, .chronic:
            chosenScene = scenes.first(where: { $0.name == "星屿冥想" }) ?? scenes[2]
        case .postoperative:
            if assessment.emotionState == .anxious || assessment.intensity >= 7 {
                chosenScene = scenes.first(where: { $0.name == "海浪呼吸" }) ?? scenes[1]
            } else {
                chosenScene = scenes.first(where: { $0.name == "星屿冥想" }) ?? scenes[2]
            }
        }

        let duration = assessment.intensity >= 8 ? chosenScene.durationMinutes + 3 : chosenScene.durationMinutes
        let functionalGoal = max(assessment.functionalLimit.score + 1, 3)

        let reason = "\(assessment.conditionType.shortLabel) + \(assessment.painQuality.rawValue) + \(assessment.emotionState.rawValue) 的组合，适合先用 \(chosenScene.name) 做 \(duration) 分钟非药物辅助缓解。"
        let plan = "先完成 2 分钟安全锚点，随后进入 \(chosenScene.breathingPattern) 的沉浸节律，再在结束前记录功能性疼痛目标，目标是把活动能力提升到 \(functionalGoal) 级。"
        let expected = "预计本次疗程可把主观疼痛从 \(Int(assessment.intensity)) 分辅助拉低约 \(String(format: "%.1f", assessment.conditionType.recommendedRelief)) 分，并降低呼吸紊乱与紧张感。"
        let safety: String

        if assessment.intensity >= 9 {
            safety = "当前疼痛极高，建议把本功能作为辅助工具，并同步联系医生评估是否需要进一步镇痛处理。"
        } else if assessment.conditionType == .labor {
            safety = "分娩模式为陪伴式辅助引导，不替代助产团队判断；宫缩异常或胎心异常时需立即转交医护。"
        } else {
            safety = "本方案属于非药物辅助工具，若疼痛持续恶化、伴发热或呼吸困难，请尽快联系医生。"
        }

        return TherapyRecommendation(
            scene: chosenScene,
            reason: reason,
            sessionPlan: plan,
            expectedOutcome: expected,
            safetyNote: safety
        )
    }
}
