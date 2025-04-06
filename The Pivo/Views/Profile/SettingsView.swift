import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("language") private var language = "ru"
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @State private var showingLanguagePicker = false
    @State private var showingPrivacyPolicy = false
    @State private var showingTermsOfService = false
    @State private var showingDeleteAccount = false
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            List {
                // Внешний вид
                Section(header: Text("Внешний вид")) {
                    Toggle("Темная тема", isOn: $isDarkMode)
                    Button(action: { showingLanguagePicker = true }) {
                        HStack {
                            Text("Язык")
                            Spacer()
                            Text(language == "ru" ? "Русский" : "English")
                                .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.6))
                        }
                    }
                }
                
                // Уведомления
                Section(header: Text("Уведомления")) {
                    Toggle("Включить уведомления", isOn: $notificationsEnabled)
                }
                
                // Конфиденциальность
                Section(header: Text("Конфиденциальность")) {
                    Button(action: { showingPrivacyPolicy = true }) {
                        HStack {
                            Text("Политика конфиденциальности")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.6))
                        }
                    }
                    
                    Button(action: { showingTermsOfService = true }) {
                        HStack {
                            Text("Условия использования")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.6))
                        }
                    }
                }
                
                // Аккаунт
                Section(header: Text("Аккаунт")) {
                    Button(action: { showingDeleteAccount = true }) {
                        HStack {
                            Text("Удалить аккаунт")
                                .foregroundColor(.red)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.red)
                        }
                    }
                    
                    Button(action: { showingLogoutAlert = true }) {
                        HStack {
                            Text("Выйти из аккаунта")
                                .foregroundColor(AppTheme.Colors.gold)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(AppTheme.Colors.gold)
                        }
                    }
                }
                
                // О приложении
                Section(header: Text("О приложении")) {
                    HStack {
                        Text("Версия")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.6))
                    }
                }
            }
            .navigationTitle("Настройки")
            .navigationBarItems(trailing: Button("Готово") {
                dismiss()
            })
            .sheet(isPresented: $showingLanguagePicker) {
                LanguagePickerView(selectedLanguage: $language)
            }
            .sheet(isPresented: $showingPrivacyPolicy) {
                PrivacyPolicyView()
            }
            .sheet(isPresented: $showingTermsOfService) {
                TermsOfServiceView()
            }
            .alert("Удалить аккаунт?", isPresented: $showingDeleteAccount) {
                Button("Отмена", role: .cancel) { }
                Button("Удалить", role: .destructive) {
                    appState.deleteAccount()
                    dismiss()
                }
            } message: {
                Text("Это действие нельзя отменить. Все ваши данные будут удалены.")
            }
            .alert("Выйти из аккаунта?", isPresented: $showingLogoutAlert) {
                Button("Отмена", role: .cancel) { }
                Button("Выйти", role: .destructive) {
                    appState.logout()
                    dismiss()
                }
            } message: {
                Text("Вы уверены, что хотите выйти из аккаунта?")
            }
        }
    }
}

struct LanguagePickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedLanguage: String
    
    var body: some View {
        NavigationView {
            List {
                Button(action: { selectedLanguage = "ru" }) {
                    HStack {
                        Text("Русский")
                        Spacer()
                        if selectedLanguage == "ru" {
                            Image(systemName: "checkmark")
                                .foregroundColor(AppTheme.Colors.gold)
                        }
                    }
                }
                
                Button(action: { selectedLanguage = "en" }) {
                    HStack {
                        Text("English")
                        Spacer()
                        if selectedLanguage == "en" {
                            Image(systemName: "checkmark")
                                .foregroundColor(AppTheme.Colors.gold)
                        }
                    }
                }
            }
            .navigationTitle("Выберите язык")
            .navigationBarItems(trailing: Button("Готово") {
                dismiss()
            })
        }
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Политика конфиденциальности")
                        .font(.title)
                        .foregroundColor(AppTheme.Colors.lightBeige)
                    
                    Text("Последнее обновление: 1 марта 2024")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.6))
                    
                    Group {
                        Text("1. Сбор информации")
                            .font(.headline)
                            .foregroundColor(AppTheme.Colors.gold)
                        Text("Мы собираем следующую информацию:")
                            .foregroundColor(AppTheme.Colors.lightBeige)
                        Text("• Имя пользователя\n• Номер телефона\n• Email (опционально)\n• Данные о бронированиях\n• История просмотров")
                            .foregroundColor(AppTheme.Colors.lightBeige)
                    }
                    
                    Group {
                        Text("2. Использование информации")
                            .font(.headline)
                            .foregroundColor(AppTheme.Colors.gold)
                        Text("Мы используем собранную информацию для:")
                            .foregroundColor(AppTheme.Colors.lightBeige)
                        Text("• Обработки бронирований\n• Отправки уведомлений\n• Улучшения работы приложения\n• Персонализации контента")
                            .foregroundColor(AppTheme.Colors.lightBeige)
                    }
                    
                    Group {
                        Text("3. Защита данных")
                            .font(.headline)
                            .foregroundColor(AppTheme.Colors.gold)
                        Text("Мы принимаем все необходимые меры для защиты ваших персональных данных от несанкционированного доступа, изменения, раскрытия или уничтожения.")
                            .foregroundColor(AppTheme.Colors.lightBeige)
                    }
                }
                .padding()
                .background(Color.black)
                .cornerRadius(12)
            }
            .navigationBarItems(trailing: Button("Готово") {
                dismiss()
            })
        }
    }
}

struct TermsOfServiceView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Условия использования")
                        .font(.title)
                        .foregroundColor(AppTheme.Colors.lightBeige)
                    
                    Text("Последнее обновление: 1 марта 2024")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.6))
                    
                    Group {
                        Text("1. Принятие условий")
                            .font(.headline)
                            .foregroundColor(AppTheme.Colors.gold)
                        Text("Используя наше приложение, вы соглашаетесь с этими условиями использования. Если вы не согласны с какими-либо условиями, пожалуйста, не используйте приложение.")
                            .foregroundColor(AppTheme.Colors.lightBeige)
                    }
                    
                    Group {
                        Text("2. Использование приложения")
                            .font(.headline)
                            .foregroundColor(AppTheme.Colors.gold)
                        Text("• Вы должны быть старше 18 лет\n• Вы несете ответственность за сохранность своего аккаунта\n• Вы соглашаетесь не использовать приложение для незаконных целей")
                            .foregroundColor(AppTheme.Colors.lightBeige)
                    }
                    
                    Group {
                        Text("3. Бронирования")
                            .font(.headline)
                            .foregroundColor(AppTheme.Colors.gold)
                        Text("• Бронирования подлежат правилам ресторана\n• Отмена бронирования должна производиться заранее\n• Мы не несем ответственности за действия ресторана")
                            .foregroundColor(AppTheme.Colors.lightBeige)
                    }
                }
                .padding()
                .background(Color.black)
                .cornerRadius(12)
            }
            .navigationBarItems(trailing: Button("Готово") {
                dismiss()
            })
        }
    }
} 