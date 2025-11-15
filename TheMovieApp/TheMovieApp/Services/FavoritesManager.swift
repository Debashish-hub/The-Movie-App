//
//  FavoritesManager.swift
//  TheMovieApp
//
//  Created by Debashish on 15/11/25.
//


import Foundation


final class FavoritesManager {
    static let shared = FavoritesManager()
    private let key = "favorite_movie_ids"
    private init() {
        load()
    }


    private var set: Set<Int> = []


    func load() {
        if let arr = UserDefaults.standard.array(forKey: key) as? [Int] {
            set = Set(arr)
        }
    }


    func save() {
        let arr = Array(set)
        UserDefaults.standard.set(arr, forKey: key)
    }


    func isFavorite(id: Int) -> Bool {
        set.contains(id)
    }
    
    func toggle(id: Int) {
        if set.contains(id) {
            set.remove(id)
        } else {
            set.insert(id)
        }
        save()
        NotificationCenter.default.post(name: .favoritesChanged, object: nil)
    }
    
    func allFavorites() -> [Int] {
        load()
        return Array(set)
    }

}


extension Notification.Name {
    static let favoritesChanged = Notification.Name("favoritesChanged")
}
