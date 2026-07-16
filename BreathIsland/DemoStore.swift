import Foundation

@MainActor
final class DemoStore: ObservableObject {
    @Published var currentAssessment: PainAssessment
    @Published var latestRecommendation: TherapyRecommendation
    @Published var activeSession: TherapySession?
    @Published var biofeedbackSamples: [BiofeedbackSample]
    @Published var latestReport: PatientReport
    @Published var companionMessages: [CompanionMessage]
    @Published var doctorInsights: [DoctorInsight]
    @Published var deviceStatus = DeviceStatus(phoneConnected: true, headsetConnected: true, wearableConnected: true)
    @Published var streakDays = 12
    @Published var completedSessions = 18
    @Published var lastPainDelta = 2.4

    let therapyScenes = TherapyScene.demoScenes

    init() {
        let assessment = PainAssessment(
            conditionType: .labor,
            painLocation: .pelvic,
            painQuality: .cramping,
            intensity: 7,
            frequency: "每 4-6 分钟一波",
            trigger: "宫缩进入活跃期，焦虑升高",
            emotionState: .anxious,
            functionalLimit: .basicMovement
        )
        let recommendation = RecommendationEngine.recommend(for: assessment, scenes: TherapyScene.demoScenes)
        let samples = DemoStore.seedSamples(for: assessment, recommendation: recommendation)

        let report = DemoStore.makeReport(
            assessment: assessment,
            recommendation: recommendation,
            samples: samples
        )
        let insights = DemoStore.makeDoctorInsights(
            assessment: assessment,
            recommendation: recommendation,
            report: report
        )

        self.currentAssessment = assessment
        self.latestRecommendation = recommendation
        self.biofeedbackSamples = samples
        self.companionMessages = DemoStore.seedMessages()
        self.latestReport = report
        self.doctorInsights = insights
    }

    func submitAssessment(_ assessment: PainAssessment) {
        currentAssessment = assessment
        latestRecommendation = RecommendationEngine.recommend(for: assessment, scenes: therapyScenes)
        latestReport = DemoStore.makeReport(
            assessment: assessment,
            recommendation: latestRecommendation,
            samples: biofeedbackSamples
        )
        doctorInsights = DemoStore.makeDoctorInsights(
            assessment: assessment,
            recommendation: latestRecommendation,
            report: latestReport
        )
    }

    func startTherapy(scene: TherapyScene) {
        activeSession = TherapySession(
            scene: scene,
            progress: 0.12,
            stageIndex: 0,
            note: "已建立沉浸锚点，准备同步呼吸节律。",
            startedAt: Date()
        )
        appendSample(label: "开始疗程", progress: 0.12)
    }

    func advanceTherapy() {
        guard var session = activeSession else { return }

        session.progress = min(session.progress + 0.28, 1.0)
        session.stageIndex = min(session.stageIndex + 1, session.stages.count - 1)

        switch session.currentStage {
        case "呼吸同步":
            session.note = "节律呼吸已稳定，心率开始缓慢下降。"
        case "认知转移":
            session.note = "沉浸意象接管注意力，主观疼痛开始松动。"
        case "沉浸收束":
            session.note = "准备结束疗程并生成反馈报告。"
        default:
            session.note = "正在建立安全锚点。"
        }

        activeSession = session
        appendSample(label: session.currentStage, progress: session.progress)

        if session.progress >= 1.0 {
            completeTherapy()
        }
    }

    func completeTherapy() {
        guard let session = activeSession else { return }

        appendSample(label: "疗程完成", progress: 1.0)
        completedSessions += 1
        streakDays += 1

        latestReport = DemoStore.makeReport(
            assessment: currentAssessment,
            recommendation: latestRecommendation,
            samples: biofeedbackSamples
        )
        doctorInsights = DemoStore.makeDoctorInsights(
            assessment: currentAssessment,
            recommendation: latestRecommendation,
            report: latestReport
        )
        lastPainDelta = max(1.0, currentAssessment.intensity - (biofeedbackSamples.last?.painAfter ?? currentAssessment.intensity))
        companionMessages.insert(
            CompanionMessage(sender: "陪伴者", role: "家属", message: "刚刚那一段你呼吸很稳，我们继续一起往下走。", mood: "稳定支持"),
            at: 0
        )
        activeSession = nil
        deviceStatus = DeviceStatus(phoneConnected: true, headsetConnected: true, wearableConnected: true)

        if session.scene.targetCondition == .labor {
            companionMessages.insert(
                CompanionMessage(sender: "助产陪伴", role: "陪产者", message: "波峰过去了，下一次我们继续跟着海浪放长呼气。", mood: "同步引导"),
                at: 0
            )
        }
    }

