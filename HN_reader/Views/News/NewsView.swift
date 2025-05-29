//
//  NewsView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 24.04.2025.
//

import SwiftUI

struct NewsView: View {

    @StateObject private var newsService = FilterSortNewsService()

    var body: some View {
        NavigationStack {
            VStack {
                HeaderView()
                
                Text("Последние новости")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                
                FilterSortNewsView(sortOption: $newsService.sortOptions, filterOption: $newsService.filterOptions)
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(newsService.filteredAndSortedIndices, id: \.self) { index in
                                                    NewRowView(item: $newsService.news[index])
                                                }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

