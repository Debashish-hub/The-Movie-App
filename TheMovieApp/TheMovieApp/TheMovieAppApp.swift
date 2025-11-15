//
//  TheMovieAppApp.swift
//  TheMovieApp
//
//  Created by Debashish on 15/11/25.
//

import SwiftUI

@main
struct TheMovieAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
