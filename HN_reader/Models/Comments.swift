//
//  Comment.swift
//  HN_reader
//
//  Created by MpAsSgHA on 06.05.2025.
//

import Foundation

struct Comments: Identifiable {
    let id = UUID()
    let author: String
    let date: String
    let text: String
}
