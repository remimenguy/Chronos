# Chronos

Application iOS de gestion du temps d'écran. Sobre, calme, presque méditative :
définir des limites par application, programmer des pauses (downtime) et, quand
une limite est atteinte, s'offrir un instant de recul avec une citation française.

## Lancer le projet

1. Ouvrir `Chronos.xcodeproj` dans Xcode 26+.
2. Choisir un simulateur iPhone (iOS 26.5) et lancer (⌘R).
3. Tests : ⌘U (logique métier + tests UI de lancement).

Aucune dépendance externe. L'application fonctionne avec un **jeu de données de
démonstration** : elle est donc pleinement utilisable dans le simulateur, sans
configuration ni autorisation particulière.

## Architecture

Séparation nette logique / modèles / vues, autour d'un store central.

```
Chronos/
├── Models/            Données pures, Codable (TrackedApp, DowntimeSchedule, Quote…)
├── Services/          Protocoles + implémentations
│   ├── ScreenTimeProviding   ← abstraction du temps d'écran (mock par défaut)
│   ├── PersistenceControlling ← persistance (UserDefaults/JSON par défaut)
│   └── QuoteProvider          ← citations françaises livrées avec l'app
├── State/
│   └── ChronosStore   @Observable, source de vérité unique, logique métier
├── DesignSystem/      Couleurs, typographie, espacements, composants réutilisables
├── Support/           Formatage des durées et des dates (français)
└── Views/             Une vue par écran (Onboarding, Dashboard, Apps, Downtime,
                       LimitReached, Settings)
```

- **`ChronosStore`** charge / persiste l'état (`AppData`), expose des valeurs
  dérivées (total du jour, apps à surveiller, downtime actif…) et toutes les
  mutations. Injecté via l'environnement SwiftUI.
- **Injection de dépendances** dans `ChronosApp` : remplacer le mock par une
  vraie source de données ne touche à rien d'autre.

## Écrans

1. **Onboarding** — présentation, autorisation, choix d'une intention.
2. **Dashboard** — temps d'écran du jour, comparaison avec hier, état du
   downtime, limites à surveiller, apps les plus utilisées, accès réglages.
3. **Applications** — usage du jour, limite définie, édition de la limite.
4. **Pause / Downtime** — horaires de début/fin, jours concernés, apps visées.
5. **Limite atteinte** — citation centrée sur fond profond, temps passé,
   fermeture ou courte extension.
6. **Réglages** — gestion des citations, préférences d'affichage, réinitialisation.

## Vraies APIs Screen Time

Le code est structuré pour brancher les frameworks Apple sans réécriture :

- **FamilyControls** — autorisation (`AuthorizationCenter.requestAuthorization`).
- **DeviceActivity** — relevés d'usage réels par application.
- **ManagedSettings** — blocage effectif (limites, downtime).

Il suffit de fournir une implémentation de `ScreenTimeProviding` adossée à ces
frameworks et de l'injecter dans `ChronosApp`. Ces APIs exigent l'entitlement
*Family Controls* (accordé par Apple) et ne fonctionnent pas dans le simulateur,
d'où le fournisseur de démonstration par défaut.

## Direction artistique

Réinterprétation douce du brand kit : papier chaud, orange vif (`#C2410C`) en
accent rare, rouge profond (`#460000`) pour l'écran de limite. Serif éditorial
(New York, à la place de Baskervville) pour les titres et citations, sans (SF, à
la place d'Epilogue) pour l'interface. Pas de bordures, pas d'ombres, pas de
dégradés, pas de capitales, beaucoup d'air.

## Arguments de lancement (tests / captures)

- `-skipOnboarding` — démarre sur l'interface principale (données de démo).
- `-tab-apps` / `-tab-downtime` / `-tab-settings` — onglet initial.
- `-previewLimit` — présente l'écran de limite atteinte.
