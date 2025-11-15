//
//  CastResponse.swift
//  TheMovieApp
//
//  Created by Debashish on 15/11/25.
//
import Foundation

struct CastResponse: Codable {
    let cast: [Cast]
}

struct Cast: Codable, Identifiable {
    var id: Int { castId ?? UUID().hashValue }

    let castId: Int?
    let name: String
    let character: String?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case castId = "cast_id"
        case name
        case character
        case profilePath = "profile_path"
    }
}
