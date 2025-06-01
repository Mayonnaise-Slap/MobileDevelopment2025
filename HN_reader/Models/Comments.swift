
// Comments.swift

import Foundation

struct Comments: Identifiable {
    let id: Int
    let author: String
    let date: String
    let text: String
    let depth: Int  // Уровень вложенности комментария
}

