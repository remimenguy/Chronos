//
//  AppUsageRow.swift
//  Chronos
//
//  Ligne réutilisable décrivant l'usage d'une app : glyphe, nom, temps,
//  et progression vis-à-vis de la limite. Pas de séparateurs ni bordures.
//

import SwiftUI

struct AppUsageRow: View {
    let app: TrackedApp
    var showsProgress: Bool = true

    private var progressTint: Color {
        if app.isOverLimit { return ChronosColor.accent }
        if app.isNearLimit { return ChronosColor.accent }
        return ChronosColor.textTertiary
    }

    var body: some View {
        HStack(spacing: Space.m) {
            AppGlyph(symbolName: app.symbolName, tintHex: app.tintHex)

            VStack(alignment: .leading, spacing: 7) {
                HStack(alignment: .firstTextBaseline) {
                    Text(app.name)
                        .font(ChronosFont.label)
                        .foregroundStyle(ChronosColor.textPrimary)
                    Spacer()
                    Text(DurationFormatter.compact(app.usedToday))
                        .font(ChronosFont.label)
                        .foregroundStyle(ChronosColor.textPrimary)
                        .monospacedDigit()
                }

                if showsProgress, app.hasLimit {
                    ProgressBar(progress: app.progress, tint: progressTint)
                    Text(limitCaption)
                        .font(ChronosFont.caption)
                        .foregroundStyle(ChronosColor.textTertiary)
                } else {
                    Text(app.category.displayName)
                        .font(ChronosFont.caption)
                        .foregroundStyle(ChronosColor.textTertiary)
                }
            }
        }
        .padding(.vertical, Space.s)
    }

    private var limitCaption: String {
        guard let limit = app.limit else { return app.category.displayName }
        if app.isOverLimit {
            return "Limite de \(DurationFormatter.short(limit)) atteinte"
        }
        return "\(DurationFormatter.short(app.remaining)) restantes sur \(DurationFormatter.short(limit))"
    }
}
