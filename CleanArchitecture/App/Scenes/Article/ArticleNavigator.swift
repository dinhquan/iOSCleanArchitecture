//
//  NewsNavigator.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/4/21.
//

import UIKit

struct ArticleNavigator {
    let navigationController: UINavigationController

    func showArticles() {
        let articleListViewController = Storyboard.load(.article, type: ArticleListViewController.self)
        articleListViewController.viewModel = ArticleListViewModel()
        articleListViewController.navigator = self
        navigationController.pushViewController(articleListViewController, animated: false)
    }

    func showArticleDetail(article: Article) {
        let articleDetailViewController = Storyboard.load(.article, type: ArticleDetailViewController.self)
        articleDetailViewController.viewModel = ArticleDetailViewModel(article: article)
        navigationController.pushViewController(articleDetailViewController, animated: true)
    }
}
