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
        if page > 3 {
            return Single.create { single in
                let responseError = ResponseError(type: .af, error: nil, afError: nil)
                single(.failure(responseError))
                return Disposables.create()
            }
        }
        
        return MockLoader
            .load(returnType: SearchArticleResult.self, file: "searchArticles.json")
            .map { $0.articles }
    }
}
