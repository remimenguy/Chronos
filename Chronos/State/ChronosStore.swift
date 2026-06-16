//
//  ChronosStore.swift
//  Chronos
//
//  Store central : seule source de vérité de l'interface. Charge / persiste
//  l'état, expose des valeurs dérivées et des mutations. La logique métier vit
//  ici, à l'écart des vues.
//

import SwiftUI
import Observation

@Observable
@MainActor
final class ChronosStore {

    /// État durable. Lecture publique ; modifications via les méthodes dédiées
    /// ou les bindings persistants (`bind(_:)`).
    private(set) var data: AppData

    /// App pour laquelle l'écran de limite atteinte est présenté (transitoire).
    var pendingLimitApp: TrackedApp?

    private let persistence: PersistenceControlling
    private let screenTime: ScreenTimeProviding

    init(persistence: PersistenceControlling, screenTime: ScreenTimeProviding) {
        self.persistence = persistence
        self.screenTime = screenTime

        if let saved = persistence.load() {
            data = saved
        } else {
            data = ChronosStore.makeDemoData(using: screenTime)
            persistence.save(data)
        }
    }

    // MARK: - Valeurs dérivées

    var trackedApps: [TrackedApp] { data.apps.filter(\.isTracked) }

    /// Temps d'écran total du jour (toutes apps confondues).
    var totalScreenTime: TimeInterval {
        data.apps.reduce(0) { $0 + $1.usedToday }
    }

    /// Apps les plus utilisées, classées par durée décroissante.
    func mostUsed(limit: Int = 3) -> [TrackedApp] {
        Array(data.apps.sorted { $0.usedToday > $1.usedToday }.prefix(limit))
    }

    /// Apps proches ou au-delà de leur limite, les plus urgentes d'abord.
    var appsNeedingAttention: [TrackedApp] {
        data.apps
            .filter { $0.hasLimit && ($0.isNearLimit || $0.isOverLimit) }
            .sorted { $0.progress > $1.progress }
    }

    var isInDowntimeNow: Bool { data.downtime.isActive() }

    /// Citation à présenter : du jour (déterministe) ou aléatoire.
    func currentQuote() -> Quote {
        let pool = data.quotes
        guard !pool.isEmpty else {
            return Quote(text: "Prends un instant pour toi.", author: nil)
        }
        if data.preferences.dailyQuote {
            let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
            return pool[(day - 1) % pool.count]
        }
        return pool.randomElement()!
    }

    // MARK: - Bindings persistants

    /// Binding sur une portion du modèle, persisté à chaque écriture.
    /// Permet une édition fluide depuis les vues tout en gardant l'état encapsulé.
    func bind<Value>(_ keyPath: WritableKeyPath<AppData, Value>) -> Binding<Value> {
        Binding(
            get: { self.data[keyPath: keyPath] },
            set: { self.data[keyPath: keyPath] = $0; self.persist() }
        )
    }

    // MARK: - Onboarding

    func completeOnboarding(goal: UserGoal?) {
        data.goal = goal
        data.onboardingCompleted = true
        persist()
    }

    func requestScreenTimeAccess() async -> Bool {
        await screenTime.requestAuthorization()
    }

    // MARK: - Applications

    func setLimit(_ limit: TimeInterval?, for app: TrackedApp) {
        guard let index = data.apps.firstIndex(where: { $0.id == app.id }) else { return }
        data.apps[index].limit = limit
        persist()
    }

    func toggleTracking(for app: TrackedApp) {
        guard let index = data.apps.firstIndex(where: { $0.id == app.id }) else { return }
        data.apps[index].isTracked.toggle()
        persist()
    }

    // MARK: - Downtime

    func setDowntime(_ id: UUID, included: Bool) {
        if included { data.downtime.appIDs.insert(id) }
        else { data.downtime.appIDs.remove(id) }
        persist()
    }

    // MARK: - Citations

    func addQuote(text: String, author: String?) {
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanText.isEmpty else { return }
        let cleanAuthor = author?.trimmingCharacters(in: .whitespacesAndNewlines)
        data.quotes.append(Quote(text: cleanText,
                                 author: (cleanAuthor?.isEmpty == false) ? cleanAuthor : nil))
        persist()
    }

    func deleteQuote(_ quote: Quote) {
        data.quotes.removeAll { $0.id == quote.id }
        persist()
    }

    // MARK: - Écran de limite atteinte

    func presentLimit(for app: TrackedApp) {
        pendingLimitApp = app
    }

    func dismissLimit() {
        pendingLimitApp = nil
    }

    /// Accorde une extension courte : repousse la limite de l'app concernée.
    func grantShortExtension() {
        guard let app = pendingLimitApp,
              let index = data.apps.firstIndex(where: { $0.id == app.id }) else {
            pendingLimitApp = nil
            return
        }
        let extra = TimeInterval(data.preferences.shortExtensionMinutes * 60)
        let base = data.apps[index].limit ?? data.apps[index].usedToday
        data.apps[index].limit = base + extra
        persist()
        pendingLimitApp = nil
    }

    // MARK: - Testabilité

    /// Démarre directement sur l'interface principale avec les données de
    /// démonstration. Utile pour les tests UI et les captures d'écran
    /// (cf. argument de lancement « -skipOnboarding »).
    func enableDemoMode() {
        guard !data.onboardingCompleted else { return }
        data.goal = data.goal ?? .reduce
        data.onboardingCompleted = true
        persist()
    }

    // MARK: - Réinitialisation

    func resetAllData() {
        persistence.clear()
        data = ChronosStore.makeDemoData(using: screenTime)
        persistence.save(data)
    }

    // MARK: - Privé

    private func persist() {
        persistence.save(data)
    }

    /// Construit l'état de démonstration initial à partir du fournisseur.
    private static func makeDemoData(using screenTime: ScreenTimeProviding) -> AppData {
        let apps = screenTime.todaysUsage()
        // Par défaut, le downtime concerne les apps sociales et de divertissement.
        let downtimeIDs = Set(
            apps.filter { $0.category == .social || $0.category == .divertissement }.map(\.id)
        )
        return AppData(
            onboardingCompleted: false,
            goal: nil,
            apps: apps,
            downtime: DowntimeSchedule(appIDs: downtimeIDs),
            quotes: QuoteProvider.builtIn,
            preferences: DisplayPreferences(),
            yesterdayScreenTime: screenTime.yesterdayTotal()
        )
    }
}
