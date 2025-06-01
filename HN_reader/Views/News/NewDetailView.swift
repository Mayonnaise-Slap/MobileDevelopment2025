
// NewDetailView.swift

import SwiftUI
import SafariServices

struct NewDetailView: View {
    @Binding var item: News
    let storyId: Int
    @State private var showSafari = false
    @State private var comments: [Comments] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    private let apiService = APIService()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(item.title)
                        .font(.title)
                        .bold()
                        .lineLimit(3)
                        .truncationMode(.tail)
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
                        .foregroundColor(Color("Divider"))
                    Spacer()
                    Text("Дата: \(item.date)")
                        .font(.subheadline)
                        .foregroundColor(Color("Divider"))
                }
                .foregroundColor(.gray)

                Text("Рейтинг: \(item.rating)")
                    .font(.subheadline)
                    .foregroundColor(Color("Main"))
                
                if let urlString = item.url,
                   let url = URL(string: urlString),
                   UIApplication.shared.canOpenURL(url) {
                    
                    Button(action: { showSafari = true }) {
                        HStack {
                            Image(systemName: "link")
                            Text("Читать новость")
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(Color("Main"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.vertical, 8)
                    .sheet(isPresented: $showSafari) {
                        SafariView(url: url)
                    }
                }

                Divider()
                    .padding(.vertical, 4)
                
                Text("Комментарии")
                    .font(.headline)
                    .padding(.bottom, 2)

                // Комментарии
                if isLoading {
                    ProgressView("Загрузка комментариев...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let error = errorMessage {
                    Text("Нет комментариев")
                        .padding()
                } else if comments.isEmpty {
                    Text("Нет комментариев")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    LazyVStack(spacing: 15) {
                        ForEach(comments) { item in
                            CommentsRowView(item: item)
                        }
                    }
                    .padding(.vertical)
                    .foregroundColor(Color("Divider"))
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Детали новости")
        .onAppear {
            loadComments()
        }
    }

    // Логика загрузки комментариев
    private func loadComments() {
        isLoading = true
        errorMessage = nil
        apiService.fetchComments(forStoryId: storyId) { (fetchedComments, error) in
            DispatchQueue.main.async {
                if let fetchedComments = fetchedComments {
                    self.comments = fetchedComments
                } else if let error = error {
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
            }
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
