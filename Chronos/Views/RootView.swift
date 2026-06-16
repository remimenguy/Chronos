//
//  RootView.swift
//  Chronos
//
//  Racine de l'app : aiguille entre onboarding et interface principale, et
//  présente l'écran de limite atteinte par-dessus tout le reste.
//

import SwiftUI

struct RootView: View {
    @Environment(ChronosStore.self) private var store

    var body: some View {
        @Bindable var store = store

        Group {
            if store.data.onboardingCompleted {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .fullScreenCover(item: $store.pendingLimitApp) { app in
            LimitReachedView(app: app)
        }
    }
}

struct MainTabView: View {
    enum Tab: Hashable { case dashboard, apps, downtime, settings }

    @State private var selection: Tab = MainTabView.initialTab

    var body: some View {
        TabView(selection: $selection) {
            DashboardView()
                .tabItem { Label("Accueil", systemImage: "house") }
                .tag(Tab.dashboard)
            AppsView()
                .tabItem { Label("Applications", systemImage: "square.grid.2x2") }
                .tag(Tab.apps)
            DowntimeView()
                .tabItem { Label("Pause", systemImage: "moon") }
                .tag(Tab.downtime)
            SettingsView()
                .tabItem { Label("Réglages", systemImage: "slider.horizontal.3") }
                .tag(Tab.settings)
        }
        .tint(ChronosColor.accent)
    }

    /// Onglet initial, pilotable par argument de lancement (tests UI / captures).
    static var initialTab: Tab {
        let args = ProcessInfo.processInfo.arguments
        if args.contains("-tab-apps") { return .apps }
        if args.contains("-tab-downtime") { return .downtime }
        if args.contains("-tab-settings") { return .settings }
        return .dashboard
    }
}
