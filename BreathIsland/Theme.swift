import SwiftUI

enum AppTheme {
    static let midnight = Color(red: 0.02, green: 0.06, blue: 0.12)
    static let deepSea = Color(red: 0.04, green: 0.10, blue: 0.18)
    static let trench = Color(red: 0.05, green: 0.17, blue: 0.31)
    static let lagoon = Color(red: 0.10, green: 0.33, blue: 0.45)
    static let steel = Color(red: 0.14, green: 0.20, blue: 0.31)
    static let seaFog = Color(red: 0.90, green: 0.95, blue: 0.97)
    static let moon = Color(red: 0.79, green: 0.89, blue: 0.95)
    static let aqua = Color(red: 0.17, green: 0.59, blue: 0.74)
    static let coral = Color(red: 0.96, green: 0.52, blue: 0.42)
    static let mint = Color(red: 0.61, green: 0.84, blue: 0.78)
    static let shellStroke = Color.white.opacity(0.16)

    static let pageGradient = LinearGradient(
        colors: [midnight, deepSea, trench, lagoon],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let railGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.16),
            Color.white.opacity(0.06)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardGradient = LinearGradient(
        colors: [
            midnight.opacity(0.62),
            trench.opacity(0.42),
            moon.opacity(0.08)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let viewportGradient = LinearGradient(
        colors: [
            midnight.opacity(0.54),
            trench.opacity(0.30),
            moon.opacity(0.06)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let insetGradient = LinearGradient(
        colors: [
            midnight.opacity(0.72),
            steel.opacity(0.42)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let heroGradient = LinearGradient(
        colors: [
            Color.black.opacity(0.34),
            deepSea.opacity(0.12),
            Color.clear
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static func sceneGradient(for scene: TherapyScene) -> LinearGradient {
        switch scene.name {
        case "冰火对抗":
            return LinearGradient(
                colors: [Color(red: 0.20, green: 0.58, blue: 0.88), Color(red: 0.94, green: 0.47, blue: 0.35)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "海浪呼吸":
            return LinearGradient(
                colors: [Color(red: 0.15, green: 0.70, blue: 0.78), Color(red: 0.09, green: 0.32, blue: 0.72)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                colors: [Color(red: 0.39, green: 0.43, blue: 0.85), Color(red: 0.14, green: 0.21, blue: 0.49)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    static func sceneAccent(for scene: TherapyScene) -> Color {
        switch scene.name {
        case "冰火对抗":
            return coral
        case "海浪呼吸":
            return aqua
        default:
            return moon
        }
    }
}

struct GlassCard<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(AppTheme.cardGradient)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.08), Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
            }
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(AppTheme.shellStroke, lineWidth: 1)
            )
            .shadow(color: AppTheme.deepSea.opacity(0.22), radius: 26, x: 0, y: 12)
    }
}

struct SurfaceViewport<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            OceanAtmosphere()
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))

            content
        }
            .background {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(AppTheme.viewportGradient)
                    )
            }
            .overlay(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(AppTheme.shellStroke, lineWidth: 1)
            )
            .shadow(color: AppTheme.deepSea.opacity(0.22), radius: 34, x: 0, y: 18)
    }
}

struct OceanAtmosphere: View {
    @State private var drifting = false

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Image("OceanSanctuary")
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .scaleEffect(drifting ? 1.08 : 1.0)
                    .offset(x: drifting ? -18 : 18, y: drifting ? -8 : 10)
                    .overlay(Color.black.opacity(0.40))

                LinearGradient(
                    colors: [AppTheme.midnight.opacity(0.58), Color.clear, AppTheme.midnight.opacity(0.24)],
                    startPoint: .leading,
                    endPoint: .trailing
                )

                Ellipse()
                    .fill(AppTheme.aqua.opacity(0.16))
                    .frame(width: proxy.size.width * 0.66, height: proxy.size.height * 0.24)
                    .blur(radius: 42)
                    .offset(x: drifting ? proxy.size.width * 0.20 : proxy.size.width * 0.05, y: drifting ? -proxy.size.height * 0.22 : -proxy.size.height * 0.16)
            }
        }
        .allowsHitTesting(false)
        .onAppear {
            withAnimation(.easeInOut(duration: 12).repeatForever(autoreverses: true)) {
                drifting = true
            }
        }
    }
}

struct BreathingHalo: View {
    let color: Color
    var diameter: CGFloat = 180
    @State private var inhaling = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(inhaling ? 0.52 : 0.16), lineWidth: inhaling ? 2 : 1)
                .frame(width: diameter, height: diameter)
                .scaleEffect(inhaling ? 1.18 : 0.82)

