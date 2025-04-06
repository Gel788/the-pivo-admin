import Foundation
import SwiftUI

// Модель элемента корзины
struct SimpleCartItem: Identifiable {
    let id: String
    let menuItemId: String
    let name: String
    let price: Double
    var quantity: Int
    
    var totalPrice: Double {
        price * Double(quantity)
    }
}

// Модель корзины
class CartModel {
    var items: [SimpleCartItem] = []
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    func addItem(menuItem: AppModels.MenuItem) {
        if let index = items.firstIndex(where: { $0.menuItemId == menuItem.id }) {
            items[index].quantity += 1
        } else {
            let newItem = SimpleCartItem(
                id: UUID().uuidString,
                menuItemId: menuItem.id,
                name: menuItem.name,
                price: menuItem.price,
                quantity: 1
            )
            items.append(newItem)
        }
    }
    
    func removeItem(id: String) {
        items.removeAll { $0.menuItemId == id }
    }
    
    func clearCart() {
        items.removeAll()
    }
} 