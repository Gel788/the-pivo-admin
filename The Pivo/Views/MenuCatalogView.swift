import SwiftUI

struct MenuCatalogView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var restaurantService = RestaurantService()
    @State private var selectedCategory: AppModels.MenuCategory? = nil
    @State private var searchText: String = ""
    @State private var selectedItem: AppModels.MenuItem? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                // Фон
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Строка поиска
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16))
                            .foregroundColor(AppTheme.Colors.gold)
                        TextField("Поиск блюд...", text: $searchText)
                            .font(.system(size: 16))
                            .foregroundColor(AppTheme.Colors.lightBeige)
                            .withKeyboardDismissButton()
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                hideKeyboard()
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(AppTheme.Colors.gold.opacity(0.8))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppTheme.Colors.gold.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    
                    // Категории
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            Button(action: {
                                selectedCategory = nil
                            }) {
                                Text("Все")
                                    .font(.system(size: 15, weight: selectedCategory == nil ? .semibold : .regular))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        selectedCategory == nil ?
                                        AppTheme.Colors.gold :
                                        Color.black.opacity(0.5)
                                    )
                                    .foregroundColor(selectedCategory == nil ? .black : AppTheme.Colors.lightBeige)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(AppTheme.Colors.gold.opacity(selectedCategory == nil ? 0 : 0.3), lineWidth: 1)
                                    )
                            }
                            
                            ForEach(AppModels.MenuCategory.allCases, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    Text(categoryName(for: category))
                                        .font(.system(size: 15, weight: selectedCategory == category ? .semibold : .regular))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            selectedCategory == category ?
                                            AppTheme.Colors.gold :
                                            Color.black.opacity(0.5)
                                        )
                                        .foregroundColor(selectedCategory == category ? .black : AppTheme.Colors.lightBeige)
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(AppTheme.Colors.gold.opacity(selectedCategory == category ? 0 : 0.3), lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 16)
                    
                    // Список блюд
                    if filteredMenuItems.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "fork.knife")
                                .font(.system(size: 50))
                                .foregroundColor(AppTheme.Colors.gold.opacity(0.7))
                            
                            Text("Блюда не найдены")
                                .font(.headline)
                                .foregroundColor(AppTheme.Colors.lightBeige)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(filteredMenuItems) { item in
                                    Button(action: {
                                        selectedItem = item
                                    }) {
                                        MenuItemCardView(item: item)
                                            .padding(.horizontal)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                }
                .navigationTitle("Меню блюд")
                .navigationBarTitleDisplayMode(.inline)
            }
            .sheet(item: $selectedItem) { item in
                NavigationView {
                    MenuItemDetailView(menuItem: item)
                }
            }
        }
        .dismissKeyboardOnTap()
    }
    
    private var allMenuItems: [AppModels.MenuItem] {
        var items: [AppModels.MenuItem] = []
        
        for restaurant in restaurantService.restaurants {
            items.append(contentsOf: restaurant.menu)
        }
        
        // Убираем дубликаты по id
        return Array(Set(items))
    }
    
    private var allCategories: [AppModels.MenuCategory] {
        return AppModels.MenuCategory.allCases.sorted { categoryName(for: $0) < categoryName(for: $1) }
    }
    
    private var filteredMenuItems: [AppModels.MenuItem] {
        var items = allMenuItems
        
        // Фильтр по категории
        if let category = selectedCategory {
            items = items.filter { $0.category == category }
        }
        
        // Фильтр по тексту поиска
        if !searchText.isEmpty {
            items = items.filter { 
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return items.sorted(by: { $0.name < $1.name })
    }
    
    private func categoryName(for category: AppModels.MenuCategory) -> String {
        switch category {
        case .beer:
            return "Пиво"
        case .snacks:
            return "Закуски"
        case .main:
            return "Основные блюда"
        case .dessert:
            return "Десерты"
        case .drinks:
            return "Напитки"
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct MenuItemCardView: View {
    let item: AppModels.MenuItem
    
    var body: some View {
        HStack(spacing: 16) {
            // Изображение блюда
            ZStack {
                if let uiImage = UIImage(named: item.imageURL) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 90, height: 90)
                        .overlay(
                            Image(systemName: "fork.knife")
                                .font(.system(size: 30))
                                .foregroundColor(AppTheme.Colors.gold)
                        )
                }
            }
            .frame(width: 90, height: 90)
            .background(Color.black.opacity(0.5))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppTheme.Colors.gold.opacity(0.2), lineWidth: 1)
            )
            
            // Информация о блюде
            VStack(alignment: .leading, spacing: 8) {
                Text(item.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.lightBeige)
                
                Text(item.description)
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.7))
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    Text("\(Int(item.price)) ₽")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppTheme.Colors.gold)
                    
                    Spacer()
                }
            }
            
            Spacer()
            
            // Стрелка для перехода
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppTheme.Colors.gold.opacity(0.7))
                .padding(.trailing, 4)
        }
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppTheme.Colors.gold.opacity(0.2), lineWidth: 1)
        )
    }
}

