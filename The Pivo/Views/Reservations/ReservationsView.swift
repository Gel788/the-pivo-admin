import SwiftUI

// MARK: - ReservationList
struct ReservationList: View {
    let reservations: [AppModels.Reservation]
    let reservationService: ReservationService
    @State private var isRefreshing = false
    
    var body: some View {
        ScrollView {
            RefreshControl(isRefreshing: $isRefreshing) {
                // Обновление данных
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isRefreshing = false
                }
            }
            
            if reservations.isEmpty {
                EmptyReservationView()
            } else {
                LazyVStack(spacing: 15) {
                    ForEach(reservations) { reservation in
                        NavigationLink {
                            BookingDetailsView(reservation: reservation)
                                .environmentObject(reservationService)
                        } label: {
                            ReservationCard(reservation: reservation)
                                .environmentObject(reservationService)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.9).combined(with: .opacity),
                            removal: .scale(scale: 0.8).combined(with: .opacity)
                        ))
                    }
                }
                .padding()
            }
        }
    }
}

// MARK: - RefreshControl
struct RefreshControl: View {
    @Binding var isRefreshing: Bool
    let action: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            if geometry.frame(in: .global).minY > 50 {
                Spacer()
                    .onAppear {
                        if !isRefreshing {
                            isRefreshing = true
                            action()
                        }
                    }
            }
            
            HStack {
                Spacer()
                if isRefreshing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.gold))
                }
                Spacer()
            }
        }
        .frame(height: 50)
    }
}

// MARK: - EmptyReservationView
struct EmptyReservationView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.Colors.gold)
            
            Text("У вас пока нет бронирований")
                .font(.title3)
                .foregroundColor(AppTheme.Colors.lightBeige)
        }
        .padding(.top, 50)
    }
}

// MARK: - StatusFilters
struct StatusFilters: View {
    @Binding var selectedStatus: AppModels.ReservationStatus?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterChip(
                    title: "Все",
                    isSelected: selectedStatus == nil,
                    action: { withAnimation(.spring()) { selectedStatus = nil } }
                )
                
                ForEach(AppModels.ReservationStatus.allCases, id: \.self) { status in
                    FilterChip(
                        title: status.rawValue,
                        isSelected: selectedStatus == status,
                        action: { withAnimation(.spring()) { selectedStatus = status } }
                    )
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

// MARK: - TotalAmountView
struct TotalAmountView: View {
    let amount: Double
    
    var body: some View {
        HStack {
            Text("Общая сумма:")
                .font(.headline)
                .foregroundColor(AppTheme.Colors.lightBeige)
            Text("\(amount, specifier: "%.2f") ₽")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.Colors.gold)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: AppTheme.Colors.gold.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Main View
struct ReservationsView: View {
    @StateObject private var viewModel = ReservationsViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Верхняя панель с поиском и фильтрами
                VStack(spacing: 12) {
                    // Поисковая строка
                    SearchBar(text: $viewModel.searchText, placeholder: "Поиск бронирований...")
                        .padding(.horizontal)
                    
                    // Фильтры статуса
                    StatusFilters(selectedStatus: $viewModel.selectedStatus)
                        .padding(.horizontal)
                    
                    // Общая сумма
                    TotalAmountView(amount: viewModel.totalAmount)
                }
                .padding(.vertical, 8)
                .background(
                    Color(.systemBackground)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, y: 5)
                )
                
                // Основной контент
                TabView(selection: $selectedTab) {
                    // Активные бронирования
                    ReservationList(
                        reservations: viewModel.filteredActiveReservations,
                        reservationService: viewModel.reservationService
                    )
                    .tag(0)
                    
                    // Завершенные бронирования
                    ReservationList(
                        reservations: viewModel.filteredCompletedReservations,
                        reservationService: viewModel.reservationService
                    )
                    .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Индикатор вкладок
                HStack(spacing: 0) {
                    TabButton(title: "Активные", isSelected: selectedTab == 0) {
                        withAnimation(.spring()) {
                            selectedTab = 0
                        }
                    }
                    
                    TabButton(title: "Завершенные", isSelected: selectedTab == 1) {
                        withAnimation(.spring()) {
                            selectedTab = 1
                        }
                    }
                }
                .padding(.vertical, 8)
                .background(
                    Color(.systemBackground)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, y: -5)
                )
            }
            .navigationTitle("Мои бронирования")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.spring()) {
                            viewModel.refreshReservations()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(AppTheme.Colors.gold)
                            .rotationEffect(.degrees(viewModel.isLoading ? 360 : 0))
                            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: viewModel.isLoading)
                    }
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                        .transition(.opacity)
                }
            }
        }
    }
}

// MARK: - Supporting Views
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(isSelected ? .white : AppTheme.Colors.gold)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? AppTheme.Colors.gold : AppTheme.Colors.gold.opacity(0.1))
                )
                .overlay(
                    Capsule()
                        .stroke(AppTheme.Colors.gold.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: AppTheme.Colors.gold.opacity(0.1), radius: 3, x: 0, y: 2)
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(isSelected ? AppTheme.Colors.gold : AppTheme.Colors.lightBeige)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    Rectangle()
                        .fill(isSelected ? AppTheme.Colors.gold.opacity(0.1) : Color.clear)
                )
                .overlay(
                    Rectangle()
                        .fill(isSelected ? AppTheme.Colors.gold : Color.clear)
                        .frame(height: 2)
                        .offset(y: 15)
                )
        }
    }
}

// MARK: - Preview
struct ReservationsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReservationsView()
                .environmentObject(AppState())
                .environmentObject(ReservationService())
                .preferredColorScheme(.dark)
        }
    }
} 