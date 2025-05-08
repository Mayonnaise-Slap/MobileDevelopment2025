//
//  NewDateilView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 26.04.2025.
//

import SwiftUI


struct NewsDetailView: View {
    @Binding var item: News
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack() {
            HeaderView()
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.backward")
                        Text("Назад")
                    }
                    .foregroundColor(Color(uiColor: #colorLiteral(red: 0.9777966142, green: 0.3477782011, blue: 0.05399081856, alpha: 1)))
                    .font(.caption)
                }
                Spacer()
            }
            .padding([.horizontal, .top])

            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text(item.title)
                        .font(.title2)
                        .bold()
                    Spacer()
                    Button(action: {
                        item.isFavorite.toggle()
                    }) {
                        Image(systemName: item.isFavorite ? "star.fill" : "star")
                            .foregroundColor(.orange)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                HStack {
                    Text("Автор: \(item.author)")
                        .font(.caption)
                    Spacer()
                    Text(item.date)
                        .font(.caption)
                    Spacer()
                    Text("Рейтинг: \(item.rating)")
                        .font(.caption)
                }
                .foregroundColor(Color("Divider"))
                

                Divider()
                    .frame(height: 2)
                    .background((Color("Divider")))

                Text("Комментарии:")
                    .font(.body)
                    .bold()

                CommentsView()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

