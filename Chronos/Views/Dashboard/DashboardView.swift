//
//  DashboardView.swift
//  Chronos
//
//  Tableau de bord : temps d'écran du jour, apps les plus utilisées, limites
//  proches d'être atteintes, accès rapide aux réglages.
//

import SwiftUI

struct DashboardView: View {
    @Environment(ChronosStore.self) private var store
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Space.xl) {
                    header
                    hero
                    downtimeStatus
                    attentionSection
                    mostUsedSection
                }
                .padding(.horizontal, Space.screen)
                .padding(.top, Space.s)
                .padding(.bottom, Space.xxl)
            }
            .background(ChronosColor.background.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundStyle(ChronosColor.textSecondary)
                    }
                    .accessibilityLabel("Réglages")
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }

    // MARK: - Sections

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(FrenchDate.longDay())
                .font(ChronosFont.caption)
                .foregroundStyle(ChronosColor.textTertiary)
            Text("Aujourd'hui")
                .font(ChronosFont.title)
                .foregroundStyle(ChronosColor.textPrimary)
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: Space.s) {
            Text(DurationFormatter.compact(store.totalScreenTime))
                .font(ChronosFont.hero)
                .foregroundStyle(ChronosColor.textPrimary)
                .monospacedDigit()
            Text("temps d'écran")
                .font(ChronosFont.body)
                .foregroundStyle(ChronosColor.textSecondary)
            if let delta = DurationFormatter.delta(today: store.totalScreenTime,
                                                   reference: store.data.yesterdayScreenTime) {
                Text(delta)
                    .font(ChronosFont.caption)
                    .foregroundStyle(ChronosColor.textTertiary)
                    .padding(.top, 2)
            }
        }
    }

    @ViewBuilder
    private var downtimeStatus: some View {
        let downtime = store.data.downtime
        if downtime.isEnabled {
            HStack(spacing: Space.m) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(store.isInDowntimeNow ? "Pause en cours" : "Pause programmée")
                        .font(ChronosFont.label)
                        .foregroundStyle(ChronosColor.textPrimary)
                    Text(downtime.rangeText(use24h: store.data.preferences.use24HourClock))
                        .font(ChronosFont.caption)
                        .foregroundStyle(ChronosColor.textSecondary)
                }
                Spacer()
                Circle()
                    .fill(store.isInDowntimeNow ? ChronosColor.accent : ChronosColor.track)
                    .frame(width: 8, height: 8)
            }
            .chronosCard()
        }
    }

    @ViewBuilder
    private var attentionSection: some View {
        let apps = store.appsNeedingAttention
        VStack(alignment: .leading, spacing: Space.m) {
            SectionHeader(title: "Limites à surveiller")
            if apps.isEmpty {
                Text("Aucune limite proche pour l'instant. Belle maîtrise.")
                    .font(ChronosFont.body)
                    .foregroundStyle(ChronosColor.textSecondary)
                    .padding(.vertical, Space.s)
            } else {
                VStack(spacing: 0) {
                    ForEach(apps) { app in
                        Button {
                            store.presentLimit(for: app)
                        } label: {
                            AppUsageRow(app: app)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var mostUsedSection: some View {
        VStack(alignment: .leading, spacing: Space.m) {
            SectionHeader(title: "Le plus utilisé")
            VStack(spacing: 0) {
                ForEach(store.mostUsed(limit: 4)) { app in
                    AppUsageRow(app: app, showsProgress: false)
                }
            }
        }
    }
}
