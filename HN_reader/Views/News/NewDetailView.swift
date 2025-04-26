//
//  NewDateilView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 26.04.2025.
//

import SwiftUI

struct NewsDetailView: View {
    let item: NewsItem

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(item.title)
                .font(.title)
                .bold()

            HStack {
                Text("Автор: \(item.author)")
                    .font(.subheadline)
                Spacer()
                Text(item.date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Text("Рейтинг: \(item.rating)")
                .font(.body)

            Spacer()
        }
        .padding()
        .navigationTitle("Подробности")
        .navigationBarTitleDisplayMode(.inline)
    }
}
