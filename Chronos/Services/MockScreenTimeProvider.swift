//
//  MockScreenTimeProvider.swift
//  Chronos
//
//  Implémentation de démonstration : fournit un jeu de données réaliste afin
//  que l'application soit pleinement fonctionnelle dans le simulateur, sans
//  l'entitlement Family Controls. Les valeurs sont stables au sein d'une session.
//

import Foundation

struct MockScreenTimeProvider: ScreenTimeProviding {

    private(set) var isAuthorized: Bool = false

    func requestAuthorization() async -> Bool {
        // Une vraie implémentation appellerait :
        // try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
        true
    }

    func todaysUsage() -> [TrackedApp] {
        let m = 60.0 // une minute
        return [
            TrackedApp(name: "Instagram", symbolName: "camera",
                       tintHex: 0xC2410C, category: .social,
                       usedToday: 78 * m, limit: 60 * m),
            TrackedApp(name: "Messages", symbolName: "message",
                       tintHex: 0x8B8378, category: .social,
                       usedToday: 41 * m, limit: nil),
            TrackedApp(name: "Vidéos", symbolName: "play.rectangle",
                       tintHex: 0x460000, category: .divertissement,
                       usedToday: 55 * m, limit: 45 * m),
            TrackedApp(name: "Actualités", symbolName: "newspaper",
                       tintHex: 0xA8643C, category: .information,
                       usedToday: 22 * m, limit: 30 * m),
            TrackedApp(name: "Jeu", symbolName: "gamecontroller",
                       tintHex: 0x6E4B2A, category: .jeux,
                       usedToday: 16 * m, limit: 20 * m),
            TrackedApp(name: "Musique", symbolName: "music.note",
                       tintHex: 0xC79A8A, category: .divertissement,
                       usedToday: 34 * m, limit: nil),
            TrackedApp(name: "Navigateur", symbolName: "safari",
                       tintHex: 0x8B5A2B, category: .information,
                       usedToday: 19 * m, limit: nil, isTracked: true),
            TrackedApp(name: "Travail", symbolName: "tray.full",
                       tintHex: 0x4A4540, category: .productivite,
                       usedToday: 27 * m, limit: nil)
        ]
    }

    func yesterdayTotal() -> TimeInterval {
        // Légèrement supérieur au total du jour pour une note encourageante.
        4 * 3600 + 9 * 60
    }
}
