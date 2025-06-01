
//  LoginRegisterService.swift
//  HN_reader
//
//  Created by MpAsSgHA on 24.05.2025.
//

import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var nickname = ""
    @Published var password = ""
    @Published var isLogin = true
    @Published var message = ""
    @Published var success: Bool = false
    
    @Published private(set) var registeredUsers: [User] = [
        User(id: 1, email: "Test@example.com", nickname: "test", password: "12345")
    ]
    
    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            message = "Введите email и пароль"
            success = false
            return
        }
        
        if let user = registeredUsers.first(where: { $0.email.lowercased() == email.lowercased() }) {
            if user.password == password {
                message = "Успешный вход, привет $user.nickname)!"
                success = true
            } else {
                message = "Неверный пароль"
                success = false
            }
        } else {
            message = "Пользователь не найден"
            success = false
        }
    }
    
    func register() {
        guard !email.isEmpty, !nickname.isEmpty, !password.isEmpty else {
            message = "Заполните все поля"
            return
        }
        
        if registeredUsers.contains(where: { $0.email == email }) {
            message = "Этот email уже зарегистрирован"
            return
        }
        
        let newUser = User(id: registeredUsers.count + 1, email: email, nickname: nickname, password: password)
        registeredUsers.append(newUser)
        message = "Регистрация прошла успешно"
        clearFields()
        isLogin = true
    }
    
    private func clearFields() {
        email = ""
        nickname = ""
        password = ""
    }
    
    func toggleMode() {
        isLogin.toggle()
        message = ""
    }
}

