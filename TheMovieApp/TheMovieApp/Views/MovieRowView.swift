//
//  MovieRowView.swift
//  TheMovieApp
//
//  Created by Debashish on 15/11/25.
//


import SwiftUI

struct MovieRowView: View {
    let movie: Movie
    @State private var isFavorite: Bool = false
    @State private var navigate = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            // Tappable content
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 12) {
                    MoviePoster(path: movie.posterPath)
                        .frame(width: 100, height: 150)
                        .cornerRadius(8)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(movie.title)
                            .font(.headline)

                        Text("⭐️ \(movie.voteAverage ?? 0, specifier: "%.2f")  (\(Int(movie.voteCount ?? 0).compact) votes)")
                            .foregroundColor(.yellow)
                            .font(.subheadline)

//                        Spacer()
                        Text("\(movie.releaseDate?.formattedDate ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    navigate = true
                }
            }

            Spacer()

            Button(action: {
                isFavorite.toggle()
                FavoritesManager.shared.toggle(id: movie.id)
            }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(.red)
                    .font(.title3)
                    .padding(.top, 4)
            }
            .buttonStyle(.plain)
        }
        .background(
            NavigationLink("", isActive: $navigate) {
                MovieDetailView(movieId: movie.id)
            }
            .hidden()
        )
        .padding(.vertical, 8)
        .onAppear {
            isFavorite = FavoritesManager.shared.isFavorite(id: movie.id)
        }
    }
}




