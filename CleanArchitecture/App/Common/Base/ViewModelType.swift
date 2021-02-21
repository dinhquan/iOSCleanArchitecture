//
//  ViewModelType.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/5/21.
//

import Foundation

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

protocol ReuseID {
    static var reuseId: String { get }
}

extension ReuseID {
    static var reuseId: String {
        String(describing: Self.self)
    }
}

protocol CellViewModelProtocol: AnyObject, ReuseID {
    associatedtype ViewModel

    func config(with viewModel: ViewModel)
}
