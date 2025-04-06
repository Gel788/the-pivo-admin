import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: HomeTab = .restaurants
    
    enum HomeTab {
        case restaurants, news, profile
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RestaurantsListView()
                .tabItem {
                    Label("Рестораны", systemImage: "fork.knife")
                }
                .tag(HomeTab.restaurants)
            
            NewsView()
                .tabItem {
                    Label("Новости", systemImage: "newspaper")
                }
                .tag(HomeTab.news)
            
            ProfileView()
                .tabItem {
                    Label("Профиль", systemImage: "person")
                }
                .tag(HomeTab.profile)
        }
        .accentColor(AppTheme.Colors.gold)
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
} 
