//
//  AuthView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 24.05.2025.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Spacer()

                    VStack(spacing: 20) {
                        Text(viewModel.isLogin ? "Вход" : "Регистрация")
                            .font(.largeTitle)
                            .bold()

                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .textInputAutocapitalization(.never)

                        if !viewModel.isLogin {
                            TextField("Nickname", text: $viewModel.nickname)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.none)
                                .textInputAutocapitalization(.never)
                        }

                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Button(action: {
                            if viewModel.isLogin {
                                viewModel.login()
                                if viewModel.success {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        isLoggedIn = true
                                    }
                                }
                            } else {
                                viewModel.register()
                            }
                        }) {
                            Text(viewModel.isLogin ? "Войти" : "Зарегистрироваться")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("Main"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .fullScreenCover(isPresented: $isLoggedIn) {
                            MainTabView()
                        }

                        if !viewModel.message.isEmpty {
                            Text(viewModel.message)
                                .foregroundColor(viewModel.success ? .green : .red)
                                .multilineTextAlignment(.center)
                                .padding(.top, 10)
                        }

                        Button(action: {
                            withAnimation {
                                viewModel.toggleMode()
                            }
                        }) {
                            Text(viewModel.isLogin ? "Нет аккаунта? Зарегистрируйтесь" : "Уже есть аккаунт? Войти")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                        }
                    }
                    .padding()
                    .frame(maxWidth: 400)

                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}
