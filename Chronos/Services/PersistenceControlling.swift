//
//  PersistenceControlling.swift
//  Chronos
//
//  Abstraction de la persistance de l'état applicatif (modèle racine AppData).
//

import Foundation

protocol PersistenceControlling {
    func load() -> AppData?
    func save(_ data: AppData)
    func clear()
}

/// Persistance par défaut : encodage JSON dans UserDefaults. Suffisant pour
/// l'état léger de l'app et trivial à remplacer (fichier, SwiftData…).
struct UserDefaultsPersistence: PersistenceControlling {
    private let key = "com.chronos.appdata.v1"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> AppData? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(AppData.self, from: data)
    }

    func save(_ data: AppData) {
        guard let encoded = try? JSONEncoder().encode(data) else { return }
        defaults.set(encoded, forKey: key)
    }

    func clear() {
        defaults.removeObject(forKey: key)
    }
}
