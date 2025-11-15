//
//  TrailerWebView.swift
//  TheMovieApp
//
//  Created by Debashish on 15/11/25.
//


import SwiftUI
import WebKit
import YouTubeiOSPlayerHelper


struct YouTubePlayerView: UIViewRepresentable {
    let videoKey: String

    func makeUIView(context: Context) -> YTPlayerView {
        return YTPlayerView()
    }

    func updateUIView(_ uiView: YTPlayerView, context: Context) {
        let params: [String: Any] = [
            "playsinline": 1,
            "autoplay": 0,
            "controls": 1,
            "modestbranding": 1
        ]

        uiView.load(withVideoId: videoKey, playerVars: params)
    }
}
