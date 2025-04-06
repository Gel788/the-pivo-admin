import SwiftUI

struct ReservationConfirmationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var reservationService: ReservationService
    @EnvironmentObject private var appState: AppState
    let reservation: AppModels.Reservation
    let restaurant: AppModels.Restaurant
    
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSuccessMessage = false
    @State private var isLoading = false
    
    private var totalDeposit: Double {
        Double(reservation.numberOfGuests) * 250.0
    }
    
    private var totalOrderAmount: Double {
        reservation.selectedMenuItems.reduce(0) { $0 + $1.price }
    }
    
    private var totalAmount: Double {
        totalDeposit + totalOrderAmount
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Заголовок
                    Text("Подтверждение бронирования")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(AppTheme.Colors.gold)
                        .padding(.top)
                    
                    // Информация о ресторане
                    restaurantInfoSection
                    
                    // Детали бронирования
                    bookingDetailsSection
                    
                    // Выбранные блюда
                    if !reservation.selectedMenuItems.isEmpty {
                        selectedItemsSection
                    }
                    
                    // Итоговая стоимость
                    totalAmountSection
                    
                    // Кнопка подтверждения
                    confirmButton
                }
                .padding()
            }
            .background(Color.black)
            
            if showSuccessMessage {
                successMessageOverlay
                    .transition(.opacity)
            }
            
            if isLoading {
                loadingOverlay
                    .transition(.opacity)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppTheme.Colors.gold)
                }
            }
        }
        .alert("Ошибка", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }
    
    private var restaurantInfoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(restaurant.name)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppTheme.Colors.gold)
            
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(AppTheme.Colors.gold)
                Text(restaurant.address)
                    .foregroundColor(AppTheme.Colors.lightBeige)
            }
            
            HStack {
                Image(systemName: "phone.fill")
                    .foregroundColor(AppTheme.Colors.gold)
                Text(restaurant.phone)
                    .foregroundColor(AppTheme.Colors.lightBeige)
            }
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var bookingDetailsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Детали бронирования")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(AppTheme.Colors.gold)
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(AppTheme.Colors.gold)
                Text(formattedDate(reservation.date))
                    .foregroundColor(AppTheme.Colors.lightBeige)
            }
            
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(AppTheme.Colors.gold)
                Text(reservation.time)
                    .foregroundColor(AppTheme.Colors.lightBeige)
            }
            
            HStack {
                Image(systemName: "person.2.fill")
                    .foregroundColor(AppTheme.Colors.gold)
                Text("\(reservation.numberOfGuests) гостей")
                    .foregroundColor(AppTheme.Colors.lightBeige)
            }
            
            if let specialRequests = reservation.specialRequests {
                HStack {
                    Image(systemName: "text.bubble.fill")
                        .foregroundColor(AppTheme.Colors.gold)
                    Text(specialRequests)
                        .foregroundColor(AppTheme.Colors.lightBeige)
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var selectedItemsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Выбранные блюда")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(AppTheme.Colors.gold)
            
            ForEach(reservation.selectedMenuItems) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.Colors.lightBeige)
                        Text(item.description)
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Text("\(Int(item.price)) ₽")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppTheme.Colors.gold)
                }
                .padding(.vertical, 5)
            }
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var totalAmountSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Депозит")
                    .foregroundColor(AppTheme.Colors.lightBeige)
                Spacer()
                Text("\(Int(totalDeposit)) ₽")
                    .foregroundColor(AppTheme.Colors.gold)
            }
            
            if !reservation.selectedMenuItems.isEmpty {
                HStack {
                    Text("Сумма заказа")
                        .foregroundColor(AppTheme.Colors.lightBeige)
                    Spacer()
                    Text("\(Int(totalOrderAmount)) ₽")
                        .foregroundColor(AppTheme.Colors.gold)
                }
            }
            
            Divider()
                .background(AppTheme.Colors.gold.opacity(0.3))
            
            HStack {
                Text("Итого")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppTheme.Colors.gold)
                Spacer()
                Text("\(Int(totalAmount)) ₽")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppTheme.Colors.gold)
            }
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var confirmButton: some View {
        Button(action: {
            confirmReservation()
        }) {
            Text("Подтвердить")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppTheme.Colors.gold)
                .cornerRadius(15)
        }
        .padding(.vertical)
    }
    
    private var successMessageOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .transition(.opacity)
            
            VStack(spacing: 25) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 70))
                    .foregroundColor(AppTheme.Colors.gold)
                
                Text("Бронирование подтверждено!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.Colors.gold)
                
                Text("Ваш столик забронирован на \(formattedDate(reservation.date)) в \(reservation.time)")
                    .font(.system(size: 16))
                    .foregroundColor(AppTheme.Colors.lightBeige)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    withAnimation {
                        showSuccessMessage = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            dismiss()
                        }
                    }
                }) {
                    Text("Готово")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppTheme.Colors.gold)
                        .cornerRadius(15)
                }
                .padding(.top, 10)
            }
            .padding(30)
            .background(Color(red: 0.1, green: 0.05, blue: 0.1))
            .cornerRadius(20)
            .padding(.horizontal, 40)
            .transition(.scale.combined(with: .opacity))
        }
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.gold))
                    .scaleEffect(2)
                
                Text("Подтверждаем бронирование...")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.Colors.lightBeige)
            }
        }
    }
    
    private func confirmReservation() {
        isLoading = true
        
        // Обновляем статус бронирования
        let updatedReservation = reservationService.updateReservationStatus(reservation, status: .confirmed)
        
        // Проверяем успешность обновления
        if updatedReservation.status == .confirmed {
            DispatchQueue.main.async {
                self.isLoading = false
                withAnimation {
                    self.showSuccessMessage = true
                }
            }
        } else {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Не удалось подтвердить бронирование"
                self.showError = true
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
} 