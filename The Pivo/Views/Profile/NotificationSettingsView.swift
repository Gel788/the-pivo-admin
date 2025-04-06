import SwiftUI

struct NotificationSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @State private var settings: NotificationSettings
    
    init() {
        _settings = State(initialValue: NotificationSettings(
            reservationReminders: true,
            specialOffers: true,
            newsUpdates: true,
            loyaltyUpdates: true
        ))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Уведомления о бронировании")) {
                    Toggle("Напоминания о бронировании", isOn: $settings.reservationReminders)
                    Toggle("Изменения статуса бронирования", isOn: $settings.reservationReminders)
                }
                
                Section(header: Text("Маркетинговые уведомления")) {
                    Toggle("Специальные предложения", isOn: $settings.specialOffers)
                    Toggle("Новости и обновления", isOn: $settings.newsUpdates)
                }
                
                Section(header: Text("Программа лояльности")) {
                    Toggle("Обновления бонусов", isOn: $settings.loyaltyUpdates)
                }
                
                Section {
                    Button(action: saveSettings) {
                        Text("Сохранить настройки")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(AppTheme.Colors.gold)
                }
            }
            .navigationTitle("Настройки уведомлений")
            .navigationBarItems(trailing: Button("Готово") {
                dismiss()
            })
            .onAppear {
                if let user = appState.currentUser {
                    settings = user.notifications
                }
            }
        }
    }
    
    private func saveSettings() {
        appState.updateNotificationSettings(settings)
        dismiss()
    }
} 