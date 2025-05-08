//
//  FilterSortLabel.swift
//  HN_reader
//
//  Created by MpAsSgHA on 08.05.2025.
//

import SwiftUI


func sortIconName(for option: SortOptions) -> String {
    switch option {
    case .date:
        return "calendar"
    case .rating:
        return "star"
    case .all:
        return "arrow.uturn.backward"
    }
}


func filterIconName(for option: FilterOptions) -> String {
    switch option {
    case .favorites:
        return "star.fill"
    case .notFavorites:
        return "star"
    case .all:
        return "arrow.uturn.backward"
    }
}
