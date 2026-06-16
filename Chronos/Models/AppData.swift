//
//  AppData.swift
//  Chronos
//
//  Modèle racine, persistable. Rassemble tout l'état durable de l'application.
//

import Foundation

struct AppData: Codable {
    var onboardingCompleted: Bool
    var goal: UserGoal?
    var apps: [TrackedApp]
    var downtime: DowntimeSchedule
    var quotes: [Quote]
    var preferences: DisplayPreferences
    /// Temps d'écran total d'hier, pour la comparaison du tableau de bord.
    var yesterdayScreenTime: TimeInterval

    init(
        onboardingCompleted: Bool = false,
        goal: UserGoal? = nil,
        apps: [TrackedApp] = [],
        downtime: DowntimeSchedule = DowntimeSchedule(),
        quotes: [Quote] = [],
        preferences: DisplayPreferences = DisplayPreferences(),
        yesterdayScreenTime: TimeInterval = 0
    ) {
        self.onboardingCompleted = onboardingCompleted
        self.goal = goal
        self.apps = apps
        self.downtime = downtime
        self.quotes = quotes
        self.preferences = preferences
        self.yesterdayScreenTime = yesterdayScreenTime
    }
}
