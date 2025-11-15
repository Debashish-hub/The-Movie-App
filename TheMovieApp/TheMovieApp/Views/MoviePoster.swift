//
//  MoviePoster.swift
//  TheMovieApp
//
//  Created by Debashish on 15/11/25.
//


import SwiftUI

struct MoviePoster: View {
    let path: String?
    @State private var image: UIImage? = nil

    var body: some View {
        ZStack {
            if let img = image {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                ProgressView()
            }
        }
        .onAppear {
            load()
        }
    }
    private func load() {
        ImageLoader.shared.loadImage(path: path) { img in
            image = img
        }
    }
}
