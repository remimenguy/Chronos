//
//  SectionHeader.swift
//  Chronos
//
//  En-tête de section discret, en serif, casse normale (jamais en capitales).
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    var trailing: String? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(ChronosFont.sectionTitle)
                .foregroundStyle(ChronosColor.textPrimary)
            Spacer()
            if let trailing {
                Text(trailing)
                    .font(ChronosFont.caption)
                    .foregroundStyle(ChronosColor.textTertiary)
            }
        }
    }
}
