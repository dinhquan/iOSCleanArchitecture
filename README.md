# iOSCleanArchitecture
iOS Clean Architecture with UIKit, MVVM, RxSwift

## High level overview

![alt text](https://github.com/dinhquan/iOSCleanArchitecture/blob/main/Images/HighLevel.png)

The whole design architecture is separated into 4 rings:
- **Entities**: Enterprise business rules
- **UseCases**: Application business rules
- **Data**: Network & Data persistent
- **Application**: UI & Devices

The most important rule is that the inner ring knows nothing about outer ring. Which means the variables, functions and classes (any entities) that exist in the outer layers can not be mentioned in the more inward levels.

## Detail overview

![alt text](https://github.com/dinhquan/iOSCleanArchitecture/blob/main/Images/DetailLevel.png)

### Domain
**Entities** are implemented as Swift struct
```swift
struct Article: Decodable {
    @Default.Empty var author: String
    @Default.Empty var title: String
    @Default.Empty var description: String
    @Default.Empty var url: String
    @Default.Empty var urlToImage: String
    @Default.Empty var publishedAt: String
    @Default.Empty var content: String
}
```

**UseCases** are protocols
```swift
protocol ArticleUseCase {
    func findArticlesByKeyword(_ keyword: String, pageSize: Int, page: Int) -> Single<[Article]>
}

```

Domain layer doesn't depend on UIKit or any 3rd party framework.

### Data
**Repositories** are concrete implementation of UseCases
```swift
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
```

### Application
Application is implemented with the MVVM pattern. The **ViewModel** performs pure transformation of a user Input to the Output
```swift
protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
```
```swift
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

    func transform(input: Input) -> Output {
        .....
        Observable.merge(search, loadMore)
            .flatMapLatest { keyword in
                return articleUseCase
                    .findArticlesByKeyword(keyword, pageSize: pageSize, page: currentPage.value)
                    .trackActivity(activityTracker)
                    .trackError(errorTracker)
                    .asDriver(onErrorJustReturn: [])
            }
            .subscribe(onNext: { articles in
        .....
    }
}
```
As you can see, `articleUseCase` is injected to ViewModel by `@Injected` annotation. Thanks to [Resolver](https://github.com/hmlongco/Resolver) library to make dependency injection easier.

The **ViewModel** is injected to **ViewController** via **Navigator**
```swift
struct ArticleNavigator {
    let navigationController: UINavigationController

    func showArticles() {
        let articleListViewController = Storyboard.load(.article, type: ArticleListViewController.self)
        articleListViewController.viewModel = ArticleListViewModel()
        articleListViewController.navigator = self
        navigationController.pushViewController(articleListViewController, animated: false)
    }
    .....
```
```swift
final class ArticleListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    private let bag = DisposeBag()

    var viewModel: ArticleListViewModel!
    var navigator: ArticleNavigator!
    .....
```

