//
//  ArticleDetailViewController.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/4/21.
//

import UIKit

final class ArticleDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var viewModel: ArticleDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {
        let article = viewModel.article
        title = article.title
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        timeLabel.text = article.formattedPublishAt
        if let url = URL(string: article.urlToImage ?? "") {
            thumbnailImageView.kf.setImage(with: url)
        }
    }
}
