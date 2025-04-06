import SwiftUI

struct RestaurantCard: View {
    let restaurant: AppModels.Restaurant
    let onBook: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Изображение ресторана
            ZStack(alignment: .bottomLeading) {
                Group {
                    if let image = UIImage(named: "Restaurants/\(restaurant.imageURL)") {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(16/9, contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(AppTheme.Colors.dark)
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
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
                        Color.black.opacity(0.7)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 80)
                
                // Информация поверх изображения
                VStack(alignment: .leading, spacing: 4) {
                    Text(restaurant.name)
                        .font(AppTheme.Typography.titleSmall)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    HStack(spacing: 4) {
                        Text(restaurant.type)
                            .font(AppTheme.Typography.bodySmall)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(6)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
            
            // Особенности ресторана
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(restaurant.features.prefix(4), id: \.self) { feature in
                        HStack(spacing: 4) {
                            Image(systemName: iconForFeature(feature))
                                .font(.system(size: 12))
                            Text(feature)
                                .font(AppTheme.Typography.bodySmall)
                        }
                        .foregroundColor(AppTheme.Colors.gold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(AppTheme.Colors.gold.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
            
            // Кнопка бронирования
            Button(action: onBook) {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                    Text("Забронировать столик")
                        .font(AppTheme.Typography.bodySmall)
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(AppTheme.Colors.gold)
                .cornerRadius(8)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(AppTheme.Colors.dark.opacity(0.3))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppTheme.Colors.gold.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func iconForFeature(_ feature: String) -> String {
        switch feature.lowercased() {
        case "wifi": return "wifi"
        case "парковка": return "car.fill"
        case "терраса": return "sun.max.fill"
        case "бар": return "wineglass.fill"
        case "кухня": return "fork.knife"
        case "музыка": return "music.note"
        case "детская зона": return "figure.child"
        case "доставка": return "bicycle"
        default: return "checkmark.circle.fill"
        }
    }
}

struct RestaurantCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            RestaurantCard(
                restaurant: AppModels.Restaurant(
                    id: "1",
                    name: "Пивная №1",
                    description: "Уютный ресторан с большим выбором крафтового пива и традиционными закусками.",
                    address: "ул. Тверская, 15, Москва",
                    phone: "+7 (495) 123-45-67",
                    email: "info@pivnaya1.ru",
                    website: "www.pivnaya1.ru",
                    hours: "Пн-Чт: 12:00-00:00, Пт-Сб: 12:00-02:00, Вс: 12:00-22:00",
                    imageURL: "RestaurantImage",
                    menu: [],
                    type: "Пивной ресторан",
                    features: ["Wi-Fi", "Живая музыка", "Бизнес-ланч", "Терраса"],
                    latitude: 55.7614,
                    longitude: 37.6122
                ),
                onBook: { print("Бронирование") }
            )
            .padding()
        }
    }
} 