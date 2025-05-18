//
//  AccountView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 08.05.2025.
//

import SwiftUI


struct AccountView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(Color("Main"))
                .padding(.top, 40)

            Text("Имя пользователя")
                .font(.title2)
                .bold()

            Divider()
                .padding(.horizontal)
                .frame(height: 2)
                .background((Color("Divider")))
            

            VStack(alignment: .leading, spacing: 10) {
                Label("Настройки", systemImage: "gear")
                Label("Выход", systemImage: "rectangle.portrait.and.arrow.right")
            }
            .padding(.horizontal)
            .foregroundColor(.primary)
        }
    }
}
