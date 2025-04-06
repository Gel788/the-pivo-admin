import SwiftUI

// Представление для неавторизованного пользователя
struct NotLoggedInView: View {
    let message: String
    @State private var showLoginSheet = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.badge.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(AppTheme.Colors.gold)
                .padding(.bottom, 20)
            
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            Button(action: {
                showLoginSheet = true
            }) {
                Text("Войти")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 200)
                    .background(AppTheme.Colors.gold)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding()
        .sheet(isPresented: $showLoginSheet) {
            AuthView()
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var showEditProfile = false
    @State private var showLogoutAlert = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Фоновый градиент
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black,
                        Color(red: 0.1, green: 0.05, blue: 0.1),
                        Color.black
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Профиль пользователя
                        VStack(spacing: 20) {
                            // Аватар
                            Circle()
                                .fill(AppTheme.Colors.darkBrown)
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Circle()
                                        .stroke(AppTheme.Colors.gold, lineWidth: 2)
                                )
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(AppTheme.Colors.gold)
                                )
                            
                            // Имя пользователя
                            if let user = appState.currentUser {
                                Text(user.name)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(AppTheme.Colors.gold)
                                
                                Text(user.email)
                                    .font(.system(size: 16))
                                    .foregroundColor(AppTheme.Colors.lightBeige)
                                
                                if !user.phone.isEmpty {
                                    Text(user.phone)
                                        .font(.system(size: 16))
                                        .foregroundColor(AppTheme.Colors.lightBeige)
                                }
                            }
                        }
                        .padding(.top, 20)
                        
                        // Кнопки действий
                        VStack(spacing: 15) {
                            // Редактировать профиль
                            Button(action: {
                                showEditProfile = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 18))
                                    Text("Редактировать профиль")
                                        .font(.system(size: 16, weight: .medium))
                                }
                                .foregroundColor(AppTheme.Colors.gold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(AppTheme.Colors.gold, lineWidth: 1)
                                )
                            }
                            
                            // Выйти из аккаунта
                            Button(action: {
                                showLogoutAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(.system(size: 18))
                                    Text("Выйти из аккаунта")
                                        .font(.system(size: 16, weight: .medium))
                                }
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.red, lineWidth: 1)
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        // История заказов
                        VStack(alignment: .leading, spacing: 15) {
                            Text("История заказов")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(AppTheme.Colors.gold)
                                .padding(.horizontal)
                            
                            if appState.orders.isEmpty {
                                Text("У вас пока нет заказов")
                                    .font(.system(size: 16))
                                    .foregroundColor(AppTheme.Colors.lightBeige)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(10)
                            } else {
                                ForEach(appState.orders) { order in
                                    OrderCard(order: order)
                                }
                            }
                        }
                        .padding(.top, 20)
                    }
                }
            }
            .navigationTitle("Профиль")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showEditProfile = true
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(AppTheme.Colors.gold)
                    }
                }
            }
            .sheet(isPresented: $showEditProfile) {
                if let user = appState.currentUser {
                    NavigationView {
                        EditProfileView(user: user)
                    }
                }
            }
            .alert("Выйти из аккаунта?", isPresented: $showLogoutAlert) {
                Button("Отмена", role: .cancel) { }
                Button("Выйти", role: .destructive) {
                    logout()
                }
            } message: {
                Text("Вы уверены, что хотите выйти из аккаунта?")
            }
            .alert("Ошибка", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func logout() {
        appState.logout()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AppState())
            .preferredColorScheme(.dark)
    }
} 