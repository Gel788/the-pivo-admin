import Foundation
import SwiftUI

enum AppModels {
    // MARK: - User Model
    struct User: Identifiable, Codable {
        let id: String
        var name: String
        var email: String
        var phone: String
        var profileImage: String?
        var dateOfBirth: Date?
        var loyaltyProgram: LoyaltyProgram
        var favoriteRestaurants: [String]
        var recentViews: [ViewHistory]
        var notifications: NotificationSettings
        var paymentMethods: [PaymentMethod]
        
        init(id: String = UUID().uuidString,
             name: String,
             email: String,
             phone: String,
             profileImage: String? = nil,
             dateOfBirth: Date? = nil,
             loyaltyProgram: LoyaltyProgram = LoyaltyProgram(),
             favoriteRestaurants: [String] = [],
             recentViews: [ViewHistory] = [],
             notifications: NotificationSettings = NotificationSettings(),
             paymentMethods: [PaymentMethod] = []) {
            self.id = id
            self.name = name
            self.email = email
            self.phone = phone
            self.profileImage = profileImage
            self.dateOfBirth = dateOfBirth
            self.loyaltyProgram = loyaltyProgram
            self.favoriteRestaurants = favoriteRestaurants
            self.recentViews = recentViews
            self.notifications = notifications
            self.paymentMethods = paymentMethods
        }
    }
    
    // MARK: - Notification Settings
    struct NotificationSettings: Codable {
        var reservationReminders: Bool
        var specialOffers: Bool
        var newsUpdates: Bool
        var loyaltyUpdates: Bool
        
        init(reservationReminders: Bool = true,
             specialOffers: Bool = true,
             newsUpdates: Bool = true,
             loyaltyUpdates: Bool = true) {
            self.reservationReminders = reservationReminders
            self.specialOffers = specialOffers
            self.newsUpdates = newsUpdates
            self.loyaltyUpdates = loyaltyUpdates
        }
    }
    
    // MARK: - Payment Method
    struct PaymentMethod: Identifiable, Codable {
        let id: String
        var type: PaymentType
        var lastFourDigits: String
        var expiryDate: Date
        var isDefault: Bool
        
        init(id: String = UUID().uuidString,
             type: PaymentType,
             lastFourDigits: String,
             expiryDate: Date,
             isDefault: Bool = false) {
            self.id = id
            self.type = type
            self.lastFourDigits = lastFourDigits
            self.expiryDate = expiryDate
            self.isDefault = isDefault
        }
    }
    
    enum PaymentType: String, Codable {
        case creditCard
        case debitCard
        case applePay
        case googlePay
        
        var iconName: String {
            switch self {
            case .creditCard:
                return "creditcard"
            case .debitCard:
                return "creditcard.fill"
            case .applePay:
                return "apple.logo"
            case .googlePay:
                return "g.circle.fill"
            }
        }
    }
    
    // MARK: - View History
    struct ViewHistory: Identifiable, Codable {
        let id: String
        let restaurantId: String?
        let timestamp: Date
        let duration: TimeInterval
        
        init(id: String = UUID().uuidString,
             restaurantId: String?,
             timestamp: Date = Date(),
             duration: TimeInterval = 0) {
            self.id = id
            self.restaurantId = restaurantId
            self.timestamp = timestamp
            self.duration = duration
        }
    }
    
    // MARK: - Loyalty Program
    struct LoyaltyProgram: Codable {
        var points: Int
        var level: LoyaltyLevel
        var transactions: [LoyaltyTransaction]
        
        init(points: Int = 0,
             level: LoyaltyLevel = .bronze,
             transactions: [LoyaltyTransaction] = []) {
            self.points = points
            self.level = level
            self.transactions = transactions
        }
    }
    
    enum LoyaltyLevel: String, Codable {
        case bronze
        case silver
        case gold
        case platinum
        
        var requiredPoints: Int {
            switch self {
            case .bronze: return 0
            case .silver: return 1000
            case .gold: return 5000
            case .platinum: return 10000
            }
        }
        
