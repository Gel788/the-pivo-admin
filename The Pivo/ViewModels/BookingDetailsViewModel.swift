import SwiftUI

class BookingDetailsViewModel: ObservableObject {
    @Published var reservation: AppModels.Reservation
    @Published var restaurantName: String = ""
    @Published var showError = false
    @Published var errorMessage: String?
    
    private let restaurantService = RestaurantService()
    private let reservationService: ReservationService
    
    init(reservation: AppModels.Reservation, reservationService: ReservationService) {
        self.reservation = reservation
        self.reservationService = reservationService
    }
    
    func loadRestaurantName(for restaurantId: String) {
        if let restaurant = restaurantService.restaurants.first(where: { $0.id == restaurantId }) {
            restaurantName = restaurant.name
        }
    }
    
    func confirmReservation() {
        let updatedReservation = AppModels.Reservation(
            id: reservation.id,
            restaurantId: reservation.restaurantId,
            restaurantName: reservation.restaurantName,
            date: reservation.date,
            time: reservation.time,
            numberOfGuests: reservation.numberOfGuests,
            status: .confirmed,
            specialRequests: reservation.specialRequests,
            selectedMenuItems: reservation.selectedMenuItems
        )
        
        reservationService.updateReservation(updatedReservation) { success in
            DispatchQueue.main.async {
                if success {
                    self.reservation = updatedReservation
                    self.objectWillChange.send()
                } else {
                    self.showError = true
                    self.errorMessage = "Не удалось подтвердить бронирование"
                }
            }
        }
    }
    
    func updateReservation(_ updatedReservation: AppModels.Reservation) {
        reservationService.updateReservation(updatedReservation) { success in
            DispatchQueue.main.async {
                if success {
                    self.reservation = updatedReservation
                    self.objectWillChange.send()
                } else {
                    self.showError = true
                    self.errorMessage = "Не удалось обновить бронирование"
                }
            }
        }
    }
    
    func cancelReservation() {
        let updatedReservation = AppModels.Reservation(
            id: reservation.id,
            restaurantId: reservation.restaurantId,
            restaurantName: reservation.restaurantName,
            date: reservation.date,
            time: reservation.time,
            numberOfGuests: reservation.numberOfGuests,
            status: .cancelled,
            specialRequests: reservation.specialRequests,
            selectedMenuItems: reservation.selectedMenuItems
        )
        
        reservationService.updateReservation(updatedReservation) { success in
            DispatchQueue.main.async {
                if success {
                    self.reservation = updatedReservation
                    self.objectWillChange.send()
                } else {
                    self.showError = true
                    self.errorMessage = "Не удалось отменить бронирование"
                }
            }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
} 