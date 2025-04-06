import SwiftUI

struct SplashView: View {
    @EnvironmentObject var appState: AppState
    @State private var opacity = 0.0
    @State private var scale = 0.7
    @State private var rotation = 0.0
    @State private var glowOpacity = 0.0
    
    var body: some View {
        ZStack {
            // Градиентный фон
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black,
                    Color(red: 0.1, green: 0.05, blue: 0.1),
                    Color.black
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Эффект свечения за логотипом
            Circle()
                .fill(AppTheme.Colors.gold.opacity(0.15))
                .frame(width: 280, height: 280)
                .blur(radius: 30)
                .opacity(glowOpacity)
            
            // Логотип с эффектами
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 240, height: 240)
                .shadow(color: AppTheme.Colors.gold.opacity(0.7), radius: 20, x: 0, y: 0)
                .rotationEffect(.degrees(rotation))
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .onAppear {
            // Анимация появления логотипа
            withAnimation(.easeOut(duration: 1.0)) {
                scale = 1.0
                opacity = 1.0
            }
            
            // Анимация свечения
            withAnimation(.easeInOut(duration: 1.5).delay(0.3)) {
                glowOpacity = 0.8
            }
            
            // Небольшое вращение для эффекта
            withAnimation(.easeInOut(duration: 1.5).repeatCount(1, autoreverses: true)) {
                rotation = 3
            }
            
            // Автоматический переход через 2.5 секунды
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.8)) {
                    opacity = 0
                    scale = 1.3
                    glowOpacity = 0
                }
                
                // Переход на следующий экран
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    appState.showSplash = false
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
            .environmentObject(AppState())
    }
} 