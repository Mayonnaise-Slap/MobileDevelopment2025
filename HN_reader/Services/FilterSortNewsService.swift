// FilterSortNewsService.swift

import SwiftUI

class FilterSortNewsService: ObservableObject {
    @Published var news: [News] = [] // ПУСТО!
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
    
    func paginatedIndices(page: Int, pageSize: Int) -> [Int] {
            let sortedIndices = filteredAndSortedIndices
            let startIndex = page * pageSize
            let endIndex = min(startIndex + pageSize, sortedIndices.count)
            
            guard startIndex < endIndex else { return [] }
            
            return Array(sortedIndices[startIndex..<endIndex])
        }
}
