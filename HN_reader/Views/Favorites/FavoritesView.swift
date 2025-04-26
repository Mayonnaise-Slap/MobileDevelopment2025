//
//  FavoritesView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 24.04.2025.
//

import SwiftUI

struct FavoritesView: View {
    @State private var dummyNews: [NewsItem] = (0..<6).map { index in
        NewsItem(
            title: "Новость \(index + 1)",
            author: "Автор \(index + 1)",
            date: "00.00.000\(index)",
            rating: Int.random(in: 0...100),
            isFavorite: false
        )
    }

    var body: some View {
        NavigationView {
            VStack {
                HeaderView()

                Text("Избранное")
                    .font(.title2)
                    .bold()
                    .padding(.top)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach($dummyNews) { $item in
                            NewsRowView(item: $item)
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}
