//
//  Helpers.swift
//  TheMovieApp
//
//  Created by Debashish on 15/11/25.
//

import Foundation

extension Int {
    // MARK: - Formatting Votes
    var compact: String {
        if self >= 1_000_000 { return "\(self / 1_000_000)M" }
        if self >= 1_000 { return "\(self / 1_000)K" }
        return "\(self)"
    }
}

extension String {
    // MARK: - Formatting Date
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        if let date = formatter.date(from: self) {
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }

        return self
    }
}

