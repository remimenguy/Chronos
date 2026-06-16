//
//  Duration+Format.swift
//  Chronos
//
//  Formatage des durées en français, dans un style sobre (« 3 h 24 »).
//

import Foundation

enum DurationFormatter {

    /// Composantes heures / minutes d'une durée.
    static func components(_ interval: TimeInterval) -> (hours: Int, minutes: Int) {
        let totalMinutes = max(0, Int(interval.rounded())) / 60
        return (totalMinutes / 60, totalMinutes % 60)
    }

    /// Forme courte et lisible : « 3 h 24 min », « 47 min », « 2 h ».
    static func short(_ interval: TimeInterval) -> String {
        let (h, m) = components(interval)
        switch (h, m) {
        case (0, _):            return "\(m) min"
        case (_, 0):            return "\(h) h"
        default:                return "\(h) h \(m) min"
        }
    }

    /// Forme compacte sans répéter l'unité : « 3 h 24 », « 47 min ».
    static func compact(_ interval: TimeInterval) -> String {
        let (h, m) = components(interval)
        if h == 0 { return "\(m) min" }
        return "\(h) h \(String(format: "%02d", m))"
    }

    /// Différence signée entre deux durées, formulée naturellement.
    /// Renvoie nil quand l'écart est négligeable (< 1 min).
    static func delta(today: TimeInterval, reference: TimeInterval) -> String? {
        let diff = today - reference
        let absMinutes = abs(Int(diff.rounded())) / 60
        guard absMinutes >= 1 else { return "autant qu'hier" }
        let label = short(TimeInterval(absMinutes * 60))
        return diff < 0 ? "\(label) de moins qu'hier" : "\(label) de plus qu'hier"
    }
}
