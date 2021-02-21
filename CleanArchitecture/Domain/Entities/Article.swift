//
//  News.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/4/21.
//

import Foundation

struct Article: Decodable {
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?

    var formattedPublishAt: String {
        guard let publishedAt = publishedAt else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ssZ"
        guard let date = formatter.date(from: publishedAt) else { return "" }

        let outFormatter = DateFormatter()
        outFormatter.dateFormat = "MMM dd, HH:mm"
        return "\(NSLocalizedString("Updated", comment: "")): \(outFormatter.string(from: date))"
    }
}