            Circle()
                .fill(color.opacity(inhaling ? 0.16 : 0.05))
                .frame(width: diameter * 0.56, height: diameter * 0.56)
                .blur(radius: 10)
                .scaleEffect(inhaling ? 1.22 : 0.78)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 4.6).repeatForever(autoreverses: true)) {
                inhaling = true
            }
        }
    }
}

struct InsetPanel<Content: View>: View {
    private let content: Content
    private let cornerRadius: CGFloat

    init(cornerRadius: CGFloat = 20, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(AppTheme.insetGradient)
            }
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
    }
}

struct MetricBadge: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.74))
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(AppTheme.insetGradient, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

struct PrimaryActionStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [AppTheme.aqua, AppTheme.coral],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.34), Color.clear, Color.white.opacity(0.08)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(configuration.isPressed ? 0.40 : 0.20), lineWidth: 1)
            )
            .shadow(color: AppTheme.aqua.opacity(configuration.isPressed ? 0.12 : 0.42), radius: configuration.isPressed ? 5 : 16, x: 0, y: configuration.isPressed ? 2 : 7)
            .scaleEffect(configuration.isPressed ? 0.965 : 1.0)
            .offset(y: configuration.isPressed ? 2 : 0)
            .hoverEffect(.lift)
            .animation(.spring(response: 0.25, dampingFraction: 0.70), value: configuration.isPressed)
    }
}

struct SecondaryActionStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white.opacity(configuration.isPressed ? 0.20 : 0.10))
                    .overlay(
                        LinearGradient(
                            colors: [Color.white.opacity(0.12), Color.clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(configuration.isPressed ? 0.30 : 0.16), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0.08 : 0.20), radius: configuration.isPressed ? 4 : 10, x: 0, y: configuration.isPressed ? 2 : 5)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .offset(y: configuration.isPressed ? 2 : 0)
            .hoverEffect(.highlight)
            .animation(.spring(response: 0.25, dampingFraction: 0.72), value: configuration.isPressed)
    }
}

struct RailButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.975 : (isSelected ? 1.0 : 0.99))
            .offset(x: configuration.isPressed ? 2 : 0, y: configuration.isPressed ? 1 : 0)
            .shadow(color: isSelected ? AppTheme.aqua.opacity(0.28) : Color.clear, radius: 12, x: 0, y: 5)
            .hoverEffect(.highlight)
            .animation(.spring(response: 0.28, dampingFraction: 0.72), value: configuration.isPressed)
            .animation(.spring(response: 0.35, dampingFraction: 0.76), value: isSelected)
    }
}

struct ChipButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .opacity(configuration.isPressed ? 0.84 : 1.0)
            .hoverEffect(.highlight)
            .animation(.spring(response: 0.22, dampingFraction: 0.66), value: configuration.isPressed)
    }
}

struct SecondaryChip: View {
    let text: String
    let selected: Bool

