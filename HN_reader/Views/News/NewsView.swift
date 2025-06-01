import SwiftUI

struct NewsView: View {
    @StateObject private var newsService = FilterSortNewsService()
    @State private var isLoading = true
    @State private var showFilterView = false
    @State private var currentPage = 0
    @State private var allNewsLoaded = false
    private let pageSize = 10
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
                            .foregroundColor(Color("Main"))
                        Text("Фильтры")
                            .foregroundColor(.primary)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color(.secondarySystemBackground))
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
                                // Отображаем только новости для текущей страницы
                                ForEach(newsService.paginatedIndices(page: currentPage, pageSize: pageSize), id: \.self) { index in
                                    NewsRowView(item: $newsService.news[index])
                                    
                                    // Загружаем следующую страницу при достижении последнего элемента
                                    if index == newsService.paginatedIndices(page: currentPage, pageSize: pageSize).last {
                                        ProgressView()
                                            .onAppear {
                                                loadNextPage()
                                            }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Индикатор загрузки следующей страницы
                        if !allNewsLoaded {
                            ProgressView()
                                .padding()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                loadInitialNews()
            }
        }
    }

    private func loadInitialNews() {
        isLoading = true
        currentPage = 0
        allNewsLoaded = false
        
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
    
    private func loadNextPage() {
        // Проверяем, есть ли еще новости для загрузки
        let totalItems = newsService.filteredAndSortedIndices.count
        let loadedItems = (currentPage + 1) * pageSize
        
        if loadedItems < totalItems {
            currentPage += 1
        } else {
            allNewsLoaded = true
        }
    }
}
