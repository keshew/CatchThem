import SwiftUI

class DailyRewardViewModel: ObservableObject {
    @Published var rewards: [Reward] = [Reward(item: .coins, count: .ten), Reward(item: .energy, count: .one), Reward(item: .coins, count: .fifteen), Reward(item: .energy, count: .five),
                                                                Reward(item: .coins, count: .thirty), Reward(item: .energy, count: .one), Reward(item: .coins, count: .thirtyFive), Reward(item: .energy, count: .ten),
                                                                Reward(item: .coins, count: .forty), Reward(item: .energy, count: .fifteen), Reward(item: .coins, count: .eighty), Reward(item: .energy, count: .one),
                                                                Reward(item: .coins, count: .eightyFive), Reward(item: .energy, count: .twenty), Reward(item: .coins, count: .ninety), Reward(item: .energy, count: .twentyFive),
                                                                Reward(item: .coins, count: .oneHundredEighty), Reward(item: .energy, count: .one), Reward(item: .coins, count: .oneHundredEightyFive), Reward(item: .energy, count: .thirty)]
    
    private let gotKey = "gotRewards"
    private let lastRewardDateKey = "lastRewardDate"

    func daysPassedSinceLastReward() -> Int {
        if let lastDate = UserDefaults.standard.object(forKey: lastRewardDateKey) as? Date {
            return UserDefaultsManager().daysPassed(since: lastDate)
        }
        return 0
    }

    func updateLastRewardDate() {
        UserDefaults.standard.set(Date(), forKey: lastRewardDateKey)
    }

    init() {
        loadGotStatus()
    }
    
    func loadGotStatus() {
        if let data = UserDefaults.standard.data(forKey: gotKey),
           let savedStatus = try? JSONDecoder().decode([Bool].self, from: data),
           savedStatus.count == rewards.count {
            for (index, isGot) in savedStatus.enumerated() {
                rewards[index].isGot = isGot
            }
        }
    }
    
    func saveGotStatus() {
        let statusArray = rewards.map { $0.isGot }
        if let data = try? JSONEncoder().encode(statusArray) {
            UserDefaults.standard.set(data, forKey: gotKey)
        }
    }
    
    func getReward(at index: Int) {
        guard index < rewards.count && !rewards[index].isGot else { return }
        
        let reward = rewards[index]
        print("Бонус получен: \(reward.item) \(reward.count.rawValue)")
        
        switch reward.item {
        case .coins:
            UserDefaultsManager.shared.addCoins(Double(reward.count.rawValue))
        case .energy:
            UserDefaultsManager.shared.addEnergy(reward.count.rawValue)
        }
        
        updateLastRewardDate()
         rewards[index].isGot = true
         saveGotStatus()
        
        NotificationCenter.default.post(name: Notification.Name("UserResourcesUpdated"), object: nil)
    }

    func canClaimReward(at index: Int) -> Bool {
        return daysPassedSinceLastReward() >= index && !rewards[index].isGot
    }
}
