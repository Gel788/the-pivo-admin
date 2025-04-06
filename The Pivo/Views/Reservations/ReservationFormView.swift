import SwiftUI

struct ReservationFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var reservationService: ReservationService
    @EnvironmentObject var appState: AppState
    
    let restaurant: AppModels.Restaurant
    
    @State private var selectedDate = Date()
    @State private var selectedTime = "18:00"
    @State private var guestsCount = 2
    @State private var specialRequests = ""
    @State private var isLoading = false
    @State private var showSuccessMessage = false
    @State private var showDatePicker = false
    @State private var showTimePicker = false
    @State private var availableTimes = ["12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00"]
    @State private var selectedMenuItems: [AppModels.MenuItemWithQuantity] = []
    @State private var showConfirmation = false
    @State private var createdReservation: AppModels.Reservation?
    @State private var showDateError = false
    @State private var showTimeError = false
    @State private var showGuestsError = false
    
    // Минимальная дата для бронирования - сегодня
    private var minimumDate: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    // Максимальная дата для бронирования - 30 дней вперед
    private var maximumDate: Date {
        Calendar.current.date(byAdding: .day, value: 30, to: minimumDate)!
    }
    
    private var isValidDate: Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return selectedDate >= today && selectedDate <= maximumDate
    }
    
    private var isValidTime: Bool {
        let calendar = Calendar.current
        let now = Date()
        let selectedDateTime = calendar.date(bySettingHour: Int(selectedTime.split(separator: ":")[0]) ?? 0,
                                          minute: Int(selectedTime.split(separator: ":")[1]) ?? 0,
                                          second: 0,
                                          of: selectedDate) ?? now
        
        return selectedDateTime > now
    }
    
    private var isValidGuests: Bool {
        return guestsCount >= 1 && guestsCount <= 10
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Фоновый градиент
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black,
                        Color(red: 0.1, green: 0.05, blue: 0.1),
                        Color.black
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Заголовок
                        Text("Бронирование столика")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(AppTheme.Colors.gold)
                            .padding(.top, 10)
                        
                        // Информация о ресторане
                        restaurantInfoSection
                        
                        // Форма бронирования
                        bookingFormSection
                        
                        // Кнопка подтверждения
                        confirmButton
                    }
                    .padding()
                }
                
                // Оверлей для выбора даты
                if showDatePicker {
                    datePickerOverlay
                }
                
                // Оверлей для выбора времени
                if showTimePicker {
                    timePickerOverlay
                }
                
                // Индикатор загрузки
                if isLoading {
                    loadingOverlay
                }
                
                // Сообщение об успешном бронировании
                if showSuccessMessage {
                    successMessageOverlay
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(isLoading || showSuccessMessage)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !isLoading && !showSuccessMessage {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(AppTheme.Colors.gold)
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $showConfirmation) {
                if let reservation = createdReservation {
                    ReservationConfirmationView(reservation: reservation, restaurant: restaurant)
                        .environmentObject(reservationService)
                        .environmentObject(appState)
                        .navigationBarBackButtonHidden(true)
                }
            }
            .alert("Ошибка даты", isPresented: $showDateError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Выберите корректную дату бронирования")
            }
            .alert("Ошибка времени", isPresented: $showTimeError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Выберите корректное время бронирования")
            }
            .alert("Ошибка количества гостей", isPresented: $showGuestsError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Количество гостей должно быть от 1 до 10")
            }
        }
    }
    
    // Информация о ресторане
    private var restaurantInfoSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(restaurant.name)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(AppTheme.Colors.gold)
            
            HStack(spacing: 15) {
                infoRow(icon: "mappin.circle.fill", text: restaurant.address)
                infoRow(icon: "phone.fill", text: restaurant.phone)
            }
            
            Text("Стоимость депозита: \(Int(restaurant.reservationCostPerPerson)) ₽ на человека")
                .font(.system(size: 16))
                .foregroundColor(AppTheme.Colors.lightBeige)
                .padding(.top, 5)
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
        )
    }
    
    // Форма бронирования
    private var bookingFormSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Детали бронирования")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppTheme.Colors.gold)
            
            // Выбор даты
            formField(icon: "calendar", title: "Дата") {
                Button(action: {
                    showDatePicker = true
                }) {
                    HStack {
                        Text(formattedDate(selectedDate))
                            .foregroundColor(AppTheme.Colors.lightBeige)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(AppTheme.Colors.gold.opacity(0.7))
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
                    )
                }
            }
            
            // Выбор времени
            formField(icon: "clock.fill", title: "Время") {
                Button(action: {
                    showTimePicker = true
                }) {
                    HStack {
                        Text(selectedTime)
                            .foregroundColor(AppTheme.Colors.lightBeige)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(AppTheme.Colors.gold.opacity(0.7))
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
                    )
                }
            }
            
            // Выбор количества гостей
            formField(icon: "person.2.fill", title: "Количество гостей") {
                HStack {
                    Button(action: {
                        if guestsCount > 1 {
                            guestsCount -= 1
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppTheme.Colors.gold)
                    }
                    
                    Text("\(guestsCount)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppTheme.Colors.lightBeige)
                        .frame(width: 40)
                    
                    Button(action: {
                        if guestsCount < 20 {
                            guestsCount += 1
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppTheme.Colors.gold)
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 15)
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
                )
            }
            
            // Особые пожелания
            formField(icon: "text.bubble.fill", title: "Особые пожелания (необязательно)") {
                TextEditor(text: $specialRequests)
                    .foregroundColor(AppTheme.Colors.lightBeige)
                    .frame(height: 100)
                    .padding(10)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
                    )
            }
            
            // Выбор блюд из меню
            formField(icon: "fork.knife", title: "Выбор блюд") {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(restaurant.menu) { item in
                        MenuItemRow(item: item, selectedItems: $selectedMenuItems)
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 15)
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
                )
            }
            
            // Итоговая стоимость
            VStack(alignment: .leading, spacing: 10) {
                Text("Итого")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppTheme.Colors.gold)
                
                HStack {
                    Text("Депозит (будет включен в счет)")
                        .font(.system(size: 16))
                        .foregroundColor(AppTheme.Colors.lightBeige)
                    
                    Spacer()
                    
                    Text("\(calculateDeposit()) ₽")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppTheme.Colors.gold)
                }
                
                if !selectedMenuItems.isEmpty {
                    HStack {
                        Text("Стоимость предзаказа")
                            .font(.system(size: 16))
                            .foregroundColor(AppTheme.Colors.lightBeige)
                        
                        Spacer()
                        
                        Text("\(calculatePreorderCost()) ₽")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppTheme.Colors.gold)
                    }
                }
                
                Divider()
                    .background(AppTheme.Colors.gold.opacity(0.3))
                
                HStack {
                    Text("Общая сумма")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(AppTheme.Colors.gold)
                    
                    Spacer()
                    
                    Text("\(calculateTotalCost()) ₽")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(AppTheme.Colors.gold)
                }
            }
            .padding()
            .background(Color.black.opacity(0.3))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
            )
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
        )
    }
    
    // Кнопка подтверждения
    private var confirmButton: some View {
        Button(action: validateAndCreateReservation) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Создать бронирование")
                        .font(.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppTheme.Colors.gold)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .disabled(isLoading)
    }
    
    // Оверлей для выбора даты
    private var datePickerOverlay: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Выберите дату")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppTheme.Colors.gold)
                
                DatePicker(
                    "",
                    selection: $selectedDate,
                    in: minimumDate...maximumDate,
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .accentColor(AppTheme.Colors.gold)
                .colorScheme(.dark)
                .environment(\.locale, Locale(identifier: "ru_RU"))
                .padding()
                
                Button(action: {
                    showDatePicker = false
                }) {
                    Text("Готово")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppTheme.Colors.gold)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color(red: 0.1, green: 0.05, blue: 0.1))
            .cornerRadius(20)
            .padding(.horizontal, 20)
        }
        .transition(.opacity)
    }
    
    // Оверлей для выбора времени
    private var timePickerOverlay: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Выберите время")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppTheme.Colors.gold)
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(availableTimes, id: \.self) { time in
                            Button(action: {
                                selectedTime = time
                                showTimePicker = false
                            }) {
                                Text(time)
                                    .font(.system(size: 18))
                                    .foregroundColor(selectedTime == time ? .black : AppTheme.Colors.lightBeige)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(selectedTime == time ? AppTheme.Colors.gold : Color.black.opacity(0.3))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .frame(height: 300)
                
                Button(action: {
                    showTimePicker = false
                }) {
                    Text("Отмена")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppTheme.Colors.gold)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color(red: 0.1, green: 0.05, blue: 0.1))
            .cornerRadius(20)
            .padding(.horizontal, 20)
        }
        .transition(.opacity)
    }
    
    // Индикатор загрузки
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.gold))
                    .scaleEffect(2)
                
                Text("Обрабатываем ваше бронирование...")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.Colors.lightBeige)
            }
        }
    }
    
    // Сообщение об успешном бронировании
    private var successMessageOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 70))
                    .foregroundColor(AppTheme.Colors.gold)
                
                Text("Бронирование успешно!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.Colors.gold)
                
                Text("Ваш столик забронирован на \(formattedDate(selectedDate)) в \(selectedTime)")
                    .font(.system(size: 16))
                    .foregroundColor(AppTheme.Colors.lightBeige)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    withAnimation {
                        showSuccessMessage = false
                    }
                    // Закрываем модальное окно и переходим во вкладку бронирования
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        presentationMode.wrappedValue.dismiss()
                        appState.selectedTab = .reservations
                    }
                }) {
                    Text("Хорошо")
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
        }
        .transition(.opacity)
    }
    
    // Вспомогательные функции
    private func formField<Content: View>(icon: String, title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(AppTheme.Colors.gold)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.Colors.gold)
            }
            
            content()
        }
    }
    
    private func infoRow(icon: String, text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(AppTheme.Colors.gold)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.Colors.lightBeige)
                .lineLimit(1)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
    
    private func formattedTime(_ time: String) -> String {
        return time
    }
    
    private func calculateDeposit() -> Int {
        return 250 * guestsCount
    }
    
    private func calculatePreorderCost() -> Int {
        return Int(selectedMenuItems.reduce(0) { $0 + ($1.menuItem.price * Double($1.quantity)) })
    }
    
    private func calculateTotalCost() -> Int {
        return calculateDeposit() + calculatePreorderCost()
    }
    
    private func validateAndCreateReservation() {
        // Сброс ошибок
        showDateError = false
        showTimeError = false
        showGuestsError = false
        
        // Валидация
        if !isValidDate {
            showDateError = true
            return
        }
        
        if !isValidTime {
            showTimeError = true
            return
        }
        
        if !isValidGuests {
            showGuestsError = true
            return
        }
        
        // Создание бронирования
        createReservation()
    }
    
    private func createReservation() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        // Создаем бронирование через сервис
        let reservation = reservationService.createReservation(
            restaurantId: restaurant.id,
            restaurantName: restaurant.name,
            date: selectedDate,
            time: selectedTime,
            numberOfGuests: guestsCount,
            specialRequests: specialRequests.isEmpty ? nil : specialRequests,
            selectedMenuItems: selectedMenuItems.map { $0.menuItem }
        )
        
        // Проверяем успешность создания бронирования
        if reservation.id.isEmpty {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            return
        }
        
        // Обновляем состояние в главном потоке
        DispatchQueue.main.async {
            self.createdReservation = reservation
            self.isLoading = false
            withAnimation {
                self.showSuccessMessage = true
            }
        }
    }
}

#Preview {
    NavigationView {
        ReservationFormView(
            restaurant: AppModels.Restaurant(
                id: "1",
                name: "Пивная №1",
                description: "Уютный ресторан с большим выбором крафтового пива и традиционными закусками.",
                address: "ул. Тверская, 15, Москва",
                phone: "+7 (495) 123-45-67",
                email: "info@pivnaya1.ru",
                website: "www.pivnaya1.ru",
                hours: "Пн-Чт: 12:00-00:00, Пт-Сб: 12:00-02:00, Вс: 12:00-22:00",
                imageURL: "",
                menu: [],
                type: "Пивной ресторан",
                features: ["Wi-Fi", "Живая музыка", "Бизнес-ланч", "Терраса"],
                latitude: 55.7614,
                longitude: 37.6122,
                reservationCostPerPerson: 1000
            )
        )
        .environmentObject(ReservationService())
        .environmentObject(AppState())
    }
    .preferredColorScheme(.dark)
} 