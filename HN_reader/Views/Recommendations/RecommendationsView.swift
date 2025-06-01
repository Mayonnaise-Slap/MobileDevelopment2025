//
//  RecommendationsView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 08.05.2025.
//

import SwiftUI

struct RecommendationsView: View {

    @StateObject private var newsService = FilterSortNewsService()

    var body: some View {
        NavigationView {
            VStack {
                HeaderView()

                Text("Рекомендации")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                
                FilterSortNewsView(sortOption: $newsService.sortOptions, filterOption: $newsService.filterOptions)
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(newsService.filteredAndSortedIndices, id: \.self) { index in
                                                    NewsRowView(item: $newsService.news[index])
                                                }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarHidden(true)
        }
    }
}
