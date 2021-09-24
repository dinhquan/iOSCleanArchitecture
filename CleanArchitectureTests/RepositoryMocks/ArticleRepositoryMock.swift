//
//  ArticleRepositoryMock.swift
//  NewsAppTests
//
//  Created by Dinh Quan on 2/4/21.
//

import Foundation
import RxSwift
@testable import CleanArchitecture

struct ArticleRepositoryMock: ArticleUseCase {
    func findArticlesByKeyword(_ keyword: String, pageSize: Int, page: Int) -> Single<[Article]> {
        return MockLoader
            .load(returnType: SearchArticleResult.self, file: "searchArticles.json")
            .map { $0.articles }
    }
}
