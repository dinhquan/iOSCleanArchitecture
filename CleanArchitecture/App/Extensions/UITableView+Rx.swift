//
//  UITableView+Rx.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/4/21.
//

import UIKit
import RxSwift
import RxCocoa

extension RxSwift.Reactive where Base: UITableView {
    var onReachedEnd: Observable<Void> {
        return base.rx
            .didScroll
            .throttle(.milliseconds(400), scheduler: MainScheduler.instance)
            .map { [weak base] in
                guard let base = base else { return false }
                if base.contentOffset.y + base.frame.size.height - 20 >= base.contentSize.height {
                    return true
                }
                return false
            }
            .filter { $0 }
            .map { _ in }
    }
}
