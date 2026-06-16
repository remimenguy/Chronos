//
//  TimeOfDay.swift
//  Chronos
//
//  Heure de la journée indépendante d'une date (pour le downtime).
//

import Foundation

struct TimeOfDay: Codable, Hashable {
    var hour: Int
    var minute: Int

    init(hour: Int, minute: Int) {
        self.hour = min(23, max(0, hour))
        self.minute = min(59, max(0, minute))
    }

    init(from date: Date) {
        let c = Calendar.current.dateComponents([.hour, .minute], from: date)
        self.init(hour: c.hour ?? 0, minute: c.minute ?? 0)
    }

    /// Minutes écoulées depuis minuit (utile pour comparer des plages).
    var minutesOfDay: Int { hour * 60 + minute }

    /// Date « aujourd'hui » à cette heure, pour alimenter un DatePicker.
    var asDateToday: Date {
        Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date()) ?? Date()
    }

    func formatted(use24h: Bool) -> String {
        if use24h {
            return String(format: "%02d h %02d", hour, minute)
        }
        let suffix = hour < 12 ? "AM" : "PM"
        let h12 = hour % 12 == 0 ? 12 : hour % 12
        return String(format: "%d:%02d %@", h12, minute, suffix)
    }
}
