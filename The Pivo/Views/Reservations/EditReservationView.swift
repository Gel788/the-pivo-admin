import SwiftUI

struct EditReservationView: View {
    let reservation: AppModels.Reservation
    @StateObject private var viewModel: EditReservationViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var reservationService: ReservationService
    @State private var showError = false
    @State private var errorMessage = ""
    
    init(reservation: AppModels.Reservation) {
        self.reservation = reservation
        _viewModel = StateObject(wrappedValue: EditReservationViewModel(reservation: reservation, reservationService: ReservationService.shared))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Дата и время
                VStack(alignment: .leading, spacing: 15) {
                    Text("Дата и время")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.Colors.gold)
                    
                    DatePicker("Дата", selection: $viewModel.selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .tint(AppTheme.Colors.gold)
                        .environment(\.locale, Locale(identifier: "ru_RU"))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.black.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
                                )
                        )
                    
                    Picker("Время", selection: $viewModel.selectedTime) {
                        ForEach(viewModel.availableTimes, id: \.self) { time in
                            Text(time).tag(time)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.black.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                
                // Количество гостей
                VStack(alignment: .leading, spacing: 15) {
                    Text("Количество гостей")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.Colors.gold)
                    
                    HStack {
                        Button(action: {
                            if viewModel.numberOfGuests > 1 {
                                viewModel.numberOfGuests -= 1
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundColor(AppTheme.Colors.gold)
                        }
                        
                        Text("\(viewModel.numberOfGuests) гостей")
                            .font(.title3)
                            .foregroundColor(AppTheme.Colors.lightBeige)
                            .frame(width: 120)
                        
                        Button(action: {
                            if viewModel.numberOfGuests < 10 {
                                viewModel.numberOfGuests += 1
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(AppTheme.Colors.gold)
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
                    )
                }
                
                // Особые пожелания
                VStack(alignment: .leading, spacing: 15) {
                    Text("Особые пожелания")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.Colors.gold)
                    
                    TextEditor(text: $viewModel.specialRequests)
                        .frame(height: 100)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.black.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
                
                // Кнопка сохранения
                Button(action: {
                    viewModel.saveChanges { success in
                        if success {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            errorMessage = "Не удалось сохранить изменения"
                            showError = true
                        }
                    }
                }) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Сохранить изменения")
                                .font(.headline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppTheme.Colors.gold)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(viewModel.isLoading)
            }
            .padding()
        }
        .navigationTitle("Редактирование бронирования")
        .alert("Ошибка", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

struct EditReservationView_Previews: PreviewProvider {
    static var previews: some View {
        let reservation = AppModels.Reservation(
            id: "1",
            restaurantId: "1",
            restaurantName: "Пивная №1",
            date: Date(),
            time: "14:00",
            numberOfGuests: 4,
            status: .confirmed,
            specialRequests: "Столик у окна, пожалуйста",
            selectedMenuItems: []
        )
        
        return NavigationView {
            EditReservationView(reservation: reservation)
                .environmentObject(AppState())
        }
        .preferredColorScheme(.dark)
    }
} 