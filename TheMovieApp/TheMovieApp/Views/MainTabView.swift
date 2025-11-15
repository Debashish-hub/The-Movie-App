//
//  MainTabView.swift
//  TheMovieApp
//
//  Created by Debashish on 15/11/25.
//


import SwiftUI

struct MainTabView: View {
        @State private var favoriteCount: Int = FavoritesManager.shared.allFavorites().count


    var body: some View {
        TabView {
            MoviesListView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .onReceive(NotificationCenter.default.publisher(for: .favoritesChanged)) { _ in
                    favoriteCount = FavoritesManager.shared.allFavorites().count
                }


            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .badge(favoriteCount) // Dynamic badge
                .onReceive(NotificationCenter.default.publisher(for: .favoritesChanged)) { _ in
                    favoriteCount = FavoritesManager.shared.allFavorites().count
                }
        }
        .accentColor(.blue)
    }
}
