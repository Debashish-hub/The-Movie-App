//
//  NetworkManager.swift
//  TheMovieApp
//
//  Created by Debashish on 15/11/25.
//


import Foundation


final class NetworkManager {
    static let shared = NetworkManager()
    private init() {
        
    }
    
    
    // Put your API key here or read from Info.plist
    static let apiKey =  "e95ffb511be2d973809a6e7d565c5bb8"//"YOUR_TMDB_API_KEY"
    private let base = "https://api.themoviedb.org/3"
    
    // MARK: - Form URL
    private func makeURL(path: String, queryItems: [URLQueryItem] = []) -> URL? {
        var components = URLComponents(string: base + path)
        var items = [URLQueryItem(name: "api_key", value: Self.apiKey)]
        items.append(contentsOf: queryItems)
        components?.queryItems = items
        return components?.url
    }
    
    // MARK: - Fetch Popular Movies
    func fetchPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = makeURL(path: "/movie/popular") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, resp, err in
            self.logAPICall(url: url, data: data, error: err)
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let data = data else {
                completion(.failure(NSError()))
                return
            }
            do {
                let resp = try JSONDecoder().decode(MoviesResponse.self, from: data)
                completion(.success(resp.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Fetch Movie Details
    func fetchMovieDetail(id: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        guard let url = makeURL(path: "/movie/\(id)") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, err in
            self.logAPICall(url: url, data: data, error: err)
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let data = data else {
                completion(.failure(NSError()))
                return
            }
            do {
                let resp = try JSONDecoder().decode(MovieDetail.self, from: data)
                completion(.success(resp))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Search Moviews By Name
    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let qi = [URLQueryItem(name: "query", value: query)]
        guard let url = makeURL(path: "/search/movie", queryItems: qi) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, err in
            self.logAPICall(url: url, data: data, error: err)
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let data = data else {
                completion(.failure(NSError()))
                return
            }
            do {
                let resp = try JSONDecoder().decode(MoviesResponse.self, from: data)
                completion(.success(resp.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Pagination
    func fetchPopularPage(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        guard let url = makeURL(path: "/movie/popular", queryItems: queryItems) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, err in
            self.logAPICall(url: url, data: data, error: err)
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let data = data else {
                completion(.failure(NSError()))
                return
            }

            do {
                let response = try JSONDecoder().decode(MoviesResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Fetch Movie By ID
    func fetchMoviesByIds(ids: [Int], completion: @escaping ([Movie]) -> Void) {
        var movies: [Movie] = []
        let group = DispatchGroup()

        for id in ids {
            group.enter()
            fetchMovieDetail(id: id) { result in
                if case .success(let detail) = result {
                    // Convert MovieDetail → Movie (minimal data used by FavoritesView)
                    let movie = Movie(
                        id: detail.id,
                        title: detail.title,
                        overview: detail.overview,
                        posterPath: detail.posterPath,
                        voteAverage: detail.voteAverage,
                        voteCount: nil,
                        releaseDate: nil
                    )
                    movies.append(movie)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(movies)
        }
    }

    // MARK: - Log
    private func logAPICall(url: URL, data: Data?, error: Error?, start: Date = Date()) {
        let duration = String(format: "%.2f", Date().timeIntervalSince(start))

        print("""
        \n================ API LOG ================
        URL: \(url.absoluteString)
        Duration: \(duration)s

        Error: \(error?.localizedDescription ?? "None")

        Response:
        \(String(data: data ?? Data(), encoding: .utf8) ?? "N/A")
        =========================================\n
        """)
    }
}

extension NetworkManager {
    func fetchMovieDetailAsync(id: Int) async throws -> MovieDetail {
        let url = makeURL(path: "/movie/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(MovieDetail.self, from: data)
    }

    func fetchCastAsync(id: Int) async throws -> [Cast] {
        let url = makeURL(path: "/movie/\(id)/credits")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(CastResponse.self, from: data).cast
    }

    func fetchVideosAsync(id: Int) async throws -> [Video] {
        let url = makeURL(path: "/movie/\(id)/videos")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(VideosResponse.self, from: data).results
    }
}
