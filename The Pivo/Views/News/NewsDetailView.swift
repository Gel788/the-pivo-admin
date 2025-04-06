import SwiftUI

struct NewsDetailView: View {
    let news: AppModels.News
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageURL = news.imageURL, !imageURL.isEmpty {
                    Image(imageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .clipped()
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.8)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Circle()
                            .fill(colorForType(news.type))
                            .frame(width: 8, height: 8)
                        Text(news.type.rawValue.capitalized)
                            .font(AppTheme.Typography.bodySmall)
                            .foregroundColor(AppTheme.Colors.gold)
                    }
                    
                    Text(news.title)
                        .font(AppTheme.Typography.titleLarge)
                        .foregroundColor(AppTheme.Colors.lightBeige)
                    
                    HStack {
                        Image(systemName: "calendar")
                            .font(.system(size: 14))
                        Text(news.date.formatted(date: .long, time: .omitted))
                            .font(AppTheme.Typography.bodySmall)
                    }
                    .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.6))
                    
                    Text(news.content)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.8))
                        .lineSpacing(8)
                }
                .padding()
            }
        }
        .background(Color.black)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppTheme.Colors.gold)
                }
            }
        }
    }
    
    private func colorForType(_ type: AppModels.NewsType) -> Color {
        switch type {
        case .news:
            return AppTheme.Colors.gold
        case .event:
            return AppTheme.Colors.lightBeige
        case .promotion:
            return AppTheme.Colors.gold.opacity(0.7)
        case .beer:
            return AppTheme.Colors.gold.opacity(0.7)
        }
    }
}

struct NewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewsDetailView(news: AppModels.News(
                id: "1",
                title: "Новое сезонное меню",
                content: "Мы обновили наше меню с учетом сезонных продуктов. Приходите попробовать новые блюда!",
                date: Date(),
                imageURL: "news1",
                type: .news
            ))
        }
    }
} 