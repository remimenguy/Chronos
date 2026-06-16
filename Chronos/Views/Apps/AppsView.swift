//
//  AppsView.swift
//  Chronos
//
//  Gestion des applications : usage du jour, limite définie, modification.
//

import SwiftUI

struct AppsView: View {
    @Environment(ChronosStore.self) private var store
    @State private var editingApp: TrackedApp?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Space.l) {
                    Text("Choisissez les applications à suivre et fixez une limite quotidienne pour celles qui le méritent.")
                        .font(ChronosFont.body)
                        .foregroundStyle(ChronosColor.textSecondary)
                        .lineSpacing(4)
                        .padding(.top, Space.s)

                    VStack(spacing: Space.s) {
                        ForEach(store.data.apps) { app in
                            Button {
                                editingApp = app
                            } label: {
                                appRow(app)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, Space.screen)
                .padding(.bottom, Space.xxl)
            }
            .background(ChronosColor.background.ignoresSafeArea())
            .navigationTitle("Applications")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $editingApp) { app in
                AppLimitEditorView(app: app)
            }
        }
    }

    private func appRow(_ app: TrackedApp) -> some View {
        HStack(spacing: Space.m) {
            AppGlyph(symbolName: app.symbolName, tintHex: app.tintHex)
                .opacity(app.isTracked ? 1 : 0.35)

            VStack(alignment: .leading, spacing: 3) {
                Text(app.name)
                    .font(ChronosFont.label)
                    .foregroundStyle(ChronosColor.textPrimary)
                Text(subtitle(for: app))
                    .font(ChronosFont.caption)
                    .foregroundStyle(app.isOverLimit ? ChronosColor.accent : ChronosColor.textSecondary)
            }

            Spacer()

            Text(DurationFormatter.compact(app.usedToday))
                .font(ChronosFont.label)
                .foregroundStyle(ChronosColor.textSecondary)
                .monospacedDigit()
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(ChronosColor.textTertiary)
        }
        .padding(.vertical, Space.s)
    }

    private func subtitle(for app: TrackedApp) -> String {
        guard app.isTracked else { return "Non suivie" }
        guard let limit = app.limit else { return "Aucune limite" }
        if app.isOverLimit { return "Limite atteinte · \(DurationFormatter.short(limit))" }
        return "Limite \(DurationFormatter.short(limit))"
    }
}
