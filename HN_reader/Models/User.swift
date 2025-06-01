// User.swift
import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: String
    let email: String
    let nickname: String
    let password: String
}
