import RealityKit
import SwiftUI

struct ImmersiveTherapyView: View {
    @EnvironmentObject private var store: DemoStore
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        RealityView { content, attachments in
            let therapyRoot = buildImmersiveCluster()
            content.add(therapyRoot)

            if let hud = attachments.entity(for: "therapyHUD") {
                hud.position = [-0.34, 1.48, -1.02]
                content.add(hud)
            }
            if let progress = attachments.entity(for: "progressHUD") {
                progress.position = [0.40, 1.18, -1.10]
                content.add(progress)
            }
        } update: { content, attachments in
            if let hud = attachments.entity(for: "therapyHUD") {
                hud.position = [-0.34, 1.48, -1.02]
                if hud.parent == nil {
                    content.add(hud)
                }
            }
            if let progress = attachments.entity(for: "progressHUD") {
                progress.position = [0.40, 1.18, -1.10]
                if progress.parent == nil {
                    content.add(progress)
                }
            }
        } attachments: {
            Attachment(id: "therapyHUD") {
                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        SectionEyebrow(text: "沉浸疗程")

                        Text(store.activeSession?.scene.name ?? store.latestRecommendation.scene.name)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white)
                        Text("Vision Pro 主治疗空间已建立空间锚点")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(AppTheme.moon)
                        Text(store.latestRecommendation.sessionPlan)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.76))

                        HStack(spacing: 10) {
                            StatusPill(text: store.latestRecommendation.scene.visualTheme, color: AppTheme.sceneAccent(for: store.latestRecommendation.scene))
                            StatusPill(text: store.latestRecommendation.scene.breathingPattern, color: AppTheme.aqua)
                        }
                    }
                    .frame(width: 420)
                }
            }

            Attachment(id: "progressHUD") {
                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        SectionEyebrow(text: "阶段同步")

                        Text(store.activeSession?.currentStage ?? "等待启动")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white)

                        if let activeSession = store.activeSession {
                            ProgressView(value: activeSession.progress)
                                .tint(AppTheme.aqua)
                            Text(activeSession.note)
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.white.opacity(0.76))
                        } else {
                            Text("从主窗口启动疗程后，这里会显示阶段推进、呼吸节律和收束提醒。")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.white.opacity(0.76))
                        }

                        Text(appModel.immersiveSpaceState == .open ? "沉浸空间已开启" : "沉浸空间待机")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.moon)
                    }
                    .frame(width: 320)
                }
            }
        }
    }

    private func buildImmersiveCluster() -> Entity {
        let scene = store.activeSession?.scene ?? store.latestRecommendation.scene
        let colors = immersivePalette(for: scene)
        let root = Entity()
        root.name = "therapyRoot"
        root.position = [0, 1.18, -1.55]

        let fieldShell = makeSphere(
            radius: 0.34,
            color: colors.core.withAlphaComponent(0.84),
            metallic: false,
            position: [0, 0.10, 0]
        )
        root.addChild(fieldShell)

        let floorDeck = makeBox(
            size: [0.92, 0.03, 0.64],
            color: colors.support.withAlphaComponent(0.34),
            metallic: false,
            position: [0, -0.24, 0.02],
            cornerRadius: 0.10
        )
        root.addChild(floorDeck)

        let focusCore = makeSphere(
            radius: 0.11,
            color: colors.accent.withAlphaComponent(0.98),
            metallic: true,
            position: [0, 0.10, 0.02]
        )
        root.addChild(focusCore)

        let breathBeam = makeBox(
            size: [0.70, 0.018, 0.018],
            color: colors.glow.withAlphaComponent(0.88),
            metallic: false,
            position: [0, -0.02, 0.16],
            cornerRadius: 0.009
        )
        breathBeam.transform.rotation = simd_quatf(angle: .pi / 18, axis: [0, 0, 1])
        root.addChild(breathBeam)

        let beaconLeft = makeBox(
            size: [0.08, 0.08, 0.08],
            color: colors.support.withAlphaComponent(0.92),
            metallic: false,
            position: [-0.26, 0.28, -0.02],
            cornerRadius: 0.02
        )
        root.addChild(beaconLeft)

        let beaconRight = makeBox(
            size: [0.08, 0.08, 0.08],
            color: colors.accent.withAlphaComponent(0.92),
            metallic: false,
            position: [0.26, 0.26, 0],
            cornerRadius: 0.02
        )
        root.addChild(beaconRight)

        for index in 0..<8 {
            let angle = Float(index) / 8 * (.pi * 2)
            let node = makeSphere(
                radius: index.isMultiple(of: 2) ? 0.03 : 0.022,
                color: (index.isMultiple(of: 2) ? colors.accent : colors.support).withAlphaComponent(0.94),
                metallic: index.isMultiple(of: 2),
                position: [cos(angle) * 0.38, 0.04 + sin(angle) * 0.08, sin(angle) * 0.18]
            )
            root.addChild(node)
        }

        addSceneSignature(for: scene, colors: colors, to: root)
        return root
    }

    private func addSceneSignature(
        for scene: TherapyScene,
        colors: (core: UIColor, accent: UIColor, support: UIColor, glow: UIColor),
        to root: Entity
    ) {
        switch scene.name {
        case "冰火对抗":
            let coolArc = makeCylinder(
                height: 0.42,
                radius: 0.025,
                color: colors.support.withAlphaComponent(0.92),
                metallic: false,
                position: [-0.16, 0.02, -0.14]
            )
            coolArc.transform.rotation = simd_quatf(angle: .pi / 4, axis: [0, 0, 1])
            root.addChild(coolArc)

            let warmArc = makeCylinder(
                height: 0.46,
                radius: 0.03,
                color: colors.accent.withAlphaComponent(0.94),
                metallic: true,
                position: [0.18, 0.08, -0.12]
            )
            warmArc.transform.rotation = simd_quatf(angle: -.pi / 4.6, axis: [0, 0, 1])
            root.addChild(warmArc)

        case "海浪呼吸":
            for index in 0..<4 {
                let wave = makeBox(
                    size: [0.56 - Float(index) * 0.08, 0.018, 0.11],
                    color: (index.isMultiple(of: 2) ? colors.glow : colors.accent).withAlphaComponent(0.86),
                    metallic: false,
                    position: [0, -0.10 + Float(index) * 0.06, -0.18 + Float(index) * 0.03],
                    cornerRadius: 0.02
                )
                wave.transform.rotation = simd_quatf(angle: .pi / 40, axis: [0, 0, 1])
                root.addChild(wave)
            }

        default:
            for index in 0..<5 {
                let height: Float = 0.14 + Float(index) * 0.05
                let starPillar = makeCylinder(
                    height: height,
                    radius: 0.018,
                    color: (index.isMultiple(of: 2) ? colors.support : colors.accent).withAlphaComponent(0.92),
                    metallic: true,
                    position: [-0.18 + Float(index) * 0.09, -0.06 + height / 2, -0.16 + Float(index % 2) * 0.04]
                )
                root.addChild(starPillar)
            }
        }
    }

    private func makeSphere(radius: Float, color: UIColor, metallic: Bool, position: SIMD3<Float>) -> ModelEntity {
        let entity = ModelEntity(
            mesh: .generateSphere(radius: radius),
            materials: [SimpleMaterial(color: color, isMetallic: metallic)]
        )
        entity.position = position
        return entity
    }

    private func makeBox(
        size: SIMD3<Float>,
        color: UIColor,
        metallic: Bool,
        position: SIMD3<Float>,
        cornerRadius: Float
    ) -> ModelEntity {
        let entity = ModelEntity(
            mesh: .generateBox(size: size, cornerRadius: cornerRadius),
            materials: [SimpleMaterial(color: color, isMetallic: metallic)]
        )
        entity.position = position
        return entity
    }

    private func makeCylinder(
        height: Float,
        radius: Float,
        color: UIColor,
        metallic: Bool,
        position: SIMD3<Float>
    ) -> ModelEntity {
        let entity = ModelEntity(
            mesh: .generateCylinder(height: height, radius: radius),
            materials: [SimpleMaterial(color: color, isMetallic: metallic)]
        )
        entity.position = position
        return entity
    }

    private func immersivePalette(for scene: TherapyScene) -> (core: UIColor, accent: UIColor, support: UIColor, glow: UIColor) {
        switch scene.name {
        case "冰火对抗":
            return (
                core: UIColor(red: 0.08, green: 0.34, blue: 0.56, alpha: 1),
                accent: UIColor(red: 0.95, green: 0.47, blue: 0.35, alpha: 1),
                support: UIColor(red: 0.68, green: 0.88, blue: 0.98, alpha: 1),
                glow: UIColor(red: 0.78, green: 0.90, blue: 0.98, alpha: 1)
            )
        case "海浪呼吸":
            return (
                core: UIColor(red: 0.07, green: 0.26, blue: 0.56, alpha: 1),
                accent: UIColor(red: 0.15, green: 0.70, blue: 0.78, alpha: 1),
                support: UIColor(red: 0.62, green: 0.86, blue: 0.83, alpha: 1),
                glow: UIColor(red: 0.70, green: 0.91, blue: 0.95, alpha: 1)
            )
        default:
            return (
                core: UIColor(red: 0.11, green: 0.16, blue: 0.42, alpha: 1),
                accent: UIColor(red: 0.54, green: 0.53, blue: 0.92, alpha: 1),
                support: UIColor(red: 0.83, green: 0.89, blue: 0.98, alpha: 1),
                glow: UIColor(red: 0.72, green: 0.82, blue: 0.98, alpha: 1)
            )
        }
    }
}
