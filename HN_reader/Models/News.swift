//
//  News.swift
//  HN_reader
//
//  Created by MpAsSgHA on 24.04.2025.
//

import Foundation

struct News: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let date: String
    let rating: Int
    var isFavorite: Bool
}
