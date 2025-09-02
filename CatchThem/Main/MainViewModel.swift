import SwiftUI

class MainViewModel: ObservableObject {
    @Published var currentIndex = 0
    @Published var ud = UserDefaultsManager()
    @Published var coins: Double = 0
    @Published var energy = 0
    
    init() {
        NotificationCenter.default.addObserver(forName: Notification.Name("UserResourcesUpdated"), object: nil, queue: .main) { _ in
            self.coins = UserDefaultsManager.shared.getCoins()
            self.energy = UserDefaultsManager.shared.getEnergy()
        }
    }
}
