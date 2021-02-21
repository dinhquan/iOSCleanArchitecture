//
//  ActivityTracker.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/5/21.
//

import Foundation
import RxSwift
import RxCocoa

public class ActivityTracker: SharedSequenceConvertibleType {
    public typealias Element = Bool
    public typealias SharingStrategy = DriverSharingStrategy

    private let _lock = NSRecursiveLock()
    private let _behavior = BehaviorRelay<Bool>(value: false)
    private let _loading: SharedSequence<SharingStrategy, Bool>

    public init() {
        _loading = _behavior.asDriver()
            .distinctUntilChanged()
    }

    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
        return source.asObservable()
            .do(onNext: { _ in
                self.sendStopLoading()
            }, onError: { _ in
                self.sendStopLoading()
            }, onCompleted: {
                self.sendStopLoading()
            }, onSubscribe: subscribed)
    }

    private func subscribed() {
        _lock.lock()
        _behavior.accept(true)
        _lock.unlock()
    }

    private func sendStopLoading() {
        _lock.lock()
        _behavior.accept(false)
        _lock.unlock()
    }

    public func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return _loading
    }
}

extension ObservableConvertibleType {
    public func trackActivity(_ activityTracker: ActivityTracker) -> Observable<Element> {
        return activityTracker.trackActivityOfObservable(self)
    }
}
