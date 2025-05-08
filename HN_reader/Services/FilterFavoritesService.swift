//
//  FilterFavoritesService.swift
//  HN_reader
//
//  Created by MpAsSgHA on 08.05.2025.
//
import SwiftUI


class FilterFavoritesService: ObservableObject {
    @Published var news: [News] = (0..<6).map { index in
        News(
            title: "Новость \(index + 1)",
            author: "Автор \(index + 1)",
            date: "00.00.000\(index)",
            rating: Int.random(in: 0...10),
            isFavorite: false
        )
    }
    
    @Published var sortOptions: SortOptions = .all
    var filterFavoritesIndices: [Int] {
        var indices: [Int] = []
        switch sortOptions {
                case .date:
                    indices = news.indices.sorted { news[$0].date > news[$1].date }
                case .rating:
                    indices = news.indices.sorted { news[$0].rating > news[$1].rating }
                case .all:
                    indices = Array(news.indices)
            }
        return indices
        }
}
