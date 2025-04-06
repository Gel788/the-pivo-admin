import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    
    @State private var name: String
    @State private var email: String
    @State private var phone: String
    @State private var isLoading = false
    @State private var showSuccessMessage = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showValidationError = false
    @State private var validationMessage = ""
    
    init(user: AppModels.User) {
        _name = State(initialValue: user.name)
        _email = State(initialValue: user.email)
        _phone = State(initialValue: user.phone)
    }
    
    var body: some View {
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
                    // Заголовок
                    Text("Редактирование профиля")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppTheme.Colors.gold)
                        .padding(.top, 10)
                    
                    // Аватар
                    VStack(spacing: 15) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(AppTheme.Colors.gold, lineWidth: 2)
                                )
                        } else {
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
                        }
                        
                        Button(action: {
                            showImagePicker = true
                        }) {
                            Text("Изменить фото")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppTheme.Colors.gold)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(AppTheme.Colors.gold, lineWidth: 1)
                                )
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Форма редактирования
                    VStack(spacing: 20) {
                        formField(icon: "person.fill", title: "Имя") {
                            TextField("Введите ваше имя", text: $name)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        formField(icon: "envelope.fill", title: "Email") {
                            TextField("Введите ваш email", text: $email)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        formField(icon: "phone.fill", title: "Телефон") {
                            TextField("Введите ваш телефон", text: $phone)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.phonePad)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
                    )
                    
                    // Кнопка сохранения
                    Button(action: saveChanges) {
                        Text("Сохранить изменения")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(AppTheme.Colors.gold)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
            
            // Индикатор загрузки
            if isLoading {
                loadingOverlay
            }
            
            // Сообщение об успехе
            if showSuccessMessage {
                successMessageOverlay
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(isLoading || showSuccessMessage)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !isLoading && !showSuccessMessage {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(AppTheme.Colors.gold)
                    }
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Ошибка"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $showValidationError) {
            Alert(
                title: Text("Ошибка валидации"),
                message: Text(validationMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func formField<Content: View>(icon: String, title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(AppTheme.Colors.gold)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.Colors.gold)
            }
            
            content()
        }
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.gold))
                    .scaleEffect(2)
                
                Text("Сохраняем изменения...")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.Colors.lightBeige)
            }
        }
    }
    
    private var successMessageOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 70))
                    .foregroundColor(AppTheme.Colors.gold)
                
                Text("Профиль обновлен!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.Colors.gold)
                
                Text("Ваши данные успешно сохранены")
                    .font(.system(size: 16))
                    .foregroundColor(AppTheme.Colors.lightBeige)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Готово")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppTheme.Colors.gold)
                        .cornerRadius(15)
                }
                .padding(.top, 10)
            }
            .padding(30)
            .background(Color(red: 0.1, green: 0.05, blue: 0.1))
            .cornerRadius(20)
            .padding(.horizontal, 40)
        }
    }
    
    private func validateInput() -> Bool {
        // Проверка имени
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validationMessage = "Имя не может быть пустым"
            showValidationError = true
            return false
        }
        
        // Проверка email
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: email) {
            validationMessage = "Введите корректный email"
            showValidationError = true
            return false
        }
        
        // Проверка телефона
        if !phone.isEmpty {
            let phoneRegex = "^\\+?[0-9]{10,15}$"
            let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
            if !phonePredicate.evaluate(with: phone) {
                validationMessage = "Введите корректный номер телефона"
                showValidationError = true
                return false
            }
        }
        
        return true
    }
    
    private func saveChanges() {
        guard validateInput() else { return }
        
        isLoading = true
        
        // Создаем обновленного пользователя
        if var currentUser = appState.currentUser {
            currentUser.name = name
            currentUser.email = email
            currentUser.phone = phone
            
            // Обновляем пользователя в AppState
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                appState.currentUser = currentUser
                isLoading = false
                showSuccessMessage = true
            }
        } else {
            alertMessage = "Ошибка: пользователь не найден"
            showAlert = true
            isLoading = false
        }
    }
}

// ImagePicker для выбора фото
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 12)
            .padding(.horizontal, 15)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black.opacity(0.3))
                    .shadow(color: AppTheme.Colors.gold.opacity(0.1), radius: 5, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
            )
            .foregroundColor(AppTheme.Colors.lightBeige)
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditProfileView(user: AppModels.User(
                id: "1",
                name: "Иван Иванов",
                email: "ivan@example.com",
                phone: "+7 (999) 123-45-67",
                favoriteRestaurants: []
            ))
            .environmentObject(AppState())
        }
        .preferredColorScheme(.dark)
    }
} 