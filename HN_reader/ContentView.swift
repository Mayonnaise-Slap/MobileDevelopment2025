import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    var body: some View {
        NavigationView {
            VStack {
                AuthView() // без передачи viewModel напрямую!
                Divider().padding(.vertical)
                NewsView()
            }
            .navigationTitle("Главная")
        }
        .environmentObject(authViewModel) // <- ключевая строка!
    }
}
