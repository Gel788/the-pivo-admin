import SwiftUI

struct AuthView: View {
    @State private var isLogin = true
    @State private var phone = ""
    @State private var password = ""
    @State private var name = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToProfile = false
    @State private var isAnimating = false
    @State private var isSuccess = false
    @State private var showPasswordRequirements = false
    @State private var showSocialAuth = false
    @EnvironmentObject var appState: AppState
    
    // Валидация
    private var isPhoneValid: Bool {
        let phoneRegex = "^\\+?[0-9]{10,15}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }
    
    private var isPasswordValid: Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    private var isFormValid: Bool {
        if isLogin {
            return isPhoneValid && isPasswordValid
        } else {
            return isPhoneValid && isPasswordValid && !name.isEmpty
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Темный фон с градиентом
                Color.black.ignoresSafeArea()
                
                // Декоративный градиент
                VStack {
                    RadialGradient(
                        gradient: Gradient(colors: [AppTheme.Colors.gold.opacity(0.4), Color.black.opacity(0)]),
                        center: .topLeading,
                        startRadius: 50,
                        endRadius: 300
                    )
                    .frame(height: 300)
                    .offset(y: -150)
                    
                    Spacer()
                }
                .ignoresSafeArea()
                
                VStack {
                    // Логотип с анимацией
                    VStack(spacing: 15) {
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding()
                            .scaleEffect(isAnimating ? 1.0 : 0.8)
                            .opacity(isAnimating ? 1.0 : 0.5)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 30)
                    
                    // Переключатель между входом и регистрацией
                    HStack(spacing: 0) {
                        // Кнопка входа
                        Button(action: {
                            withAnimation(.spring()) {
                                isLogin = true
                            }
                        }) {
                            VStack(spacing: 8) {
                                Text("Вход")
                                    .font(.headline)
                                    .foregroundColor(isLogin ? AppTheme.Colors.gold : AppTheme.Colors.lightBeige.opacity(0.6))
                                    .frame(maxWidth: .infinity)
                                
                                Rectangle()
                                    .fill(isLogin ? AppTheme.Colors.gold : Color.clear)
                                    .frame(height: 3)
                            }
                        }
                        
                        // Кнопка регистрации
                        Button(action: {
                            withAnimation(.spring()) {
                                isLogin = false
                            }
                        }) {
                            VStack(spacing: 8) {
                                Text("Регистрация")
                                    .font(.headline)
                                    .foregroundColor(!isLogin ? AppTheme.Colors.gold : AppTheme.Colors.lightBeige.opacity(0.6))
                                    .frame(maxWidth: .infinity)
                                
                                Rectangle()
                                    .fill(!isLogin ? AppTheme.Colors.gold : Color.clear)
                                    .frame(height: 3)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    VStack(spacing: 20) {
                        // Поля ввода с улучшенным дизайном
                        VStack(spacing: 15) {
                            // Поле телефона
                            HStack {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(AppTheme.Colors.gold)
                                    .frame(width: 24)
                                
                                TextField("Телефон", text: $phone)
                                    .keyboardType(.phonePad)
                                    .foregroundColor(AppTheme.Colors.lightBeige)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(UIColor.systemGray6).opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(isPhoneValid ? AppTheme.Colors.gold.opacity(0.3) : AppTheme.Colors.warmRed.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            
                            // Поле пароля
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(AppTheme.Colors.gold)
                                    .frame(width: 24)
                                
                                SecureField("Пароль", text: $password)
                                    .foregroundColor(AppTheme.Colors.lightBeige)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(UIColor.systemGray6).opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(isPasswordValid ? AppTheme.Colors.gold.opacity(0.3) : AppTheme.Colors.warmRed.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            
                            if !isPasswordValid {
                                Text("Пароль должен содержать минимум 8 символов, буквы и цифры")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.Colors.warmRed)
                                    .padding(.horizontal)
                            }
                            
                            // Поле имени (только для регистрации)
                            if !isLogin {
                                HStack {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(AppTheme.Colors.gold)
                                        .frame(width: 24)
                                    
                                    TextField("Имя", text: $name)
                                        .foregroundColor(AppTheme.Colors.lightBeige)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(UIColor.systemGray6).opacity(0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(name.isEmpty ? AppTheme.Colors.warmRed.opacity(0.3) : AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
                                        )
                                )
                                .transition(.opacity)
                            }
                        }
                        
                        // Кнопка действия
                        Button(action: {
                            authenticateUser()
                        }) {
                            HStack {
                                if isLogin {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.headline)
                                    Text("Войти")
                                } else {
                                    Image(systemName: "person.fill.badge.plus")
                                        .font(.headline)
                                    Text("Зарегистрироваться")
                                }
                            }
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? AppTheme.Colors.gold : AppTheme.Colors.gold.opacity(0.5))
                            .foregroundColor(.black)
                            .cornerRadius(12)
                            .shadow(color: AppTheme.Colors.gold.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                        .disabled(!isFormValid)
                        
                        // Разделитель
                        HStack {
                            Rectangle()
                                .fill(AppTheme.Colors.gold.opacity(0.3))
                                .frame(height: 1)
                            Text("или")
                                .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.6))
                                .font(.subheadline)
                            Rectangle()
                                .fill(AppTheme.Colors.gold.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.vertical)
                        
                        // Социальная авторизация
                        HStack(spacing: 20) {
                            Button(action: { authenticateWithApple() }) {
                                Image(systemName: "apple.logo")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .background(Color.black)
                                    .clipShape(Circle())
                            }
                            
                            Button(action: { authenticateWithGoogle() }) {
                                Image(systemName: "g.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .background(Color.red)
                                    .clipShape(Circle())
                            }
                        }
                        
                        if isLogin {
                            Button(action: {
                                // Логика восстановления пароля
                            }) {
                                Text("Забыли пароль?")
                                    .foregroundColor(AppTheme.Colors.gold)
                                    .padding(.top, 5)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Подвал
                    VStack(spacing: 20) {
                        Button(action: {
                            // Логика продолжения без авторизации
                            loginAsGuest()
                        }) {
                            HStack {
                                Image(systemName: "person.fill.questionmark")
                                    .font(.subheadline)
                                Text("Продолжить без авторизации")
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(AppTheme.Colors.lightBeige)
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.bottom, 20)
                }
                .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Внимание"), 
                    message: Text(alertMessage), 
                    dismissButton: .default(Text("OK")) {
                        if isSuccess && !isLogin {
                            // Переход в личный кабинет после успешной регистрации
                            navigateToProfile = true
                        }
                    }
                )
            }
            .navigationDestination(isPresented: $navigateToProfile) {
                TabView {
                    ProfileView().tabItem {
                        Image(systemName: "person.fill")
                        Text("Профиль")
                    }
                }.accentColor(AppTheme.Colors.gold)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0)) {
                    isAnimating = true
                }
            }
        }
    }
    
    private func authenticateUser() {
        // Проверка на пустые поля
        if phone.isEmpty || password.isEmpty || (!isLogin && name.isEmpty) {
            alertMessage = "Пожалуйста, заполните все поля"
            showAlert = true
            return
        }
        
        // Проверка валидности телефона
        if !isPhoneValid {
            alertMessage = "Пожалуйста, введите корректный номер телефона"
            showAlert = true
            return
        }
        
        // Проверка валидности пароля
        if !isPasswordValid {
            alertMessage = "Пароль должен содержать минимум 8 символов, буквы и цифры"
            showAlert = true
            return
        }
        
        if isLogin {
            appState.login(email: phone, password: password)
        } else {
            appState.register(name: name, email: phone, phone: phone, password: password)
        }
        
        isSuccess = true
        alertMessage = isLogin ? "Вход выполнен успешно" : "Регистрация выполнена успешно"
        showAlert = true
    }
    
    private func authenticateWithApple() {
        // Реализация входа через Apple
        isSuccess = true
        alertMessage = "Вход через Apple временно недоступен"
        
        showAlert = true
    }
    
    private func authenticateWithGoogle() {
        // Реализация входа через Google
        isSuccess = true
        alertMessage = "Вход через Google временно недоступен"
        
        showAlert = true
    }
    
    private func loginAsGuest() {
        // Логика входа как гость
        isSuccess = true
        alertMessage = "Вход как гость выполнен успешно"
        
        showAlert = true
    }
}

struct RoundedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(UIColor.systemGray6).opacity(0.2))
            .cornerRadius(12)
            .foregroundColor(AppTheme.Colors.lightBeige)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
            )
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(AppState())
    }
} 