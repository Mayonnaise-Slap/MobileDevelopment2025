import SwiftUI

struct AuthView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var appState: AppState
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    
                    Image("HN_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)

                    VStack(spacing: 20) {

                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)

                        if !viewModel.isLogin {
                            TextField("Nickname", text: $viewModel.nickname)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.none)
                        }

                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Button(action: {
                                    if viewModel.isLogin {
                                        if viewModel.login() {
                                            appState.isAuthenticated = true
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
                                .environmentObject(viewModel)
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
        .onAppear {
            if viewModel.currentUser != nil {
                isLoggedIn = true
            }
        }
    }
}
