//
//  NewsService.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/4/21.
//

import Foundation

enum ArticleService: RestAPI {
    case searchArticlesByKeyword(q: String, pageSize: Int, page: Int)

    var path: String {
        switch self {
        case .searchArticlesByKeyword(let q, let pageSize, let page):
            let encodedQ = q.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) ?? ""
            return "everything?q=\(encodedQ)&from=2021-02-01&sortBy=publishedAt&apiKey=\(Config.current.apiKey)&pageSize=\(pageSize)&page=\(page)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .searchArticlesByKeyword:
            return .get
        }
    }

    var mockFile: String {
        switch self {
        case .searchArticlesByKeyword:
            return "searchArticles.json"
        }
    }
}
