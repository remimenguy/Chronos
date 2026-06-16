//
//  UserGoal.swift
//  Chronos
//
//  Objectif personnel choisi à l'onboarding. Oriente le ton de l'app
//  sans jamais culpabiliser l'utilisateur.
//

import Foundation

enum UserGoal: String, Codable, CaseIterable, Identifiable {
    case reduce
    case sleep
    case focus
    case presence

    var id: String { rawValue }

    var title: String {
        switch self {
        case .reduce:   return "Réduire mon temps d'écran"
        case .sleep:    return "Mieux dormir"
        case .focus:    return "Gagner en concentration"
        case .presence: return "Être plus présent"
        }
    }

    var subtitle: String {
        switch self {
        case .reduce:   return "Reprendre la main, doucement, jour après jour."
        case .sleep:    return "Protéger mes soirées et mon sommeil."
        case .focus:    return "Moins d'interruptions, plus d'attention."
        case .presence: return "Donner du temps à ce qui compte vraiment."
        }
    }
}
