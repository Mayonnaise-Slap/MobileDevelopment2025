//
//  FavoritesView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 24.04.2025.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesService = FilterFavoritesService()

    var body: some View {
        NavigationStack {
            VStack {
                HeaderView()

                Text("Избранное")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                
                FilterFavoritesView(sortOption: $favoritesService.sortOptions)

                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(favoritesService.filterFavoritesIndices, id: \.self) { index in
                            NewsRowView(item: $favoritesService.news[index])
                                                }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarHidden(true)
        }
    }
}
