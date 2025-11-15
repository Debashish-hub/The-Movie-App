//
//  FavoritesView.swift
//  TheMovieApp
//
//  Created by Debashish on 15/11/25.
//


import SwiftUI

struct FavoritesView: View {
    @State private var favoriteMovies: [Movie] = []

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ZStack {
                if favoriteMovies.isEmpty {
                    emptyView
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(favoriteMovies) { movie in
                                NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                                    FavoriteGridItem(movie: movie)
                                        .padding()
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                loadFavorites()
            }
        }
    }


    private func loadFavorites() {
        favoriteMovies = []
        let ids = FavoritesManager.shared.allFavorites()
        guard !ids.isEmpty else {
            return
        }

        NetworkManager.shared.fetchMoviesByIds(ids: ids) { list in
            DispatchQueue.main.async {
                favoriteMovies = list
            }
        }
    }
    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart.slash")
                .font(.system(size: 40))
                .foregroundColor(.gray)

            Text("You have no favorites yet")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.top, 4)

            Text("Browse movies and tap the heart to save them here.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }

}


// MARK: - Grid Item for FavoritesView
struct FavoriteGridItem: View {
    let movie: Movie


    var body: some View {
        VStack(alignment: .leading) {
            MoviePoster(path: movie.posterPath)
                .frame(height: 200)
        }
    }
}
