import SwiftUI

@main
struct BreathIslandCompanionApp: App {
    @StateObject private var store = DemoStore()
    var body: some Scene {
        WindowGroup { CompanionContentView().environmentObject(store) }
    }
}
