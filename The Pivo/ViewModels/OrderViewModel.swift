import Foundation
import SwiftUI

class OrderViewModel: ObservableObject {
    @Published var orders: [AppModels.Order] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let userDefaults = UserDefaults.standard
    private let ordersKey = "savedOrders"
    
    init() {
        loadOrders()
    }
    
    func createOrder(restaurantId: String, items: [AppModels.CartItem], totalAmount: Double, paymentMethod: AppModels.PaymentMethod) -> AppModels.Order {
        let order = AppModels.Order(
            restaurantId: restaurantId,
            items: items,
            totalAmount: totalAmount,
            paymentMethod: paymentMethod
        )
        
        orders.append(order)
        saveOrders()
        return order
    }
    
    func updateOrderStatus(_ order: AppModels.Order, status: AppModels.OrderStatus) -> AppModels.Order {
        if let index = orders.firstIndex(where: { $0.id == order.id }) {
            var updatedOrder = order
            updatedOrder.status = status
            orders[index] = updatedOrder
            saveOrders()
            return updatedOrder
        }
        return order
    }
    
    func cancelOrder(_ order: AppModels.Order) {
        if let index = orders.firstIndex(where: { $0.id == order.id }) {
            orders.remove(at: index)
            saveOrders()
        }
    }
    
    func getOrder(_ id: String) -> AppModels.Order? {
        return orders.first { $0.id == id }
    }
    
    func getOrdersByRestaurant(_ restaurantId: String) -> [AppModels.Order] {
        return orders.filter { $0.restaurantId == restaurantId }
    }
    
    func getActiveOrders() -> [AppModels.Order] {
        return orders.filter { $0.status != .cancelled }
    }
    
    func getCompletedOrders() -> [AppModels.Order] {
        return orders.filter { $0.status == .delivered }
    }
    
    private func loadOrders() {
        if let data = userDefaults.data(forKey: ordersKey),
           let decodedOrders = try? JSONDecoder().decode([AppModels.Order].self, from: data) {
            orders = decodedOrders
        }
    }
    
    private func saveOrders() {
        if let encoded = try? JSONEncoder().encode(orders) {
            userDefaults.set(encoded, forKey: ordersKey)
        }
    }
} 