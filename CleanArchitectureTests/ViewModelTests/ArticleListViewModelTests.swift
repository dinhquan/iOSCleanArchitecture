//
//  ArticleListViewModelTests.swift
//  NewsAppTests
//
//  Created by Dinh Quan on 2/4/21.
//

import XCTest
import RxTest
import RxBlocking
import RxSwift
import struct RxCocoa.Driver
@testable import CleanArchitecture

typealias ViewModel = ArticleListViewModel

class ArticleListViewModelTests: XCTestCase {

    var testScheduler: TestScheduler!
    var viewModel: ViewModel!
    let bag = DisposeBag()

    override func setUpWithError() throws {
        testScheduler = TestScheduler(initialClock: 0)
        viewModel = ArticleListViewModel()
        viewModel.articleUseCase = ArticleRepositoryMock()
    }

    override func tearDownWithError() throws {}

    func test_searchWithKeyword() throws {
        // Given
        let search = testScheduler
            .createHotObservable([
                .next(0, "Tesla")
            ])
            .asObservable()
        let input = ViewModel.Input(search: search, loadMore: .never())
        let output = viewModel.transform(input: input)

        // When
        testScheduler.start()
        let articles = try! output.tableData.articles.toBlocking().first()!

        // Then
        XCTAssertEqual(articles.count, 20)
        XCTAssertEqual(articles[1].author, "Mike Murphy")
    }

    func test_loadMore() throws {
        // Given
        let search = testScheduler
            .createHotObservable([
                .next(0, "Tesla")
            ])
            .asObservable()
        let loadMore = testScheduler
            .createHotObservable([
                .next(2, ())
            ])
            .asObservable()
        let input = ViewModel.Input(search: search, loadMore: loadMore)
        let output = viewModel.transform(input: input)

        // When
        testScheduler.start()
        let articles = try! output.tableData.articles.toBlocking().first()!
        
        // Then
        XCTAssertEqual(articles.count, 40)
    }

    func test_loadMoreWithError() throws {
        // Given
        let search = testScheduler
            .createHotObservable([
                .next(0, "Tesla")
            ])
            .asObservable()
        let loadMore = testScheduler
            .createHotObservable([
                .next(1, ()),
                .next(2, ()),
                .next(3, ()),
                .next(4, ())
            ])
            .asObservable()
        let input = ViewModel.Input(search: search, loadMore: loadMore)
        let output = viewModel.transform(input: input)

        // When
        output.error
            .drive()
            .disposed(by: bag)

        testScheduler.start()
        let error = try! output.error.toBlocking().first()

        // Then
        XCTAssertNotNil(error)
    }
}

private extension Driver where Element == [ViewModel.SectionModel] {
    var articles: Observable<[Article]> {
        return map { sectionModels -> [Article] in
            return sectionModels[0].items
                .map { sectionItem -> Article in
                    switch sectionItem {
                    case .article(let vm):
                        return vm.article
                    }
                }
        }
        .asObservable()
    }
}
