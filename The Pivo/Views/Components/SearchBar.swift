import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    let placeholder: String
    
    init(text: Binding<String>, placeholder: String) {
        self._text = text
        self.placeholder = placeholder
    }
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppTheme.Colors.gold)
            
            TextField(placeholder, text: $text)
                .foregroundColor(AppTheme.Colors.lightBeige)
            
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppTheme.Colors.gold)
                }
            }
        }
        .padding(8)
        .background(Color.black.opacity(0.7))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    SearchBar(text: .constant(""), placeholder: "Поиск")
        .padding()
        .background(Color.black)
} 