import SwiftUI

@main
struct CatchThemApp: App {
    @State var ud = UserDefaultsManager()

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    ud.checkAndSetFirstLaunch()
                    ud.restoreEnergyIfNeeded()
                }
        }
    }
}

import SwiftUI

enum Screen {
    case home
    case catchGame
    case runGame
}

@MainActor
class Router: ObservableObject {
    @Published var currentScreen: Screen = .home

    func goToCatchGame() {
        currentScreen = .catchGame
    }

    func goToRunGame() {
        currentScreen = .runGame
    }

    func pop() {
        currentScreen = .home
    }
}

struct ContentView: View {
    @StateObject private var router = Router()
    @StateObject var dailyRewardModel = DailyRewardViewModel()
    
    var body: some View {
        NavigationStack {
            switch router.currentScreen {
            case .home:
                MainView()
                    .environmentObject(router)
                    .environmentObject(dailyRewardModel)
            case .catchGame:
                TrialsSetupView()
                    .environmentObject(router)
            case .runGame:
                RunGameView()
                    .environmentObject(router)
            }
        }
    }
}

#Preview {
    ContentView()
}
