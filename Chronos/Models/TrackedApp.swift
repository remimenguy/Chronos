//
//  TrackedApp.swift
//  Chronos
//
//  Une application suivie : usage du jour, limite éventuelle, métadonnées
//  d'affichage. Représente l'unité de base manipulée par l'app.
//
//  Deux notions distinctes :
//   • la limite **configurée** (`limit`) — stable, verrouillée 1 mois après
//     sa définition (engagement de l'utilisateur, cf. `canEditLimit`) ;
//   • l'extension **du jour** (`extensionUsedDate` / `extensionBonusSeconds`) —
//     un répit temporaire qui ne modifie jamais la limite configurée.
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
    /// Limite quotidienne configurée, ou nil si aucune limite définie.
    var limit: TimeInterval?
    /// Date à laquelle la limite a été définie (sert au verrou d'un mois).
    var limitSetDate: Date?
    /// L'app est-elle prise en compte dans le suivi et les blocages.
    var isTracked: Bool
    /// Date de la dernière extension accordée (déblocage strict, une fois/jour).
    var extensionUsedDate: Date?
    /// Rallonge accordée ce jour-là, en secondes (n'altère pas `limit`).
    var extensionBonusSeconds: TimeInterval

    init(
        id: UUID = UUID(),
        name: String,
        symbolName: String,
        tintHex: UInt,
        category: AppCategory,
        usedToday: TimeInterval,
        limit: TimeInterval? = nil,
        limitSetDate: Date? = nil,
        isTracked: Bool = true,
        extensionUsedDate: Date? = nil,
        extensionBonusSeconds: TimeInterval = 0
    ) {
        self.id = id
        self.name = name
        self.symbolName = symbolName
        self.tintHex = tintHex
        self.category = category
        self.usedToday = usedToday
        self.limit = limit
        self.limitSetDate = limitSetDate
        self.isTracked = isTracked
        self.extensionUsedDate = extensionUsedDate
        self.extensionBonusSeconds = extensionBonusSeconds
    }

    // MARK: - Limite & verrou mensuel

    var hasLimit: Bool { limit != nil }

    /// Date à partir de laquelle la limite redevient modifiable (1 mois après).
    var limitUnlockDate: Date? {
        guard let set = limitSetDate else { return nil }
        return Calendar.current.date(byAdding: .month, value: 1, to: set)
    }

    /// La limite peut-elle être modifiée maintenant ? Verrouillée pendant un
    /// mois après chaque définition ; toujours modifiable si jamais définie.
    var canEditLimit: Bool {
        guard let unlock = limitUnlockDate else { return true }
        return Date() >= unlock
    }

    // MARK: - Extension du jour

    /// L'extension du jour a-t-elle déjà été consommée (réinitialisée chaque jour).
    var extensionUsedToday: Bool {
        guard let date = extensionUsedDate else { return false }
        return Calendar.current.isDateInToday(date)
    }

    /// Rallonge effective applicable aujourd'hui (0 si pas d'extension ce jour).
    var currentBonus: TimeInterval {
        extensionUsedToday ? extensionBonusSeconds : 0
    }

    /// Limite réellement appliquée pour le blocage = limite configurée + rallonge.
    var effectiveLimit: TimeInterval? {
        limit.map { $0 + currentBonus }
    }

    // MARK: - Valeurs dérivées (basées sur la limite effective)

    /// Avancement vis-à-vis de la limite effective (0…1+), 0 si pas de limite.
    var progress: Double {
        guard let effectiveLimit, effectiveLimit > 0 else { return 0 }
        return usedToday / effectiveLimit
    }

    var isOverLimit: Bool {
        guard let effectiveLimit else { return false }
        return usedToday >= effectiveLimit
    }

    /// Proche de la limite : au moins 80 % consommé, sans l'avoir atteinte.
    var isNearLimit: Bool {
        hasLimit && progress >= 0.8 && !isOverLimit
    }

    /// Temps restant avant la limite effective (jamais négatif).
    var remaining: TimeInterval {
        guard let effectiveLimit else { return 0 }
        return max(0, effectiveLimit - usedToday)
    }
}
