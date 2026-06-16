//
//  AppCategory.swift
//  Chronos
//
//  Catégorie d'une application suivie.
//

import Foundation

enum AppCategory: String, Codable, CaseIterable, Identifiable {
    case social
    case divertissement
    case productivite
    case jeux
    case information
    case autre

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .social:         return "Réseaux sociaux"
        case .divertissement: return "Divertissement"
        case .productivite:   return "Productivité"
        case .jeux:           return "Jeux"
        case .information:    return "Information"
        case .autre:          return "Autre"
        }
    }
}
