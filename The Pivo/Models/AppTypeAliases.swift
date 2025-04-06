import Foundation
import SwiftUI

// MARK: - Типалиасы из пространства имен AppModels
// Основные модели данных
typealias Restaurant = AppModels.Restaurant
typealias RestaurantModel = Restaurant
typealias MenuItemModel = AppModels.MenuItem
typealias NewsModel = AppModels.News
typealias NewsType = AppModels.NewsType
typealias User = AppModels.User
typealias Reservation = AppModels.Reservation
typealias ReservationStatus = AppModels.ReservationStatus
typealias Order = AppModels.Order
typealias CartItem = AppModels.CartItem
typealias MenuItemWithQuantity = AppModels.MenuItemWithQuantity
typealias ViewHistory = AppModels.ViewHistory
typealias NotificationSettings = AppModels.NotificationSettings
typealias PaymentMethod = AppModels.PaymentMethod
typealias LoyaltyTransaction = AppModels.LoyaltyTransaction

// MARK: - Типы, которые вызывают конфликты и не используются
// Следующие типалиасы закомментированы из-за конфликтов с типами в AppState.swift
// typealias User = AppModels.User
// typealias Reservation = AppModels.Reservation
// typealias ReservationStatus = AppModels.ReservationStatus

// MARK: - Типы замыканий
typealias VoidClosure = () -> Void
typealias BoolClosure = (Bool) -> Void
typealias StringClosure = (String) -> Void
typealias IntClosure = (Int) -> Void
typealias DoubleClosure = (Double) -> Void
typealias DateClosure = (Date) -> Void
typealias ErrorClosure = (Error) -> Void
typealias MenuItemClosure = (AppModels.MenuItem) -> Void
typealias MenuItemWithQuantityClosure = (AppModels.MenuItemWithQuantity) -> Void
typealias ReservationClosure = (AppModels.Reservation) -> Void
typealias RestaurantClosure = (AppModels.Restaurant) -> Void
typealias NewsClosure = (AppModels.News) -> Void 