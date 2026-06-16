//
//  OnboardingView.swift
//  Chronos
//
//  Onboarding court en trois temps : présentation, autorisation, objectif.
//  Ton calme, sans pression.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(ChronosStore.self) private var store

    @State private var step = 0
    @State private var selectedGoal: UserGoal?
    @State private var isRequestingAccess = false
    @State private var accessGranted = false

    var body: some View {
        VStack(spacing: 0) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity)

            footer
        }
        .padding(.horizontal, Space.screen)
        .padding(.bottom, Space.l)
        .background(ChronosColor.background.ignoresSafeArea())
        .animation(.easeInOut(duration: 0.3), value: step)
    }

    // MARK: - Contenu par étape

    @ViewBuilder
    private var content: some View {
        switch step {
        case 0: presentation
        case 1: permission
        default: goalChoice
        }
    }

    private var presentation: some View {
        VStack(alignment: .leading, spacing: Space.l) {
            Spacer()
            Text("Chronos")
                .font(ChronosFont.serif(44, .regular))
                .foregroundStyle(ChronosColor.textPrimary)
            Text("Reprenez la main sur votre temps d'écran, en douceur. Des limites claires, des pauses choisies, et un instant pour souffler quand c'est nécessaire.")
                .font(ChronosFont.bodyLarge)
                .foregroundStyle(ChronosColor.textSecondary)
                .lineSpacing(5)
            Spacer()
            Spacer()
        }
    }

    private var permission: some View {
        VStack(alignment: .leading, spacing: Space.l) {
            Spacer()
            Text("Accès au temps d'écran")
                .font(ChronosFont.title)
                .foregroundStyle(ChronosColor.textPrimary)
            Text("Pour mesurer votre usage et appliquer vos limites, Chronos a besoin d'accéder au temps d'écran. Vos données restent sur votre appareil.")
                .font(ChronosFont.body)
                .foregroundStyle(ChronosColor.textSecondary)
                .lineSpacing(5)

            if accessGranted {
                Text("Accès accordé.")
                    .font(ChronosFont.label)
                    .foregroundStyle(ChronosColor.accent)
            }
            Spacer()
            Spacer()
        }
    }

    private var goalChoice: some View {
        VStack(alignment: .leading, spacing: Space.l) {
            Spacer().frame(height: Space.xl)
            Text("Votre intention")
                .font(ChronosFont.title)
                .foregroundStyle(ChronosColor.textPrimary)
            Text("Qu'aimeriez-vous cultiver ?")
                .font(ChronosFont.body)
                .foregroundStyle(ChronosColor.textSecondary)

            VStack(spacing: Space.s) {
                ForEach(UserGoal.allCases) { goal in
                    goalCard(goal)
                }
            }
            Spacer()
        }
    }

    private func goalCard(_ goal: UserGoal) -> some View {
        let isSelected = selectedGoal == goal
        return Button {
            selectedGoal = goal
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(goal.title)
                    .font(ChronosFont.label)
                    .foregroundStyle(ChronosColor.textPrimary)
                Text(goal.subtitle)
                    .font(ChronosFont.caption)
                    .foregroundStyle(ChronosColor.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Space.m)
            .background(isSelected ? ChronosColor.accentSoft : ChronosColor.surfaceMuted)
            .clipShape(RoundedRectangle(cornerRadius: Space.corner, style: .continuous))
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: 0.15), value: isSelected)
    }

    // MARK: - Pied de page (progression + action)

    private var footer: some View {
        VStack(spacing: Space.l) {
            pageDots
            primaryAction
        }
    }

    private var pageDots: some View {
        HStack(spacing: Space.s) {
            ForEach(0..<3, id: \.self) { index in
                Capsule()
                    .fill(index == step ? ChronosColor.accent : ChronosColor.track)
                    .frame(width: index == step ? 22 : 7, height: 7)
                    .animation(.easeOut(duration: 0.2), value: step)
            }
        }
    }

    @ViewBuilder
    private var primaryAction: some View {
        switch step {
        case 0:
            ChronosButton(title: "Commencer") { withAnimation { step = 1 } }
        case 1:
            ChronosButton(title: accessGranted ? "Continuer" : "Autoriser l'accès",
                          isEnabled: !isRequestingAccess) {
                if accessGranted {
                    withAnimation { step = 2 }
                } else {
                    requestAccess()
                }
            }
        default:
            ChronosButton(title: "Terminer", isEnabled: selectedGoal != nil) {
                store.completeOnboarding(goal: selectedGoal)
            }
        }
    }

    private func requestAccess() {
        isRequestingAccess = true
        Task {
            let granted = await store.requestScreenTimeAccess()
            isRequestingAccess = false
            withAnimation { accessGranted = granted }
        }
    }
}
