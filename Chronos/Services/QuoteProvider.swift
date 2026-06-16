//
//  QuoteProvider.swift
//  Chronos
//
//  Citations françaises livrées avec l'application. Ton motivant et introspectif,
//  jamais culpabilisant.
//

import Foundation

enum QuoteProvider {
    static let builtIn: [Quote] = [
        Quote(text: "Le temps est ce que nous avons de plus précieux, car il ne revient jamais.",
              author: "Sénèque", isBuiltIn: true),
        Quote(text: "Rien ne sert de courir ; il faut partir à point.",
              author: "Jean de La Fontaine", isBuiltIn: true),
        Quote(text: "La vie, c'est ce qui se passe pendant que tu es occupé à faire d'autres projets.",
              author: "Anonyme", isBuiltIn: true),
        Quote(text: "On ne voit bien qu'avec le cœur. L'essentiel est invisible pour les yeux.",
              author: "Antoine de Saint-Exupéry", isBuiltIn: true),
        Quote(text: "Le présent est le seul temps dont nous disposons vraiment.",
              author: "Anonyme", isBuiltIn: true),
        Quote(text: "Il n'est pas de vent favorable pour celui qui ne sait où il va.",
              author: "Sénèque", isBuiltIn: true),
        Quote(text: "La simplicité est la sophistication suprême.",
              author: "Léonard de Vinci", isBuiltIn: true),
        Quote(text: "Ce que tu fais de tes journées est ce que tu fais de ta vie.",
              author: "Annie Dillard", isBuiltIn: true),
        Quote(text: "Le silence est une source de grande force.",
              author: "Lao Tseu", isBuiltIn: true),
        Quote(text: "Mieux vaut prendre le changement par la main avant qu'il ne nous prenne par la gorge.",
              author: "Winston Churchill", isBuiltIn: true),
        Quote(text: "Chaque instant passé à regarder ailleurs est un instant volé à ta propre vie.",
              author: "Anonyme", isBuiltIn: true),
        Quote(text: "La patience est amère, mais son fruit est doux.",
              author: "Jean-Jacques Rousseau", isBuiltIn: true),
        Quote(text: "Connais-toi toi-même.",
              author: "Socrate", isBuiltIn: true),
        Quote(text: "Le bonheur n'est pas une destination, c'est une manière de voyager.",
              author: "Anonyme", isBuiltIn: true),
        Quote(text: "Prends soin des minutes, les heures prendront soin d'elles-mêmes.",
              author: "Lord Chesterfield", isBuiltIn: true),
        Quote(text: "La liberté commence là où s'arrête l'habitude.",
              author: "Anonyme", isBuiltIn: true),
        Quote(text: "Il faut savoir s'arrêter pour mieux avancer.",
              author: "Anonyme", isBuiltIn: true),
        Quote(text: "Le vrai luxe, c'est le temps.",
              author: "Anonyme", isBuiltIn: true)
    ]
}
