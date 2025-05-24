//
//  User.swift
//  HN_reader
//
//  Created by MpAsSgHA on 24.05.2025.
//

import Foundation

struct User: Identifiable, Codable {
    let id = UUID()
    let email: String
    let nickname: String
    let password: String
}
