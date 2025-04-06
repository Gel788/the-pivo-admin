import Foundation
import Combine
import SwiftUI

class NewsViewModel: ObservableObject {
    @Published var news: [AppModels.News] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    private let restaurantService = RestaurantService()
    
    init() {
        setupBindings()
        fetchNews()
    }
    
    private func setupBindings() {
        // Подписываемся на изменения в сервисе новостей
        restaurantService.$news
            .receive(on: DispatchQueue.main)
            .sink { [weak self] news in
                self?.news = news
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        restaurantService.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.error = error
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func fetchNews() {
        isLoading = true
        
        // Имитация задержки сети
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.news = [
                AppModels.News(
                    id: "1",
                    title: "Новое сезонное меню",
                    content: "Мы обновили наше меню с учетом сезонных продуктов. Приходите попробовать новые блюда!",
                    date: Date(),
                    imageURL: "news1",
                    type: .news
                ),
                AppModels.News(
                    id: "2",
                    title: "Фестиваль крафтового пива",
                    content: "Приглашаем на наш ежегодный фестиваль крафтового пива!",
                    date: Date().addingTimeInterval(86400),
                    imageURL: "news2",
                    type: .event
                ),
                AppModels.News(
                    id: "3",
                    title: "Специальное предложение",
                    content: "Скидка 20% на все позиции меню по понедельникам!",
                    date: Date().addingTimeInterval(172800),
                    imageURL: "news3",
                    type: .promotion
                ),
                AppModels.News(
                    id: "4",
                    title: "Открытие летней веранды",
                    content: "Мы рады сообщить об открытии нашей летней веранды. Теперь вы можете наслаждаться блюдами на свежем воздухе!",
                    date: Date().addingTimeInterval(259200),
                    imageURL: "news4",
                    type: .news
                )
            ]
            self.isLoading = false
        }
    }
    
    func getNewsByType(_ type: AppModels.NewsType) -> [AppModels.News] {
        return news.filter { $0.type == type }
    }
    
    func getLatestNews() -> [AppModels.News] {
        return news.sorted { $0.date > $1.date }
    }
    
    func getNewsByDate(_ date: Date) -> [AppModels.News] {
        let calendar = Calendar.current
        return news.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    func getNewsByDateRange(_ startDate: Date, _ endDate: Date) -> [AppModels.News] {
        return news.filter { $0.date >= startDate && $0.date <= endDate }
    }
    
    func getNewsByCategory(_ category: String) -> [AppModels.News] {
        return news.filter { $0.content.localizedCaseInsensitiveContains(category) }
    }
    
    func searchNews(_ query: String) -> [AppModels.News] {
        return news.filter {
            $0.title.localizedCaseInsensitiveContains(query) ||
            $0.content.localizedCaseInsensitiveContains(query)
        }
    }
    
    func getNewsByDateAndCategory(_ date: Date, _ category: AppModels.NewsType) -> [AppModels.News] {
        return news.filter { news in
            Calendar.current.isDate(news.date, inSameDayAs: date) && news.type == category
        }
    }
    
    func getNewsByDateRangeAndCategory(_ startDate: Date, _ endDate: Date, _ category: AppModels.NewsType) -> [AppModels.News] {
        return news.filter { news in
            news.date >= startDate && news.date <= endDate && news.type == category
        }
    }
    
    func getNewsByDateRangeAndSearchQuery(_ startDate: Date, _ endDate: Date, _ query: String) -> [AppModels.News] {
        return news.filter { news in
            news.date >= startDate && news.date <= endDate &&
            (news.title.localizedCaseInsensitiveContains(query) ||
             news.content.localizedCaseInsensitiveContains(query))
        }
    }
    
    func getNewsByCategoryAndSearchQuery(_ category: AppModels.NewsType, _ query: String) -> [AppModels.News] {
        return news.filter { news in
            news.type == category &&
            (news.title.localizedCaseInsensitiveContains(query) ||
             news.content.localizedCaseInsensitiveContains(query))
        }
    }
    
    func getNewsByDateAndSearchQuery(_ date: Date, _ query: String) -> [AppModels.News] {
        return news.filter { news in
            Calendar.current.isDate(news.date, inSameDayAs: date) &&
            (news.title.localizedCaseInsensitiveContains(query) ||
             news.content.localizedCaseInsensitiveContains(query))
        }
    }
    
    func getNewsByDateRangeAndCategoryAndSearchQuery(_ startDate: Date, _ endDate: Date, _ category: AppModels.NewsType, _ query: String) -> [AppModels.News] {
        return news.filter { news in
            news.date >= startDate && news.date <= endDate &&
            news.type == category &&
            (news.title.localizedCaseInsensitiveContains(query) ||
             news.content.localizedCaseInsensitiveContains(query))
        }
    }
    
    func getNewsByDateAndCategoryAndSearchQuery(_ date: Date, _ category: AppModels.NewsType, _ query: String) -> [AppModels.News] {
        return news.filter { news in
            Calendar.current.isDate(news.date, inSameDayAs: date) &&
            news.type == category &&
            (news.title.localizedCaseInsensitiveContains(query) ||
             news.content.localizedCaseInsensitiveContains(query))
        }
    }
    
    func getNewsByDateRangeAndCategoryAndSearchQueryAndSort(_ startDate: Date, _ endDate: Date, _ category: AppModels.NewsType, _ query: String, _ sortBy: SortOption) -> [AppModels.News] {
        var filteredNews = getNewsByDateRangeAndCategoryAndSearchQuery(startDate, endDate, category, query)
        
        switch sortBy {
        case .dateAscending:
            filteredNews.sort { $0.date < $1.date }
        case .dateDescending:
            filteredNews.sort { $0.date > $1.date }
        case .titleAscending:
            filteredNews.sort { $0.title < $1.title }
        case .titleDescending:
            filteredNews.sort { $0.title > $1.title }
        }
        
        return filteredNews
    }
    
    enum SortOption {
        case dateAscending
        case dateDescending
        case titleAscending
        case titleDescending
    }
    
    // Форматирование даты для отображения
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    // Получение цвета для типа новости
    func typeColor(_ type: AppModels.NewsType) -> Color {
        switch type {
        case .event:
            return .purple
        case .promotion:
            return .orange
        case .news:
            return .blue
        case .beer:
            return .brown
        }
    }
} 