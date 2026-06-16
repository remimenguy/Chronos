//
//  LimitReachedView.swift
//  Chronos
//
//  Écran de limite atteinte : une citation au centre, sur fond profond.
//  Très calme, contemplatif, sans culpabilisation.
//

import SwiftUI

struct LimitReachedView: View {
    @Environment(ChronosStore.self) private var store
    let app: TrackedApp

    @State private var quote: Quote = Quote(text: "", author: nil)
    @State private var appeared = false

    private var extensionMinutes: Int {
        min(DisplayPreferences.maxExtensionMinutes, store.data.preferences.shortExtensionMinutes)
    }

    var body: some View {
        VStack(spacing: 0) {
            topLabel
            Spacer()
            quoteBlock
            Spacer()
            usageLine
            actions
        }
        .padding(.horizontal, Space.l)
        .padding(.top, Space.xxl)
        .padding(.bottom, Space.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ChronosColor.deep.ignoresSafeArea())
        .onAppear {
            quote = store.currentQuote()
            withAnimation(.easeOut(duration: 0.6)) { appeared = true }
        }
    }

    // MARK: - Éléments

    private var topLabel: some View {
        VStack(spacing: 6) {
            Text(app.name)
                .font(ChronosFont.label)
                .foregroundStyle(ChronosColor.deepText)
            Text("Limite atteinte")
                .font(ChronosFont.caption)
                .foregroundStyle(ChronosColor.deepSecondary)
        }
        .opacity(appeared ? 1 : 0)
    }

    private var quoteBlock: some View {
        VStack(spacing: Space.l) {
            Text("« \(quote.text) »")
                .font(ChronosFont.quote)
                .italic()
                .multilineTextAlignment(.center)
                .foregroundStyle(ChronosColor.deepText)
                .lineSpacing(8)
                .fixedSize(horizontal: false, vertical: true)

            if let author = quote.author {
                Text(author)
                    .font(ChronosFont.caption)
                    .foregroundStyle(ChronosColor.deepSecondary)
            }
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 8)
    }

    private var usageLine: some View {
        Text("\(DurationFormatter.short(app.usedToday)) passées sur \(app.name) aujourd'hui")
            .font(ChronosFont.caption)
            .foregroundStyle(ChronosColor.deepSecondary)
            .multilineTextAlignment(.center)
            .padding(.bottom, Space.l)
            .opacity(appeared ? 1 : 0)
    }

    private var actions: some View {
        VStack(spacing: Space.s) {
            // Bouton principal : on sort de l'application bloquée.
            Button {
                store.dismissLimit()
            } label: {
                Text("OK")
                    .font(ChronosFont.button)
                    .foregroundStyle(ChronosColor.deep)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(ChronosColor.deepText)
                    .clipShape(RoundedRectangle(cornerRadius: Space.corner, style: .continuous))
            }

            // Déblocage strict : une seule extension de 5 min max par jour.
            if app.extensionUsedToday {
                Text("Extension déjà utilisée aujourd'hui")
                    .font(ChronosFont.caption)
                    .foregroundStyle(ChronosColor.deepSecondary)
                    .padding(.vertical, 13)
            } else {
                Button {
                    store.grantShortExtension()
                } label: {
                    Text("M'accorder \(extensionMinutes) minutes, une seule fois")
                        .font(ChronosFont.button)
                        .foregroundStyle(ChronosColor.deepSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                }
            }
        }
    }
}
