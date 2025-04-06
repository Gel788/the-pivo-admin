import SwiftUI

struct FilterButtonView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Typography.bodySmall)
                .fontWeight(isSelected ? .bold : .medium)
                .padding(.horizontal, AppTheme.Spacing.small)
                .padding(.vertical, AppTheme.Spacing.small / 2)
                .background(isSelected ? AppTheme.Colors.gold : Color(UIColor.systemGray6).opacity(0.3))
                .foregroundColor(isSelected ? .black : AppTheme.Colors.lightBeige)
                .cornerRadius(15)
        }
    }
}

struct FilterButtonGroup<T: Hashable & CaseIterable>: View where T: RawRepresentable, T.RawValue == String {
    @Binding var selectedItem: T?
    var includeAllOption: Bool = true
    var allTitle: String = "Все"
    var titleForItem: ((T) -> String)?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.medium) {
                if includeAllOption {
                    FilterButtonView(
                        title: allTitle,
                        isSelected: selectedItem == nil,
                        action: {
                            selectedItem = nil
                        }
                    )
                }
                
                ForEach(Array(T.allCases), id: \.self) { item in
                    FilterButtonView(
                        title: titleForItem?(item) ?? item.rawValue,
                        isSelected: selectedItem == item,
                        action: {
                            selectedItem = item
                        }
                    )
                }
            }
            .padding(.horizontal, AppTheme.Spacing.medium)
        }
        .padding(.vertical, AppTheme.Spacing.small)
    }
}

struct FilterButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            FilterButtonView(title: "С пивом", isSelected: true, action: {})
            FilterButtonView(title: "Без пива", isSelected: false, action: {})
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
} 