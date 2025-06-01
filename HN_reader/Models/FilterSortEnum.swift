// FilterSortEnum.swift

import SwiftUI

enum SortOptions: String, CaseIterable {
    case date = "По дате"
    case rating = "По рейтингу"
    case all = "Сбросить"
}

enum FilterOptions: String, CaseIterable {
    case all = "Сбросить"
    case favorites = "Избранные"
    case notFavorites = "Не избранные"
}
