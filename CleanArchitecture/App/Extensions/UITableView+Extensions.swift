//
//  UITableView+Extensions.swift
//  BaseApp
//
//  Created by Dinh Quan on 10/28/2020.
//

import UIKit

extension UITableView {
    func dequeue<Cell>(type: Cell.Type, for indexPath: IndexPath) -> Cell where Cell: ReuseID, Cell: UITableViewCell {
        let id = Cell.reuseId
        guard let cell = dequeueReusableCell(withIdentifier: id, for: indexPath) as? Cell else {
            fatalError("Dequeue failed for: \(id), at indexPath: \(indexPath.description)")
        }
        return cell
    }

    func dequeue<Cell>(type: Cell.Type) -> Cell where Cell: ReuseID, Cell: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.reuseId) as? Cell else {
            fatalError("Dequeue failed for: \(Cell.reuseId)")
        }
        return cell
    }

    func dequeue<Cell>(type: Cell.Type) -> Cell where Cell: ReuseID, Cell: UITableViewHeaderFooterView {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: Cell.reuseId) as? Cell else {
            fatalError("HeaderFooter dequeue failed for: \(Cell.reuseId)")
        }
        return cell
    }
}

extension UITableView {
    func createCell<Cell, ViewModel>(_ type: Cell.Type, _ viewModel: ViewModel, _ indexPath: IndexPath) -> Cell
        where Cell: UITableViewCell, Cell: CellViewModelProtocol, Cell.ViewModel == ViewModel {
        let cell = dequeue(type: Cell.self, for: indexPath)
        cell.config(with: viewModel)
        return cell
    }

    func register<Cell>(type: Cell.Type, identifier: String? = nil, nibName: String? = nil, bundle: Bundle = .main) {
        let cellName = String(describing: type)
        let cellIdentifier = identifier ?? cellName
        let cellNibName = nibName ?? cellName
        register(UINib(nibName: cellNibName, bundle: bundle), forCellReuseIdentifier: cellIdentifier)
    }
}
