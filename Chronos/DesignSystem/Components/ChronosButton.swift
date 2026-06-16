//
//  ChronosButton.swift
//  Chronos
//
//  Boutons plats, sans bordure ni ombre. États clairs via opacité.
//

import SwiftUI

struct ChronosButton: View {
    enum Kind { case primary, secondary, quiet }

    let title: String
    var kind: Kind = .primary
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(ChronosFont.button)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
        }
        .buttonStyle(ChronosButtonStyle(kind: kind))
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.4)
    }
}

private struct ChronosButtonStyle: ButtonStyle {
    let kind: ChronosButton.Kind

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(foreground)
            .background(background(pressed: configuration.isPressed))
            .clipShape(RoundedRectangle(cornerRadius: Space.corner, style: .continuous))
            .contentShape(Rectangle())
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }

    private var foreground: Color {
        switch kind {
        case .primary:   return .white
        case .secondary: return ChronosColor.accent
        case .quiet:     return ChronosColor.textSecondary
        }
    }

    private func background(pressed: Bool) -> Color {
        switch kind {
        case .primary:   return ChronosColor.accent
        case .secondary: return ChronosColor.accentSoft
        case .quiet:     return pressed ? ChronosColor.surfaceMuted : .clear
        }
    }
}
