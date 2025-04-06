//
//  The_PivoApp.swift
//  The Pivo
//
//  Created by Альберт Гилоян on 08.03.2025.
//

import SwiftUI

@main
struct The_PivoApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var appState = AppState()
    @StateObject private var restaurantService = RestaurantService()
    @StateObject private var reservationService = ReservationService()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Основной фон для всего приложения
                Color.black.ignoresSafeArea()
                
                if appState.showSplash {
                    SplashView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(appState)
                        .environmentObject(restaurantService)
                        .environmentObject(reservationService)
                        .transition(.opacity)
                } else {
                    MainTabView()
                        .environmentObject(appState)
                        .environmentObject(restaurantService)
                        .environmentObject(reservationService)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: appState.showSplash)
            .preferredColorScheme(.dark) // Принудительно устанавливаем темную тему
        }
    }
}
