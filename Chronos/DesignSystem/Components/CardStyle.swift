//
//  CardStyle.swift
//  Chronos
//
//  Conteneur doux : fond légèrement teinté, coins arrondis. Aucune bordure,
//  aucune ombre — la séparation vient de la couleur et de l'espace.
//

import SwiftUI

private struct CardModifier: ViewModifier {
    var fill: Color = ChronosColor.surfaceMuted
    var padding: CGFloat = Space.m

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(fill)
            .clipShape(RoundedRectangle(cornerRadius: Space.corner, style: .continuous))
    }
}

extension View {
    func chronosCard(fill: Color = ChronosColor.surfaceMuted, padding: CGFloat = Space.m) -> some View {
        modifier(CardModifier(fill: fill, padding: padding))
    }
}
