import SwiftUI
import MapKit

struct RestaurantDetailView: View {
    let restaurant: AppModels.Restaurant
    @EnvironmentObject var appState: AppState
    @State private var showReservationForm = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Фоновый градиент
            AppTheme.Colors.darkBackgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Изображение ресторана
                    headerImage
                        .frame(height: 260)
                        .clipped()
                        .padding(.horizontal, 12)
                        .padding(.top, 12)
                    
                    // Информация о ресторане
                    restaurantInfo
                        .frame(maxWidth: UIScreen.main.bounds.width - 24)
                }
            }
            .navigationBarHidden(true)
            .overlay(
                backButton,
                alignment: .topLeading
            )
        }
        .sheet(isPresented: $showReservationForm) {
            ReservationFormView(restaurant: restaurant)
                .environmentObject(appState)
        }
    }
    
    // Изображение в шапке
    private var headerImage: some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                if let image = UIImage(named: "slide-6") {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fill)
                        .frame(maxWidth: UIScreen.main.bounds.width - 24)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(AppTheme.Colors.dark)
                        .frame(maxWidth: UIScreen.main.bounds.width - 24)
                        .overlay(
                            Text("Изображение недоступно")
                                .foregroundColor(.white)
                        )
                }
            }
            
            // Градиент для текста
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.clear,
                    Color.black.opacity(0.8)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 100)
            
            // Информация
            VStack(alignment: .leading, spacing: 6) {
                Text(restaurant.name)
                    .font(AppTheme.Typography.titleLarge)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    // Тип ресторана
                    Text(restaurant.type)
                        .font(AppTheme.Typography.bodyBold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
        }
        .cornerRadius(12)
    }
    
    // Информация о ресторане
    private var restaurantInfo: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            // Описание
            Text(restaurant.description)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
                .padding(.horizontal, 12)
                .padding(.top, 8)
            
            // Контактная информация
            VStack(spacing: AppTheme.Spacing.medium) {
                // Адрес
                HStack(spacing: AppTheme.Spacing.small) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(AppTheme.Colors.gold)
                        .font(.system(size: 18))
                    Text(restaurant.address)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.lightBeige)
                }
                
                // Телефон
                HStack(spacing: AppTheme.Spacing.small) {
                    Image(systemName: "phone.fill")
                        .foregroundColor(AppTheme.Colors.gold)
                        .font(.system(size: 18))
                    Text(restaurant.phone)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.lightBeige)
                }
                
                // Часы работы
                HStack(spacing: AppTheme.Spacing.small) {
                    Image(systemName: "clock.fill")
                        .foregroundColor(AppTheme.Colors.gold)
                        .font(.system(size: 18))
                    Text(restaurant.hours)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.lightBeige)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppTheme.Colors.gold.opacity(0.2), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 12)
            
            // Кнопка бронирования
            Button(action: {
                showReservationForm = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .font(.system(size: 16, weight: .medium))
                    Text("Забронировать столик")
                        .font(AppTheme.Typography.button)
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppTheme.Colors.gold)
                        .shadow(color: AppTheme.Colors.gold.opacity(0.3), radius: 6, x: 0, y: 3)
                )
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 32)
        }
    }
    
    // Кнопка "Назад"
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(12)
                .background(Color.black.opacity(0.5))
                .clipShape(Circle())
        }
        .padding(.top, 50)
        .padding(.leading, 20)
    }
    
    // Вспомогательные функции
    private func iconForFeature(_ feature: String) -> String {
        switch feature.lowercased() {
        case "wifi":
            return "wifi"
        case "парковка":
            return "car.fill"
        case "терраса":
            return "sun.max.fill"
        case "бар":
            return "wineglass.fill"
        case "кухня":
            return "fork.knife"
        case "музыка":
            return "music.note"
        case "детская зона":
            return "figure.child"
        case "доставка":
            return "bicycle"
        default:
            return "checkmark.circle.fill"
        }
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailView(
            restaurant: AppModels.Restaurant(
                id: "1",
                name: "Пивной ресторан",
                description: "Уютный ресторан с большим выбором пива и закусок",
                address: "ул. Пивная, 1",
                phone: "+7 123 456 7890",
                email: "info@pivnoy.ru",
                website: "www.pivnoy.ru",
                hours: "Пн-Чт: 12:00-00:00, Пт-Сб: 12:00-02:00, Вс: 12:00-22:00",
                imageURL: "RestaurantImage",
                menu: [],
                type: "Пивной ресторан",
                features: ["Wi-Fi", "Парковка", "Живая музыка"],
                latitude: 55.753215,
                longitude: 37.622504,
                reservationCostPerPerson: 500.0
            )
        )
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
    }
} 