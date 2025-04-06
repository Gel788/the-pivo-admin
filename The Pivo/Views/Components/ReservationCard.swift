import SwiftUI

struct ReservationCard: View {
    let reservation: AppModels.Reservation
    @StateObject private var restaurantService = RestaurantService()
    @EnvironmentObject var reservationService: ReservationService
    @EnvironmentObject var appState: AppState
    @State private var showingCancelAlert = false
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Бронирование #\(reservation.id)")
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
            
            Text("Дата: \(formatDate(reservation.date))")
                .font(.system(size: 14))
                .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
            
            Text("Время: \(reservation.time)")
                .font(.system(size: 14))
                .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
            
            Text("Количество гостей: \(reservation.numberOfGuests)")
                .font(.system(size: 14))
                .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
            
            if let specialRequests = reservation.specialRequests, !specialRequests.isEmpty {
                Text("Примечания: \(specialRequests)")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
            }
            
            if reservation.status == .pending || reservation.status == .confirmed {
                Button(action: {
                    showingCancelAlert = true
                }) {
                    Text("Отменить бронирование")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.red)
                        .padding(.top, 8)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: AppTheme.Colors.gold.opacity(0.2), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal)
        .opacity(isAnimating ? 0 : 1)
        .scaleEffect(isAnimating ? 0.8 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isAnimating)
        .alert("Отменить бронирование?", isPresented: $showingCancelAlert) {
            Button("Отмена", role: .cancel) { }
            Button("Отменить", role: .destructive) {
                withAnimation {
                    isAnimating = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    cancelReservation()
                }
            }
        } message: {
            Text("Вы уверены, что хотите отменить это бронирование?")
        }
    }
    
    private var restaurantName: String {
        restaurantService.restaurants.first(where: { $0.id == reservation.restaurantId })?.name ?? "Ресторан"
    }
    
    private var statusText: String {
        switch reservation.status {
        case .pending:
            return "Ожидает подтверждения"
        case .confirmed:
            return "Подтверждено"
        case .completed:
            return "Завершено"
        case .cancelled:
            return "Отменено"
        }
    }
    
    private var statusColor: Color {
        switch reservation.status {
        case .pending:
            return .orange
        case .confirmed:
            return .green
        case .completed:
            return .blue
        case .cancelled:
            return .red
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
    
    private func cancelReservation() {
        reservationService.cancelReservation(reservation)
    }
} 