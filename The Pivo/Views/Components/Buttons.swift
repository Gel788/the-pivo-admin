import SwiftUI

// MARK: - Стили кнопок
extension View {
    func primaryButtonStyle() -> some View {
        self
            .font(AppTheme.Typography.button)
            .foregroundColor(.black)
            .padding(.horizontal, AppTheme.Spacing.medium)
            .padding(.vertical, AppTheme.Spacing.small)
            .background(AppTheme.Colors.gold)
            .cornerRadius(20)
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .font(AppTheme.Typography.button)
            .foregroundColor(AppTheme.Colors.gold)
            .padding(.horizontal, AppTheme.Spacing.medium)
            .padding(.vertical, AppTheme.Spacing.small)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(AppTheme.Colors.gold, lineWidth: 1)
            )
    }
}

// MARK: - Основная кнопка
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .primaryButtonStyle()
        }
    }
}

// MARK: - Вторичная кнопка
struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .secondaryButtonStyle()
        }
    }
}

// MARK: - Кнопка с иконкой
struct IconButton: View {
    let systemName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .foregroundColor(AppTheme.Colors.gold)
                .font(.system(size: 20))
        }
    }
}

// MARK: - Кнопка фильтра
struct CustomFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Typography.body)
                .foregroundColor(isSelected ? .black : AppTheme.Colors.gold)
                .padding(.horizontal, AppTheme.Spacing.medium)
                .padding(.vertical, AppTheme.Spacing.small)
                .background(isSelected ? AppTheme.Colors.gold : Color.clear)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppTheme.Colors.gold, lineWidth: 1)
                )
        }
    }
}

// MARK: - Кнопка "Назад"
struct BackButton: View {
    let action: () -> Void
    
    var body: some View {
        IconButton(systemName: "chevron.left", action: action)
    }
}

// MARK: - Кнопка "Закрыть"
struct CloseButton: View {
    let action: () -> Void
    
    var body: some View {
        IconButton(systemName: "xmark", action: action)
    }
}

// MARK: - Кнопка "Поделиться"
struct ShareButton: View {
    let action: () -> Void
    
    var body: some View {
        IconButton(systemName: "square.and.arrow.up", action: action)
    }
}

// MARK: - Кнопка "В избранное"
struct FavoriteButton: View {
    let isFavorite: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? AppTheme.Colors.red : AppTheme.Colors.gold)
                .font(.system(size: 20))
        }
    }
} 