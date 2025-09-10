import SwiftUI
import StoreKit

@MainActor
class ShopViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var arrayOfBrids: [BitdType] = []
    @Published var arrayOfEggs: [EggType] = []
    @Published var showAlert = false
    
    private let birdsKey = "arrayOfBrids"
    let productIDs = ["coins", "coins500", "coins1000", "energy5", "energy10", "energy15"]
    
    private var transactionListener: Task<Void, Never>? = nil
    private let eggsKey = "arrayOfEggs"

    func saveEggs() {
        do {
            let data = try JSONEncoder().encode(arrayOfEggs)
            UserDefaults.standard.set(data, forKey: eggsKey)
        } catch {
            print("Failed to save eggs: \(error)")
        }
    }

    func unlockRandomEgg() {
        let lockedEggs = arrayOfEggs.filter { $0.isLocked }
        guard let randomEgg = lockedEggs.randomElement() else {
            print("Все яйца уже разблокированы")
            showAlert = true
            return
        }

        if let index = arrayOfEggs.firstIndex(where: { $0.id == randomEgg.id }) {
            arrayOfEggs[index].isLocked = false
            saveEggs()
            UserDefaultsManager().minusCoins(10000)
        }
    }
    
    func loadEggs() {
        guard let data = UserDefaults.standard.data(forKey: eggsKey) else {
            arrayOfEggs = [
                EggType(name: "Classic", imageName: "egg", isSelected: true, isLocked: false),
                EggType(name: "Red", imageName: "egg1"),
                EggType(name: "Orange", imageName: "egg4"),
                EggType(name: "Yellow", imageName: "egg7"),
                EggType(name: "Green", imageName: "egg10"),
                EggType(name: "Blue", imageName: "egg2"),
                EggType(name: "Dark Blue", imageName: "egg5"),
                EggType(name: "Purple", imageName: "egg8"),
                EggType(name: "Lilac", imageName: "egg11"),
                EggType(name: "Pink", imageName: "egg3"),
                EggType(name: "Brown", imageName: "egg6"),
                EggType(name: "White", imageName: "egg9")
            ]
            saveEggs()
            return
        }
        do {
            arrayOfEggs = try JSONDecoder().decode([EggType].self, from: data)
        } catch {
            print("Failed to load eggs: \(error)")
            loadEggs()
        }
    }

    func saveBirds() {
         do {
             let data = try JSONEncoder().encode(arrayOfBrids)
             UserDefaults.standard.set(data, forKey: birdsKey)
         } catch {
             print("Failed save birds: \(error)")
         }
     }

    func loadBirds() {
        guard let data = UserDefaults.standard.data(forKey: birdsKey) else {
            arrayOfBrids = [
                BitdType(name: "Classic", imageName: "chikenMove", isSelected: true, isLocked: false),
                BitdType(name: "Chicken", imageName: "chickenMove"),
                BitdType(name: "Turkey", imageName: "turkeyMove"),
                BitdType(name: "Parrot", imageName: "parrotMove"),
                BitdType(name: "Canary", imageName: "canaryMove"),
                BitdType(name: "Penguin", imageName: "penguinMove"),
                BitdType(name: "Flamingo", imageName: "flamingoMove"),
                BitdType(name: "Peacock", imageName: "peacockMove"),
                BitdType(name: "Toucan", imageName: "toucanMove"),
                BitdType(name: "Owl", imageName: "owlMove"),
                BitdType(name: "Pigeon", imageName: "pigeonMove"),
                BitdType(name: "Seagull", imageName: "seagullMove")
            ]
            saveBirds()
            return
        }
        do {
            let decoded = try JSONDecoder().decode([BitdType].self, from: data)
            arrayOfBrids = decoded
        } catch {
            print("Failed to load saved birds, using default. Error: \(error)")
            arrayOfBrids = [
                BitdType(name: "Classic", imageName: "chikenMove", isSelected: true, isLocked: false),
                BitdType(name: "Chicken", imageName: "chickenMove"),
                BitdType(name: "Turkey", imageName: "turkeyMove"),
                BitdType(name: "Parrot", imageName: "parrotMove"),
                BitdType(name: "Canary", imageName: "canaryMove"),
                BitdType(name: "Penguin", imageName: "penguinMove"),
                BitdType(name: "Flamingo", imageName: "flamingoMove"),
                BitdType(name: "Peacock", imageName: "peacockMove"),
                BitdType(name: "Toucan", imageName: "toucanMove"),
                BitdType(name: "Owl", imageName: "owlMove"),
                BitdType(name: "Pigeon", imageName: "pigeonMove"),
                BitdType(name: "Seagull", imageName: "seagullMove")
            ]
            saveBirds()
        }
    }

    init() {
        listenForTransactions()
        loadBirds()
        loadEggs()
    }
    
    func selectEgg(at index: Int) {
        guard arrayOfEggs.indices.contains(index) else { return }

        for i in arrayOfEggs.indices {
            arrayOfEggs[i].isSelected = false
        }
        arrayOfEggs[index].isSelected = true

        saveEggs()
        print("Выбрано яйцо: \(arrayOfEggs[index].name)")
    }
    
    func selectBird(at index: Int) {
        guard arrayOfBrids.indices.contains(index) else { return }
        for i in arrayOfBrids.indices {
            arrayOfBrids[i].isSelected = false
        }
        arrayOfBrids[index].isSelected = true
        saveBirds()
    }

    
    func unlockRandomBird() {
        let lockedBirds = arrayOfBrids.filter { $0.isLocked }
        guard let randomBird = lockedBirds.randomElement() else {
            print("Все птицы уже разблокированы")
            showAlert = true
            return
        }
   
        if let index = arrayOfBrids.firstIndex(where: { $0.id == randomBird.id }) {
            arrayOfBrids[index].isLocked = false
            saveBirds()
            UserDefaultsManager().minusCoins(100000)
        }
    }
    
    func loadProducts() {
        Task {
            do {
                products = try await Product.products(for: productIDs)
                print("Загруженные продукты:")
                for product in products {
                    print("- id: \(product.id), название: \(product.displayName), цена: \(product.displayPrice)")
                }
            } catch {
                print("Ошибка загрузки продуктов: \(error)")
                products = []
            }
        }
    }
    
    func buyProduct(id: String) {
        guard let product = products.first(where: { $0.id == id }) else {
            print("Продукт не найден")
            return
        }
        Task {
            do {
                let result = try await product.purchase()
                switch result {
                case .success(let verification):
                    let transaction = try verification.payloadValue
                    await transaction.finish()
                    print("Покупка успешна: \(product.id)")

                    if id == "coins" {
                        UserDefaultsManager().addCoins(100)
                    } else if id == "coins500" {
                        UserDefaultsManager().addCoins(500)
                    } else if id == "coins1000" {
                        UserDefaultsManager().addCoins(1000)
                    } else if id == "energy5" {
                        UserDefaultsManager().addEnergy(5)
                    } else if id == "energy10" {
                        UserDefaultsManager().addEnergy(10)
                    } else if id == "energy15" {
                        UserDefaultsManager().addEnergy(15)
                    }
                    NotificationCenter.default.post(name: Notification.Name("UserResourcesUpdated"), object: nil)
                case .userCancelled, .pending:
                    print("Покупка отменена или в ожидании")
                @unknown default:
                    print("Неизвестный результат покупки")
                }
            } catch {
                print("Ошибка покупки: \(error)")
            }
        }
    }

    
    private func listenForTransactions() {
        transactionListener = Task {
            for await result in Transaction.updates {
                do {
                    let transaction = try result.payloadValue
                    await transaction.finish()
                    print("Обновление транзакции для продукта: \(transaction.productID)")
                } catch {
                    print("Транзакция не прошла проверку, игнорируем: \(error)")
                }
            }
        }
    }
    
    deinit {
        transactionListener?.cancel()
    }
}
