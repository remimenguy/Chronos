//
//  AppLimitEditorView.swift
//  Chronos
//
//  Édition de la limite quotidienne et du suivi d'une application.
//

import SwiftUI

struct AppLimitEditorView: View {
    @Environment(ChronosStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    let app: TrackedApp

    @State private var isTracked: Bool
    @State private var hasLimit: Bool
    @State private var limitHours: Int
    @State private var limitMinutes: Int

    init(app: TrackedApp) {
        self.app = app
        _isTracked = State(initialValue: app.isTracked)
        _hasLimit = State(initialValue: app.hasLimit)
        let (h, m) = DurationFormatter.components(app.limit ?? 3600)
        _limitHours = State(initialValue: h)
        _limitMinutes = State(initialValue: max(0, m))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Space.xl) {
                    appHeader
                    trackingToggle
                    if isTracked {
                        if app.canEditLimit { limitSection }
                        else { lockedLimitSection }
                    }
                }
                .padding(.horizontal, Space.screen)
                .padding(.top, Space.m)
                .padding(.bottom, Space.xxl)
            }
            .background(ChronosColor.background.ignoresSafeArea())
            .navigationTitle("Limite")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Annuler") { dismiss() }
                        .tint(ChronosColor.textSecondary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Enregistrer") { save() }
                        .tint(ChronosColor.accent)
                        .fontWeight(.medium)
                }
            }
        }
    }

    // MARK: - Sections

    private var appHeader: some View {
        HStack(spacing: Space.m) {
            AppGlyph(symbolName: app.symbolName, tintHex: app.tintHex, size: 52)
            VStack(alignment: .leading, spacing: 3) {
                Text(app.name)
                    .font(ChronosFont.sectionTitle)
                    .foregroundStyle(ChronosColor.textPrimary)
                Text("\(DurationFormatter.short(app.usedToday)) aujourd'hui")
                    .font(ChronosFont.caption)
                    .foregroundStyle(ChronosColor.textSecondary)
            }
            Spacer()
        }
    }

    private var trackingToggle: some View {
        Toggle(isOn: $isTracked.animation(.easeInOut(duration: 0.2))) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Suivre cette application")
                    .font(ChronosFont.label)
                    .foregroundStyle(ChronosColor.textPrimary)
                Text("Comptabiliser son usage et appliquer les pauses.")
                    .font(ChronosFont.caption)
                    .foregroundStyle(ChronosColor.textSecondary)
            }
        }
        .tint(ChronosColor.accent)
    }

    private var limitSection: some View {
        VStack(alignment: .leading, spacing: Space.l) {
            Toggle(isOn: $hasLimit.animation(.easeInOut(duration: 0.2))) {
                Text("Limite quotidienne")
                    .font(ChronosFont.label)
                    .foregroundStyle(ChronosColor.textPrimary)
            }
            .tint(ChronosColor.accent)

            if hasLimit {
                limitPicker
                Text("Une fois définie, la limite ne pourra être modifiée qu'un mois plus tard.")
                    .font(ChronosFont.caption)
                    .foregroundStyle(ChronosColor.textTertiary)
                    .lineSpacing(3)
            }
        }
    }

    /// Limite verrouillée : lecture seule + date de déverrouillage.
    private var lockedLimitSection: some View {
        VStack(alignment: .leading, spacing: Space.s) {
            HStack {
                Text("Limite quotidienne")
                    .font(ChronosFont.label)
                    .foregroundStyle(ChronosColor.textPrimary)
                Spacer()
                Text(app.limit.map { DurationFormatter.short($0) } ?? "Aucune")
                    .font(ChronosFont.label)
                    .foregroundStyle(ChronosColor.textSecondary)
            }
            if let unlock = app.limitUnlockDate {
                Text("Limite verrouillée. Modifiable à partir du \(FrenchDate.longDate(unlock)).")
                    .font(ChronosFont.caption)
                    .foregroundStyle(ChronosColor.textSecondary)
                    .lineSpacing(3)
            }
        }
        .chronosCard()
    }

    private var limitPicker: some View {
        HStack(spacing: 0) {
            Picker("Heures", selection: $limitHours) {
                ForEach(0...8, id: \.self) { Text("\($0) h").tag($0) }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)

            Picker("Minutes", selection: $limitMinutes) {
                ForEach(Array(stride(from: 0, through: 55, by: 5)), id: \.self) {
                    Text("\($0) min").tag($0)
                }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
        }
        .frame(height: 150)
    }

    // MARK: - Actions

    private func save() {
        if app.isTracked != isTracked {
            store.toggleTracking(for: app)
        }
        if isTracked && hasLimit {
            let total = TimeInterval(limitHours * 3600 + limitMinutes * 60)
            store.setLimit(max(60, total), for: app)
        } else {
            store.setLimit(nil, for: app)
        }
        dismiss()
    }
}
