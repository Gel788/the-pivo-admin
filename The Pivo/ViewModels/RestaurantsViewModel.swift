import Foundation
import Combine
import SwiftUI

class RestaurantsViewModel: ObservableObject {
    @Published var restaurants: [AppModels.Restaurant] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = true
    @Published var error: Error?
    @Published var showReservationForm: Bool = false
    @Published var selectedRestaurant: AppModels.Restaurant?
    
    private var cancellables = Set<AnyCancellable>()
    private let restaurantService: RestaurantService
    
    init(restaurantService: RestaurantService = RestaurantService()) {
        self.restaurantService = restaurantService
        setupBindings()
    }
    
    private func setupBindings() {
        // Подписываемся на изменения в сервисе ресторанов
        restaurantService.$restaurants
            .receive(on: DispatchQueue.main)
            .sink { [weak self] restaurants in
                self?.restaurants = restaurants
                self?.isLoading = false
                self?.error = nil
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
    
    // Отфильтрованные рестораны
    var filteredRestaurants: [AppModels.Restaurant] {
        var result = restaurants
        
        // Фильтрация по поиску
        if !searchText.isEmpty {
            result = result.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        return result
    }
    
    // Загрузка ресторанов
    func fetchRestaurants() {
        isLoading = true
        error = nil
        restaurantService.fetchRestaurants()
    }
    
    // Обновление списка ресторанов
    func refreshRestaurants() {
        fetchRestaurants()
    }
    
    // Очистка поиска
    func clearSearch() {
        searchText = ""
    }
    
    // Открытие формы бронирования
    func openReservationForm(for restaurant: AppModels.Restaurant) {
        selectedRestaurant = restaurant
        showReservationForm = true
    }
    
    // Закрытие формы бронирования
    func closeReservationForm() {
        showReservationForm = false
        selectedRestaurant = nil
    }
    
    // Форматирование ценового диапазона
    func formatPriceRange(_ range: String) -> String {
        switch range {
        case "$": return "Бюджетный"
        case "$$": return "Средний"
        case "$$$": return "Высокий"
        default: return range
        }
    }
    
    // Форматирование рейтинга
    func formatRating(_ rating: Double) -> String {
        return String(format: "%.1f", rating)
    }
} 