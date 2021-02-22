//
//  NewsRepository.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/4/21.
//

import RxSwift

struct SearchArticleResult: Decodable {
    @Default.EmptyList var articles: [Article]
    @Default.Zero var totalResults: Int
}

struct ArticleRepository: ArticleUseCase {
    func findArticlesByKeyword(_ keyword: String, pageSize: Int, page: Int) -> Single<[Article]> {
        return ArticleService
            .searchArticlesByKeyword(q: keyword, pageSize: pageSize, page: page)
            .request(returnType: SearchArticleResult.self)
            .map { $0.articles }
    }
}
