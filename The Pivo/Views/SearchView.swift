import SwiftUI

struct SearchView: View {
    @State private var searchText = ""

    var body: some View {
        VStack {
            TextField("Search...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .withKeyboardDismissButton()
                .dismissKeyboardOnTap()

            Button(action: {
                searchText = ""
                hideKeyboard()
            }) {
                Image(systemName: "xmark.circle.fill")
            }
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
} 