import SwiftUI

// MARK: - Индикатор загрузки
struct LoadingIndicator: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.gold))
            .scaleEffect(1.5)
    }
}

// MARK: - Сообщение об ошибке
struct ErrorMessage: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(AppTheme.Colors.red)
            
            Text(message)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.lightBeige)
                .multilineTextAlignment(.center)
            
            Button("Повторить") {
                retryAction()
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.Colors.gold)
        }
        .padding(AppTheme.Spacing.large)
    }
}

// MARK: - Пустое состояние
struct EmptyStateView: View {
    let title: String
    let message: String
    let actionTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            Image(systemName: "tray")
                .font(.system(size: 50))
                .foregroundColor(AppTheme.Colors.gold)
            
            Text(title)
                .font(AppTheme.Typography.title)
                .foregroundColor(AppTheme.Colors.lightBeige)
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button(action: action) {
                Text(actionTitle)
                    .font(AppTheme.Typography.button)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppTheme.Colors.gold)
                    .cornerRadius(10)
            }
        }
        .padding(AppTheme.Spacing.large)
    }
}

// MARK: - Состояние загрузки
struct LoadingView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(AppTheme.Colors.gold)
            
            Text(message)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.lightBeige)
        }
        .padding(AppTheme.Spacing.large)
    }
}

// MARK: - Состояние ошибки
struct ErrorView: View {
    let title: String
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(AppTheme.Colors.red)
            
            Text(title)
                .font(AppTheme.Typography.title)
                .foregroundColor(AppTheme.Colors.lightBeige)
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button(action: retryAction) {
                Text("Повторить")
                    .font(AppTheme.Typography.button)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppTheme.Colors.gold)
                    .cornerRadius(10)
            }
        }
        .padding(AppTheme.Spacing.large)
    }
}

// MARK: - Состояние успеха
struct SuccessView: View {
    let title: String
    let message: String
    let actionTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 50))
                .foregroundColor(AppTheme.Colors.gold)
            
            Text(title)
                .font(AppTheme.Typography.title)
                .foregroundColor(AppTheme.Colors.lightBeige)
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button(action: action) {
                Text(actionTitle)
                    .font(AppTheme.Typography.button)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppTheme.Colors.gold)
                    .cornerRadius(10)
            }
        }
        .padding(AppTheme.Spacing.large)
    }
}

// MARK: - Информационная карточка
struct InfoCard: View {
    let title: String
    let message: String
    let icon: String
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.medium) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppTheme.Colors.gold)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                Text(title)
                    .font(AppTheme.Typography.bodyBold)
                    .foregroundColor(AppTheme.Colors.lightBeige)
                
                Text(message)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
            }
        }
        .padding(AppTheme.Spacing.medium)
        .background(Color.black.opacity(0.3))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppTheme.Colors.goldDark, lineWidth: 1)
        )
    }
}

// MARK: - Статус заказа
struct OrderStatus: View {
    let status: String
    let date: Date
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                Text("Статус заказа")
                    .font(AppTheme.Typography.bodyBold)
                    .foregroundColor(AppTheme.Colors.lightBeige)
                
                Text(status)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.gold)
            }
            
            Spacer()
            
            Text(date, style: .time)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
        }
        .padding(AppTheme.Spacing.medium)
        .background(Color.black.opacity(0.3))
        .cornerRadius(10)
    }
}

// MARK: - Информация о ресторане
struct RestaurantInfo: View {
    let name: String
    let address: String
    let rating: Double
    let reviewsCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Text(name)
                .font(AppTheme.Typography.title)
                .foregroundColor(AppTheme.Colors.lightBeige)
            
            HStack {
                Image(systemName: "location")
                    .foregroundColor(AppTheme.Colors.gold)
                
                Text(address)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
            }
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(AppTheme.Colors.gold)
                
                Text(String(format: "%.1f", rating))
                    .font(AppTheme.Typography.bodyBold)
                    .foregroundColor(AppTheme.Colors.lightBeige)
                
                Text("(\(reviewsCount) отзывов)")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
            }
        }
        .padding(AppTheme.Spacing.medium)
        .background(Color.black.opacity(0.3))
        .cornerRadius(10)
    }
} 