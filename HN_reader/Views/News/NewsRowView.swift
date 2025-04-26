//
//  NewsRowView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 24.04.2025.
//
import SwiftUI

struct NewsRowView: View {
    @Binding var item: NewsItem

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                NavigationLink(destination: NewsDetailView(item: item)) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Image(systemName: "info.circle")
                }
                Text("Автор: \(item.author)")
                    .font(.caption)
                Text(item.date)
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text("Рейтинг: \(item.rating)")
                    .font(.caption2)
                    .foregroundColor(.gray)
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


