import SwiftUI

// MARK: - Базовый компонент карточки
struct BaseCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        let backgroundShape = RoundedRectangle(cornerRadius: 24)
        let backgroundFill = backgroundShape.fill(AppTheme.Colors.darkLight)
        let shadow = backgroundFill.shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
        
        return content
            .padding(AppTheme.Spacing.medium)
            .background(shadow)
    }
}

// MARK: - Карточка ресторана
struct CustomRestaurantCard: View {
    let restaurant: AppModels.Restaurant
    let onBook: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Изображение ресторана
            ZStack(alignment: .bottomLeading) {
                Group {
                    if !restaurant.imageURL.isEmpty, let image = UIImage(named: "Restaurants/\(restaurant.imageURL)") {
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

// MARK: - Карточка блюда
struct MenuItemCard: View {
    let item: AppModels.MenuItem
    let onAdd: () -> Void
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                // Изображение блюда
                AsyncImage(url: URL(string: item.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(AppTheme.Colors.dark)
                        .overlay(
                            ProgressView()
                                .tint(AppTheme.Colors.gold)
                        )
                }
                .frame(height: 200)
                .clipped()
                .cornerRadius(20)
                
                // Информация о блюде
                VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                    HStack {
                        Text(item.name)
                            .font(AppTheme.Typography.titleSmall)
                            .foregroundColor(AppTheme.Colors.lightBeige)
                        
                        Spacer()
                        
                        Text(String(format: "%d ₽", item.price))
                            .font(AppTheme.Typography.titleSmall)
                            .foregroundColor(AppTheme.Colors.gold)
                    }
                    
                    Text(item.description)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
                        .lineLimit(2)
                    
                    HStack {
                        // Характеристики
                        HStack(spacing: 12) {
                            if let abv = item.abv {
                                HStack(spacing: 4) {
                                    Image(systemName: "drop.fill")
                                        .font(.system(size: 12))
                                    Text(String(format: "%.1f%%", abv))
                                        .font(AppTheme.Typography.bodySmall)
                                }
                                .foregroundColor(AppTheme.Colors.gold)
                            }
                            
                            if let ibu = item.ibu {
                                HStack(spacing: 4) {
                                    Image(systemName: "chart.bar.fill")
                                        .font(.system(size: 12))
                                    Text(String(format: "%d IBU", ibu))
                                        .font(AppTheme.Typography.bodySmall)
                                }
                                .foregroundColor(AppTheme.Colors.gold)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: onAdd) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(AppTheme.Colors.gold)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Карточка новости
struct CustomNewsCard: View {
    let news: AppModels.News
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                // Изображение
                Group {
                    if let imageURL = news.imageURL, !imageURL.isEmpty, let image = UIImage(named: "News/\(imageURL)") {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Rectangle()
                            .fill(AppTheme.Colors.dark)
                            .overlay(
                                Text("Изображение недоступно")
                                    .foregroundColor(.white)
                            )
                    }
                }
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                // Контент
                VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                    // Тип новости
                    HStack {
                        Circle()
                            .fill(colorForType(news.type))
                            .frame(width: 8, height: 8)
                        Text(news.type.rawValue.capitalized)
                            .font(AppTheme.Typography.bodySmall)
                            .foregroundColor(AppTheme.Colors.gold)
                    }
                    
                    // Заголовок
                    Text(news.title)
                        .font(AppTheme.Typography.titleSmall)
                        .foregroundColor(AppTheme.Colors.lightBeige)
                        .lineLimit(2)
                    
                    // Описание
                    Text(news.content)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
                        .lineLimit(3)
                    
                    // Дата
                    HStack {
                        Image(systemName: "calendar")
                            .font(.system(size: 14))
                        Text(news.date.formatted(date: .abbreviated, time: .omitted))
                            .font(AppTheme.Typography.bodySmall)
                    }
                    .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.6))
                }
                .padding(.horizontal, AppTheme.Spacing.medium)
            }
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(AppTheme.Colors.darkLight)
                    .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func colorForType(_ type: AppModels.NewsType) -> Color {
        switch type {
        case .news:
            return AppTheme.Colors.gold
        case .event:
            return AppTheme.Colors.lightBeige
        case .promotion:
            return AppTheme.Colors.gold.opacity(0.7)
        case .beer:
            return AppTheme.Colors.gold.opacity(0.7)
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            CustomNewsCard(
                news: AppModels.News(
                    id: "1",
                    title: "Новое крафтовое пиво",
                    content: "Мы рады представить вам наше новое крафтовое пиво с уникальным вкусом и ароматом.",
                    date: Date(),
                    imageURL: "beer",
                    type: .beer
                ),
                onTap: {}
            )
            
            MenuItemCard(
                item: AppModels.MenuItem(
                    id: "1",
                    name: "IPA Хмельной Кот",
                    description: "Хмельное пиво с ярким цитрусовым вкусом и ароматом.",
                    price: 350,
                    imageURL: "beer",
                    category: .beer
                ),
                onAdd: {}
            )
            
            CustomRestaurantCard(
                restaurant: AppModels.Restaurant(
                    id: "1",
                    name: "The Pivo",
                    description: "Уютный ресторан с широким выбором пива и закусок",
                    address: "ул. Примерная, 123",
                    phone: "+7 (999) 123-45-67",
                    email: "info@thepivo.ru",
                    website: "www.thepivo.ru",
                    hours: "Пн-Вс: 12:00 - 02:00",
                    imageURL: "Logo",
                    menu: [],
                    type: "Пивной ресторан",
                    features: ["Wi-Fi", "Парковка", "Живая музыка"],
                    latitude: 55.753215,
                    longitude: 37.622504
                ),
                onBook: {}
            )
        }
        .padding()
    }
    .background(Color.black)
} 