//
//  ChronosApp.swift
//  Chronos
//
//  Application de gestion du temps d'écran.
//  Point d'entrée : compose les services, instancie le store partagé
//  et l'injecte dans l'environnement SwiftUI.
//

import SwiftUI

@main
struct ChronosApp: App {
    /// Store central de l'application, partagé via l'environnement.
    /// Les dépendances (persistance, fournisseur de temps d'écran) sont
    /// injectées ici, ce qui rend le remplacement par de vraies APIs trivial.
    @State private var store: ChronosStore = {
        let store = ChronosStore(
            persistence: UserDefaultsPersistence(),
            screenTime: MockScreenTimeProvider()
        )
        // Permet aux tests UI / captures de démarrer sur l'écran principal.
        let args = ProcessInfo.processInfo.arguments
        if args.contains("-skipOnboarding") {
            store.enableDemoMode()
        }
        if args.contains("-previewLimit"),
           let app = store.appsNeedingAttention.first ?? store.data.apps.first {
            store.presentLimit(for: app)
        }
        return store
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
                // Direction artistique « papier chaud » : un seul rendu cohérent.
                .preferredColorScheme(.light)
                .tint(ChronosColor.accent)
        }
    }
}
