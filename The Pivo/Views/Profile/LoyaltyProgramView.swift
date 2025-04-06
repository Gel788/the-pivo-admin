import SwiftUI

struct LoyaltyProgramView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @State private var showingTransactionHistory = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let loyalty = appState.currentUser?.loyaltyProgram {
                        // Текущий уровень и прогресс
                        VStack(spacing: 15) {
                            Text("Текущий уровень")
                                .font(.headline)
                                .foregroundColor(AppTheme.Colors.lightBeige)
                            
                            Text(loyalty.level.rawValue)
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(AppTheme.Colors.gold)
                            
                            // Прогресс-бар
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(Color.black.opacity(0.5))
                                        .frame(height: 8)
                                        .cornerRadius(4)
                                    
                                    Rectangle()
                                        .fill(AppTheme.Colors.gold)
                                        .frame(width: geometry.size.width * CGFloat(loyalty.points) / CGFloat(loyalty.level.requiredPoints), height: 8)
                                        .cornerRadius(4)
                                }
                            }
                            .frame(height: 8)
                            
                            HStack {
                                Text("\(loyalty.points) / \(loyalty.level.requiredPoints) баллов")
                                    .font(.subheadline)
                                    .foregroundColor(AppTheme.Colors.lightBeige)
                                
                                Spacer()
                                
                                Text("Скидка \(loyalty.level.discount)%")
                                    .font(.subheadline)
                                    .foregroundColor(AppTheme.Colors.gold)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.5))
                        )
                        
                        // Преимущества текущего уровня
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Преимущества уровня")
                                .font(.headline)
                                .foregroundColor(AppTheme.Colors.lightBeige)
                            
                            ForEach(loyalty.level.benefits, id: \.self) { benefit in
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(AppTheme.Colors.gold)
                                    Text(benefit)
                                        .foregroundColor(AppTheme.Colors.lightBeige)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.5))
                        )
                        
                        // История транзакций
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("История транзакций")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.Colors.lightBeige)
                                
                                Spacer()
                                
                                Button(action: { showingTransactionHistory = true }) {
                                    Text("Все")
                                        .foregroundColor(AppTheme.Colors.gold)
                                }
                            }
                            
                            ForEach(loyalty.transactions.prefix(5)) { transaction in
                                TransactionRow(transaction: transaction)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.5))
                        )
                    } else {
                        Text("Программа лояльности недоступна")
                            .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.6))
                    }
                }
                .padding()
            }
            .background(Color.black)
            .navigationTitle("Программа лояльности")
            .navigationBarItems(trailing: Button("Готово") {
                dismiss()
            })
            .sheet(isPresented: $showingTransactionHistory) {
                TransactionHistoryView()
            }
        }
    }
}

struct TransactionRow: View {
    let transaction: LoyaltyTransaction
    
    var body: some View {
        HStack {
            Image(systemName: transaction.type.iconName)
                .foregroundColor(transaction.type.color)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(transaction.description)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.Colors.lightBeige)
                Text(transaction.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.6))
            }
            
            Spacer()
            
            Text(transaction.type.pointsPrefix + "\(transaction.points)")
                .font(.subheadline)
                .foregroundColor(transaction.type.color)
        }
        .padding(.vertical, 5)
    }
}

struct TransactionHistoryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            List {
                if let transactions = appState.currentUser?.loyaltyProgram.transactions {
                    ForEach(transactions) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                }
            }
            .navigationTitle("История транзакций")
            .navigationBarItems(trailing: Button("Готово") {
                dismiss()
            })
        }
    }
} 