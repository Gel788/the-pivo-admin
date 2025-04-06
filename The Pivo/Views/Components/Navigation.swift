import SwiftUI

// MARK: - Навигационная панель
struct NavigationBar: View {
    let title: String
    let showBackButton: Bool
    let trailingItems: [NavigationBarItem]
    let onBack: () -> Void
    
    var body: some View {
        HStack {
            if showBackButton {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(AppTheme.Colors.gold)
                }
                .padding(.trailing, AppTheme.Spacing.medium)
            }
            
            Text(title)
                .font(AppTheme.Typography.title)
                .foregroundColor(AppTheme.Colors.lightBeige)
            
            Spacer()
            
            HStack(spacing: AppTheme.Spacing.medium) {
                ForEach(trailingItems) { item in
                    Button(action: item.action) {
                        Image(systemName: item.iconName)
                            .font(.title3)
                            .foregroundColor(AppTheme.Colors.gold)
                    }
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.medium)
        .padding(.vertical, AppTheme.Spacing.small)
        .background(Color.black.opacity(0.3))
    }
}

// MARK: - Элемент навигационной панели
struct NavigationBarItem: Identifiable {
    let id = UUID()
    let iconName: String
    let action: () -> Void
}

// MARK: - Модальное представление
struct ModalView<Content: View>: View {
    let title: String
    let content: Content
    let onDismiss: () -> Void
    
    init(title: String, onDismiss: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.title = title
        self.onDismiss = onDismiss
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            HStack {
                Text(title)
                    .font(AppTheme.Typography.title)
                    .foregroundColor(AppTheme.Colors.lightBeige)
                
                Spacer()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(AppTheme.Colors.gold)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.medium)
            
            content
                .padding(.horizontal, AppTheme.Spacing.medium)
        }
        .padding(.vertical, AppTheme.Spacing.medium)
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
    }
}

// MARK: - Табы навигации
struct CustomNavigationTabs: View {
    @Binding var selectedTab: Int
    let tabs: [NavigationTab]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button(action: {
                    withAnimation {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: AppTheme.Spacing.small) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 24))
                        
                        Text(tab.title)
                            .font(AppTheme.Typography.bodySmall)
                    }
                    .foregroundColor(selectedTab == index ? AppTheme.Colors.gold : AppTheme.Colors.lightBeige.opacity(0.6))
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, AppTheme.Spacing.medium)
        .background(Color.black.opacity(0.3))
    }
}

// MARK: - Таб навигации
struct NavigationTab {
    let title: String
    let icon: String
}

// MARK: - Хлебные крошки
struct CustomBreadcrumbs: View {
    let items: [String]
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.small) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                if index > 0 {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.Colors.gold)
                }
                
                Text(item)
                    .font(AppTheme.Typography.bodySmall)
                    .foregroundColor(index == items.count - 1 ? AppTheme.Colors.gold : AppTheme.Colors.lightBeige.opacity(0.8))
            }
        }
    }
} 