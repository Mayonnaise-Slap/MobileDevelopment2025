//
//  FilterNewsService.swift
//  HN_reader
//
//  Created by MpAsSgHA on 06.05.2025.
//
import SwiftUI


class FilterSortNewsService: ObservableObject {
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
    @Published var filterOptions: FilterOptions = .all
    
    var filteredAndSortedIndices: [Int] {
            var indices = Array(news.indices)

            switch filterOptions {
                case .all: break
                case .favorites:
                    indices = indices.filter { news[$0].isFavorite }
                case .notFavorites:
                    indices = indices.filter { !news[$0].isFavorite }
            }

            switch sortOptions {
                case .date:
                    indices = indices.sorted { news[$0].date > news[$1].date }
                case .rating:
                    indices = indices.sorted { news[$0].rating > news[$1].rating }
                case .all:
                    break
            }

            return Array(indices)
        }
}
