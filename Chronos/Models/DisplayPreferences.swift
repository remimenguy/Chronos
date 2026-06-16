//
//  DisplayPreferences.swift
//  Chronos
//
//  Préférences d'affichage simples, réellement appliquées dans l'interface.
//

import Foundation

struct DisplayPreferences: Codable, Hashable {
    /// Format 24 h (par défaut, usage français) plutôt que 12 h AM/PM.
    var use24HourClock: Bool
    /// Citation du jour (déterministe) plutôt qu'aléatoire à chaque blocage.
    var dailyQuote: Bool
    /// Durée d'une extension courte accordée depuis l'écran de limite.
    var shortExtensionMinutes: Int

    init(use24HourClock: Bool = true, dailyQuote: Bool = true, shortExtensionMinutes: Int = 15) {
        self.use24HourClock = use24HourClock
        self.dailyQuote = dailyQuote
        self.shortExtensionMinutes = shortExtensionMinutes
    }
}
