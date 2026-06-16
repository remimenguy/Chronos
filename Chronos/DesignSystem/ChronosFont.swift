//
//  ChronosFont.swift
//  Chronos
//
//  Typographie. Le brand kit associe Epilogue (sans) et Baskervville (serif).
//  Pour un projet autonome qui se lance sans polices embarquées, on s'appuie
//  sur les familles système équivalentes : New York (serif, éditorial, à la
//  place de Baskervville) et SF Pro (sans, à la place d'Epilogue).
//
//  Pour brancher les vraies polices : ajouter les .ttf au bundle, les déclarer
//  dans UIAppFonts, puis remplacer `.system(... design:)` par `.custom(...)`.
//

import SwiftUI

enum ChronosFont {
    /// Serif éditorial — titres, grands chiffres, citations.
    static func serif(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }

    /// Sans — libellés, corps de texte, contrôles.
    static func sans(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }

    // Rôles
    static let hero          = serif(60, .light)
    static let title         = serif(30, .regular)
    static let sectionTitle  = serif(20, .regular)
    static let quote         = serif(27, .regular)
    static let bodyLarge     = sans(17, .regular)
    static let body          = sans(16, .regular)
    static let label         = sans(15, .medium)
    static let caption       = sans(13, .regular)
    static let button        = sans(16, .medium)
}
