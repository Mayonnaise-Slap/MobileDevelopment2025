// AuthViewModel.swift
import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var email = ""
    @Published var nickname = ""
    @Published var password = ""
    @Published var isLogin = true
    @Published var message = ""
    @Published var success = false
    @Published var currentUser: User? {
        didSet {
            saveCurrentUser()
        }
    }
    
    // MARK: - Private Properties
    private let usersKey = "registeredUsers"
    private let currentUserKey = "currentUserId"
    
    // MARK: - Initialization
    init() {
        loadCurrentUser()
    }
    
    // MARK: - Authentication Methods
    
    /// Attempt to log in the user
    func login() -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            message = "Введите email и пароль"
            success = false
            return false
        }
        
        // Find user by email (case-insensitive)
        let normalizedEmail = email.lowercased()
        if let user = registeredUsers.first(where: { $0.email.lowercased() == normalizedEmail }) {
            // Check password
            if user.password == password {
                currentUser = user
                message = "Успешный вход, привет \(user.nickname)!"
                success = true
                return true
            } else {
                message = "Неверный пароль"
                success = false
            }
        } else {
            message = "Пользователь не найден"
            success = false
        }
        return false
    }
    
    /// Register a new user
    func register() {
        guard !email.isEmpty, !nickname.isEmpty, !password.isEmpty else {
            message = "Заполните все поля"
            success = false
            return
        }
        
        // Check if email already exists (case-insensitive)
        let normalizedEmail = email.lowercased()
        if registeredUsers.contains(where: { $0.email.lowercased() == normalizedEmail }) {
            message = "Этот email уже зарегистрирован"
            success = false
            return
        }
        
        // Create new user
        let newUser = User(
            id: UUID().uuidString,
            email: email,
            nickname: nickname,
            password: password
        )
        
        // Add to registered users and save
        registeredUsers.append(newUser)
        saveUsers()
        
        message = "Регистрация прошла успешно"
        success = true
        clearFields()
    }
    
    /// Log out the current user
    func logout() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: currentUserKey)
    }
    
    /// Toggle between login and registration modes
    func toggleMode() {
        isLogin.toggle()
        message = ""
    }
    
    // MARK: - Helper Methods
    
    /// Clear input fields
    private func clearFields() {
        email = ""
        nickname = ""
        password = ""
    }
    
    // MARK: - Data Persistence
    
    /// Get or set registered users from UserDefaults
    var registeredUsers: [User] {
        get {
            // Try to load from UserDefaults
            guard let data = UserDefaults.standard.data(forKey: usersKey),
                  let users = try? JSONDecoder().decode([User].self, from: data) else {
                // Return default test user if no data exists
                return [
                    User(
                        id: "1",
                        email: "test@example.com",
                        nickname: "test",
                        password: "12345"
                    )
                ]
            }
            return users
        }
        set {
            // Save to UserDefaults
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: usersKey)
            }
        }
    }
    
    /// Save current user ID to UserDefaults
    private func saveCurrentUser() {
        if let user = currentUser {
            UserDefaults.standard.set(user.id, forKey: currentUserKey)
        }
    }
    private func loadCurrentUser() {
        guard let userId = UserDefaults.standard.string(forKey: currentUserKey) else { return }
        currentUser = registeredUsers.first { $0.id == userId }
    }
    private func saveUsers() {
        if let data = try? JSONEncoder().encode(registeredUsers) {
            UserDefaults.standard.set(data, forKey: usersKey)
        }
    }
}
