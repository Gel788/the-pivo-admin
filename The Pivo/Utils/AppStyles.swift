import SwiftUI

// MARK: - Основные константы стиля
enum AppStyle {
    static let cornerRadius: CGFloat = 16
    static let smallCornerRadius: CGFloat = 10
    static let standardPadding: CGFloat = 16
    static let smallPadding: CGFloat = 8
    static let largePadding: CGFloat = 24
    
    static let cardShadow: Shadow = Shadow(
        color: Color.black.opacity(0.2),
        radius: 10,
        x: 0,
        y: 5
    )
    
    static let buttonShadow: Shadow = Shadow(
        color: Color.black.opacity(0.3),
        radius: 8,
        x: 0,
        y: 4
    )
    
    // Анимации
    static let standardAnimation: Animation = .spring(response: 0.3, dampingFraction: 0.7)
    
    // Размеры компонентов
    static let cardHeight: CGFloat = 200
    static let avatarSize: CGFloat = 56
}

// MARK: - Расширения для стиля текста
extension Text {
    func titleStyle() -> some View {
        self.font(.system(size: 24, weight: .bold))
            .foregroundColor(.primary)
    }
    
    func headlineStyle() -> some View {
        self.font(.system(size: 20, weight: .semibold))
            .foregroundColor(.primary)
    }
    
    func subheadlineStyle() -> some View {
        self.font(.system(size: 16))
            .foregroundColor(.primary)
    }
    
    func captionStyle() -> some View {
        self.font(.system(size: 14))
            .foregroundColor(.secondary)
    }
    
    func badgeStyle() -> some View {
        self.font(.system(size: 14))
            .foregroundColor(.black)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(AppTheme.Colors.gold)
            .cornerRadius(12)
    }
}

// MARK: - Расширения для View
extension View {
    // Стиль для кнопок
    func buttonStyle() -> some View {
        self
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(AppTheme.Colors.gold)
            .cornerRadius(20)
    }
    
    // Стиль для полей ввода
    func inputStyle() -> some View {
        self
            .font(.system(size: 16))
            .foregroundColor(.primary)
            .padding(16)
            .background(AppTheme.Colors.lightBeige)
            .cornerRadius(10)
    }
    
    // Стиль для меток
    func labelStyle() -> some View {
        self
            .font(.system(size: 14))
            .foregroundColor(.secondary)
    }
    
    // Стиль для ошибок
    func errorStyle() -> some View {
        self
            .font(.system(size: 14))
            .foregroundColor(.red)
    }
    
    // Стиль для успешных сообщений
    func successStyle() -> some View {
        self
            .font(.system(size: 14))
            .foregroundColor(AppTheme.Colors.gold)
    }
    
    // Стиль для ссылок
    func linkStyle() -> some View {
        self
            .font(.system(size: 16))
            .foregroundColor(AppTheme.Colors.gold)
    }
    
    // Стиль для разделителей
    func dividerStyle() -> some View {
        self
            .frame(height: 1)
            .background(AppTheme.Colors.lightBeige)
    }
    
    // Стиль для бейджей
    func badgeStyle() -> some View {
        self
            .font(.system(size: 14))
            .foregroundColor(.black)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(AppTheme.Colors.gold)
            .cornerRadius(12)
    }
    
    // Стиль для табов
    func tabStyle(isSelected: Bool) -> some View {
        self
            .font(.system(size: 16))
            .foregroundColor(isSelected ? AppTheme.Colors.gold : Color.secondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
    }
    
    // Стиль компактной карточки
    func compactCardStyle() -> some View {
        self.padding(8)
            .background(Color.black.opacity(0.3))
            .cornerRadius(AppStyle.smallCornerRadius)
            .shadow(
                color: AppStyle.cardShadow.color,
                radius: AppStyle.cardShadow.radius / 2,
                x: AppStyle.cardShadow.x,
                y: AppStyle.cardShadow.y / 2
            )
    }
    
    // Стиль фоторамки
    func photoFrameStyle(height: CGFloat = 180) -> some View {
        self.frame(maxWidth: .infinity)
            .frame(height: height)
            .clipped()
            .cornerRadius(AppStyle.cornerRadius)
    }
    
    // Градиентный оверлей для карточек с фото
    func darkGradientOverlay() -> some View {
        self.overlay(
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(AppStyle.cornerRadius)
        )
    }
    
    // Стиль заголовка секции
    func sectionHeaderStyle() -> some View {
        self
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(AppTheme.Colors.lightBeige)
            .padding(.vertical, 16)
    }
    
    // Стиль описания
    func descriptionStyle() -> some View {
        self
            .font(.system(size: 16))
            .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
    }
    
    // Стиль цены
    func priceStyle() -> some View {
        self
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(AppTheme.Colors.gold)
    }
    
    // Стиль рейтинга
    func ratingStyle() -> some View {
        self
            .font(.system(size: 16))
            .foregroundColor(AppTheme.Colors.lightBeige)
    }
    
    // Стиль тега
    func tagStyle() -> some View {
        self
            .font(.system(size: 14))
            .foregroundColor(AppTheme.Colors.gold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(AppTheme.Colors.gold.opacity(0.1)))
            .cornerRadius(15)
    }
    
    // Стиль даты
    func dateStyle() -> some View {
        self
            .font(.system(size: 14))
            .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
    }
    
    // Стиль статуса
    func statusStyle(isActive: Bool) -> some View {
        self
            .font(.system(size: 14))
            .foregroundColor(isActive ? AppTheme.Colors.gold : Color.red)
    }
    
    // Стиль количества
    func quantityStyle() -> some View {
        self
            .font(.system(size: 16))
            .foregroundColor(AppTheme.Colors.lightBeige)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.black.opacity(0.3))
            .cornerRadius(15)
    }
}

// MARK: - Вспомогательные модели
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - ViewModifiers
struct PulsateEffect: ViewModifier {
    @State private var pulsate = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(pulsate ? 1.04 : 1.0)
            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulsate)
            .onAppear {
                pulsate = true
            }
    }
}

extension View {
    func pulsateEffect() -> some View {
        self.modifier(PulsateEffect())
    }
} 