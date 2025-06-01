// User.swift

import Foundation

struct User: Identifiable, Codable {
    let id: Int
    let email: String
    let nickname: String
    let password: String
}
