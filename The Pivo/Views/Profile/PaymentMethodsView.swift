import SwiftUI

struct PaymentMethodsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @State private var showingAddCard = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            List {
                if let paymentMethods = appState.currentUser?.paymentMethods, !paymentMethods.isEmpty {
                    ForEach(paymentMethods, id: \.id) { method in
                        PaymentMethodRow(method: method)
                    }
                    .onDelete(perform: deletePaymentMethod)
                } else {
                    Text("Нет добавленных способов оплаты")
                        .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.6))
                }
                
                Section {
                    Button(action: { showingAddCard = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(AppTheme.Colors.gold)
                            Text("Добавить карту")
                                .foregroundColor(AppTheme.Colors.gold)
                        }
                    }
                }
            }
            .navigationTitle("Способы оплаты")
            .navigationBarItems(trailing: Button("Готово") {
                dismiss()
            })
            .sheet(isPresented: $showingAddCard) {
                AddPaymentMethodView()
            }
            .alert("Способ оплаты", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func deletePaymentMethod(at offsets: IndexSet) {
        if let user = appState.currentUser {
            var methods = user.paymentMethods
            methods.remove(atOffsets: offsets)
            appState.updatePaymentMethods(methods)
        }
    }
}

struct PaymentMethodRow: View {
    let method: PaymentMethod
    
    var body: some View {
        HStack {
            Image(systemName: method.type.iconName)
                .font(.title2)
                .foregroundColor(AppTheme.Colors.gold)
                .frame(width: 40)
            
            VStack(alignment: .leading) {
                Text(method.type.rawValue)
                    .font(.headline)
                    .foregroundColor(AppTheme.Colors.lightBeige)
                Text("•••• \(method.lastFourDigits)")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.6))
                Text("Срок действия: \(method.expiryDate)")
                    .font(.caption)
                    .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.4))
            }
            
            Spacer()
            
            if method.isDefault {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(AppTheme.Colors.gold)
            }
        }
        .padding(.vertical, 8)
    }
}

struct AddPaymentMethodView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var cardholderName = ""
    @State private var isDefault = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Данные карты")) {
                    TextField("Номер карты", text: $cardNumber)
                        .keyboardType(.numberPad)
                    TextField("Срок действия (ММ/ГГ)", text: $expiryDate)
                        .keyboardType(.numberPad)
                    TextField("CVV", text: $cvv)
                        .keyboardType(.numberPad)
                    TextField("Имя владельца", text: $cardholderName)
                }
                
                Section {
                    Toggle("Сделать карту основной", isOn: $isDefault)
                }
                
                Section {
                    Button(action: addCard) {
                        Text("Добавить карту")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(AppTheme.Colors.gold)
                }
            }
            .navigationTitle("Новая карта")
            .navigationBarItems(trailing: Button("Отмена") {
                dismiss()
            })
            .alert("Карта", isPresented: $showingAlert) {
                Button("OK") {
                    if alertMessage.contains("успешно") {
                        dismiss()
                    }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func addCard() {
        // Валидация
        if cardNumber.isEmpty || expiryDate.isEmpty || cvv.isEmpty || cardholderName.isEmpty {
            alertMessage = "Пожалуйста, заполните все поля"
            showingAlert = true
            return
        }
        
        // Парсинг даты
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        guard let expiryDateObj = dateFormatter.date(from: expiryDate) else {
            alertMessage = "Неверный формат даты"
            showingAlert = true
            return
        }
        
        // Здесь будет логика добавления карты
        let newMethod = AppModels.PaymentMethod(
            type: .creditCard,
            lastFourDigits: String(cardNumber.suffix(4)),
            expiryDate: expiryDateObj,
            isDefault: isDefault
        )
        
        if let user = appState.currentUser {
            var methods = user.paymentMethods
            methods.append(newMethod)
            appState.updatePaymentMethods(methods)
        }
        
        alertMessage = "Карта успешно добавлена"
        showingAlert = true
    }
} 