//
//  ChronosColor.swift
//  Chronos
//
//  Palette dérivée du brand kit, réinterprétée en version douce et « papier ».
//  L'orange vif reste un accent rare ; l'essentiel est en tons chauds neutres.
//

import SwiftUI

extension Color {
    /// Initialise une couleur depuis un entier hexadécimal (0xRRGGBB).
    init(hex: UInt, opacity: Double = 1) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8) & 0xFF) / 255
        let b = Double(hex & 0xFF) / 255
        self.init(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }
}

enum ChronosColor {
    // Fondations « papier chaud »
    static let background    = Color(hex: 0xFBF9F7)
    static let surface       = Color(hex: 0xFFFFFF)
    static let surfaceMuted  = Color(hex: 0xF3EFEA)

    // Texte : du presque-noir chaud aux gris doux
    static let textPrimary   = Color(hex: 0x2A2724)
    static let textSecondary = Color(hex: 0x8B8378)
    static let textTertiary  = Color(hex: 0xBCB4A9)

    // Accent — orange vif, utilisé avec parcimonie
    static let accent        = Color(hex: 0xC2410C)
    static let accentSoft    = Color(hex: 0xFFE8D8)

    // Tons profonds — écran de limite atteinte, contemplatif
    static let deep          = Color(hex: 0x460000)
    static let deepText      = Color(hex: 0xFFE8D8)
    static let deepSecondary = Color(hex: 0xC79A8A)

    // Pistes de progression neutres
    static let track         = Color(hex: 0xEDE7E0)
}
