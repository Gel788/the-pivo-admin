import SwiftUI

struct OrderCard: View {
    let order: AppModels.Order
    @StateObject private var restaurantService = RestaurantService()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Заказ #\(order.id)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(AppTheme.Colors.gold)
                
                Spacer()
                
                Text(statusText)
                    .font(.system(size: 14))
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(statusColor.opacity(0.2))
                    .cornerRadius(15)
            }
            
            Text(restaurantName)
                .font(.system(size: 16))
                .foregroundColor(AppTheme.Colors.lightBeige)
            
            Text("Дата: \(formatDate(order.date))")
                .font(.system(size: 14))
                .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
            
            if !order.items.isEmpty {
                Text("Позиции:")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.Colors.gold)
                
                ForEach(order.items, id: \.id) { item in
                    HStack {
                        Text(item.menuItem.name)
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.Colors.lightBeige)
                        
                        Spacer()
                        
                        Text("\(item.quantity) шт.")
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
                    }
                }
            }
            
            HStack {
                Text("Итого:")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(AppTheme.Colors.gold)
                
                Spacer()
                
                Text("\(order.totalAmount, specifier: "%.2f") ₽")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(AppTheme.Colors.gold)
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var restaurantName: String {
        restaurantService.restaurants.first(where: { $0.id == order.restaurantId })?.name ?? "Ресторан"
    }
    
    private var statusText: String {
        switch order.status {
        case .pending:
            return "Ожидает подтверждения"
        case .confirmed:
            return "Подтвержден"
        case .completed:
            return "Завершен"
        case .cancelled:
            return "Отменен"
        case .inProgress:
            return "В процессе"
        case .readyForPickup:
            return "Готов к выдаче"
        case .preparing:
            return "Готовится"
        case .ready:
            return "Готов"
        case .delivered:
            return "Доставлен"
        }
    }
    
    private var statusColor: Color {
        switch order.status {
        case .pending:
            return .orange
        case .confirmed:
            return .green
        case .completed:
            return .blue
        case .cancelled:
            return .red
        case .inProgress:
            return .purple
        case .readyForPickup:
            return .green
        case .preparing:
            return .blue
        case .ready:
            return .green
        case .delivered:
            return .purple
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
} 