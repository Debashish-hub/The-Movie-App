//
//  VideosResponse.swift
//  TheMovieApp
//
//  Created by Debashish on 15/11/25.
//


import Foundation


struct VideosResponse: Codable {
    let id: Int
    let results: [Video]
}


struct Video: Codable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
}
