//
//  FilterSortEnum.swift
//  HN_reader
//
//  Created by MpAsSgHA on 08.05.2025.
//

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
