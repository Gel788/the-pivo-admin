import SwiftUI
import Foundation

struct NewsView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: NewsTab = .all
    @State private var selectedNews: AppModels.News?
    
    enum NewsTab {
        case all, promotions, updates
    }
    
    var filteredNews: [AppModels.News] {
        switch selectedTab {
        case .all:
            return appState.newsItems
        case .promotions:
            return appState.newsItems.filter { $0.type == .promotion }
        case .updates:
            return appState.newsItems.filter { $0.type == .beer }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Tab Bar
                HStack(spacing: 20) {
                    ForEach([NewsTab.all, .promotions, .updates], id: \.self) { tab in
                        Button(action: {
                            withAnimation {
                                selectedTab = tab
                            }
                        }) {
                            Text(tabTitle(for: tab))
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(selectedTab == tab ? AppTheme.Colors.gold : .gray)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(
                                    selectedTab == tab ?
                                    AppTheme.Colors.gold.opacity(0.1) :
                                    Color.clear
                                )
                                .cornerRadius(20)
                        }
                    }
                }
                .padding()
                
                // News List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredNews) { news in
                            CustomNewsCard(news: news) {
                                selectedNews = news
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(Color.black)
            .navigationTitle("Новости")
            .sheet(item: $selectedNews) { news in
                NewsDetailView(news: news)
            }
            .onAppear {
                appState.fetchNews()
            }
        }
    }
    
    private func tabTitle(for tab: NewsTab) -> String {
        switch tab {
        case .all:
            return "Все"
        case .promotions:
            return "Акции"
        case .updates:
            return "Обновления"
        }
    }
}

#Preview {
    NewsView()
        .environmentObject(AppState())
} 