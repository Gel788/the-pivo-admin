import SwiftUI

class AppState: ObservableObject {
    @Published var currentUser: AppModels.User?
    @Published var restaurants: [AppModels.Restaurant] = []
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var error: Error?
    @Published var showSplash = true
    @Published var cartItems: [AppModels.CartItem] = []
    @Published var newsItems: [AppModels.News] = []
    @Published var orders: [AppModels.Order] = []
    @Published var selectedTab: Tab = .news
    @Published var news: [AppModels.News] = []
    
    // Перечисление для табов
    enum Tab {
        case news
        case restaurants
        case menu
        case reservations
        case profile
    }
    
    private let userDefaults = UserDefaults.standard
    private let userKey = "currentUser"
    
    init() {
        // Инициализируем данные в главном потоке
        DispatchQueue.main.async {
            self.loadUser()
            self.fetchRestaurants()
            self.fetchNews()
            self.fetchOrders()
        }
    }
    
    // MARK: - User Management
    
    func login(email: String, password: String) {
        isLoading = true
        
        // Здесь будет реальная аутентификация
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let user = AppModels.User(
                name: "Тестовый пользователь",
                email: email,
                phone: email // Используем email как телефон, так как в AuthView мы передаем телефон в качестве email
            )
            
            self.currentUser = user
            self.isAuthenticated = true
            self.isLoading = false
            self.saveUser()
            
            // Устанавливаем вкладку профиля после успешного входа
            self.selectedTab = .profile
        }
    }
    
    func register(name: String, email: String, phone: String, password: String) {
        isLoading = true
        
        // Здесь будет реальная регистрация
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let user = AppModels.User(
                name: name,
                email: email,
                phone: phone
            )
            
            self.currentUser = user
            self.isAuthenticated = true
            self.isLoading = false
            self.saveUser()
        }
    }
    
    func loginAsGuest() {
        isLoading = true
        
        // Здесь будет создание гостевого аккаунта
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let user = AppModels.User(
                name: "Гость",
                email: "guest@example.com",
                phone: ""
            )
            
            self.currentUser = user
            self.isAuthenticated = true
            self.isLoading = false
            self.saveUser()
        }
    }
    
    func logout() {
        currentUser = nil
        isAuthenticated = false
        userDefaults.removeObject(forKey: userKey)
    }
    
    func deleteAccount() {
        logout()
    }
    
    // MARK: - Profile Management
    
    func updateProfile(name: String, email: String, phone: String) {
        guard var user = currentUser else { return }
        
        user.name = name
        user.email = email
        user.phone = phone
        
        currentUser = user
        saveUser()
    }
    
    func updateProfileImage(_ imageURL: String) {
        guard var user = currentUser else { return }
        user.profileImage = imageURL
        currentUser = user
        saveUser()
    }
    
    // MARK: - Loyalty Program
    
    func addLoyaltyPoints(_ points: Int) {
        guard var user = currentUser else { return }
        user.loyaltyProgram.points += points
        currentUser = user
        saveUser()
    }
    
    func spendLoyaltyPoints(_ points: Int) {
        guard var user = currentUser else { return }
        user.loyaltyProgram.points -= points
        currentUser = user
        saveUser()
    }
    
    // MARK: - Favorites
    
    func toggleFavorite(_ restaurantId: String) {
        guard var user = currentUser else { return }
        
        if user.favoriteRestaurants.contains(restaurantId) {
            user.favoriteRestaurants.removeAll { $0 == restaurantId }
        } else {
            user.favoriteRestaurants.append(restaurantId)
        }
        
        currentUser = user
        saveUser()
    }
    
    func updateFavorites(_ restaurantIds: [String]) {
        guard var user = currentUser else { return }
        user.favoriteRestaurants = restaurantIds
        currentUser = user
        saveUser()
    }
    
    // MARK: - View History
    
    func addToViewHistory(_ restaurantId: String?) {
        guard var user = currentUser else { return }
        
        let viewHistory = AppModels.ViewHistory(restaurantId: restaurantId)
        user.recentViews.append(viewHistory)
        
        // Ограничиваем историю последними 10 просмотрами
        if user.recentViews.count > 10 {
            user.recentViews.removeFirst()
        }
        
        currentUser = user
        saveUser()
    }
    
    func updateViewHistory(_ history: [AppModels.ViewHistory]) {
        guard var user = currentUser else { return }
        user.recentViews = history
        currentUser = user
        saveUser()
    }
    
    // MARK: - Notification Settings
    
    func updateNotificationSettings(_ settings: AppModels.NotificationSettings) {
        guard var user = currentUser else { return }
        user.notifications = settings
        currentUser = user
        saveUser()
    }
    
    // MARK: - Payment Methods
    
    func updatePaymentMethods(_ methods: [AppModels.PaymentMethod]) {
        guard var user = currentUser else { return }
        user.paymentMethods = methods
        currentUser = user
        saveUser()
    }
    
    // MARK: - Restaurant Management
    
    func fetchRestaurants() {
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
                longitude: 37.622504
            )
            
            self.restaurants = [sampleRestaurant]
            self.isLoading = false
        }
    }
    
    // MARK: - Cart Management
    
    func addToCart(_ item: AppModels.CartItem) {
        if let index = cartItems.firstIndex(where: { $0.menuItem.id == item.menuItem.id }) {
            cartItems[index].quantity += item.quantity
        } else {
            cartItems.append(item)
        }
    }
    
    func removeFromCart(_ item: AppModels.CartItem) {
        cartItems.removeAll { $0.menuItem.id == item.menuItem.id }
    }
    
    func updateCartItemQuantity(_ item: AppModels.CartItem, quantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.menuItem.id == item.menuItem.id }) {
            if quantity > 0 {
                cartItems[index].quantity = quantity
            } else {
                cartItems.remove(at: index)
            }
        }
    }
    
    func clearCart() {
        cartItems.removeAll()
    }
    
    func checkout(totalAmount: Double, paymentMethod: AppModels.PaymentMethod) {
        // Здесь будет логика оформления заказа
        clearCart()
    }
    
    // MARK: - News Management
    
    func fetchNews() {
        // Здесь будет реальный запрос к API
        let sampleNews = [
            AppModels.News(
                id: "1",
                title: "Новое пиво в меню",
                content: "Мы добавили новое крафтовое пиво в наше меню!",
                date: Date(),
                imageURL: "news1",
                type: .beer
            ),
            AppModels.News(
                id: "2",
                title: "Специальное предложение",
                content: "Скидка 20% на все заказы в выходные!",
                date: Date(),
                imageURL: "news2",
                type: .promotion
            )
        ]
        newsItems = sampleNews
    }
    
    func fetchSampleNews() {
        // Здесь будет логика загрузки новостей
        news = [
            AppModels.News(
                id: "1",
                title: "Новое крафтовое пиво",
                content: "Мы рады представить вам наше новое крафтовое пиво с уникальным вкусом и ароматом.",
                date: Date(),
                imageURL: "beer",
                type: .beer
            ),
            AppModels.News(
                id: "2",
                title: "Акция на доставку",
                content: "При заказе от 2000₽ доставка бесплатно!",
                date: Date(),
                imageURL: "delivery",
                type: .promotion
            )
        ]
    }
    
    // MARK: - Order Management
    
    func fetchOrders() {
        // Здесь будет реальный запрос к API
        let sampleOrders = [
            AppModels.Order(
                id: "1",
                restaurantId: "1",
                items: [],
                totalAmount: 1000,
                date: Date(),
                status: .pending,
                paymentMethod: AppModels.PaymentMethod(
                    type: .creditCard,
                    lastFourDigits: "1234",
                    expiryDate: Date(),
                    isDefault: true
                )
            )
        ]
        orders = sampleOrders
    }
    
    func cancelOrder(_ order: AppModels.Order) {
        if let index = orders.firstIndex(where: { $0.id == order.id }) {
            var updatedOrder = order
            updatedOrder.status = .cancelled
            orders[index] = updatedOrder
        }
    }
    
    // MARK: - Private Methods
    
    private func loadUser() {
        if let data = userDefaults.data(forKey: userKey),
           let user = try? JSONDecoder().decode(AppModels.User.self, from: data) {
            DispatchQueue.main.async {
                self.currentUser = user
                self.isAuthenticated = true
            }
        }
    }
    
    private func saveUser() {
        if let user = currentUser,
           let encoded = try? JSONEncoder().encode(user) {
            userDefaults.set(encoded, forKey: userKey)
        }
    }
} 