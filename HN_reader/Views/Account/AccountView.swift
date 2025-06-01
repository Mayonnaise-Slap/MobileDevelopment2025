// AccountView.swift
import SwiftUI

struct AccountView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(Color("Main"))
                .padding(.top, 40)

            if let user = authViewModel.currentUser {
                Text(user.nickname)
                    .font(.title2)
                    .bold()
            } else {
                Text("Имя пользователя")
                    .font(.title2)
                    .bold()
            }

            Divider()
                .padding(.horizontal)
                .frame(height: 2)
                .background((Color("Divider")))
            
            VStack(alignment: .leading, spacing: 10) {
                Label("Настройки", systemImage: "gear")
                
                Button(action: {
                    authViewModel.logout()
                }) {
                    Label("Выход", systemImage: "rectangle.portrait.and.arrow.right")
                }
            }
            .padding(.horizontal)
            .foregroundColor(.primary)
        }
    }
}
