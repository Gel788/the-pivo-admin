import SwiftUI
import UIKit

// Расширение для скругления определенных углов View
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// Форма для скругления определенных углов
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// Дополнительные расширения для работы с View
extension View {
    // Применение условного модификатора
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    // Применение тени для карточек
    func cardShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// Расширение для Date для форматирования
extension Date {
    func formattedWithPattern(_ pattern: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        return formatter.string(from: self)
    }
}

#if canImport(UIKit)
import SwiftUI

// Общий метод для скрытия клавиатуры
func hideKeyboard() {
    // Новый способ получения окон для iOS 15+
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first else {
        // Запасной вариант для старых версий
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        return
    }
    
    window.endEditing(true)
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func dismissKeyboardOnTap() -> some View {
        self.gesture(TapGesture().onEnded { _ in
            hideKeyboard()
        })
    }
}

// Модификатор для добавления кнопки закрытия клавиатуры к TextField
struct KeyboardDismissButton: ViewModifier {
    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
            
            if UIResponder.currentFirstResponder != nil {
                Button(action: {
                    // Вызываем метод UIApplication напрямую
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Image(systemName: "keyboard.chevron.compact.down")
                        .foregroundColor(AppTheme.Colors.gold)
                        .padding(8)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                        .padding(.trailing, 10)
                }
            }
        }
    }
}

extension View {
    func withKeyboardDismissButton() -> some View {
        modifier(KeyboardDismissButton())
    }
}

// Отслеживание активного FirstResponder для определения, открыта ли клавиатура
private extension UIResponder {
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }
    
    static var _currentFirstResponder: UIResponder?
    
    @objc private func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }
}
#endif

// Добавляем расширение для поддержки навигации по свайпу
extension View {
    // Функция для добавления свайпа между экранами
    func swipeNavigation<Destination: View>(destination: Destination) -> some View {
        self.gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -100 {
                        // Свайп влево - переход вперед
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            
                            // Переход на новый экран
                            let window = UIApplication.shared.connectedScenes.first as? UIWindowScene
                            let keyWindow = window?.windows.first
                            keyWindow?.rootViewController?.present(
                                UIHostingController(rootView: destination),
                                animated: true
                            )
                        }
                    } else if value.translation.width > 100 {
                        // Свайп вправо - возврат назад
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            
                            // Возврат к предыдущему экрану
                            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                            let rootWindow = scene?.windows.first
                            rootWindow?.rootViewController?.dismiss(animated: true)
                        }
                    }
                }
        )
    }
}

// Обновляю другие места с тем же устаревшим API
func swipeNavigation<Content: View>(_ content: Content) -> some View {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let _ = windowScene.windows.first else {
        return content
    }
    
    // Остальной код остается без изменений
    
    return content
} 