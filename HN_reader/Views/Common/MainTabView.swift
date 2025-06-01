//
//  MainTabView.swift
//  HN_reader
//
//  Created by MpAsSgHA on 24.04.2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NewsView()
                .tabItem {
                    Label("Главная", systemImage: "house")
                }
            FavoritesView()
                .tabItem {
                    Label("Избранное", systemImage: "newspaper")
                }
            RecommendationsView()
                .tabItem {
                    Label("Рекомендации", systemImage: "hand.thumbsup")
                }
            AccountView()
                .tabItem {
                    Label("Аккаунт", systemImage: "person.crop.circle")
                }
        }.tint(Color("Main"))
    }
}
