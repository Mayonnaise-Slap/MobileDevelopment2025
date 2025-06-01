
// NewDetailView.swift

import SwiftUI

struct NewDetailView: View {
    @Binding var item: News
    let storyId: Int

    init(item: Binding<News>, storyId: Int) {
        self._item = item
        self.storyId = storyId
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(item.title)
                    .font(.title)
                    .bold()
                Spacer()
                Button(action: {
                    item.isFavorite.toggle()
                }) {
                    Image(systemName: item.isFavorite ? "star.fill" : "star")
                        .foregroundColor(Color("Star"))
                }
            }
            HStack {
                Text("Автор: \(item.author)")
                    .font(.subheadline)
                Spacer()
                Text("Дата: \(item.date)")
                    .font(.subheadline)
            }
            .foregroundColor(.gray)
            Text("Рейтинг: \(item.rating)")
                .font(.subheadline)
                .foregroundColor(Color("Main"))
            NavigationLink(destination: CommentsView(storyId: storyId)) {
                Text("Посмотреть комментарии")
                    .padding()
                    .background(Color("Main"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Детали новости")
    }
}

struct NewDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewDetailView(item: .constant(News(id: 1, title: "Новость 1", author: "Автор 1", date: "00.00.0001", rating: 5, isFavorite: false)), storyId: 1)
        }
    }
}
