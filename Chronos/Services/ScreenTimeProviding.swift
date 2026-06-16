//
//  ScreenTimeProviding.swift
//  Chronos
//
//  Abstraction de la source de données « temps d'écran ».
//
//  En production, une implémentation s'appuierait sur les frameworks Apple :
//    • FamilyControls      → autorisation (AuthorizationCenter.requestAuthorization)
//    • DeviceActivity      → relevés d'usage par application
//    • ManagedSettings     → blocage effectif des apps (limites, downtime)
//
//  Ces frameworks exigent l'entitlement « Family Controls » (accordé par Apple)
//  et ne fonctionnent pas dans le simulateur. L'app reste donc pilotée par une
//  implémentation de démonstration, sélectionnable ici sans toucher au reste.
//

import Foundation

protocol ScreenTimeProviding {
    /// Demande l'autorisation d'accéder au temps d'écran.
    func requestAuthorization() async -> Bool

    /// Indique si l'accès est accordé.
    var isAuthorized: Bool { get }

    /// Relevé d'usage du jour, par application.
    func todaysUsage() -> [TrackedApp]

    /// Temps d'écran total de la veille (pour la comparaison du tableau de bord).
    func yesterdayTotal() -> TimeInterval
}
