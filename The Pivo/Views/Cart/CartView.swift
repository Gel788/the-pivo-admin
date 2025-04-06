import SwiftUI





struct CartView: View {
    @EnvironmentObject var appState: AppState
    @State private var showCheckoutSheet = false
    @State private var cartModel = CartModel()
    
    var body: some View {
        ZStack {
            AppTheme.Colors.lightBeige
                .ignoresSafeArea()
            
            if appState.cartItems.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "cart.fill")
                        .font(.system(size: 70))
                        .foregroundColor(AppTheme.Colors.darkBrown.opacity(0.3))
                    
                    Text("Ваша корзина пуста")
                        .font(.title2)
                        .foregroundColor(AppTheme.Colors.darkBrown)
                    
                    Text("Добавьте товары из меню ресторана")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.Colors.darkBrown.opacity(0.7))
                        .multilineTextAlignment(.center)
                    
                    NavigationLink(destination: RestaurantsListView()) {
                        Text("Перейти к ресторанам")
                            .padding()
                            .background(AppTheme.Colors.gold)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            } else {
                VStack {
                    ScrollView {
                        LazyVStack {
                            ForEach(appState.cartItems) { item in
                                CartItemRow(item: item)
                            }
                        }
                    }
                    
                    VStack(spacing: 15) {
                        HStack {
                            Text("Итого:")
                                .font(.headline)
                                .foregroundColor(AppTheme.Colors.darkBrown)
                            
                            Spacer()
                            
                            Text("\(Int(appState.cartItems.reduce(0) { $0 + ($1.menuItem.price * Double($1.quantity)) })) ₽")
                                .font(.headline)
                                .foregroundColor(AppTheme.Colors.gold)
                        }
                        
                        Button(action: {
                            updateCartModel()
                            showCheckoutSheet = true
                        }) {
                            Text("Оформить заказ")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppTheme.Colors.gold)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .font(.headline)
                        }
                        
                        Button(action: {
                            appState.clearCart()
                        }) {
                            Text("Очистить корзину")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(AppTheme.Colors.warmRed)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(AppTheme.Colors.warmRed, lineWidth: 1)
                                )
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10, corners: [.topLeft, .topRight])
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
                }
            }
        }
        .navigationTitle("Корзина")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showCheckoutSheet) {
            CheckoutView(cartModel: cartModel, appState: appState)
        }
    }
    
    private func updateCartModel() {
        cartModel = CartModel()
        for item in appState.cartItems {
            cartModel.addItem(menuItem: item.menuItem)
        }
    }
    
    private func removeItems(at offsets: IndexSet) {
        for offset in offsets {
            let item = appState.cartItems[offset]
            appState.removeFromCart(item)
        }
    }
}

struct CartItemRow: View {
    let item: AppModels.CartItem
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                Text(item.menuItem.name)
                    .font(.headline)
                    .foregroundColor(AppTheme.Colors.darkBrown)
                
                Text("\(Int(item.menuItem.price)) ₽")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.Colors.gold)
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    decrementQuantity()
                }) {
                    Image(systemName: "minus.circle")
                        .foregroundColor(AppTheme.Colors.darkBrown)
                }
                
                Text("\(item.quantity)")
                    .font(.headline)
                    .frame(minWidth: 30)
                    .foregroundColor(AppTheme.Colors.darkBrown)
                
                Button(action: {
                    incrementQuantity()
                }) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(AppTheme.Colors.gold)
                }
                
                Button(action: {
                    appState.removeFromCart(item)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(AppTheme.Colors.warmRed)
                }
                .padding(.leading, 10)
            }
            
            Text("\(Int(item.menuItem.price * Double(item.quantity))) ₽")
                .font(.headline)
                .foregroundColor(AppTheme.Colors.darkBrown)
                .frame(minWidth: 70, alignment: .trailing)
        }
        .padding(.vertical, 5)
    }
    
    private func incrementQuantity() {
        appState.updateCartItemQuantity(item, quantity: item.quantity + 1)
    }
    
    private func decrementQuantity() {
        if item.quantity > 1 {
            appState.updateCartItemQuantity(item, quantity: item.quantity - 1)
        } else {
            appState.removeFromCart(item)
        }
    }
}

struct CheckoutView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    @State private var orderType = 0
    @State private var address = ""
    @State private var comment = ""
    @State private var showingAlert = false
    var cartModel: CartModel
    @StateObject private var orderViewModel: OrderViewModel
    
    init(cartModel: CartModel, appState: AppState) {
        self.cartModel = cartModel
        self._orderViewModel = StateObject(wrappedValue: OrderViewModel())
    }
    
    var body: some View {
        Form {
            Section(header: Text("Тип заказа")) {
                Picker("Тип заказа", selection: $orderType) {
                    Text("Доставка").tag(0)
                    Text("Самовывоз").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            if orderType == 0 {
                Section(header: Text("Адрес доставки")) {
                    TextField("Введите адрес", text: $address)
                }
            }
            
            Section(header: Text("Ваш заказ")) {
                ForEach(cartModel.items) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("\(item.quantity) x \(Int(item.price)) ₽")
                            .foregroundColor(AppTheme.Colors.darkBrown.opacity(0.7))
                    }
                }
                
                HStack {
                    Text("Итого")
                        .font(.headline)
                    Spacer()
                    Text("\(Int(cartModel.totalPrice)) ₽")
                        .font(.headline)
                        .foregroundColor(AppTheme.Colors.gold)
                }
                .padding(.top, 5)
            }
            
            Section(header: Text("Комментарий к заказу")) {
                TextField("Комментарий (необязательно)", text: $comment)
            }
            
            Section {
                Button(action: {
                    if let user = appState.currentUser,
                       let paymentMethod = user.paymentMethods.first(where: { $0.isDefault }) {
                        appState.checkout(totalAmount: cartModel.totalPrice, paymentMethod: paymentMethod)
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showingAlert = true
                    }
                }) {
                    Text("Оформить заказ")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                }
                .listRowBackground(AppTheme.Colors.gold)
            }
        }
        .navigationTitle("Оформление заказа")
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Ошибка"),
                message: Text("Пожалуйста, добавьте способ оплаты в профиле"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        let appState = AppState()
        let menuItem = AppModels.MenuItem(
            id: "1",
            name: "Пиво",
            description: "Вкусное пиво",
            price: 300,
            imageURL: "beer",
            category: .beer
        )
        appState.addToCart(AppModels.CartItem(menuItem: menuItem))
        
        return CartView()
            .environmentObject(appState)
    }
} 