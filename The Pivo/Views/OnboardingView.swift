import SwiftUI
import Foundation

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(title: "Добро пожаловать в Pivo", description: "Откройте для себя мир крафтового пива", imageName: "beer"),
        OnboardingPage(title: "Большой выбор", description: "Более 100 сортов пива от лучших пивоварен", imageName: "beer"),
        OnboardingPage(title: "Удобная доставка", description: "Доставляем пиво прямо к вашей двери", imageName: "delivery")
    ]
    
    // Если есть метод, который вызывается при завершении онбординга
    func completeOnboarding() {
        // Устанавливаем флаг, что онбординг пройден
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        
        // Устанавливаем вкладку Новости как основную (индекс 1)
        appState.selectedTab = .news
        
        // Закрываем онбординг
        appState.showSplash = false
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            
            VStack {
                Spacer()
                
                if currentPage == pages.count - 1 {
                    Button(action: {
                        withAnimation {
                            appState.selectedTab = .news
                        }
                    }) {
                        Text("Начать")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.Colors.gold)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            appState.fetchSampleNews()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 20) {
            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding(.top, 50)
            
            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Spacer()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(AppState())
    }
} 