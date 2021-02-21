//
//  ArticleListViewModel.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/4/21.
//

import RxSwift
import RxCocoa
import RxDataSources

struct ArticleListViewModel: ViewModelProtocol {
    struct Input {
        let search: Observable<String>
        let loadMore: Observable<Void>
    }

    struct Output {
        let tableData: Driver<[SectionModel]>
        let fetching: Driver<Bool>
        let error: Driver<Error>
    }

    @Injected var articleUseCase: ArticleUseCase

    private let bag = DisposeBag()
    private let pageSize = 20

    func transform(input: Input) -> Output {
        let currentPage = BehaviorRelay<Int>(value: 1)
        let allArticles = BehaviorRelay<[Article]>(value: [])

        let loadMore = input.loadMore
            .do(onNext: {
                let nextPage = currentPage.value + 1
                currentPage.accept(nextPage)
            })
            .withLatestFrom(input.search)

        let search = input.search
            .do(onNext: { _ in
                currentPage.accept(1)
            })

        let activityTracker = ActivityTracker()
        let errorTracker = ErrorTracker()

        Observable.merge(search, loadMore)
            .flatMapLatest { keyword in
                return articleUseCase
                    .findArticlesByKeyword(keyword, pageSize: pageSize, page: currentPage.value)
                    .trackActivity(activityTracker)
                    .trackError(errorTracker)
                    .asDriver(onErrorJustReturn: [])
            }
            .subscribe(onNext: { articles in
                var appendedArticles = allArticles.value
                if (currentPage.value == 1) {
                    appendedArticles.removeAll()
                }
                appendedArticles.append(contentsOf: articles)
                allArticles.accept(appendedArticles)
            })
            .disposed(by: bag)

        let sectionItems = allArticles.map { articles -> [SectionItem] in
            return articles.map {
                SectionItem.article(viewModel: ArticleCellViewModel(article: $0))
            }
        }

        let tableData = sectionItems
            .map { [SectionModel(items: $0)] }
            .asDriver(onErrorJustReturn: [])

        return Output(tableData: tableData,
                      fetching: activityTracker.asDriver(),
                      error: errorTracker.asDriver())
    }
}

extension ArticleListViewModel {
    struct SectionModel {
        var items: [SectionItem]
    }

    enum SectionItem {
        case article(viewModel: ArticleCellViewModel)
    }
}

extension ArticleListViewModel.SectionModel: SectionModelType {
    typealias Item = ArticleListViewModel.SectionItem

    init(original: ArticleListViewModel.SectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
