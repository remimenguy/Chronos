//
//  AppGlyph.swift
//  Chronos
//
//  Représentation abstraite de l'icône d'une app : carré arrondi teinté avec
//  un symbole. (Les vraies icônes système ne sont pas accessibles.)
//

import SwiftUI

struct AppGlyph: View {
    let symbolName: String
    let tintHex: UInt
    var size: CGFloat = 44

    var body: some View {
        RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
            .fill(Color(hex: tintHex, opacity: 0.12))
            .frame(width: size, height: size)
            .overlay(
                Image(systemName: symbolName)
                    .font(.system(size: size * 0.42, weight: .regular))
                    .foregroundStyle(Color(hex: tintHex))
            )
    }
}
