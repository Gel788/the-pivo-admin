import SwiftUI

class EditReservationViewModel: ObservableObject {
    @Published var selectedDate: Date
    @Published var selectedTime: String
    @Published var numberOfGuests: Int
    @Published var specialRequests: String
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    
    let reservation: AppModels.Reservation
    let availableTimes = ["12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00"]
    private let reservationService: ReservationService
    
    init(reservation: AppModels.Reservation, reservationService: ReservationService) {
        self.reservation = reservation
        self.reservationService = reservationService
        self._selectedDate = Published(initialValue: reservation.date)
        self._selectedTime = Published(initialValue: reservation.time)
        self._numberOfGuests = Published(initialValue: reservation.numberOfGuests)
        self._specialRequests = Published(initialValue: reservation.specialRequests ?? "")
    }
    
    func saveChanges(completion: @escaping (Bool) -> Void = { _ in }) {
        isLoading = true
        
        let updatedReservation = AppModels.Reservation(
            id: reservation.id,
            restaurantId: reservation.restaurantId,
            restaurantName: reservation.restaurantName,
            date: selectedDate,
            time: selectedTime,
            numberOfGuests: numberOfGuests,
            status: reservation.status,
            specialRequests: specialRequests.isEmpty ? nil : specialRequests,
            selectedMenuItems: reservation.selectedMenuItems
        )
        
        reservationService.updateReservation(updatedReservation) { success in
            DispatchQueue.main.async {
                self.isLoading = false
                if success {
                    completion(true)
                } else {
                    self.showError = true
                    self.errorMessage = "Не удалось сохранить изменения"
                    completion(false)
                }
            }
        }
    }
} 