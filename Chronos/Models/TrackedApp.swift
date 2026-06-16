//
//  TrackedApp.swift
//  Chronos
//
//  Une application suivie : usage du jour, limite éventuelle, métadonnées
//  d'affichage. Représente l'unité de base manipulée par l'app.
//

import Foundation

struct TrackedApp: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    /// Symbole SF servant de glyphe (pas d'accès aux vraies icônes système).
    var symbolName: String
    /// Teinte du glyphe (entier hexadécimal).
    var tintHex: UInt
    var category: AppCategory
    /// Temps d'utilisation aujourd'hui.
    var usedToday: TimeInterval
    /// Limite quotidienne, ou nil si aucune limite définie.
    var limit: TimeInterval?
    /// L'app est-elle prise en compte dans le suivi et les blocages.
    var isTracked: Bool

    init(
        id: UUID = UUID(),
        name: String,
        symbolName: String,
        tintHex: UInt,
        category: AppCategory,
        usedToday: TimeInterval,
        limit: TimeInterval? = nil,
        isTracked: Bool = true
    ) {
        self.id = id
        self.name = name
        self.symbolName = symbolName
        self.tintHex = tintHex
        self.category = category
        self.usedToday = usedToday
        self.limit = limit
        self.isTracked = isTracked
    }

    // MARK: - Valeurs dérivées

    var hasLimit: Bool { limit != nil }

    /// Avancement vis-à-vis de la limite (0…1+), 0 si pas de limite.
    var progress: Double {
        guard let limit, limit > 0 else { return 0 }
        return usedToday / limit
    }

    var isOverLimit: Bool {
        guard let limit else { return false }
        return usedToday >= limit
    }

    /// Proche de la limite : au moins 80 % consommé, sans l'avoir atteinte.
    var isNearLimit: Bool {
        hasLimit && progress >= 0.8 && !isOverLimit
    }

    /// Temps restant avant la limite (jamais négatif).
    var remaining: TimeInterval {
        guard let limit else { return 0 }
        return max(0, limit - usedToday)
    }
}
