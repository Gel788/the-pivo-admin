import Foundation
import SwiftUI

class ReservationService: ObservableObject {
    static let shared = ReservationService()
    
    @Published private(set) var reservations: [AppModels.Reservation] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let userDefaults = UserDefaults.standard
    private let reservationsKey = "savedReservations"
    
    init() {
        // Инициализируем данные в главном потоке
        DispatchQueue.main.async {
            self.loadReservations()
        }
    }
    
    // Создание нового бронирования
    func createReservation(
        restaurantId: String,
        restaurantName: String,
        date: Date,
        time: String,
        numberOfGuests: Int,
        specialRequests: String?,
        selectedMenuItems: [AppModels.MenuItem]
    ) -> AppModels.Reservation {
        let reservation = AppModels.Reservation(
            id: UUID().uuidString,
            restaurantId: restaurantId,
            restaurantName: restaurantName,
            date: date,
            time: time,
            numberOfGuests: numberOfGuests,
            status: .pending,
            specialRequests: specialRequests,
            selectedMenuItems: selectedMenuItems
        )
        
        // Обновляем состояние в главном потоке
        DispatchQueue.main.async {
            self.reservations.append(reservation)
            self.saveReservations()
            self.objectWillChange.send()
        }
        
        return reservation
    }
    
    // Обновление статуса бронирования
    func updateReservationStatus(_ reservation: AppModels.Reservation, status: AppModels.ReservationStatus) -> AppModels.Reservation {
        if let index = reservations.firstIndex(where: { $0.id == reservation.id }) {
            let updatedReservation = AppModels.Reservation(
                id: reservation.id,
                restaurantId: reservation.restaurantId,
                restaurantName: reservation.restaurantName,
                date: reservation.date,
                time: reservation.time,
                numberOfGuests: reservation.numberOfGuests,
                status: status,
                specialRequests: reservation.specialRequests,
                selectedMenuItems: reservation.selectedMenuItems
            )
            
            // Обновляем состояние в главном потоке
            DispatchQueue.main.async {
                self.reservations[index] = updatedReservation
                self.saveReservations()
                self.objectWillChange.send()
            }
            
            return updatedReservation
        }
        return reservation
    }
    
    // Отмена бронирования
    func cancelReservation(_ reservation: AppModels.Reservation) {
        if let index = reservations.firstIndex(where: { $0.id == reservation.id }) {
            reservations.remove(at: index)
            saveReservations()
        }
    }
    
    // Получение бронирований по фильтру
    func getReservations(filter: (AppModels.Reservation) -> Bool) -> [AppModels.Reservation] {
        return reservations.filter(filter)
    }
    
    // Получение бронирований для конкретного ресторана
    func getReservationsForRestaurant(_ restaurantId: String) -> [AppModels.Reservation] {
        return getReservations { $0.restaurantId == restaurantId }
    }
    
    // Получение конкретного бронирования
    func getReservation(_ id: String) -> AppModels.Reservation? {
        return reservations.first { $0.id == id }
    }
    
    // Получение всех активных бронирований (не отмененных)
    func getActiveReservations() -> [AppModels.Reservation] {
        return getReservations { $0.status == .confirmed }
    }
    
    // Получение предстоящих бронирований
    func getUpcomingReservations() -> [AppModels.Reservation] {
        let now = Date()
        return getReservations { $0.date > now && $0.status != .cancelled }
    }
    
    // Обновление бронирования
    func updateReservation(_ reservation: AppModels.Reservation, completion: @escaping (Bool) -> Void = { _ in }) {
        if let index = reservations.firstIndex(where: { $0.id == reservation.id }) {
            DispatchQueue.main.async {
                self.reservations[index] = reservation
                self.saveReservations()
                self.objectWillChange.send()
                completion(true)
            }
        } else {
            completion(false)
        }
    }
    
    private func loadReservations() {
        if let data = userDefaults.data(forKey: reservationsKey),
           let decodedReservations = try? JSONDecoder().decode([AppModels.Reservation].self, from: data) {
            DispatchQueue.main.async {
                self.reservations = decodedReservations
                print("Загружено \(self.reservations.count) бронирований")
            }
        } else {
            print("Нет сохраненных бронирований")
        }
    }
    
    private func saveReservations() {
        do {
            let encoded = try JSONEncoder().encode(reservations)
            userDefaults.set(encoded, forKey: reservationsKey)
            print("Сохранено \(reservations.count) бронирований")
        } catch {
            print("Ошибка при сохранении бронирований: \(error.localizedDescription)")
        }
    }
} 