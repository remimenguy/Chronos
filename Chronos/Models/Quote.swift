//
//  Quote.swift
//  Chronos
//
//  Citation affichée sur l'écran de limite atteinte.
//

import Foundation

struct Quote: Identifiable, Codable, Hashable {
    let id: UUID
    var text: String
    var author: String?
    /// Citation fournie avec l'app (non modifiable, seulement masquable).
    var isBuiltIn: Bool

    init(id: UUID = UUID(), text: String, author: String? = nil, isBuiltIn: Bool = false) {
        self.id = id
        self.text = text
        self.author = author
        self.isBuiltIn = isBuiltIn
    }
}
