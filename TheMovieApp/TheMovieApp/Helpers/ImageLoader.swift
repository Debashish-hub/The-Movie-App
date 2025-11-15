//
//  ImageLoader.swift
//  TheMovieApp
//
//  Created by Debashish on 15/11/25.
//


import UIKit


final class ImageLoader {
    static let shared = ImageLoader()
    private var cache = NSCache<NSString, UIImage>()

    // MARK: - Load Image
    func loadImage(path: String?, size: String = "w342", completion: @escaping (UIImage?) -> Void) {
        guard let path = path else {
            completion(nil)
            return
        }
        let base = "https://image.tmdb.org/t/p/\(size)" + path
        if let cached = cache.object(forKey: base as NSString) {
            completion(cached)
            return
        }
        guard let url = URL(string: base) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let d = data, let img = UIImage(data: d) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            self.cache.setObject(img, forKey: base as NSString)
            DispatchQueue.main.async {
                completion(img)
            }
        }.resume()
    }
}

