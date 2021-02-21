//
//  ArticleCell.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/4/21.
//

import UIKit
import Kingfisher

final class ArticleCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
}

extension ArticleCell: CellViewModelProtocol {
    func config(with vm: ArticleCellViewModel) {
        let article = vm.article
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        timeLabel.text = article.formattedPublishAt
        if let url = URL(string: article.urlToImage ?? "") {
            thumbnailImageView.kf.setImage(with: url)
        }
    }
}

struct ArticleCellViewModel {
    let article: Article
}
