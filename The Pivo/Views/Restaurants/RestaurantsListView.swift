import SwiftUI

// Упрощаем опции сортировки, оставляя только расстояние
enum RestaurantSortOption: String, CaseIterable {
    case distance
    
    var title: String {
        switch self {
        case .distance:
            return "По расстоянию"
        }
    }
}

struct RestaurantsListView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    @State private var selectedCategory: String?
    @State private var showFilter = false
    
    private var categories: [String] {
        let allCategories = appState.restaurants.map { $0.type }
        let uniqueCategories = Set(allCategories)
        return Array(uniqueCategories).sorted()
    }
    
    private var filteredRestaurants: [AppModels.Restaurant] {
        var filtered = appState.restaurants
        
        // Фильтр по поиску
        if !searchText.isEmpty {
            filtered = filtered.filter { restaurant in
                restaurant.name.localizedCaseInsensitiveContains(searchText) ||
                restaurant.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Фильтр по категории
        if let category = selectedCategory {
            filtered = filtered.filter { $0.type == category }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Поисковая строка
                        SearchBar(text: $searchText, placeholder: "Поиск ресторанов")
                            .padding(.horizontal)
                        
                        // Категории
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                CategoryButton(
                                    title: "Все",
                                    isSelected: selectedCategory == nil,
                                    action: { selectedCategory = nil }
                                )
                                
                                ForEach(categories, id: \.self) { category in
                                    CategoryButton(
                                        title: category,
                                        isSelected: selectedCategory == category,
                                        action: { selectedCategory = category }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Список ресторанов
                        LazyVStack(spacing: 16) {
                            ForEach(filteredRestaurants) { restaurant in
                                RestaurantCard(restaurant: restaurant, onBook: {})
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Рестораны")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showFilter = true }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(AppTheme.Colors.gold)
                    }
                }
            }
            .sheet(isPresented: $showFilter) {
                FilterView(selectedCategory: $selectedCategory)
            }
        }
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? AppTheme.Colors.gold : Color.clear)
                .foregroundColor(isSelected ? .white : AppTheme.Colors.gold)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppTheme.Colors.gold, lineWidth: 1)
                )
        }
    }
}

struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCategory: String?
    @EnvironmentObject var appState: AppState
    
    private var categories: [String] {
        let allCategories = appState.restaurants.map { $0.type }
        let uniqueCategories = Set(allCategories)
        return Array(uniqueCategories).sorted()
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Категории")) {
                    Button(action: { 
                        selectedCategory = nil
                        dismiss()
                    }) {
                        HStack {
                            Text("Все")
                            Spacer()
                            if selectedCategory == nil {
                                Image(systemName: "checkmark")
                                    .foregroundColor(AppTheme.Colors.gold)
                            }
                        }
                    }
                    
                    ForEach(categories, id: \.self) { category in
                        Button(action: { 
                            selectedCategory = category
                            dismiss()
                        }) {
                            HStack {
                                Text(category)
                                Spacer()
                                if selectedCategory == category {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(AppTheme.Colors.gold)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Фильтр")
            .navigationBarItems(trailing: Button("Готово") {
                dismiss()
            })
        }
    }
}

struct RestaurantRow: View {
    let restaurant: AppModels.Restaurant
    
    var body: some View {
        HStack(spacing: 16) {
            // Изображение ресторана
            if !restaurant.imageURL.isEmpty, let url = URL(string: restaurant.imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.3))
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.3))
                    @unknown default:
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.3))
                    }
                }
                .frame(width: 80, height: 80)
                .cornerRadius(8)
            } else {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            }
            
            // Информация о ресторане
            VStack(alignment: .leading, spacing: 4) {
                Text(restaurant.name)
                    .font(.headline)
                
                Text(restaurant.address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text(restaurant.type)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct RestaurantsListView_Previews: PreviewProvider {
    static var previews: some View {
        let restaurantService = RestaurantService()
        restaurantService.restaurants = [
            AppModels.Restaurant(
                id: "1",
                name: "Пивной ресторан",
                description: "Уютный ресторан с большим выбором пива и закусок",
                address: "ул. Пивная, 1",
                phone: "+7 123 456 7890",
                email: "info@pivnoy.ru",
                website: "www.pivnoy.ru",
                hours: "Пн-Чт: 12:00-00:00, Пт-Сб: 12:00-02:00, Вс: 12:00-22:00",
                imageURL: "RestaurantImage",
                menu: [],
                type: "Пивной ресторан",
                features: ["Wi-Fi", "Парковка", "Живая музыка"],
                latitude: 55.753215,
                longitude: 37.622504,
                reservationCostPerPerson: 500.0
            ),
            AppModels.Restaurant(
                id: "2",
                name: "Крафтовый паб",
                description: "Паб с большим выбором крафтового пива",
                address: "ул. Крафтовая, 2",
                phone: "+7 987 654 3210",
                email: "info@craftpub.ru",
                website: "www.craftpub.ru",
                hours: "Ежедневно: 11:00-23:00",
                imageURL: "RestaurantImage2",
                menu: [],
                type: "Крафтовый паб",
                features: ["Wi-Fi", "Парковка", "Детская площадка"],
                latitude: 55.761665,
                longitude: 37.632324,
                reservationCostPerPerson: 600.0
            )
        ]
        
        return RestaurantsListView()
            .environmentObject(AppState())
            .environmentObject(restaurantService)
            .preferredColorScheme(.dark)
    }
} 