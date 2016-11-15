//
//  StrictTableCellPresenter.swift
//  CirrusMD
//
//  Created by David Nix on 1/11/16.
//  Copyright © 2016 CirrusMD. All rights reserved.
//

import Foundation


public protocol StrictPresentableTableCell {
    associatedtype ViewData

    static var reuseID: String { get }
    func updateWithViewData(_ viewData: ViewData, tableView: UITableView)
}


public protocol StrictTableCellPresenterType {
    var reuseID: String { get }
    func configureCell(_ cell: UITableViewCell, tableView: UITableView) -> UITableViewCell
}


public struct StrictTableCellPresenter<Cell>: StrictTableCellPresenterType where Cell: StrictPresentableTableCell, Cell: UITableViewCell {

    public let reuseID = Cell.reuseID
    public let viewData: Cell.ViewData

    public init(_ viewData: Cell.ViewData) {
        self.viewData = viewData
    }

    public func configureCell(_ cell: UITableViewCell, tableView: UITableView) -> UITableViewCell {
        if let c = cell as? Cell {
            c.updateWithViewData(viewData, tableView: tableView)
        }
        return cell
    }
}
