//
//  ViewState+Rx.swift
//  EcommerceBase
//
//  Created by Dinh Quan on 1/28/21.
//

import UIKit
import RxSwift
import RxCocoa

/// ViewController view states.
enum ViewControllerViewState: Equatable {
    case viewWillAppear
    case viewDidAppear
    case viewWillDisappear
    case viewDidDisappear
    case viewDidLoad
    case viewDidLayoutSubviews
    case willMove
    case didMove
}

/// UIViewController view state changes.
/// Emits a Bool value indicating whether the change was animated or not.
extension RxSwift.Reactive where Base: UIViewController {
    var viewDidLoad: Observable<Void> {
        methodInvoked(#selector(UIViewController.viewDidLoad))
            .map { _ in }
    }

    var viewDidLayoutSubviews: Observable<Void> {
        methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .map { _ in }
    }

    var viewWillAppear: Observable<Bool> {
        methodInvoked(#selector(UIViewController.viewWillAppear))
            .map { $0.first as? Bool ?? false }
    }

    var viewDidAppear: Observable<Bool> {
        methodInvoked(#selector(UIViewController.viewDidAppear))
            .map { $0.first as? Bool ?? false }
    }

    var viewWillDisappear: Observable<Bool> {
        methodInvoked(#selector(UIViewController.viewWillDisappear))
            .map { $0.first as? Bool ?? false }
    }

    var viewDidDisappear: Observable<Bool> {
        methodInvoked(#selector(UIViewController.viewDidDisappear))
            .map { $0.first as? Bool ?? false }
    }

    var willMove: Observable<UIViewController?> {
        methodInvoked(#selector(UIViewController.willMove(toParent:)))
            .map { $0.first as? UIViewController? ?? nil }
    }

    var didMove: Observable<UIViewController?> {
        methodInvoked(#selector(UIViewController.didMove(toParent:)))
            .map { $0.first as? UIViewController? ?? nil }
    }

    /// Observable sequence of the view controller's view state.
    /// This gives you an observable sequence of all possible states.
    /// - returns: Observable sequence of AppStates.
    var viewState: Observable<ViewControllerViewState> {
        Observable.of(
            viewDidLoad.map { _ in ViewControllerViewState.viewDidLoad },
            viewDidLayoutSubviews.map { _ in ViewControllerViewState.viewDidLayoutSubviews },
            viewWillAppear.map { _ in ViewControllerViewState.viewWillAppear },
            viewDidAppear.map { _ in ViewControllerViewState.viewDidAppear },
            viewWillDisappear.map { _ in ViewControllerViewState.viewWillDisappear },
            viewDidDisappear.map { _ in ViewControllerViewState.viewDidDisappear }
        )
        .merge()
    }
}

