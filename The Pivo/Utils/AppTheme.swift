import SwiftUI

struct AppTheme {
    struct Colors {
        static let gold = Color(red: 212/255, green: 175/255, blue: 55/255)
        static let darkGold = Color(red: 0.7, green: 0.55, blue: 0.3)
        static let lightBeige = Color(red: 245/255, green: 245/255, blue: 220/255)
        static let darkGray = Color(red: 28/255, green: 28/255, blue: 30/255)
        static let darkBrown = Color(red: 51/255, green: 25/255, blue: 0/255)
        static let amber = Color(red: 0.89, green: 0.60, blue: 0.0)
        static let warmRed = Color(red: 220/255, green: 53/255, blue: 69/255)
        
        static let foamWhite = Color(red: 0.98, green: 0.98, blue: 0.96)
        static let hopGreen = Color(red: 0.20, green: 0.50, blue: 0.25)
        static let maltBrown = Color(red: 0.55, green: 0.30, blue: 0.15)
        
        static let success = Color(red: 0.20, green: 0.60, blue: 0.25)
        static let warning = Color(red: 0.90, green: 0.55, blue: 0.0)
        static let error = Color(red: 0.85, green: 0.10, blue: 0.10)
        
        static let backgroundPrimary = Color.black
        static let backgroundSecondary = Color(red: 0.10, green: 0.10, blue: 0.10)
        static let textPrimary = lightBeige
        static let textSecondary = Color(red: 0.75, green: 0.75, blue: 0.75)
        
        // Дополнительные цвета
        static let red = Color(red: 255/255, green: 59/255, blue: 48/255)
        static let redLight = Color(red: 255/255, green: 59/255, blue: 48/255).opacity(0.8)
        static let redDark = Color(red: 215/255, green: 50/255, blue: 40/255)
        
        static let goldLight = Color(red: 212/255, green: 175/255, blue: 55/255).opacity(0.8)
        static let goldDark = Color(red: 180/255, green: 150/255, blue: 45/255)
        
        // Цвета для темной темы
        static let dark = Color(red: 28/255, green: 28/255, blue: 30/255)
        static let darkLight = Color(red: 44/255, green: 44/255, blue: 46/255)
        static let darkDark = Color(red: 20/255, green: 20/255, blue: 22/255)
        
        // Градиенты
        static let goldGradient = LinearGradient(
            gradient: Gradient(colors: [Colors.gold, Colors.darkGold]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        static let darkBackgroundGradient = LinearGradient(
            gradient: Gradient(colors: [Colors.backgroundPrimary, Colors.backgroundSecondary]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        // Функция для создания радиального градиента с золотым оттенком
        static func goldenRadialGradient(center: UnitPoint = .topLeading) -> RadialGradient {
            return RadialGradient(
                gradient: Gradient(colors: [Colors.gold.opacity(0.4), Color.black.opacity(0)]),
                center: center,
                startRadius: 50,
                endRadius: 300
            )
        }
        
        // Цвета для статусов бронирования
        static let pendingColor = Color.orange
        static let confirmedColor = Color.green
        static let completedColor = Color.blue
        static let cancelledColor = Color.red
    }
    
    struct Typography {
        static let title = Font.system(size: 24, weight: .bold)
        static let titleSmall = Font.system(size: 20, weight: .bold)
        static let titleLarge = Font.system(size: 28, weight: .bold)
        
        static let heading = Font.system(size: 18, weight: .semibold)
        static let headingSmall = Font.system(size: 16, weight: .semibold)
        static let headingLarge = Font.system(size: 22, weight: .semibold)
        
        static let body = Font.system(size: 16)
        static let bodySmall = Font.system(size: 14)
        static let bodyLarge = Font.system(size: 18)
        
        static let bodyBold = Font.system(size: 16, weight: .bold)
        static let bodyBoldSmall = Font.system(size: 14, weight: .bold)
        static let bodyBoldLarge = Font.system(size: 18, weight: .bold)
        
        static let button = Font.system(size: 16, weight: .medium)
        static let buttonSmall = Font.system(size: 14, weight: .medium)
        static let buttonLarge = Font.system(size: 18, weight: .medium)
    }
    
    struct Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
    }
} 