    private func appendSample(label: String, progress: Double) {
        let baseHeartRate = 96.0 - progress * 12.0
        let baseHRV = 22.0 + progress * 11.0
        let breathingRate = 18.0 - progress * 5.0
        let painAfter = max(1.0, currentAssessment.intensity - progress * currentAssessment.conditionType.recommendedRelief)

        let sample = BiofeedbackSample(
            heartRate: baseHeartRate,
            hrv: baseHRV,
            breathingRate: breathingRate,
            painBefore: currentAssessment.intensity,
            painAfter: painAfter,
            timestamp: Date().addingTimeInterval(Double(biofeedbackSamples.count) * 90.0),
            label: label
        )

        biofeedbackSamples.append(sample)
        if biofeedbackSamples.count > 12 {
            biofeedbackSamples.removeFirst()
        }
    }

    private static func seedSamples(for assessment: PainAssessment, recommendation: TherapyRecommendation) -> [BiofeedbackSample] {
        let now = Date()
        return [
            BiofeedbackSample(heartRate: 98, hrv: 20, breathingRate: 20, painBefore: assessment.intensity, painAfter: assessment.intensity, timestamp: now.addingTimeInterval(-360), label: "基线"),
            BiofeedbackSample(heartRate: 95, hrv: 24, breathingRate: 18, painBefore: assessment.intensity, painAfter: assessment.intensity - 0.6, timestamp: now.addingTimeInterval(-270), label: "进入场景"),
            BiofeedbackSample(heartRate: 91, hrv: 27, breathingRate: 16, painBefore: assessment.intensity, painAfter: assessment.intensity - 1.1, timestamp: now.addingTimeInterval(-180), label: "呼吸同步"),
            BiofeedbackSample(heartRate: 87, hrv: 30, breathingRate: 15, painBefore: assessment.intensity, painAfter: assessment.intensity - 1.8, timestamp: now.addingTimeInterval(-90), label: "认知转移"),
            BiofeedbackSample(heartRate: 84, hrv: 33, breathingRate: 14, painBefore: assessment.intensity, painAfter: assessment.intensity - recommendation.scene.targetCondition.recommendedRelief, timestamp: now, label: "结束"),
        ]
    }

    private static func seedMessages() -> [CompanionMessage] {
        [
            CompanionMessage(sender: "林医生", role: "医生", message: "今天先以 10-12 分钟节律型疗程为主，结束后重点看呼吸是否放慢。", mood: "医疗建议"),
            CompanionMessage(sender: "妈妈", role: "家属", message: "你每次把呼气放长一点，身体都会更松一点，我一直在。", mood: "温暖陪伴"),
            CompanionMessage(sender: "护理站", role: "医护", message: "若疼痛持续升高或出现眩晕，请立即切回人工处理。", mood: "风险提醒")
        ]
    }

    private static func makeReport(
        assessment: PainAssessment,
        recommendation: TherapyRecommendation,
        samples: [BiofeedbackSample]
    ) -> PatientReport {
        let finalPain = samples.last?.painAfter ?? assessment.intensity
        let summary = "本次 \(recommendation.scene.name) 疗程后，主观疼痛由 \(Int(assessment.intensity)) 分辅助下降到约 \(String(format: "%.1f", finalPain)) 分，呼吸频率与 HRV 呈改善趋势。"
        let notes = "建议继续以 \(recommendation.scene.breathingPattern) 为主节律，若下次治疗前疼痛仍高于 8 分，应与医生同步调整镇痛方案。"
        let nextStep = "下一步建议：在下一次高峰疼痛前 5 分钟启动疗程，并把目标从“止痛”改成“恢复 \(assessment.functionalLimit.score + 1) 级功能活动”。"

        return PatientReport(
            assessment: assessment,
            recommendation: recommendation,
            biofeedback: samples,
            summary: summary,
            doctorNotes: notes,
            nextStep: nextStep
        )
    }

    private static func makeDoctorInsights(
        assessment: PainAssessment,
        recommendation: TherapyRecommendation,
        report: PatientReport
    ) -> [DoctorInsight] {
        let painAfter = report.biofeedback.last?.painAfter ?? assessment.intensity

        return [
            DoctorInsight(
                title: "依从性",
                detail: "最近 7 天完成 \(Int.random(in: 4...6)) 次计划疗程，完成率维持在 82% 左右。",
                level: .stable
            ),
            DoctorInsight(
                title: "风险提示",
                detail: assessment.intensity >= 8 ? "当前起始疼痛较高，建议把数字疗法与临床镇痛评估并行。" : "目前可继续居家辅助训练，重点关注疼痛峰值前启动时机。",
                level: assessment.intensity >= 8 ? .priority : .watch
            ),
            DoctorInsight(
                title: "下次建议",
                detail: "优先推荐 \(recommendation.scene.name)，目标把疗程后疼痛稳定在 \(String(format: "%.1f", painAfter)) 分以下。",
                level: .stable
            )
        ]
    }
}
