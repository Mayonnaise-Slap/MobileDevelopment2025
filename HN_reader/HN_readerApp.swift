//
//  HN_readerApp.swift
//  HN_reader
//
//  Created by MpAsSgHA on 24.04.2025.
//

import SwiftUI

@main
struct HN_readerApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var appState = AppState(
            isAuthenticated: UserDefaults.standard.string(forKey: "currentUserId") != nil
        )
    @AppStorage("isDarkMode") var isDarkMode = false
        
        var body: some Scene {
            WindowGroup {
                ContentView()
                    .environmentObject(authViewModel)
                    .environmentObject(appState)
                    .preferredColorScheme(isDarkMode ? .dark : .light)
            }
        }
    }
