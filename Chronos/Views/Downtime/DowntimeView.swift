//
//  DowntimeView.swift
//  Chronos
//
//  Pause / downtime : horaires, jours concernés, apps visées. Édition en
//  direct, persistée automatiquement via les bindings du store.
//

import SwiftUI

struct DowntimeView: View {
    @Environment(ChronosStore.self) private var store

    var body: some View {
        let downtime = store.bind(\.downtime)

        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Space.xl) {
                    intro
                    enableToggle(downtime.isEnabled)

                    if downtime.wrappedValue.isEnabled {
                        scheduleSection(downtime)
                        daysSection(downtime.days)
                        appsSection
                    }
                }
                .padding(.horizontal, Space.screen)
                .padding(.top, Space.s)
                .padding(.bottom, Space.xxl)
            }
            .background(ChronosColor.background.ignoresSafeArea())
            .navigationTitle("Pause")
            .navigationBarTitleDisplayMode(.inline)
            .animation(.easeInOut(duration: 0.2), value: downtime.wrappedValue.isEnabled)
        }
    }

    // MARK: - Sections

    private var intro: some View {
        Text("Définissez une plage de calme. Pendant la pause, les applications choisies sont mises de côté.")
            .font(ChronosFont.body)
            .foregroundStyle(ChronosColor.textSecondary)
            .lineSpacing(4)
            .padding(.top, Space.s)
    }

    private func enableToggle(_ isEnabled: Binding<Bool>) -> some View {
        Toggle(isOn: isEnabled) {
            VStack(alignment: .leading, spacing: 3) {
                Text(store.isInDowntimeNow ? "Pause en cours" : "Pause programmée")
                    .font(ChronosFont.label)
                    .foregroundStyle(ChronosColor.textPrimary)
                Text("Activer la mise en pause automatique.")
                    .font(ChronosFont.caption)
                    .foregroundStyle(ChronosColor.textSecondary)
            }
        }
        .tint(ChronosColor.accent)
    }

    private func scheduleSection(_ downtime: Binding<DowntimeSchedule>) -> some View {
        VStack(spacing: Space.m) {
            timeRow(title: "Début", time: downtime.start)
            timeRow(title: "Fin", time: downtime.end)
        }
        .chronosCard()
    }

    private func timeRow(title: String, time: Binding<TimeOfDay>) -> some View {
        HStack {
            Text(title)
                .font(ChronosFont.label)
                .foregroundStyle(ChronosColor.textPrimary)
            Spacer()
            DatePicker(
                "",
                selection: dateBinding(time),
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
        }
    }

    private func daysSection(_ days: Binding<Set<Weekday>>) -> some View {
        VStack(alignment: .leading, spacing: Space.m) {
            SectionHeader(title: "Jours concernés")
            HStack(spacing: Space.s) {
                ForEach(Weekday.orderedMondayFirst) { day in
                    dayChip(day, days: days)
                }
            }
        }
    }

    private func dayChip(_ day: Weekday, days: Binding<Set<Weekday>>) -> some View {
        let isOn = days.wrappedValue.contains(day)
        return Button {
            if isOn { days.wrappedValue.remove(day) }
            else { days.wrappedValue.insert(day) }
        } label: {
            Text(day.letter)
                .font(ChronosFont.label)
                .foregroundStyle(isOn ? .white : ChronosColor.textSecondary)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(isOn ? ChronosColor.accent : ChronosColor.surfaceMuted)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: 0.15), value: isOn)
    }

    private var appsSection: some View {
        VStack(alignment: .leading, spacing: Space.m) {
            SectionHeader(title: "Applications mises en pause")
            VStack(spacing: Space.s) {
                ForEach(store.trackedApps) { app in
                    appToggleRow(app)
                }
            }
        }
    }

    private func appToggleRow(_ app: TrackedApp) -> some View {
        let included = store.data.downtime.appIDs.contains(app.id)
        return Button {
            store.setDowntime(app.id, included: !included)
        } label: {
            HStack(spacing: Space.m) {
                AppGlyph(symbolName: app.symbolName, tintHex: app.tintHex, size: 38)
                Text(app.name)
                    .font(ChronosFont.label)
                    .foregroundStyle(ChronosColor.textPrimary)
                Spacer()
                Image(systemName: included ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(included ? ChronosColor.accent : ChronosColor.textTertiary)
            }
            .padding(.vertical, Space.xs)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Conversion TimeOfDay <-> Date

    private func dateBinding(_ source: Binding<TimeOfDay>) -> Binding<Date> {
        Binding(
            get: { source.wrappedValue.asDateToday },
            set: { source.wrappedValue = TimeOfDay(from: $0) }
        )
    }
}
