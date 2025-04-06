import SwiftUI

struct OrderDetailView: View {
    let order: AppModels.Order
    @State private var showCancelAlert = false
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var appState: AppState
    @StateObject private var restaurantService = RestaurantService()
    @Binding var isPresented: Bool
    
    // Если isPresented не указан, используем Environment
    init(order: AppModels.Order, isPresented: Binding<Bool>? = nil) {
        self.order = order
        self._isPresented = isPresented ?? .constant(true)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Кнопка "Назад"
                Button(action: {
                    withAnimation {
                        isPresented = false
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Назад")
                    }
                    .foregroundColor(AppTheme.Colors.gold)
                    .padding(.bottom, 10)
                }
                
                // Заголовок с информацией о ресторане
                restaurantInfoSection
                
                // Статус заказа
                statusSection
                
                // Элементы заказа
                orderItemsSection
                
                // Итоговая информация
                totalSection
                
                // Кнопка отмены (только если заказ не завершен и не отменен)
                if canCancel {
                    Button(action: {
                        showCancelAlert = true
                    }) {
                        HStack {
                            Image(systemName: "xmark.circle")
                            Text("Отменить заказ")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.top, 10)
                }
            }
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("Детали заказа")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showCancelAlert) {
            Alert(
                title: Text("Отменить заказ?"),
                message: Text("Вы уверены, что хотите отменить этот заказ? Это действие нельзя отменить."),
                primaryButton: .destructive(Text("Отменить заказ")) {
                    appState.cancelOrder(order)
                    isPresented = false
                },
                secondaryButton: .cancel(Text("Назад"))
            )
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 100 {
                        withAnimation {
                            isPresented = false
                        }
                    }
                }
        )
    }
    
    private var restaurantInfoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            let restaurant = restaurantService.restaurants.first(where: { $0.id == order.restaurantId })
            
            Text(restaurant?.name ?? "Ресторан")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.Colors.gold)
            
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(AppTheme.Colors.gold)
                Text(restaurant?.address ?? "Адрес недоступен")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.Colors.lightBeige)
            }
            
            Text("Заказ №\(order.id.prefix(8))")
                .font(.caption)
                .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.7))
            
            Text("Создан: \(formattedDate(order.createdAt))")
                .font(.caption)
                .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.7))
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var statusSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Статус заказа:")
                    .font(.headline)
                    .foregroundColor(AppTheme.Colors.lightBeige)
                
                HStack {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 12, height: 12)
                    
                    Text(statusText)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(statusColor)
                }
            }
            
            Spacer()
            
            Image(systemName: statusIcon)
                .font(.title)
                .foregroundColor(statusColor)
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var orderItemsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Состав заказа")
                .font(.headline)
                .foregroundColor(AppTheme.Colors.gold)
            
            ForEach(order.items, id: \.id) { item in
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(item.menuItem.name)
                            .font(.headline)
                            .foregroundColor(AppTheme.Colors.lightBeige)
                        
                        Text(item.menuItem.description)
                            .font(.caption)
                            .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.7))
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        Text("\(item.quantity) шт.")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.Colors.lightBeige)
                        
                        Text("\(item.menuItem.price, specifier: "%.0f") ₽")
                            .font(.headline)
                            .foregroundColor(AppTheme.Colors.gold)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var totalSection: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Стоимость блюд:")
                    .foregroundColor(AppTheme.Colors.lightBeige)
                Spacer()
                Text("\(order.totalAmount, specifier: "%.0f") ₽")
                    .foregroundColor(AppTheme.Colors.lightBeige)
            }
            
            Divider()
                .background(AppTheme.Colors.gold.opacity(0.3))
            
            HStack {
                Text("Итого:")
                    .font(.headline)
                    .foregroundColor(AppTheme.Colors.lightBeige)
                Spacer()
                Text("\(order.totalAmount, specifier: "%.0f") ₽")
                    .font(.headline)
                    .foregroundColor(AppTheme.Colors.gold)
            }
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var statusText: String {
        switch order.status {
        case .pending:
            return "Ожидает подтверждения"
        case .confirmed:
            return "Подтвержден"
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
        case .completed:
            return "Завершен"
        case .cancelled:
            return "Отменен"
        }
    }
    
    private var statusColor: Color {
        switch order.status {
        case .pending:
            return .orange
        case .confirmed:
            return .blue
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
        case .completed:
            return .green
        case .cancelled:
            return .red
        }
    }
    
    private var statusIcon: String {
        switch order.status {
        case .pending:
            return "clock"
        case .confirmed:
            return "checkmark.circle"
        case .inProgress:
            return "arrow.triangle.2.circlepath"
        case .readyForPickup:
            return "bag.fill"
        case .preparing:
            return "flame"
        case .ready:
            return "bag.fill"
        case .delivered:
            return "checkmark.circle.fill"
        case .completed:
            return "checkmark.circle.fill"
        case .cancelled:
            return "xmark.circle.fill"
        }
    }
    
    private var canCancel: Bool {
        switch order.status {
        case .pending, .confirmed:
            return true
        case .inProgress, .readyForPickup, .preparing, .ready, .delivered, .completed, .cancelled:
            return false
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Создаем тестовый заказ
        let sampleOrder = AppModels.Order(
            id: "test-order-1",
            restaurantId: "restaurant1",
            items: [
                AppModels.CartItem(
                    menuItem: AppModels.MenuItem(
                        id: "menu1",
                        name: "Пиво светлое",
                        description: "Свежее светлое пиво",
                        price: 250,
                        imageURL: "",
                        category: .beer,
                        abv: 4.5,
                        ibu: 15
                    ),
                    quantity: 2
                )
            ],
            totalAmount: 500,
            date: Date(),
            createdAt: Date(),
            status: .pending,
            paymentMethod: AppModels.PaymentMethod(
                type: .creditCard,
                lastFourDigits: "1234",
                expiryDate: Date().addingTimeInterval(86400 * 365),
                isDefault: true
            )
        )
        
        return NavigationView {
            OrderDetailView(order: sampleOrder)
                .environmentObject(AppState())
        }
        .preferredColorScheme(.dark)
    }
} 