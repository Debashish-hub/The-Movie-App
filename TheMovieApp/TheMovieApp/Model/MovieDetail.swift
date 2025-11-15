//
//  MovieDetail.swift
//  TheMovieApp
//
//  Created by Debashish on 15/11/25.
//


import Foundation


struct MovieDetail: Codable {
    let id: Int
    let title: String
    let overview: String?
    let genres: [Genre]
    let runtime: Int?
    let voteAverage: Double?
    let posterPath: String?


    enum CodingKeys: String, CodingKey {
        case id, title, overview, genres, runtime
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
    }
}


struct Genre: Codable {
    let id: Int;
    let name: String
}
