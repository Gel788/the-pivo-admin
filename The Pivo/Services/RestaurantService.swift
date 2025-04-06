import Foundation
import SwiftUI
import Combine

enum RestaurantError: Error {
    case networkError
    case decodingError
    case cacheError
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .networkError:
            return "Ошибка сети. Проверьте подключение к интернету."
        case .decodingError:
            return "Ошибка при обработке данных."
        case .cacheError:
            return "Ошибка при работе с кэшем."
        case .unknown:
            return "Произошла неизвестная ошибка."
        }
    }
}

class RestaurantService: ObservableObject {
    static let shared = RestaurantService()
    
    @Published var restaurants: [AppModels.Restaurant] = []
    @Published var news: [AppModels.News] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let userDefaults = UserDefaults.standard
    private let restaurantsKey = "savedRestaurants"
    private let cacheTimeout: TimeInterval = 3600 // 1 час
    
    init() {
        loadRestaurants()
    }
    
    func fetchRestaurants() {
        isLoading = true
        error = nil
        
        // Проверяем кэш
        if let cachedData = userDefaults.data(forKey: restaurantsKey),
           let cachedRestaurants = try? JSONDecoder().decode([AppModels.Restaurant].self, from: cachedData),
           let lastUpdate = userDefaults.object(forKey: "lastRestaurantsUpdate") as? Date,
           Date().timeIntervalSince(lastUpdate) < cacheTimeout {
            DispatchQueue.main.async {
                self.restaurants = cachedRestaurants
                self.isLoading = false
            }
            return
        }
        
        // Моковые данные для тестирования
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            do {
                self.restaurants = [
                    AppModels.Restaurant(
                        id: "1",
                        name: "The Pivo",
                        description: "Уютный ресторан с широким выбором пива и закусок",
                        address: "ул. Примерная, 123",
                        phone: "+7 (999) 123-45-67",
                        email: "info@thepivo.ru",
                        website: "www.thepivo.ru",
                        hours: "Пн-Вс: 12:00 - 02:00",
                        imageURL: "Logo",
                        menu: [
                            AppModels.MenuItem(
                                id: "1",
                                name: "Светлое пиво",
                                description: "Классическое светлое пиво",
                                price: 250.0,
                                imageURL: "beer1",
                                category: .beer
                            ),
                            AppModels.MenuItem(
                                id: "2",
                                name: "Темное пиво",
                                description: "Темное пиво с богатым вкусом",
                                price: 300.0,
                                imageURL: "beer2",
                                category: .beer
                            )
                        ],
                        type: "Пивной ресторан",
                        features: ["Wi-Fi", "Парковка", "Живая музыка"],
                        latitude: 55.753215,
                        longitude: 37.622504,
                        reservationCostPerPerson: 500.0
                    ),
                    AppModels.Restaurant(
                        id: "2",
                        name: "Pivo & Grill",
                        description: "Ресторан с отличным грилем и пивом",
                        address: "ул. Другая, 456",
                        phone: "+7 (999) 765-43-21",
                        email: "info@pivogrill.ru",
                        website: "www.pivogrill.ru",
                        hours: "Пн-Вс: 11:00 - 23:00",
                        imageURL: "Logo",
                        menu: [
                            AppModels.MenuItem(
                                id: "3",
                                name: "Стейк Рибай",
                                description: "Сочный стейк из мраморной говядины",
                                price: 1200.0,
                                imageURL: "steak1",
                                category: .main
                            ),
                            AppModels.MenuItem(
                                id: "4",
                                name: "Крафтовое IPA",
                                description: "Хмельное крафтовое пиво",
                                price: 350.0,
                                imageURL: "beer3",
                                category: .beer
                            )
                        ],
                        type: "Ресторан",
                        features: ["Wi-Fi", "Парковка", "Терраса"],
                        latitude: 55.761389,
                        longitude: 37.608889,
                        reservationCostPerPerson: 1000.0
                    )
                ]
                try self.saveRestaurants()
                self.isLoading = false
            } catch {
                self.error = RestaurantError.cacheError
                self.isLoading = false
            }
        }
    }
    
    private func saveRestaurants() throws {
        let encoded = try JSONEncoder().encode(restaurants)
        userDefaults.set(encoded, forKey: restaurantsKey)
        userDefaults.set(Date(), forKey: "lastRestaurantsUpdate")
    }
    
    private func loadRestaurants() {
        if let data = userDefaults.data(forKey: restaurantsKey),
           let decodedRestaurants = try? JSONDecoder().decode([AppModels.Restaurant].self, from: data) {
            DispatchQueue.main.async {
                self.restaurants = decodedRestaurants
            }
        }
    }
    
    func clearCache() {
        userDefaults.removeObject(forKey: restaurantsKey)
        userDefaults.removeObject(forKey: "lastRestaurantsUpdate")
        self.restaurants = []
    }
    
    func fetchNews() {
        // Здесь будет реальный запрос к API
        let sampleNews = [
            AppModels.News(
                id: "1",
                title: "Новое сезонное меню",
                content: "Мы обновили наше меню с учетом сезонных продуктов. Приходите попробовать новые блюда!",
                date: Date(),
                imageURL: "news1",
                type: .news
            ),
            AppModels.News(
                id: "2",
                title: "Фестиваль крафтового пива",
                content: "Приглашаем на наш ежегодный фестиваль крафтового пива!",
                date: Date().addingTimeInterval(86400),
                imageURL: "news2",
                type: .event
            ),
            AppModels.News(
                id: "3",
                title: "Специальное предложение",
                content: "Скидка 20% на все позиции меню по понедельникам!",
                date: Date().addingTimeInterval(172800),
                imageURL: "news3",
                type: .promotion
            )
        ]
        
        news = sampleNews
    }
    
    func getRestaurant(_ id: String) -> AppModels.Restaurant? {
        return restaurants.first { $0.id == id }
    }
    
    func getMenuItems(for restaurantId: String, category: AppModels.MenuCategory? = nil) -> [AppModels.MenuItem] {
        guard let restaurant = getRestaurant(restaurantId) else { return [] }
        
        if let category = category {
            return restaurant.menu.filter { $0.category == category }
        }
        
        return restaurant.menu
    }
    
    // Моковые данные для новостей
    private func loadMockNews() {
        self.news = [
            AppModels.News(
                id: "1",
                title: "Новое сезонное меню",
                content: "Мы обновили наше меню с учетом сезонных продуктов. Приходите попробовать новые блюда!",
                date: Date(),
                imageURL: "Logo",
                type: .news
            ),
            AppModels.News(
                id: "2",
                title: "Фестиваль крафтового пива",
                content: "Приглашаем на наш ежегодный фестиваль крафтового пива. Вас ждет дегустация лучших сортов и увлекательная программа.",
                date: Date().addingTimeInterval(86400),
                imageURL: "Logo",
                type: .event
            ),
            AppModels.News(
                id: "3",
                title: "Специальное предложение",
                content: "Каждый понедельник с 12:00 до 15:00 действует скидка 20% на все блюда из меню!",
                date: Date().addingTimeInterval(172800),
                imageURL: "Logo",
                type: .promotion
            ),
            AppModels.News(
                id: "4",
                title: "Открытие летней веранды",
                content: "Мы рады сообщить об открытии нашей летней веранды. Теперь вы можете наслаждаться блюдами на свежем воздухе!",
                date: Date().addingTimeInterval(259200),
                imageURL: "Logo",
                type: .news
            )
        ]
    }
    
    func fetchRestaurantsByType(_ type: String) {
        isLoading = true
        
        // Здесь будет реальный запрос к API
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let sampleRestaurant = AppModels.Restaurant(
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
                type: type,
                features: ["Wi-Fi", "Парковка", "Живая музыка"],
                latitude: 55.753215,
                longitude: 37.622504,
                reservationCostPerPerson: 500.0
            )
            
            self.restaurants = [sampleRestaurant]
            self.isLoading = false
        }
    }
    
    func fetchRestaurantsByPriceRange(_ priceRange: String) {
        isLoading = true
        
        // Здесь будет реальный запрос к API
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let sampleRestaurant = AppModels.Restaurant(
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
                longitude: 37.622504,
                reservationCostPerPerson: 500.0
            )
            
            self.restaurants = [sampleRestaurant]
            self.isLoading = false
        }
    }
    
    func fetchRestaurantsByFeatures(_ features: [String]) {
        isLoading = true
        
        // Здесь будет реальный запрос к API
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let sampleRestaurant = AppModels.Restaurant(
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
                features: features,
                latitude: 55.753215,
                longitude: 37.622504,
                reservationCostPerPerson: 500.0
            )
            
            self.restaurants = [sampleRestaurant]
            self.isLoading = false
        }
    }
    
    func fetchRestaurantsByLocation(latitude: Double, longitude: Double, radius: Double) {
        isLoading = true
        
        // Здесь будет реальный запрос к API
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let sampleRestaurant = AppModels.Restaurant(
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
                latitude: latitude,
                longitude: longitude,
                reservationCostPerPerson: 500.0
            )
            
            self.restaurants = [sampleRestaurant]
            self.isLoading = false
        }
    }
} 