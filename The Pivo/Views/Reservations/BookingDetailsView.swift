import SwiftUI

struct BookingDetailsView: View {
    let reservation: AppModels.Reservation
    @StateObject private var viewModel: BookingDetailsViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var reservationService: ReservationService
    @State private var shouldDismiss = false
    
    init(reservation: AppModels.Reservation) {
        self.reservation = reservation
        _viewModel = StateObject(wrappedValue: BookingDetailsViewModel(reservation: reservation, reservationService: ReservationService.shared))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Информация о бронировании
                VStack(alignment: .leading, spacing: 15) {
                    Text("Детали бронирования")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.Colors.gold)
                    
                    HStack {
                        Image(systemName: "building.2")
                            .foregroundColor(AppTheme.Colors.gold)
                        Text(viewModel.restaurantName.isEmpty ? reservation.restaurantName : viewModel.restaurantName)
                            .font(.headline)
                    }
                    
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(AppTheme.Colors.gold)
                        Text(viewModel.formattedDate(reservation.date))
                            .font(.headline)
                    }
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(AppTheme.Colors.gold)
                        Text(reservation.time)
                            .font(.headline)
                    }
                    
                    HStack {
                        Image(systemName: "person.3")
                            .foregroundColor(AppTheme.Colors.gold)
                        Text("\(reservation.numberOfGuests) гостей")
                            .font(.headline)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(AppTheme.Colors.darkGray)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: AppTheme.Colors.gold.opacity(0.1), radius: 5, x: 0, y: 2)
                )
                
                // Статус бронирования
                VStack(alignment: .leading, spacing: 15) {
                    Text("Статус")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.Colors.gold)
                    
                    HStack {
                        Circle()
                            .fill(statusColor)
                            .frame(width: 12, height: 12)
                        Text(statusText)
                            .font(.headline)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(AppTheme.Colors.darkGray)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: AppTheme.Colors.gold.opacity(0.1), radius: 5, x: 0, y: 2)
                )
                
                // Действия
                VStack(spacing: 15) {
                    if reservation.status == .pending {
                        HStack(spacing: 20) {
                            Button(action: {
                                viewModel.confirmReservation()
                                shouldDismiss = true
                            }) {
                                Text("Подтвердить")
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(AppTheme.Colors.gold)
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                viewModel.cancelReservation()
                                shouldDismiss = true
                            }) {
                                Text("Отменить")
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    
                    // Кнопка редактирования
                    if reservation.status == .pending || reservation.status == .confirmed {
                        NavigationLink(destination: EditReservationView(reservation: reservation).environmentObject(reservationService)) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Редактировать бронирование")
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(AppTheme.Colors.gold)
                                    .shadow(color: AppTheme.Colors.gold.opacity(0.3), radius: 5, x: 0, y: 2)
                            )
                            .foregroundColor(.black)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(AppTheme.Colors.darkGray)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: AppTheme.Colors.gold.opacity(0.1), radius: 5, x: 0, y: 2)
                )
            }
            .padding()
        }
        .navigationTitle("Детали бронирования")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadRestaurantName(for: reservation.restaurantId)
            print("Статус бронирования: \(reservation.status.rawValue)")
            print("Можно редактировать: \(reservation.status == .pending || reservation.status == .confirmed)")
        }
        .onChange(of: shouldDismiss) { oldValue, newValue in
            if newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Ошибка"),
                message: Text(viewModel.errorMessage ?? "Произошла ошибка"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var statusColor: Color {
        switch reservation.status {
        case .pending:
            return .orange
        case .confirmed:
            return .green
        case .cancelled:
            return .red
        case .completed:
            return .blue
        }
    }
    
    private var statusText: String {
        switch reservation.status {
        case .pending:
            return "Ожидает подтверждения"
        case .confirmed:
            return "Подтверждено"
        case .cancelled:
            return "Отменено"
        case .completed:
            return "Завершено"
        }
    }
}

#Preview {
    NavigationView {
        BookingDetailsView(reservation: AppModels.Reservation(
            id: "1",
            restaurantId: "1",
            restaurantName: "Пивная",
            date: Date(),
            time: "19:00",
            numberOfGuests: 2,
            status: .confirmed,
            specialRequests: nil,
            selectedMenuItems: []
        ))
    }
} 