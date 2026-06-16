//
//  ChronosTests.swift
//  ChronosTests
//
//  Tests de la logique métier : store, limites, downtime, formatage.
//

import Testing
import Foundation
@testable import Chronos

/// Persistance en mémoire pour isoler les tests.
@MainActor
final class InMemoryPersistence: PersistenceControlling {
    var stored: AppData?
    func load() -> AppData? { stored }
    func save(_ data: AppData) { stored = data }
    func clear() { stored = nil }
}

@MainActor
struct ChronosStoreTests {

    private func makeStore() -> ChronosStore {
        ChronosStore(persistence: InMemoryPersistence(), screenTime: MockScreenTimeProvider())
    }

    @Test func seedsDemoDataAndStartsBeforeOnboarding() {
        let store = makeStore()
        #expect(store.data.onboardingCompleted == false)
        #expect(store.data.apps.isEmpty == false)
        #expect(store.data.quotes.count == QuoteProvider.builtIn.count)
    }

    @Test func completingOnboardingPersistsGoal() {
        let store = makeStore()
        store.completeOnboarding(goal: .sleep)
        #expect(store.data.onboardingCompleted)
        #expect(store.data.goal == .sleep)
    }

    @Test func totalScreenTimeSumsAllApps() {
        let store = makeStore()
        let expected = store.data.apps.reduce(0) { $0 + $1.usedToday }
        #expect(store.totalScreenTime == expected)
    }

    @Test func settingLimitMarksAppOverLimit() {
        let store = makeStore()
        let app = store.data.apps[0]
        store.setLimit(60, for: app) // 1 min, sous l'usage réel
        let updated = store.data.apps.first { $0.id == app.id }!
        #expect(updated.isOverLimit)
    }

    @Test func grantingExtensionRaisesLimitAndClearsPending() {
        let store = makeStore()
        let app = store.data.apps[0]
        store.setLimit(60, for: app)
        store.presentLimit(for: app)
        store.grantShortExtension()

        let updated = store.data.apps.first { $0.id == app.id }!
        let expected = 60 + Double(store.data.preferences.shortExtensionMinutes * 60)
        #expect(updated.limit == expected)
        #expect(store.pendingLimitApp == nil)
    }

    @Test func resetRestoresDemoStateAndOnboarding() {
        let store = makeStore()
        store.completeOnboarding(goal: .focus)
        store.resetAllData()
        #expect(store.data.onboardingCompleted == false)
        #expect(store.data.goal == nil)
    }

    @Test func addingAndDeletingQuotes() {
        let store = makeStore()
        let before = store.data.quotes.count
        store.addQuote(text: "Une citation de test", author: "Moi")
        #expect(store.data.quotes.count == before + 1)

        let added = store.data.quotes.last!
        store.deleteQuote(added)
        #expect(store.data.quotes.count == before)
    }
}

struct DowntimeLogicTests {

    private func date(weekday wantedWeekday: Int, hour: Int, minute: Int) -> Date {
        // Cherche une date récente correspondant au jour et à l'heure voulus.
        var comps = DateComponents()
        comps.year = 2026; comps.month = 6; comps.hour = hour; comps.minute = minute
        let cal = Calendar(identifier: .gregorian)
        for day in 15...21 { // semaine du 15 au 21 juin 2026
            comps.day = day
            if let d = cal.date(from: comps),
               cal.component(.weekday, from: d) == wantedWeekday {
                return d
            }
        }
        return cal.date(from: comps)!
    }

    @Test func overnightScheduleActiveLateNight() {
        // 22 h → 7 h, tous les jours. À 23 h un mercredi : actif.
        let schedule = DowntimeSchedule(days: Set(Weekday.allCases))
        let wednesday23h = date(weekday: 4, hour: 23, minute: 0)
        #expect(schedule.isActive(at: wednesday23h))
    }

    @Test func overnightScheduleInactiveMidday() {
        let schedule = DowntimeSchedule(days: Set(Weekday.allCases))
        let wednesdayNoon = date(weekday: 4, hour: 12, minute: 0)
        #expect(schedule.isActive(at: wednesdayNoon) == false)
    }

    @Test func disabledScheduleNeverActive() {
        let schedule = DowntimeSchedule(isEnabled: false, days: Set(Weekday.allCases))
        let wednesday23h = date(weekday: 4, hour: 23, minute: 0)
        #expect(schedule.isActive(at: wednesday23h) == false)
    }

    @Test func excludedDayIsInactive() {
        // Active seulement le lundi ; un mercredi à 23 h : inactif.
        let schedule = DowntimeSchedule(days: [.monday])
        let wednesday23h = date(weekday: 4, hour: 23, minute: 0)
        #expect(schedule.isActive(at: wednesday23h) == false)
    }
}

struct FormattingTests {

    @Test func shortDurationFormatting() {
        #expect(DurationFormatter.short(0) == "0 min")
        #expect(DurationFormatter.short(47 * 60) == "47 min")
        #expect(DurationFormatter.short(2 * 3600) == "2 h")
        #expect(DurationFormatter.short(3 * 3600 + 24 * 60) == "3 h 24 min")
    }

    @Test func deltaWording() {
        let today = 3.0 * 3600
        let more = DurationFormatter.delta(today: today, reference: today - 600)
        #expect(more == "10 min de plus qu'hier")
        let less = DurationFormatter.delta(today: today, reference: today + 600)
        #expect(less == "10 min de moins qu'hier")
    }
}
