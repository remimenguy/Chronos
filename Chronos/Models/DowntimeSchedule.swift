//
//  DowntimeSchedule.swift
//  Chronos
//
//  Période de pause programmée : horaires, jours concernés, apps visées.
//

import Foundation

struct DowntimeSchedule: Codable, Hashable {
    var isEnabled: Bool
    var start: TimeOfDay
    var end: TimeOfDay
    var days: Set<Weekday>
    /// Apps concernées par le downtime (sous-ensemble des apps suivies).
    var appIDs: Set<UUID>

    init(
        isEnabled: Bool = true,
        start: TimeOfDay = TimeOfDay(hour: 22, minute: 0),
        end: TimeOfDay = TimeOfDay(hour: 7, minute: 0),
        days: Set<Weekday> = Set(Weekday.allCases),
        appIDs: Set<UUID> = []
    ) {
        self.isEnabled = isEnabled
        self.start = start
        self.end = end
        self.days = days
        self.appIDs = appIDs
    }

    /// La plage traverse-t-elle minuit (ex. 22 h → 7 h) ?
    var isOvernight: Bool { start.minutesOfDay >= end.minutesOfDay }

    /// Le downtime est-il actif maintenant ?
    func isActive(at date: Date = Date()) -> Bool {
        guard isEnabled else { return false }
        guard days.contains(Weekday(rawValue: Calendar.current.component(.weekday, from: date)) ?? .monday)
        else { return false }

        let now = TimeOfDay(from: date).minutesOfDay
        let s = start.minutesOfDay
        let e = end.minutesOfDay
        if isOvernight {
            return now >= s || now < e
        } else {
            return now >= s && now < e
        }
    }

    /// Texte résumant la plage horaire, ex. « 22 h 00 → 07 h 00 ».
    func rangeText(use24h: Bool) -> String {
        "\(start.formatted(use24h: use24h)) → \(end.formatted(use24h: use24h))"
    }
}
