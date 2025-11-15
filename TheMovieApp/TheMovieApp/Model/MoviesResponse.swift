//
//  MoviesResponse.swift
//  TheMovieApp
//
//  Created by Debashish on 15/11/25.
//


import Foundation


struct MoviesResponse: Codable {
    let page: Int
    let results: [Movie]
}


struct Movie: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let voteAverage: Double?
    let voteCount: Double?
    let releaseDate: String?
    


    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case voteCount = "vote_count"
    }
}
