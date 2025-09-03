import SwiftUI
import StoreKit

@MainActor
class ShopViewModel: ObservableObject {
    @Published var products: [Product] = []

    let productIDs = ["coins", "coins500", "coins1000", "energy5", "energy10", "energy15"]
    
    private var transactionListener: Task<Void, Never>? = nil
    
    init() {
        listenForTransactions()
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
