//
//  Weekday.swift
//  Chronos
//
//  Jour de la semaine. Les valeurs brutes correspondent à `Calendar`
//  (dimanche = 1 … samedi = 7) pour comparer facilement avec la date courante.
//

import Foundation

enum Weekday: Int, Codable, CaseIterable, Identifiable, Comparable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday

    var id: Int { rawValue }

    /// Ordre d'affichage français : du lundi au dimanche.
    static var orderedMondayFirst: [Weekday] {
        [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    }

    static var weekdays: Set<Weekday> { [.monday, .tuesday, .wednesday, .thursday, .friday] }

    var shortName: String {
        switch self {
        case .monday:    return "Lun"
        case .tuesday:   return "Mar"
        case .wednesday: return "Mer"
        case .thursday:  return "Jeu"
        case .friday:    return "Ven"
        case .saturday:  return "Sam"
        case .sunday:    return "Dim"
        }
    }

    var letter: String { String(shortName.prefix(1)) }

    static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        let order = orderedMondayFirst
        return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
    }

    /// Jour de la semaine actuel.
    static var today: Weekday {
        Weekday(rawValue: Calendar.current.component(.weekday, from: Date())) ?? .monday
    }
}
