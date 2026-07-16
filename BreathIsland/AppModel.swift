import Foundation

@MainActor
final class AppModel: ObservableObject {
    enum ImmersiveState {
        case closed
        case transitioning
        case open
    }

    let immersiveSpaceID = "BreathIslandTherapySpace"
    @Published var immersiveSpaceState: ImmersiveState = .closed
}
