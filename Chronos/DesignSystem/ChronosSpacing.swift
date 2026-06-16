//
//  ChronosSpacing.swift
//  Chronos
//
//  Échelle d'espacement. Beaucoup d'air : les valeurs sont volontairement
//  généreuses pour laisser respirer l'interface.
//

import CoreGraphics

enum Space {
    static let xs: CGFloat = 4
    static let s: CGFloat = 8
    static let m: CGFloat = 16
    static let l: CGFloat = 24
    static let xl: CGFloat = 36
    static let xxl: CGFloat = 56

    /// Marge horizontale standard des écrans.
    static let screen: CGFloat = 24

    /// Rayon d'arrondi des éléments tactiles (glyphes, boutons, champs).
    static let corner: CGFloat = 14
}