struct MenuItemDetailView: View {
    let menuItem: AppModels.MenuItem
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Изображение блюда
                    if !menuItem.imageURL.isEmpty {
                        Image(menuItem.imageURL)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 240)
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.black.opacity(0.5),
                                        Color.clear,
                                        Color.black.opacity(0.3)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    } else {
                        ZStack {
                            Rectangle()
                                .fill(Color.black.opacity(0.7))
                                .frame(height: 240)
                            
                            Image(systemName: "photo")
                                .font(.system(size: 50))
                                .foregroundColor(AppTheme.Colors.gold.opacity(0.5))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 24) {
                        // Название и категория
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(menuItem.name)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(AppTheme.Colors.gold)
                                
                                Text(categoryName(for: menuItem.category))
                                    .font(.system(size: 16))
                                    .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            // Рейтинг и цена
                            VStack(alignment: .trailing, spacing: 8) {
                                Text("\(Int(menuItem.price)) ₽")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(AppTheme.Colors.gold)
                            }
                        }
                        
                        Divider()
                            .background(AppTheme.Colors.gold.opacity(0.2))
                        
                        // Описание
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Описание")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppTheme.Colors.gold)
                            
                            Text(menuItem.description)
                                .font(.system(size: 16))
                                .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.9))
                                .multilineTextAlignment(.leading)
                                .lineSpacing(4)
                        }
                        
                        if let abv = menuItem.abv, let ibu = menuItem.ibu, menuItem.category == .beer {
                            Divider()
                                .background(AppTheme.Colors.gold.opacity(0.2))
                                .padding(.vertical, 8)
                            
                            // Информация о пиве
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Информация о пиве")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(AppTheme.Colors.gold)
                                
                                HStack(spacing: 24) {
                                    // ABV
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Крепость")
                                            .font(.system(size: 14))
                                            .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.7))
                                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                                            Text("\(abv, specifier: "%.1f")")
                                                .font(.system(size: 20, weight: .bold))
                                            Text("%")
                                                .font(.system(size: 16))
                                        }
                                        .foregroundColor(AppTheme.Colors.lightBeige)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(16)
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(12)
                                    
                                    // IBU
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Горечь")
                                            .font(.system(size: 14))
                                            .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.7))
                                        Text("\(ibu, specifier: "%.0f") IBU")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(AppTheme.Colors.lightBeige)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(16)
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(12)
                                }
                            }
                        }
                    }
                    .padding(20)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack(spacing: 8) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                Text("Назад")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(AppTheme.Colors.gold)
        })
    }
    
    private func categoryName(for category: AppModels.MenuCategory) -> String {
        switch category {
        case .beer:
            return "Пиво"
        case .snacks:
            return "Закуски"
        case .main:
            return "Основные блюда"
        case .dessert:
            return "Десерты"
        case .drinks:
            return "Напитки"
        }
    }
}

struct MenuCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        MenuCatalogView()
            .environmentObject(AppState())
            .environmentObject(RestaurantService())
    }
} 