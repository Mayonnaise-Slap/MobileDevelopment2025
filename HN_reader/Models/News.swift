// News.swift

import Foundation

struct News: Identifiable {
    let id: Int
    let title: String
    let author: String
    let date: String
    let rating: Int
    var isFavorite: Bool
}
