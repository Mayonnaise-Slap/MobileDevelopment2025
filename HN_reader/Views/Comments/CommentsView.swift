
// CommentsView.swift

import SwiftUI

struct CommentsView: View {
    @State private var comments: [Comments] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    private let apiService = APIService()
    let storyId: Int

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Загрузка комментариев...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else if let errorMessage {
                Text("Ошибка: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else if comments.isEmpty {
                Text("Нет комментариев")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach($comments) { $item in
                            CommentsRowView(item: item)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Комментарии")
        .onAppear {
            loadComments()
        }
    }

    private func loadComments() {
        isLoading = true
        errorMessage = nil
        
        apiService.fetchComments(forStoryId: storyId) { (fetchedComments, error) in
            DispatchQueue.main.async {
                if let fetchedComments = fetchedComments {
                    self.comments = fetchedComments
                } else if let error = error {
                    self.errorMessage = error.localizedDescription
                    print("Ошибка загрузки комментариев: \(error)")
                }
                self.isLoading = false
            }
        }
    }
}
