//
//  DisplayPreferences.swift
//  Chronos
//
//  Préférences d'affichage simples, réellement appliquées dans l'interface.
//

import Foundation

struct DisplayPreferences: Codable, Hashable {
    /// Déblocage strict : durée maximale (et par défaut) d'une extension.
    static let maxExtensionMinutes = 5

    /// Format 24 h (par défaut, usage français) plutôt que 12 h AM/PM.
    var use24HourClock: Bool
    /// Citation du jour (déterministe) plutôt qu'aléatoire à chaque blocage.
    var dailyQuote: Bool
    /// Durée de l'extension unique accordée depuis l'écran de limite (≤ 5 min).
    var shortExtensionMinutes: Int

    init(use24HourClock: Bool = true,
         dailyQuote: Bool = true,
         shortExtensionMinutes: Int = DisplayPreferences.maxExtensionMinutes) {
        self.use24HourClock = use24HourClock
        self.dailyQuote = dailyQuote
        self.shortExtensionMinutes = min(DisplayPreferences.maxExtensionMinutes, max(1, shortExtensionMinutes))
    }
}
