# Интеграция мобильного приложения с сервером

## 1. Сетевой слой

### 1.1 API Клиент
```swift
class APIClient {
    static let shared = APIClient()
    private let baseURL = "https://api.thepivo.ru"
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 300
        session = URLSession(configuration: configuration)
    }
    
    func request<T: Codable>(_ endpoint: APIEndpoint) async throws -> T {
        // Реализация запросов
    }
}
```

### 1.2 Endpoints
```swift
enum APIEndpoint {
    case restaurants
    case restaurant(id: String)
    case menu(restaurantId: String)
    case reservations
    case reservation(id: String)
    case news
    case newsItem(id: String)
    
    var path: String {
        switch self {
        case .restaurants:
            return "/api/restaurants"
        case .restaurant(let id):
            return "/api/restaurants/\(id)"
        // ... остальные case
        }
    }
}
```

### 1.3 Модели данных
```swift
struct Restaurant: Codable {
    let id: String
    let name: String
    let description: String
    // ... остальные поля
}

struct MenuItem: Codable {
    let id: String
    let name: String
    let price: Double
    // ... остальные поля
}

struct Reservation: Codable {
    let id: String
    let restaurantId: String
    let date: Date
    // ... остальные поля
}
```

## 2. Кэширование

### 2.1 Core Data
```swift
class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ThePivo")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
```

### 2.2 UserDefaults
```swift
class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    func saveToken(_ token: String) {
        defaults.set(token, forKey: "authToken")
    }
    
    func getToken() -> String? {
        return defaults.string(forKey: "authToken")
    }
}
```

## 3. WebSocket

### 3.1 WebSocket Manager
```swift
class WebSocketManager {
    static let shared = WebSocketManager()
    private var webSocket: URLSessionWebSocketTask?
    
    func connect() {
        let url = URL(string: "wss://api.thepivo.ru/ws")!
        let session = URLSession(configuration: .default)
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
        receiveMessage()
    }
    
    private func receiveMessage() {
        webSocket?.receive { [weak self] result in
            switch result {
            case .success(let message):
                self?.handleMessage(message)
            case .failure(let error):
                print("WebSocket error: \(error)")
            }
        }
    }
    
    private func handleMessage(_ message: URLSessionWebSocketTask.Message) {
        // Обработка сообщений
    }
}
```

## 4. Обработка ошибок

### 4.1 NetworkError
```swift
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    case unauthorized
    case noInternet
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Неверный URL"
        case .noData:
            return "Нет данных"
        // ... остальные case
        }
    }
}
```

### 4.2 ErrorHandler
```swift
class ErrorHandler {
    static let shared = ErrorHandler()
    
    func handle(_ error: Error) {
        if let networkError = error as? NetworkError {
            handleNetworkError(networkError)
        } else {
            handleGeneralError(error)
        }
    }
    
    private func handleNetworkError(_ error: NetworkError) {
        // Обработка сетевых ошибок
    }
    
    private func handleGeneralError(_ error: Error) {
        // Обработка общих ошибок
    }
}
```

## 5. Аутентификация

### 5.1 AuthManager
```swift
class AuthManager {
    static let shared = AuthManager()
    
    func login(email: String, password: String) async throws -> AuthResponse {
        let endpoint = APIEndpoint.login(email: email, password: password)
        return try await APIClient.shared.request(endpoint)
    }
    
    func refreshToken() async throws {
        guard let refreshToken = UserDefaultsManager.shared.getRefreshToken() else {
            throw AuthError.noRefreshToken
        }
        let endpoint = APIEndpoint.refreshToken(token: refreshToken)
        let response: AuthResponse = try await APIClient.shared.request(endpoint)
        UserDefaultsManager.shared.saveTokens(response)
    }
}
```

## 6. Синхронизация данных

### 6.1 SyncManager
```swift
class SyncManager {
    static let shared = SyncManager()
    
    func syncRestaurants() async throws {
        let restaurants: [Restaurant] = try await APIClient.shared.request(.restaurants)
        await MainActor.run {
            CoreDataManager.shared.saveRestaurants(restaurants)
        }
    }
    
    func syncReservations() async throws {
        let reservations: [Reservation] = try await APIClient.shared.request(.reservations)
        await MainActor.run {
            CoreDataManager.shared.saveReservations(reservations)
        }
    }
}
```

## 7. Офлайн режим

### 7.1 OfflineManager
```swift
class OfflineManager {
    static let shared = OfflineManager()
    
    func checkConnectivity() -> Bool {
        // Проверка подключения к интернету
    }
    
    func syncPendingChanges() async {
        // Синхронизация изменений при восстановлении соединения
    }
}
```

## 8. Мониторинг

### 8.1 Analytics
```swift
class Analytics {
    static let shared = Analytics()
    
    func trackEvent(_ event: AnalyticsEvent) {
        // Отправка аналитики
    }
    
    func trackError(_ error: Error) {
        // Отправка информации об ошибках
    }
}
```

## 9. Тестирование

### 9.1 Network Tests
```swift
class NetworkTests: XCTestCase {
    func testRestaurantFetch() async throws {
        let restaurants: [Restaurant] = try await APIClient.shared.request(.restaurants)
        XCTAssertFalse(restaurants.isEmpty)
    }
    
    func testReservationCreation() async throws {
        let reservation = ReservationRequest(...)
        let response: Reservation = try await APIClient.shared.request(.createReservation(reservation))
        XCTAssertNotNil(response.id)
    }
}
```

### 9.2 Mock Data
```swift
struct MockData {
    static let restaurants: [Restaurant] = [
        Restaurant(id: "1", name: "The Pivo", ...),
        // ... другие рестораны
    ]
    
    static let menuItems: [MenuItem] = [
        MenuItem(id: "1", name: "Пиво", price: 250, ...),
        // ... другие позиции
    ]
}
``` 