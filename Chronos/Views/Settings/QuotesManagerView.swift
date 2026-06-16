//
//  QuotesManagerView.swift
//  Chronos
//
//  Gestion des citations : consultation, ajout, suppression.
//

import SwiftUI

struct QuotesManagerView: View {
    @Environment(ChronosStore.self) private var store
    @State private var showAdd = false

    var body: some View {
        List {
            ForEach(store.data.quotes) { quote in
                quoteRow(quote)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: Space.s, leading: Space.screen,
                                              bottom: Space.s, trailing: Space.screen))
            }
            .onDelete(perform: delete)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(ChronosColor.background.ignoresSafeArea())
        .navigationTitle("Citations")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAdd = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(ChronosColor.accent)
                }
                .accessibilityLabel("Ajouter une citation")
            }
        }
        .sheet(isPresented: $showAdd) {
            AddQuoteView()
        }
    }

    private func quoteRow(_ quote: Quote) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(quote.text)
                .font(ChronosFont.serif(17, .regular))
                .foregroundStyle(ChronosColor.textPrimary)
                .lineSpacing(3)
            if let author = quote.author {
                Text("— \(author)")
                    .font(ChronosFont.caption)
                    .foregroundStyle(ChronosColor.textSecondary)
            }
        }
        .padding(.vertical, Space.xs)
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            store.deleteQuote(store.data.quotes[index])
        }
    }
}

/// Formulaire d'ajout d'une citation personnalisée.
struct AddQuoteView: View {
    @Environment(ChronosStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var text = ""
    @State private var author = ""

    private var canSave: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Space.l) {
                    field(title: "Citation") {
                        TextField("Écrivez une citation…", text: $text, axis: .vertical)
                            .lineLimit(3...6)
                    }
                    field(title: "Auteur (facultatif)") {
                        TextField("Nom de l'auteur", text: $author)
                    }
                }
                .padding(.horizontal, Space.screen)
                .padding(.top, Space.l)
            }
            .background(ChronosColor.background.ignoresSafeArea())
            .navigationTitle("Nouvelle citation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Annuler") { dismiss() }
                        .tint(ChronosColor.textSecondary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Ajouter") {
                        store.addQuote(text: text, author: author)
                        dismiss()
                    }
                    .tint(ChronosColor.accent)
                    .fontWeight(.medium)
                    .disabled(!canSave)
                }
            }
        }
    }

    private func field<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: Space.s) {
            Text(title)
                .font(ChronosFont.caption)
                .foregroundStyle(ChronosColor.textSecondary)
            content()
                .font(ChronosFont.body)
                .foregroundStyle(ChronosColor.textPrimary)
                .padding(Space.m)
                .background(ChronosColor.surfaceMuted)
                .clipShape(RoundedRectangle(cornerRadius: Space.corner, style: .continuous))
        }
    }
}
