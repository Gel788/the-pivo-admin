// Фильтры по типу заказа (если такие есть)
/*
Button(action: {
    filterType = .delivery
}) {
    Text("Доставка")
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(filterType == .delivery ? AppTheme.Colors.gold : Color.black.opacity(0.7))
        .foregroundColor(filterType == .delivery ? .black : AppTheme.Colors.lightBeige)
        .cornerRadius(20)
}
*/

// В карточке заказа (OrderCard):
// Удаляю label или иконку доставки
/*
if order.deliveryMethod == .delivery {
    Image(systemName: "bicycle")
        .foregroundColor(AppTheme.Colors.gold)
}
*/

import SwiftUI

struct OrdersListView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var orderViewModel = OrderViewModel()
    @State private var selectedTab = 0
    
    // Вспомогательные функции для проверки статусов
    private func isActiveOrder(_ order: AppModels.Order) -> Bool {
        switch order.status {
        case .pending, .confirmed, .preparing:
            return true
        default:
            return false
        }
    }
    
    private func isCompletedOrder(_ order: AppModels.Order) -> Bool {
        switch order.status {
        case .completed, .cancelled:
            return true
        default:
            return false
        }
    }
    
    // Вычисляемые свойства для фильтрации
    private var activeOrders: [AppModels.Order] {
        orderViewModel.orders.filter(isActiveOrder)
    }
    
    private var completedOrders: [AppModels.Order] {
        orderViewModel.orders.filter(isCompletedOrder)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Переключатель табов
            HStack(spacing: 0) {
                ForEach(["Активные", "История"], id: \.self) { tab in
                    Button(action: {
                        withAnimation {
                            selectedTab = tab == "Активные" ? 0 : 1
                        }
                    }) {
                        VStack(spacing: 8) {
                            Text(tab)
                                .font(.headline)
                                .foregroundColor(selectedTab == (tab == "Активные" ? 0 : 1) ? AppTheme.Colors.gold : AppTheme.Colors.lightBeige.opacity(0.7))
                            
                            Rectangle()
                                .fill(selectedTab == (tab == "Активные" ? 0 : 1) ? AppTheme.Colors.gold : Color.clear)
                                .frame(height: 3)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            // Содержимое таба
            if selectedTab == 0 {
                activeOrdersView
            } else {
                orderHistoryView
            }
        }
        .navigationTitle("Мои заказы")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var activeOrdersView: some View {
        ScrollView {
            VStack(spacing: 20) {
                if activeOrders.isEmpty {
                    VStack(spacing: 15) {
                        Image(systemName: "bag")
                            .font(.system(size: 50))
                            .foregroundColor(AppTheme.Colors.gold.opacity(0.7))
                        
                        Text("У вас нет активных заказов")
                            .font(.headline)
                            .foregroundColor(AppTheme.Colors.lightBeige)
                        
                        NavigationLink(destination: RestaurantsListView()) {
                            Text("Перейти к ресторанам")
                                .fontWeight(.medium)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(AppTheme.Colors.gold)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.top, 50)
                } else {
                    ForEach(activeOrders) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            OrderCard(order: order)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }
    
    private var orderHistoryView: some View {
        ScrollView {
            VStack(spacing: 20) {
                if completedOrders.isEmpty {
                    VStack(spacing: 15) {
                        Image(systemName: "clock")
                            .font(.system(size: 50))
                            .foregroundColor(AppTheme.Colors.gold.opacity(0.7))
                        
                        Text("История заказов пуста")
                            .font(.headline)
                            .foregroundColor(AppTheme.Colors.lightBeige)
                    }
                    .padding(.top, 50)
                } else {
                    ForEach(completedOrders) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            OrderCard(order: order)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

struct OrdersListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrdersListView()
                .environmentObject(AppState())
                .preferredColorScheme(.dark)
        }
    }
} 