//
//  ProgressBar.swift
//  Chronos
//
//  Barre de progression plate (capsule), sans bordure ni ombre.
//

import SwiftUI

struct ProgressBar: View {
    /// Avancement 0…1 (les valeurs supérieures sont bornées).
    let progress: Double
    var tint: Color = ChronosColor.accent
    var track: Color = ChronosColor.track
    var height: CGFloat = 6

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule(style: .continuous)
                    .fill(track)
                Capsule(style: .continuous)
                    .fill(tint)
                    .frame(width: geo.size.width * min(1, max(0, progress)))
            }
        }
        .frame(height: height)
    }
}
