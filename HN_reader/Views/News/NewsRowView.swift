//
//  NewsRowView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 24.04.2025.
//
import SwiftUI

struct NewRowView: View {
    @Binding var item: News

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                NavigationLink(destination: NewsDetailView(item: $item)) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Image(systemName: "info.circle")
                        .foregroundColor(Color("Icon"))
                }
                Text("Автор: \(item.author)")
                    .font(.caption)
                Text(item.date)
                    .font(.caption2)
                    .foregroundColor(Color("Divider"))
                Text("Рейтинг: \(item.rating)")
                    .font(.caption2)
                    .foregroundColor(Color("Divider"))
            }
            Spacer()
            Button(action: {
                item.isFavorite.toggle()
            }) {
                Image(systemName: item.isFavorite ? "star.fill" : "star")
                    .foregroundColor(.orange)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.4)))
    }
}


