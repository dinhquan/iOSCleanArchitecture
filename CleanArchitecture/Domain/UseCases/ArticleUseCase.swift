//
//  NewsUseCase.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/4/21.
//

import RxSwift

protocol ArticleUseCase {
    func findArticlesByKeyword(_ keyword: String, pageSize: Int, page: Int) -> Single<[Article]>
}
