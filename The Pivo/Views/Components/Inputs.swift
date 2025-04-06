import SwiftUI

// MARK: - Поле поиска
struct SearchField: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppTheme.Colors.gold)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.dark)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppTheme.Colors.gold)
                }
            }
        }
        .padding(AppTheme.Spacing.medium)
        .background(AppTheme.Colors.lightBeige)
        .cornerRadius(10)
    }
}

// MARK: - Текстовое поле
struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let isSecure: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text(title)
                .font(AppTheme.Typography.bodySmall)
                .foregroundColor(AppTheme.Colors.darkLight)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.dark)
                    .padding(AppTheme.Spacing.medium)
                    .background(AppTheme.Colors.lightBeige)
                    .cornerRadius(10)
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.dark)
                    .padding(AppTheme.Spacing.medium)
                    .background(AppTheme.Colors.lightBeige)
                    .cornerRadius(10)
            }
        }
    }
}

// MARK: - Текстовое поле с иконкой
struct IconTextField: View {
    let systemName: String
    @Binding var text: String
    let placeholder: String
    let isSecure: Bool
    
    var body: some View {
        HStack {
            Image(systemName: systemName)
                .foregroundColor(AppTheme.Colors.gold)
                .frame(width: 20)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.dark)
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.dark)
            }
        }
        .padding(AppTheme.Spacing.medium)
        .background(AppTheme.Colors.lightBeige)
        .cornerRadius(10)
    }
}

// MARK: - Текстовое поле с кнопкой
struct TextFieldWithButton: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let buttonTitle: String
    let buttonAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text(title)
                .font(AppTheme.Typography.bodySmall)
                .foregroundColor(AppTheme.Colors.darkLight)
            
            HStack {
                TextField(placeholder, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.dark)
                    .padding(AppTheme.Spacing.medium)
                    .background(AppTheme.Colors.lightBeige)
                    .cornerRadius(10)
                
                Button(action: buttonAction) {
                    Text(buttonTitle)
                        .font(AppTheme.Typography.button)
                        .foregroundColor(.black)
                        .padding(.horizontal, AppTheme.Spacing.medium)
                        .padding(.vertical, AppTheme.Spacing.small)
                        .background(AppTheme.Colors.gold)
                        .cornerRadius(10)
                }
            }
        }
    }
}

// MARK: - Текстовое поле с валидацией
struct ValidatedTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let errorMessage: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text(title)
                .font(AppTheme.Typography.bodySmall)
                .foregroundColor(AppTheme.Colors.darkLight)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.dark)
                .padding(AppTheme.Spacing.medium)
                .background(AppTheme.Colors.lightBeige)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(errorMessage != nil ? AppTheme.Colors.red : Color.clear, lineWidth: 1)
                )
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(AppTheme.Typography.bodySmall)
                    .foregroundColor(AppTheme.Colors.red)
            }
        }
    }
}

// MARK: - Поле выбора даты
struct DatePickerField: View {
    @Binding var date: Date
    let placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundColor(AppTheme.Colors.gold)
            
            DatePicker(
                placeholder,
                selection: $date,
                displayedComponents: [.date]
            )
            .foregroundColor(AppTheme.Colors.lightBeige)
        }
        .padding(AppTheme.Spacing.medium)
        .background(AppTheme.Colors.lightBeige)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppTheme.Colors.gold, lineWidth: 1)
        )
    }
}

// MARK: - Поле выбора времени
struct TimePickerField: View {
    @Binding var time: Date
    let placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "clock")
                .foregroundColor(AppTheme.Colors.gold)
            
            DatePicker(
                placeholder,
                selection: $time,
                displayedComponents: [.hourAndMinute]
            )
            .foregroundColor(AppTheme.Colors.lightBeige)
        }
        .padding(AppTheme.Spacing.medium)
        .background(AppTheme.Colors.lightBeige)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppTheme.Colors.gold, lineWidth: 1)
        )
    }
} 