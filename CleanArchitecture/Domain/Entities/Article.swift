//
//  News.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/4/21.
//

import Foundation

struct Article: Decodable {
    @Default.Empty var author: String
    @Default.Empty var title: String
    @Default.Empty var description: String
    @Default.Empty var url: String
    @Default.Empty var urlToImage: String
    @Default.Empty var publishedAt: String
    @Default.Empty var content: String
}

extension Article {
    var formattedPublishedAt: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ssZ"
        guard let date = formatter.date(from: publishedAt) else { return "" }

        let outFormatter = DateFormatter()
        outFormatter.dateFormat = "MMM dd, HH:mm"
        return "\(NSLocalizedString("Updated", comment: "")): \(outFormatter.string(from: date))"
    }
}
