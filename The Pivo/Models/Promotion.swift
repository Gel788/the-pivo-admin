import Foundation

struct Promotion: Identifiable {
    let id: String
    let title: String
    let description: String
    let imageURL: String?
    let startDate: Date
    let endDate: Date?
    let discountAmount: Double?
    let discountPercentage: Double?
    let promoCode: String?
    var isActive: Bool = true
    
    static let samplePromotions: [Promotion] = [
        Promotion(
            id: "1",
            title: "Скидка 20% на все сорта IPA",
            description: "Получите скидку 20% на все индийские светлые эли в нашем баре при заказе через приложение.",
            imageURL: "promo_1",
            startDate: Date().addingTimeInterval(-86400 * 7),
            endDate: Date().addingTimeInterval(86400 * 14),
            discountAmount: nil,
            discountPercentage: 20,
            promoCode: "IPA20",
            isActive: true
        ),
        Promotion(
            id: "2",
            title: "Счастливые часы",
            description: "С понедельника по четверг с 17:00 до 19:00 все напитки со скидкой 30%.",
            imageURL: "promo_2",
            startDate: Date().addingTimeInterval(-86400 * 14),
            endDate: nil,
            discountAmount: nil,
            discountPercentage: 30,
            promoCode: nil,
            isActive: true
        ),
        Promotion(
            id: "3",
            title: "500 ₽ за первый заказ",
            description: "Получите скидку 500 ₽ на ваш первый заказ через наше приложение.",
            imageURL: "promo_3",
            startDate: Date(),
            endDate: Date().addingTimeInterval(86400 * 30),
            discountAmount: 500,
            discountPercentage: nil,
            promoCode: "FIRST500",
            isActive: true
        )
    ]
} 