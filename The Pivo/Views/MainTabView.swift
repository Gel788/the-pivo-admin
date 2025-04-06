import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var restaurantService: RestaurantService
    @EnvironmentObject var reservationService: ReservationService
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            // Новостная лента
            NewsView()
                .tabItem {
                    Label("Новости", systemImage: "newspaper")
                }
                .tag(AppState.Tab.news)
            
            // Рестораны
            RestaurantsView()
                .tabItem {
                    Label("Рестораны", systemImage: "fork.knife")
                }
                .tag(AppState.Tab.restaurants)
            
            // Меню
            MenuCatalogView()
                .tabItem {
                    Label("Меню", systemImage: "menucard")
                }
                .tag(AppState.Tab.menu)
            
            // Бронирования
            ReservationsView()
                .tabItem {
                    Label("Бронирования", systemImage: "calendar")
                }
                .tag(AppState.Tab.reservations)
            
            // Профиль
            ProfileView()
                .tabItem {
                    Label("Профиль", systemImage: "person.fill")
                }
                .tag(AppState.Tab.profile)
        }
        .accentColor(AppTheme.Colors.gold)
        .onAppear {
            // Настройка внешнего вида TabBar
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = UIColor.black
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AppState())
            .environmentObject(RestaurantService())
            .environmentObject(ReservationService())
            .preferredColorScheme(.dark)
    }
} 