// FilterFavoritesService.swift

import SwiftUI

class FilterFavoritesService: ObservableObject {
    @Published var news: [News] = [] // Всё ок!
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
    
    func paginatedIndices(page: Int, pageSize: Int) -> [Int] {
        let indices = filterFavoritesIndices
        let start = page * pageSize
        let end = min(start + pageSize, indices.count)
        if start < end {
            return Array(indices[start..<end])
        } else {
            return []
        }
    }
}
