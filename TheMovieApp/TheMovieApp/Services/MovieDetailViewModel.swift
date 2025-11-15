//
//  MovieDetailViewModel.swift
//  TheMovieApp
//
//  Created by Debashish on 15/11/25.
//
import SwiftUI

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var detail: MovieDetail?
    @Published var cast: [Cast] = []
    @Published var trailerKey: String?
    @Published var isFavorite = false
    @Published var isLoadingDetails = true
    @Published var isLoadingCast = true
    @Published var isLoadingVideos = true
    @Published var allVideos: [Video] = []
    @Published var selectedVideoIndex: Int = 0
    @Published var detailsError: String?
    @Published var castError: String?
    @Published var videosError: String?

    let maxVideosToShow = 5

    func load(movieId: Int) {
        isFavorite = FavoritesManager.shared.isFavorite(id: movieId)

        Task {
            await loadDetails(movieId)
        }

        Task {
            await loadCast(movieId)
        }

        Task {
            await loadVideos(movieId)
        }
    }

    func loadDetails(_ id: Int) async {
        defer {
            isLoadingDetails = false
        }
        do {
            detail = try await NetworkManager.shared.fetchMovieDetailAsync(id: id)
        } catch {
            detailsError = error.localizedDescription
            print("Details failed:", error.localizedDescription)
        }
    }

    func loadCast(_ id: Int) async {
        defer {
            isLoadingCast = false
        }
        do {
            cast = try await NetworkManager.shared.fetchCastAsync(id: id)
        } catch {
            castError = error.localizedDescription
            print("Cast failed:", error.localizedDescription)
        }
    }
    func loadVideos(_ id: Int) async {
        defer { isLoadingVideos = false }
        do {
            let vids = try await NetworkManager.shared.fetchVideosAsync(id: id)
            let youtube = vids.filter { $0.site.lowercased() == "youtube" }
            let limitedVideos = Array(youtube.prefix(maxVideosToShow))
            allVideos = limitedVideos
            if let trailer = youtube.first {
                trailerKey = trailer.key
                // Delay to prevent UI freeze
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.isLoadingVideos = false
                }
            }
        } catch {
            videosError = error.localizedDescription
            print("Videos failed:", error.localizedDescription)
        }
    }
}
