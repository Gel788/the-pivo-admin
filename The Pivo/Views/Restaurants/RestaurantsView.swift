import SwiftUI

struct RestaurantsView: View {
    @StateObject private var viewModel = RestaurantsViewModel()
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Фоновый градиент
                AppTheme.Colors.darkBackgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Заголовок и поиск
                    headerView
                    
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.gold))
                            .scaleEffect(1.5)
                        Spacer()
                    } else if viewModel.error != nil {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 50))
                                .foregroundColor(AppTheme.Colors.gold)
                            
                            Text("Произошла ошибка при загрузке ресторанов")
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.lightBeige)
                                .multilineTextAlignment(.center)
                            
                            Button(action: {
                                viewModel.fetchRestaurants()
                            }) {
                                Text("Повторить")
                                    .font(AppTheme.Typography.button)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppTheme.Colors.gold)
                                    )
                            }
                        }
                        .padding()
                        Spacer()
                    } else {
                        // Список ресторанов
                        restaurantsList
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.fetchRestaurants()
            }
            .sheet(isPresented: $viewModel.showReservationForm) {
                if let restaurant = viewModel.selectedRestaurant {
                    ReservationFormView(restaurant: restaurant)
                }
            }
            .alert("Ошибка", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    // Заголовок и поиск
    private var headerView: some View {
        VStack(spacing: 20) {
            // Заголовок
            HStack {
                Text("Рестораны")
                    .font(AppTheme.Typography.titleLarge)
                    .foregroundColor(AppTheme.Colors.gold)
                
                Spacer()
                
                Button(action: {
                    viewModel.fetchRestaurants()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(AppTheme.Colors.gold)
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            // Строка поиска
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppTheme.Colors.gold.opacity(0.7))
                    .font(.system(size: 18))
                
                TextField("Поиск ресторана", text: $viewModel.searchText)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.lightBeige)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.clearSearch()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppTheme.Colors.gold.opacity(0.7))
                            .font(.system(size: 18))
                    }
                }
            }
            .padding(15)
            .background(AppTheme.Colors.darkLight)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal)
        }
    }
    
    // Список ресторанов
    private var restaurantsList: some View {
        ScrollView {
            LazyVStack(spacing: 25) {
                ForEach(viewModel.filteredRestaurants) { restaurant in
                    NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                        CustomRestaurantCard(restaurant: restaurant) {
                            viewModel.openReservationForm(for: restaurant)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
        }
        .refreshable {
            viewModel.fetchRestaurants()
        }
    }
}

struct RestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantsView()
            .preferredColorScheme(.dark)
    }
} 