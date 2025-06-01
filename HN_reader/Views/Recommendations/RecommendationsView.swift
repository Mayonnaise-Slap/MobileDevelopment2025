//
//  RecommendationsView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 08.05.2025.
//

import SwiftUI

struct RecommendationsView: View {
    @StateObject private var favoritesService = FilterFavoritesService()
    @State private var isLoading = true
    @State private var currentPage = 0
    @State private var allStoriesLoaded = false
    private let pageSize = 10
    private let apiService = APIService()

    var body: some View {
        NavigationStack {
            VStack {
                HeaderView()
                Text("Рекомендации")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                FilterFavoritesView(sortOption: $favoritesService.sortOptions)

                if isLoading {
                    ProgressView("Загрузка избранного...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxHeight: .infinity)
                } else if favoritesService.news.isEmpty {
                    Text("Нет избранных новостей")
                        .foregroundColor(.secondary)
                        .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(favoritesService.paginatedIndices(page: currentPage, pageSize: pageSize), id: \.self) { index in
                                NewsRowView(item: $favoritesService.news[index])
                                if index == favoritesService.paginatedIndices(page: currentPage, pageSize: pageSize).last {
                                    ProgressView()
                                        .onAppear {
                                            loadNextPage()
                                        }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    if !allStoriesLoaded {
                        ProgressView().padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                loadInitialFavorites()
            }
        }
    }

    private func loadInitialFavorites() {
        isLoading = true
        currentPage = 0
        allStoriesLoaded = false
        apiService.fetchTopStories { news, error in
            DispatchQueue.main.async {
                if let news = news {
                    favoritesService.news = news
                } else if let error = error {
                    print("Ошибка загрузки избранного: $error)")
                }
                isLoading = false
            }
        }
    }

    private func loadNextPage() {
        let totalItems = favoritesService.filterFavoritesIndices.count
        let loadedItems = (currentPage + 1) * pageSize
        if loadedItems < totalItems {
            currentPage += 1
        } else {
            allStoriesLoaded = true
        }
    }
}
