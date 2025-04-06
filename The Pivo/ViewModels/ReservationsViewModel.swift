import Foundation
import SwiftUI

class ReservationsViewModel: ObservableObject {
    @Published var reservationService: ReservationService
    @Published var isLoading = false
    @Published var searchText = ""
    @Published var selectedStatus: AppModels.ReservationStatus?
    
    init() {
        self.reservationService = ReservationService()
        loadReservations()
    }
    
    private func loadReservations() {
        isLoading = true
        // Здесь будет загрузка данных
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
        }
    }
    
    func refreshReservations() {
        isLoading = true
        // Здесь будет обновление данных
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
        }
    }
    
    var filteredActiveReservations: [AppModels.Reservation] {
        var result = reservationService.reservations.filter { $0.status == .pending || $0.status == .confirmed }
        
        if let status = selectedStatus {
            result = result.filter { $0.status == status }
        }
        
        if !searchText.isEmpty {
            result = result.filter { reservation in
                reservation.restaurantName.localizedCaseInsensitiveContains(searchText) ||
                reservation.id.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    var filteredCompletedReservations: [AppModels.Reservation] {
        var result = reservationService.reservations.filter { $0.status == .completed || $0.status == .cancelled }
        
        if let status = selectedStatus {
            result = result.filter { $0.status == status }
        }
        
        if !searchText.isEmpty {
            result = result.filter { reservation in
                reservation.restaurantName.localizedCaseInsensitiveContains(searchText) ||
                reservation.id.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    var totalAmount: Double {
        var total = 0.0
        let filteredReservations = selectedStatus == nil ? 
            reservationService.reservations :
            reservationService.reservations.filter { $0.status == selectedStatus }
        
        for reservation in filteredReservations {
            // Добавляем депозит за каждого гостя
            total += Double(reservation.numberOfGuests) * 250.0
            
            // Добавляем стоимость выбранных позиций меню
            for item in reservation.selectedMenuItems {
                total += item.price
            }
        }
        return total
    }
} 