        var discount: Double {
            switch self {
            case .bronze: return 0.05
            case .silver: return 0.10
            case .gold: return 0.15
            case .platinum: return 0.20
            }
        }
        
        var benefits: [String] {
            switch self {
            case .bronze:
                return [
                    "Скидка 5% на все заказы",
                    "Бесплатная доставка при заказе от 2000₽",
                    "Доступ к базовым акциям"
                ]
            case .silver:
                return [
                    "Скидка 10% на все заказы",
                    "Бесплатная доставка при заказе от 1500₽",
                    "Доступ к расширенным акциям",
                    "Приоритетное обслуживание"
                ]
            case .gold:
                return [
                    "Скидка 15% на все заказы",
                    "Бесплатная доставка при любом заказе",
                    "Доступ ко всем акциям",
                    "Приоритетное обслуживание",
                    "Персональный менеджер"
                ]
            case .platinum:
                return [
                    "Скидка 20% на все заказы",
                    "Бесплатная доставка при заказе от 1000₽",
                    "Доступ ко всем акциям",
                    "Приоритетное обслуживание",
                    "Персональный менеджер"
                ]
            }
        }
    }
    
    struct LoyaltyTransaction: Identifiable, Codable {
        let id: String
        let type: LoyaltyTransactionType
        let points: Int
        let timestamp: Date
        let description: String
        
        init(id: String = UUID().uuidString,
             type: LoyaltyTransactionType,
             points: Int,
             timestamp: Date = Date(),
             description: String) {
            self.id = id
            self.type = type
            self.points = points
            self.timestamp = timestamp
            self.description = description
        }
    }
    
    enum LoyaltyTransactionType: String, Codable {
        case earned
        case spent
        case expired
        case bonus
        
        var iconName: String {
            switch self {
            case .earned:
                return "plus.circle.fill"
            case .spent:
                return "minus.circle.fill"
            case .expired:
                return "xmark.circle.fill"
            case .bonus:
                return "star.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .earned, .bonus:
                return .green
            case .spent:
                return .red
            case .expired:
                return .gray
            }
        }
        
        var pointsPrefix: String {
            switch self {
            case .earned, .bonus:
                return "+"
            case .spent, .expired:
                return "-"
            }
        }
    }
    
    // MARK: - Restaurant Model
    struct Restaurant: Identifiable, Codable {
        let id: String
        let name: String
        let description: String
        let address: String
        let phone: String
        let email: String
        let website: String
        let hours: String
        let imageURL: String
        let menu: [MenuItem]
        let type: String
        let features: [String]
        let latitude: Double
        let longitude: Double
        let reservationCostPerPerson: Double
        
        init(id: String = UUID().uuidString,
             name: String,
             description: String,
             address: String,
             phone: String,
             email: String,
             website: String,
             hours: String,
             imageURL: String,
             menu: [MenuItem] = [],
             type: String,
             features: [String] = [],
             latitude: Double,
             longitude: Double,
             reservationCostPerPerson: Double = 500.0) {
            self.id = id
            self.name = name
            self.description = description
            self.address = address
            self.phone = phone
            self.email = email
            self.website = website
            self.hours = hours
            self.imageURL = imageURL
            self.menu = menu
            self.type = type
            self.features = features
            self.latitude = latitude
            self.longitude = longitude
            self.reservationCostPerPerson = reservationCostPerPerson
        }
    }
    
    // MARK: - Menu Item Model
    struct MenuItem: Identifiable, Codable, Hashable {
        let id: String
        let name: String
        let description: String
        let price: Double
        let imageURL: String
        let category: MenuCategory
        let abv: Double?
        let ibu: Int?
        
