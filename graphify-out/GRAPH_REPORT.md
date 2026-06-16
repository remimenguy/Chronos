# Graph Report - .  (2026-06-17)

## Corpus Check
- 38 files · ~37,600 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 217 nodes · 333 edges · 16 communities detected
- Extraction: 76% EXTRACTED · 24% INFERRED · 0% AMBIGUOUS · INFERRED: 80 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]

## God Nodes (most connected - your core abstractions)
1. `ChronosStore` - 20 edges
2. `Weekday` - 17 edges
3. `AppCategory` - 11 edges
4. `DowntimeSchedule` - 11 edges
5. `ChronosStoreTests` - 11 edges
6. `UserGoal` - 9 edges
7. `DowntimeView` - 9 edges
8. `TimeOfDay` - 7 edges
9. `Quote` - 7 edges
10. `TrackedApp` - 7 edges

## Surprising Connections (you probably didn't know these)
- `ChronosButton` --inherits--> `View`  [EXTRACTED]
  Chronos/DesignSystem/Components/ChronosButton.swift →   _Bridges community 3 → community 10_
- `SectionHeader` --inherits--> `View`  [EXTRACTED]
  Chronos/DesignSystem/Components/SectionHeader.swift →   _Bridges community 3 → community 2_
- `AppLimitEditorView` --inherits--> `View`  [EXTRACTED]
  Chronos/Views/Apps/AppLimitEditorView.swift →   _Bridges community 3 → community 5_
- `OnboardingView` --inherits--> `View`  [EXTRACTED]
  Chronos/Views/Onboarding/OnboardingView.swift →   _Bridges community 3 → community 4_
- `Weekday` --inherits--> `Codable`  [EXTRACTED]
  Chronos/Models/Weekday.swift →   _Bridges community 0 → community 6_

## Communities

### Community 0 - "Community 0"
Cohesion: 0.07
Nodes (21): AppCategory, autre, divertissement, information, jeux, productivite, social, AppData (+13 more)

### Community 1 - "Community 1"
Cohesion: 0.13
Nodes (4): ChronosStore, ChronosStoreTests, Quote, apps

### Community 2 - "Community 2"
Cohesion: 0.11
Nodes (8): ButtonStyle, CardModifier, View, ChronosButtonStyle, DowntimeView, SectionHeader, SettingsView, ViewModifier

### Community 3 - "Community 3"
Cohesion: 0.08
Nodes (15): AppGlyph, AppUsageRow, ChronosFont, DashboardView, LimitReachedView, ProgressBar, AddQuoteView, QuotesManagerView (+7 more)

### Community 4 - "Community 4"
Cohesion: 0.14
Nodes (5): InMemoryPersistence, MockScreenTimeProvider, OnboardingView, PersistenceControlling, ScreenTimeProviding

### Community 5 - "Community 5"
Cohesion: 0.17
Nodes (5): AppLimitEditorView, AppsView, FormattingTests, DurationFormatter, Int

### Community 6 - "Community 6"
Cohesion: 0.17
Nodes (10): Comparable, FrenchDate, Weekday, friday, monday, saturday, sunday, thursday (+2 more)

### Community 7 - "Community 7"
Cohesion: 0.31
Nodes (3): DowntimeLogicTests, TrackedAppTests, DowntimeSchedule

### Community 8 - "Community 8"
Cohesion: 0.18
Nodes (3): ChronosUITests, ChronosUITestsLaunchTests, XCTestCase

### Community 9 - "Community 9"
Cohesion: 0.33
Nodes (2): PersistenceControlling, UserDefaultsPersistence

### Community 10 - "Community 10"
Cohesion: 0.33
Nodes (5): ChronosButton, Kind, primary, quiet, secondary

### Community 11 - "Community 11"
Cohesion: 0.5
Nodes (2): ChronosColor, Color

### Community 12 - "Community 12"
Cohesion: 0.67
Nodes (2): App, ChronosApp

### Community 13 - "Community 13"
Cohesion: 1.0
Nodes (1): Space

### Community 14 - "Community 14"
Cohesion: 1.0
Nodes (1): QuoteProvider

### Community 15 - "Community 15"
Cohesion: 1.0
Nodes (1): ScreenTimeProviding

## Knowledge Gaps
- **26 isolated node(s):** `ChronosColor`, `Space`, `primary`, `secondary`, `quiet` (+21 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `Community 13`** (2 nodes): `ChronosSpacing.swift`, `Space`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 14`** (2 nodes): `QuoteProvider.swift`, `QuoteProvider`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 15`** (2 nodes): `ScreenTimeProviding.swift`, `ScreenTimeProviding`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `ChronosStore` connect `Community 1` to `Community 2`, `Community 4`?**
  _High betweenness centrality (0.145) - this node is a cross-community bridge._
- **Why does `DowntimeView` connect `Community 2` to `Community 3`?**
  _High betweenness centrality (0.131) - this node is a cross-community bridge._
- **Why does `TimeOfDay` connect `Community 0` to `Community 2`, `Community 7`?**
  _High betweenness centrality (0.116) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `Weekday` (e.g. with `.isActive()` and `.longDay()`) actually correct?**
  _`Weekday` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 5 inferred relationships involving `DowntimeSchedule` (e.g. with `.makeDemoData()` and `.overnightScheduleActiveLateNight()`) actually correct?**
  _`DowntimeSchedule` has 5 INFERRED edges - model-reasoned connections that need verification._
- **What connects `ChronosColor`, `Space`, `primary` to the rest of the system?**
  _26 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.07 - nodes in this community are weakly interconnected._