//
//  MovieDetailView.swift
//  TheMovieApp
//
//  Created by Debashish on 15/11/25.
//


import SwiftUI
import WebKit

struct MovieDetailView: View {
    let movieId: Int
    @StateObject private var vm = MovieDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: Trailer
                trailerSection
                
                // MARK: Details
                detailsSection
                
                // MARK: Cast
                castSection
                
                // MARK: Favorite Button
                if vm.detail != nil {
                    favoriteButton
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .onAppear {
            vm.load(movieId: movieId)
        }
    }
    
    // MARK: Trailer
    var trailerSection: some View {
        VStack(alignment: .center, spacing: 12) {
            if let error = vm.videosError {
                Rectangle()
                    .fill(Color.black.opacity(0.2))
                    .frame(height: 250)
                    .cornerRadius(12)
                    .overlay(
                        VStack(spacing: 8) {
                            Text(error)
                                .foregroundColor(.white)

                            Button("Retry") {
                                vm.isLoadingVideos = true
                                vm.videosError = nil
                                Task {
                                    await vm.loadVideos(movieId)
                                }
                            }
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(8)
                        }
                    )
            } else if vm.isLoadingVideos {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 250)
                    .cornerRadius(12)
                    .overlay(ProgressView())
            }
            else if vm.allVideos.isEmpty {
                Rectangle()
                    .fill(Color.black.opacity(0.2))
                    .frame(height: 200)
                    .cornerRadius(12)
                    .overlay(Text("No Videos Available"))
            }
            else {
                TabView(selection: $vm.selectedVideoIndex) {
                    ForEach(Array(vm.allVideos.enumerated()), id: \.offset) { index, video in
                        YouTubePlayerView(videoKey: video.key)
                            .frame(height: 250)
                            .cornerRadius(12)
                            .tag(index)
                    }
                }
                .frame(height: 250)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                // MARK: - Custom Page Indicator
                HStack(spacing: 10) {
                    ForEach(vm.allVideos.indices, id: \.self) { index in
                        Capsule()
                            .fill(vm.selectedVideoIndex == index ? Color.blue : Color.gray.opacity(0.5))
                            .frame(
                                width: vm.selectedVideoIndex == index ? 22 : 8,
                                height: 8
                            )
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: vm.selectedVideoIndex)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)

            }
        }
    }

    // MARK: Details
    private var detailsSection: some View {
        Group {
            if let error = vm.detailsError {
                VStack(spacing: 8) {
                    Text(error)
                        .foregroundColor(.red)

                    Button("Retry") {
                        vm.isLoadingDetails = true
                        vm.detailsError = nil
                        Task { await vm.loadDetails(movieId) }
                    }
                    .buttonStyle(.bordered)
                }
            } else if vm.isLoadingDetails {
                ProgressView("Loading details...")
            } else if let d = vm.detail {
                VStack(alignment: .leading, spacing: 10) {
                    Text(d.title)
                        .font(.largeTitle.bold())
                    
                    HStack {
                        Text("⭐️ \(d.voteAverage ?? 0, specifier: "%.2f")")
                        Text("• \(d.runtime ?? 0) min")
                    }
                    .font(.headline)
                    
                    Text("Genres: " + d.genres.map{$0.name}.joined(separator: ", "))
                        .font(.subheadline)
                    
                    Text(d.overview ?? "")
                        .font(.body)
                        .padding(.top)
                }
            }
        }
    }
    
    // MARK: Cast
    private var castSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cast")
                .font(.headline)
            
            if let error = vm.castError {
                VStack(spacing: 8) {
                    Text(error)
                        .foregroundColor(.red)

                    Button("Retry") {
                        vm.isLoadingCast = true
                        vm.castError = nil
                        Task { await vm.loadCast(movieId) }
                    }
                    .buttonStyle(.bordered)
                }
            } else if vm.isLoadingCast {
                ProgressView("Loading cast…")
            } else if vm.cast.isEmpty {
                Text("No cast information available")
                    .foregroundColor(.secondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(vm.cast) { member in
                            VStack(alignment: .leading, spacing: 6) {
                                MoviePoster(path: member.profilePath)
                                    .frame(width: 90, height: 120)
                                    .cornerRadius(8)
                                
                                Text(member.name)
                                    .font(.caption)
                                    .lineLimit(1)
                                
                                Text(member.character ?? "")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                            .frame(width: 90)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Favorite Button
    private var favoriteButton: some View {
        Button {
            FavoritesManager.shared.toggle(id: movieId)
            vm.isFavorite = FavoritesManager.shared.isFavorite(id: movieId)
        } label: {
            Text(vm.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
    
}