        init(id: String = UUID().uuidString,
             name: String,
             description: String,
             price: Double,
             imageURL: String,
             category: MenuCategory,
             abv: Double? = nil,
             ibu: Int? = nil) {
            self.id = id
            self.name = name
            self.description = description
            self.price = price
            self.imageURL = imageURL
            self.category = category
            self.abv = abv
            self.ibu = ibu
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    enum MenuCategory: String, Codable, CaseIterable {
        case beer
        case snacks
        case main
        case dessert
        case drinks
    }
    
    // MARK: - Cart Item Model
    struct CartItem: Identifiable, Codable {
        let id: String
        let menuItem: MenuItem
        var quantity: Int
        
        init(id: String = UUID().uuidString,
             menuItem: MenuItem,
             quantity: Int = 1) {
            self.id = id
            self.menuItem = menuItem
            self.quantity = quantity
        }
    }
    
    // MARK: - Reservation Model
    struct Reservation: Identifiable, Codable {
        let id: String
        let restaurantId: String
        let restaurantName: String
        let date: Date
        let time: String
        let numberOfGuests: Int
        let status: ReservationStatus
        let specialRequests: String?
        let selectedMenuItems: [MenuItem]
        
        init(id: String = UUID().uuidString,
             restaurantId: String,
             restaurantName: String,
             date: Date,
             time: String,
             numberOfGuests: Int,
             status: ReservationStatus = .pending,
             specialRequests: String? = nil,
             selectedMenuItems: [MenuItem] = []) {
            self.id = id
            self.restaurantId = restaurantId
            self.restaurantName = restaurantName
            self.date = date
            self.time = time
            self.numberOfGuests = numberOfGuests
            self.status = status
            self.specialRequests = specialRequests
            self.selectedMenuItems = selectedMenuItems
        }
    }
    
    enum ReservationStatus: String, Codable, CaseIterable {
        case pending = "Ожидает подтверждения"
        case confirmed = "Подтверждено"
        case cancelled = "Отменено"
        case completed = "Завершено"
        
        var color: Color {
            switch self {
            case .pending:
                return .orange
            case .confirmed:
                return .blue
            case .completed:
                return .green
            case .cancelled:
                return .red
            }
        }
        
        var localizedString: String {
            return self.rawValue
        }
    }
    
    // MARK: - Cart and Order Models
    struct Order: Identifiable, Codable {
        let id: String
        let restaurantId: String
        let items: [CartItem]
        let totalAmount: Double
        let date: Date
        let createdAt: Date
        var status: OrderStatus
        let paymentMethod: PaymentMethod
        
        init(id: String = UUID().uuidString,
             restaurantId: String,
             items: [CartItem],
             totalAmount: Double,
             date: Date = Date(),
             createdAt: Date = Date(),
             status: OrderStatus = .pending,
             paymentMethod: PaymentMethod) {
            self.id = id
            self.restaurantId = restaurantId
            self.items = items
            self.totalAmount = totalAmount
            self.date = date
            self.createdAt = createdAt
            self.status = status
            self.paymentMethod = paymentMethod
        }
    }
    
    enum OrderStatus: String, Codable {
        case pending
        case confirmed
        case inProgress
        case readyForPickup
        case preparing
        case ready
        case delivered
        case completed
        case cancelled
        
        var color: Color {
            switch self {
            case .pending:
                return .orange
            case .confirmed:
                return .blue
            case .inProgress:
                return .purple
            case .readyForPickup:
                return .green
            case .preparing:
                return .blue
            case .ready:
                return .green
            case .delivered:
                return .purple
            case .completed:
                return .green
            case .cancelled:
                return .red
            }
        }
    }
    
    // MARK: - News Model
    struct News: Identifiable, Codable {
        let id: String
        let title: String
        let content: String
        let date: Date
        let imageURL: String?
        let type: NewsType
    }
    
    enum NewsType: String, Codable {
        case news
        case event
        case promotion
        case beer
    }
    
    // MARK: - Menu Item With Quantity
    struct MenuItemWithQuantity: Identifiable {
        let id: String
        let menuItem: MenuItem
        var quantity: Int
    }
} 