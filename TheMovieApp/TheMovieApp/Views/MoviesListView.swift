//
//  MoviesListView.swift
//  TheMovieApp
//
//  Created by Debashish on 15/11/25.
//


import SwiftUI


struct MoviesListView: View {

    // MARK: - States
    @State private var movies: [Movie] = []
    @State private var searchText = ""
    @State private var page = 1

    @State private var isLoading = true
    @State private var isFetchingMore = false
    @State private var searchDebounceTask: DispatchWorkItem?
    
    @State private var searchError: String?
    @State private var popularError: String?


    var body: some View {
        NavigationView {
            ZStack {
                moviesList
                    .searchable(text: $searchText, prompt: "Search movies")
                    .onChange(of: searchText) { _ in
                        debounceSearch()
                    }

                if isLoading {
                    ProgressView("Loading movies...")
                        .scaleEffect(1.3)
                }
            }
            .navigationTitle("Popular Movies")
        }
        .onAppear(perform: loadPopular)
    }

    private var moviesList: some View {
        List {
            if let error = popularError {
                errorRow(message: error, retryAction: loadPopular)
            }

            if let error = searchError {
                errorRow(message: error) {
                    searchMovies()
                }
            }
            
            ForEach(movies) { movie in
                NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                    MovieRowView(movie: movie)
                }
                .onAppear {
                    triggerPaginationIfNeeded(movie)
                }
            }

            if isFetchingMore {
                loadingMoreRow
            }
        }
        .listStyle(.plain)
    }

    private func triggerPaginationIfNeeded(_ movie: Movie) {
        if movie == movies.last {
            loadMoreMovies()
        }
    }

    private var loadingMoreRow: some View {
        HStack {
            Spacer()
            ProgressView().padding()
            Spacer()
        }
    }

    // MARK: - Error Handling
    private func errorRow(message: String, retryAction: @escaping () -> Void) -> some View {
        VStack(spacing: 8) {
            Text(message)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)

            Button("Retry") {
                retryAction()
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 5)
    }

    // MARK: - Initial Load
    private func loadPopular() {
        isLoading = true
        page = 1
        popularError = nil
        NetworkManager.shared.fetchPopularMovies { result in
            DispatchQueue.main.async {
                isLoading = false

                switch result {
                case .success(let list):
                    self.movies = list

                case .failure(let error):
                    self.popularError = error.localizedDescription
                    print("Error loading popular movies:", error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Search with Debounce
    private func debounceSearch() {
        searchDebounceTask?.cancel()

        let task = DispatchWorkItem {
            searchMovies()
        }

        searchDebounceTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: task)
    }

    private func searchMovies() {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else {
            searchError = nil
            loadPopular()
            return
        }
        searchError = nil
        NetworkManager.shared.searchMovies(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self.movies = list

                case .failure(let error):
                    self.searchError = error.localizedDescription
                    print("Search failed:", error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Infinite Scroll
    private func loadMoreMovies() {
        guard !isFetchingMore && searchText.isEmpty else { return }

        isFetchingMore = true
        page += 1

        NetworkManager.shared.fetchPopularPage(page: page) { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isFetchingMore = false

                switch result {
                case .success(let list):
                    self.movies.append(contentsOf: list)

                case .failure(let error):
                    print("Pagination failed:", error.localizedDescription)
                }
            }
        }
    }
}

