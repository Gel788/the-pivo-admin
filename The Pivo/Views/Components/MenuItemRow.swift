import SwiftUI

struct MenuItemRow: View {
    let item: AppModels.MenuItem
    @Binding var selectedItems: [AppModels.MenuItemWithQuantity]
    
    private var quantity: Int {
        selectedItems.first(where: { $0.menuItem.id == item.id })?.quantity ?? 0
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.system(size: 16))
                    .foregroundColor(AppTheme.Colors.lightBeige)
                
                Text("\(Int(item.price)) ₽")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.Colors.gold)
            }
            
            Spacer()
            
            HStack(spacing: 15) {
                Button(action: {
                    if quantity > 0 {
                        if quantity == 1 {
                            selectedItems.removeAll { $0.menuItem.id == item.id }
                        } else {
                            if let index = selectedItems.firstIndex(where: { $0.menuItem.id == item.id }) {
                                selectedItems[index].quantity -= 1
                            }
                        }
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(quantity > 0 ? AppTheme.Colors.gold : AppTheme.Colors.gold.opacity(0.3))
                }
                
                Text("\(quantity)")
                    .font(.system(size: 16))
                    .foregroundColor(AppTheme.Colors.lightBeige)
                    .frame(width: 30)
                
                Button(action: {
                    if let index = selectedItems.firstIndex(where: { $0.menuItem.id == item.id }) {
                        selectedItems[index].quantity += 1
                    } else {
                        selectedItems.append(AppModels.MenuItemWithQuantity(id: UUID().uuidString, menuItem: item, quantity: 1))
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(AppTheme.Colors.gold)
                }
            }
        }
        .padding()
        .background(AppTheme.Colors.darkBrown)
        .cornerRadius(10)
    }
} 