//
//  ArticleListViewController.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/4/21.
//

import UIKit
import RxSwift
import RxDataSources

final class ArticleListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noArticlesLabel: UILabel!
    @IBOutlet weak var loadMoreIndicator: UIActivityIndicatorView!

    private let bag = DisposeBag()

    var viewModel: ArticleListViewModel!
    var navigator: ArticleNavigator!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("News", comment: "")
        bind()
    }

    private func bind() {
        let dataSource = RxTableViewSectionedReloadDataSource<ArticleListViewModel.SectionModel>(configureCell: { ds, tv, ip, _ in
            switch ds[ip] {
            case let .article(viewModel):
                return tv.createCell(ArticleCell.self, viewModel, ip)
            }
        })

        let search = searchBar.rx
            .searchButtonClicked.map { [weak self] Void -> String in
                return self?.searchBar.text ?? ""
            }
            .do(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .filter { $0.count > 0 }
            .asObservable()

        let loadMore = tableView.rx
            .onReachedEnd
            .do(onNext: { [weak self] in
                self?.loadMoreIndicator.isHidden = false
                self?.loadMoreIndicator.startAnimating()
            })

        let input = ArticleListViewModel.Input(search: search,
                                               loadMore: loadMore)
        let output = viewModel.transform(input: input)

        output.tableData
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

        tableView.rx
            .modelSelected(ArticleListViewModel.SectionItem.self)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                switch item {
                case .article(let vm):
                    self.navigator.showArticleDetail(article: vm.article)
                }
            })
            .disposed(by: bag)

        tableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: bag)

        output.tableData
            .map { !($0.first?.items.isEmpty ?? false) }
            .drive(noArticlesLabel.rx.isHidden)
            .disposed(by: bag)

        output.fetching
            .drive(onNext: { [weak self] isFetching in
                if isFetching {
                    Loading.show()
                } else {
                    Loading.dismiss()
                    self?.loadMoreIndicator.isHidden = true
                    self?.loadMoreIndicator.stopAnimating()
                }
            })
            .disposed(by: bag)

        output.error
            .drive(onNext: { error in
                Toast.show(error.localizedDescription)
            })
            .disposed(by: bag)
    }
}
