import SwiftUI

struct ViewHistoryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @State private var selectedTimeRange: TimeRange = .week
    
    enum TimeRange: String, CaseIterable {
        case day = "День"
        case week = "Неделя"
        case month = "Месяц"
        case all = "Все"
    }
    
    var filteredHistory: [AppModels.ViewHistory] {
        guard let history = appState.currentUser?.recentViews else { return [] }
        
        let calendar = Calendar.current
        let now = Date()
        
        return history.filter { historyItem in
            switch selectedTimeRange {
            case .day:
                return calendar.isDateInToday(historyItem.timestamp)
            case .week:
                return calendar.isDate(historyItem.timestamp, equalTo: now, toGranularity: .weekOfYear)
            case .month:
                return calendar.isDate(historyItem.timestamp, equalTo: now, toGranularity: .month)
            case .all:
                return true
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Фильтр по времени
                Picker("Период", selection: $selectedTimeRange) {
                    ForEach(TimeRange.allCases, id: \.self) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(Color.black)
                .cornerRadius(12)
                
                if filteredHistory.isEmpty {
                    VStack(spacing: 15) {
                        Image(systemName: "clock")
                            .font(.system(size: 50))
                            .foregroundColor(AppTheme.Colors.gold.opacity(0.5))
                        Text("История просмотров пуста")
                            .font(.headline)
                            .foregroundColor(AppTheme.Colors.lightBeige)
                        Text("Здесь будет отображаться история просмотренных ресторанов")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(filteredHistory) { historyItem in
                            ViewHistoryRow(historyItem: historyItem)
                        }
                        .onDelete(perform: deleteHistory)
                    }
                }
            }
            .background(Color.black)
            .navigationTitle("История просмотров")
            .navigationBarItems(trailing: Button("Готово") {
                dismiss()
            })
        }
    }
    
    private func deleteHistory(at offsets: IndexSet) {
        if var user = appState.currentUser {
            user.recentViews.remove(atOffsets: offsets)
            appState.updateViewHistory(user.recentViews)
        }
    }
}

struct ViewHistoryRow: View {
    let historyItem: AppModels.ViewHistory
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack {
            Text(historyItem.timestamp.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundColor(AppTheme.Colors.lightBeige.opacity(0.4))
        }
        .padding(.vertical, 5)
    }
}
