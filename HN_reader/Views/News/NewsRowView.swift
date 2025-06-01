// NewsRowView.swift

import SwiftUI

struct NewsRowView: View {
    @Binding var item: News

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                NavigationLink(destination: NewDetailView(item: $item, storyId: item.id)) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .truncationMode(.tail)
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
        .background(Color("Star"))
    }
}

struct NewsRowView_Previews: PreviewProvider {
    static var previews: some View {
        NewsRowView(item: .constant(News(id: 1, title: "Новость 1", author: "Автор 1", date: "00.00.0001", rating: 5, isFavorite: false, url: "http://192.168.31.156:8000/api/v1/topstories")))
    }
}
