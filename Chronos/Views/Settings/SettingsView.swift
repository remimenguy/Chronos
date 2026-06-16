//
//  SettingsView.swift
//  Chronos
//
//  Réglages : gestion des citations, préférences d'affichage, réinitialisation.
//

import SwiftUI

struct SettingsView: View {
    @Environment(ChronosStore.self) private var store
    @State private var showResetConfirm = false

    var body: some View {
        let prefs = store.bind(\.preferences)

        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Space.xl) {
                    goalSection
                    preferencesSection(prefs)
                    quotesSection
                    dataSection
                    footer
                }
                .padding(.horizontal, Space.screen)
                .padding(.top, Space.s)
                .padding(.bottom, Space.xxl)
            }
            .background(ChronosColor.background.ignoresSafeArea())
            .navigationTitle("Réglages")
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("Réinitialiser toutes les données ?",
                                isPresented: $showResetConfirm,
                                titleVisibility: .visible) {
                Button("Réinitialiser", role: .destructive) { store.resetAllData() }
                Button("Annuler", role: .cancel) {}
            } message: {
                Text("Vos limites, pauses et citations personnalisées seront effacées et l'onboarding réapparaîtra.")
            }
        }
    }

    // MARK: - Sections

    @ViewBuilder
    private var goalSection: some View {
        if let goal = store.data.goal {
            VStack(alignment: .leading, spacing: Space.m) {
                SectionHeader(title: "Votre intention")
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(ChronosFont.label)
                        .foregroundStyle(ChronosColor.textPrimary)
                    Text(goal.subtitle)
                        .font(ChronosFont.caption)
                        .foregroundStyle(ChronosColor.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .chronosCard(fill: ChronosColor.accentSoft)
            }
        }
    }

    private func preferencesSection(_ prefs: Binding<DisplayPreferences>) -> some View {
        VStack(alignment: .leading, spacing: Space.m) {
            SectionHeader(title: "Affichage")
            VStack(spacing: Space.l) {
                Toggle(isOn: prefs.use24HourClock) {
                    settingLabel("Format 24 heures",
                                 "Afficher les horaires sur 24 h.")
                }
                .tint(ChronosColor.accent)

                Toggle(isOn: prefs.dailyQuote) {
                    settingLabel("Citation du jour",
                                 "Une même citation par jour, sinon aléatoire.")
                }
                .tint(ChronosColor.accent)

                VStack(alignment: .leading, spacing: Space.s) {
                    settingLabel("Durée d'une extension",
                                 "Temps accordé depuis l'écran de limite.")
                    Stepper(
                        "\(prefs.wrappedValue.shortExtensionMinutes) minutes",
                        value: prefs.shortExtensionMinutes,
                        in: 5...30,
                        step: 5
                    )
                    .font(ChronosFont.caption)
                    .tint(ChronosColor.accent)
                }
            }
            .chronosCard()
        }
    }

    private var quotesSection: some View {
        VStack(alignment: .leading, spacing: Space.m) {
            SectionHeader(title: "Citations")
            NavigationLink {
                QuotesManagerView()
            } label: {
                HStack {
                    settingLabel("Gérer les citations",
                                 "\(store.data.quotes.count) citations disponibles.")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(ChronosColor.textTertiary)
                }
                .chronosCard()
            }
            .buttonStyle(.plain)
        }
    }

    private var dataSection: some View {
        VStack(alignment: .leading, spacing: Space.m) {
            SectionHeader(title: "Données")
            Button {
                showResetConfirm = true
            } label: {
                HStack {
                    Text("Réinitialiser les données")
                        .font(ChronosFont.label)
                        .foregroundStyle(ChronosColor.accent)
                    Spacer()
                }
                .chronosCard()
            }
            .buttonStyle(.plain)
        }
    }

    private var footer: some View {
        Text("Chronos · Données de démonstration")
            .font(ChronosFont.caption)
            .foregroundStyle(ChronosColor.textTertiary)
            .frame(maxWidth: .infinity)
            .padding(.top, Space.m)
    }

    private func settingLabel(_ title: String, _ subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(ChronosFont.label)
                .foregroundStyle(ChronosColor.textPrimary)
            Text(subtitle)
                .font(ChronosFont.caption)
                .foregroundStyle(ChronosColor.textSecondary)
        }
    }
}