    private var fillStyle: AnyShapeStyle {
        if selected {
            AnyShapeStyle(
                LinearGradient(
                    colors: [AppTheme.aqua, AppTheme.mint],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
        } else {
            AnyShapeStyle(
                LinearGradient(
                    colors: [Color.white.opacity(0.92), Color.white.opacity(0.86)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }

    var body: some View {
        Text(text)
            .font(.system(size: 13, weight: .semibold, design: .rounded))
            .foregroundStyle(selected ? Color.white : AppTheme.deepSea)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(fillStyle, in: Capsule())
            .overlay(Capsule().stroke(Color.white.opacity(0.55), lineWidth: 1))
    }
}

struct StatusPill: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .foregroundStyle(Color.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(color.opacity(0.85), in: Capsule())
            .overlay(Capsule().stroke(Color.white.opacity(0.20), lineWidth: 1))
            .shadow(color: color.opacity(0.30), radius: 8, x: 0, y: 4)
    }
}

struct SectionEyebrow: View {
    let text: String

    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 11, weight: .bold, design: .rounded))
            .tracking(1.2)
            .foregroundStyle(AppTheme.moon)
    }
}

struct SceneSignatureView: View {
    let scene: TherapyScene
    var compact = false
    @State private var floating = false

    private var palette: (accent: Color, support: Color, glow: Color) {
        switch scene.name {
        case "冰火对抗":
            return (accent: AppTheme.coral, support: AppTheme.aqua, glow: AppTheme.moon)
        case "海浪呼吸":
            return (accent: AppTheme.aqua, support: AppTheme.mint, glow: AppTheme.moon)
        default:
            return (accent: Color(red: 0.62, green: 0.58, blue: 0.94), support: AppTheme.moon, glow: AppTheme.mint)
        }
    }

    var body: some View {
        ZStack {
            AppTheme.sceneGradient(for: scene)

            LinearGradient(
                colors: [Color.black.opacity(0.16), Color.clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(palette.glow.opacity(compact ? 0.16 : 0.20))
                .frame(width: compact ? 120 : 180)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )

            BreathingHalo(color: palette.glow, diameter: compact ? 102 : 154)

            sceneOverlay

            VStack {
                Spacer()

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(scene.visualTheme)
                            .font(.system(size: compact ? 11 : 12, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.94))
                        Text(scene.breathingPattern)
                            .font(.system(size: compact ? 10 : 11, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.74))
                            .lineLimit(1)
                    }

                    Spacer()

                    Image(systemName: scene.icon)
                        .font(.system(size: compact ? 18 : 22, weight: .semibold))
                        .foregroundStyle(Color.white.opacity(0.86))
                }
                .padding(compact ? 14 : 16)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.10), lineWidth: 1)
        )
        .onAppear {
            withAnimation(.easeInOut(duration: scene.name == "海浪呼吸" ? 4.6 : 5.8).repeatForever(autoreverses: true)) {
                floating = true
            }
        }
    }

    @ViewBuilder
    private var sceneOverlay: some View {
        switch scene.name {
        case "冰火对抗":
            HStack(spacing: compact ? 22 : 32) {
                Circle()
                    .fill(palette.support.opacity(0.84))
                    .frame(width: compact ? 44 : 58, height: compact ? 44 : 58)
                    .overlay(Circle().stroke(Color.white.opacity(0.18), lineWidth: 1))
                Circle()
                    .fill(palette.accent.opacity(0.84))
                    .frame(width: compact ? 62 : 84, height: compact ? 62 : 84)
                    .overlay(Circle().stroke(Color.white.opacity(0.18), lineWidth: 1))
            }
            .rotationEffect(.degrees(-16))
            .offset(y: floating ? -8 : 8)

        case "海浪呼吸":
            VStack(spacing: compact ? 10 : 12) {
                ForEach(0..<4, id: \.self) { index in
                    Capsule()
                        .fill((index.isMultiple(of: 2) ? palette.glow : palette.accent).opacity(0.78))
                        .frame(width: compact ? 116 - CGFloat(index * 14) : 170 - CGFloat(index * 18), height: compact ? 12 : 16)
                        .offset(x: CGFloat(index % 2 == 0 ? -10 : 10))
                }
            }
            .rotationEffect(.degrees(-8))
            .offset(x: floating ? 13 : -13)

        default:
            ZStack {
                Circle()
                    .stroke(palette.support.opacity(0.28), lineWidth: compact ? 10 : 14)
                    .frame(width: compact ? 76 : 108, height: compact ? 76 : 108)

                ForEach(0..<6, id: \.self) { index in
                    Circle()
                        .fill((index.isMultiple(of: 2) ? palette.accent : palette.support).opacity(0.86))
                        .frame(width: compact ? 10 : 14, height: compact ? 10 : 14)
                        .offset(
                            x: cos(Double(index) / 6.0 * .pi * 2) * (compact ? 52 : 72),
                            y: sin(Double(index) / 6.0 * .pi * 2) * (compact ? 24 : 32)
                        )
                }
            }
            .rotationEffect(.degrees(floating ? 8 : -8))
        }
    }
}
