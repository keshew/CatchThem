import SwiftUI

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let lastVisitDateKey = "lastVisitDate"
    private let consecutiveDaysKey = "consecutiveDays"
    
  
}

import Foundation

extension UserDefaultsManager {
    func daysPassed(since date: Date) -> Int {
        let calendar = Calendar.current
        let startOfDay1 = calendar.startOfDay(for: date)
        let startOfDay2 = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: startOfDay1, to: startOfDay2)
        return components.day ?? 0
    }

    func updateLastVisitDate() {
        let calendar = Calendar.current
        let today = Date()
        let defaults = UserDefaults.standard

        if let lastVisit = defaults.object(forKey: lastVisitDateKey) as? Date,
           let consecutiveDays = defaults.object(forKey: consecutiveDaysKey) as? Int {
            if calendar.isDateInYesterday(lastVisit) {
                defaults.set(consecutiveDays + 1, forKey: consecutiveDaysKey)
            } else if !calendar.isDateInToday(lastVisit) {
                defaults.set(1, forKey: consecutiveDaysKey)
            }
        } else {
            defaults.set(1, forKey: consecutiveDaysKey)
        }

        defaults.set(today, forKey: lastVisitDateKey)
        defaults.synchronize()
    }

    func getConsecutiveDays() -> Int {
        return UserDefaults.standard.integer(forKey: consecutiveDaysKey)
    }
}

extension UserDefaultsManager {
    private var coinKey: String { "coin" }

    func getCoins() -> Double {
        return UserDefaults.standard.double(forKey: coinKey)
    }

    func addCoins(_ amount: Double) {
        guard amount > 0 else { return }
        let currentCoins = getCoins()
        let newTotal = currentCoins + amount
        UserDefaults.standard.set(newTotal, forKey: coinKey)
        UserDefaults.standard.synchronize()
    }
    func minusCoins(_ amount: Double) {
        guard amount > 0 else { return }
        let currentCoins = getCoins()
        let newTotal = currentCoins - amount
        UserDefaults.standard.set(newTotal, forKey: coinKey)
        UserDefaults.standard.synchronize()
    }
    func setCoins(_ amount: Double) {
        UserDefaults.standard.set(amount, forKey: coinKey)
        UserDefaults.standard.synchronize()
    }
}

extension UserDefaultsManager {
    private var isFirstLaunchKey: String { "isFirstLaunch" }

    func checkAndSetFirstLaunch() {
        let defaults = UserDefaults.standard
        let isFirstLaunch = !defaults.bool(forKey: isFirstLaunchKey)
        if isFirstLaunch {
            setCoins(222500)
            setEnergy(15)
            defaults.set(true, forKey: isFirstLaunchKey)
            defaults.synchronize()
        }
    }
}

extension UserDefaultsManager {
    private var energyKey: String { "energy" }

    func getEnergy() -> Int {
        return UserDefaults.standard.integer(forKey: energyKey)
    }

    func addEnergy(_ amount: Int) {
        guard amount > 0 else { return }
        let currentCoins = getEnergy()
        let newTotal = currentCoins + amount
        UserDefaults.standard.set(newTotal, forKey: energyKey)
        UserDefaults.standard.synchronize()
    }

    func minusEnergy(_ amount: Int) {
        guard amount > 0 else { return }
        let currentCoins = getEnergy()
        let newTotal = currentCoins - amount
        UserDefaults.standard.set(newTotal, forKey: energyKey)
        UserDefaults.standard.synchronize()
    }
    
    func setEnergy(_ amount: Int) {
        UserDefaults.standard.set(amount, forKey: energyKey)
        UserDefaults.standard.synchronize()
    }
}

extension UserDefaultsManager {
    private var lastEnergyUpdateKey: String { "lastEnergyUpdate" }
    private var maxEnergy: Int { 15 }

    func restoreEnergyIfNeeded() {
        let defaults = UserDefaults.standard
        let now = Date()

        let lastUpdate = defaults.object(forKey: lastEnergyUpdateKey) as? Date ?? now
        let elapsedHours = Int(now.timeIntervalSince(lastUpdate) / 3600)

        guard elapsedHours > 0 else { return }

        var currentEnergy = getEnergy()
        currentEnergy += elapsedHours
        if currentEnergy > maxEnergy {
            currentEnergy = maxEnergy
        }

        setEnergy(currentEnergy)
        defaults.set(now, forKey: lastEnergyUpdateKey)
        defaults.synchronize()
    }
}
