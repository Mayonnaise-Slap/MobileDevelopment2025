import SwiftUI

struct NewsView: View {
    @StateObject private var newsService = FilterSortNewsService()
    @State private var isLoading = true
    @State private var showFilterView = false
    private let apiService = APIService()

    var body: some View {
        NavigationStack {
            VStack {
                HeaderView()
                Text("Новости")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                Button(action: {
                    showFilterView = true
                }) {
                    HStack {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.white)
                        Text("Фильтры")
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color("Main"))
                    .cornerRadius(8)
                    
                }
                .padding(.bottom, 8)
                .sheet(isPresented: $showFilterView) {
                    FilterSortNewsView(
                        sortOption: $newsService.sortOptions,
                        filterOption: $newsService.filterOptions
                    )
                }
                if isLoading {
                    ProgressView("Загрузка новостей...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxHeight: .infinity)
                } else {
                    if newsService.news.isEmpty {
                        Text("Нет новостей")
                            .foregroundColor(.secondary)
                            .frame(maxHeight: .infinity)
                    } else {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(newsService.filteredAndSortedIndices, id: \.self) { index in
                                    NewsRowView(item: $newsService.news[index])
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                loadNews()
            }
        }
    }

    private func loadNews() {
        isLoading = true
        apiService.fetchNewStories { news, error in
            DispatchQueue.main.async {
                if let news = news {
                    self.newsService.news = news
                } else if let error = error {
                    print("Ошибка загрузки новостей: \(error)")
                }
                self.isLoading = false
            }
        }
    }
}
