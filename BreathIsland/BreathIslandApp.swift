import SwiftUI

@main
struct BreathIslandApp: App {
    @StateObject private var store = DemoStore()
    @StateObject private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView(initialTab: launchTab)
                .environmentObject(store)
                .environmentObject(appModel)
        }
        .defaultSize(width: 1440, height: 960)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveTherapyView()
                .environmentObject(store)
                .environmentObject(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.full), in: .full)
    }

    private var launchTab: RootTab {
        let arguments = CommandLine.arguments
        guard let markerIndex = arguments.firstIndex(of: "--initial-tab"),
              arguments.indices.contains(arguments.index(after: markerIndex))
        else {
            return .dashboard
        }

        switch arguments[arguments.index(after: markerIndex)] {
        case "assessment":
            return .assessment
        case "therapy":
            return .therapy
        case "report":
            return .report
        default:
            return .dashboard
        }
    }
}
