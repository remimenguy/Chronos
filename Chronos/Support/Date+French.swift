//
//  Date+French.swift
//  Chronos
//
//  Petits utilitaires de formatage de date en français.
//

import Foundation

enum FrenchDate {
    /// Ex. « Mardi 17 juin ».
    static func longDay(_ date: Date = Date()) -> String {
        let raw = date.formatted(
            .dateTime.weekday(.wide).day().month(.wide)
                .locale(Locale(identifier: "fr_FR"))
        )
        return raw.prefix(1).uppercased() + raw.dropFirst()
    }

    /// Ex. « 17 juillet 2026 ».
    static func longDate(_ date: Date) -> String {
        date.formatted(
            .dateTime.day().month(.wide).year()
                .locale(Locale(identifier: "fr_FR"))
        )
    }
}
