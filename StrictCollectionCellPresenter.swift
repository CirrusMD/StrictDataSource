//
//  StrictCollectionCellPresenter.swift
//  CirrusMD
//
//  Created by David Nix on 8/25/16.
//  Copyright © 2016 CirrusMD. All rights reserved.
//

import UIKit


public protocol StrictPresentableCollectionCell {
    associatedtype ViewData

    static var reuseID: String { get }
    func updateWithViewData(_ viewData: ViewData, collectionView: UICollectionView)
}


public protocol StrictCollectionCellPresenterType {
    var reuseID: String { get }
    func configureCell(_ cell: UICollectionViewCell, collectionView: UICollectionView) -> UICollectionViewCell
}


public struct StrictCollectionCellPresenter<Cell>: StrictCollectionCellPresenterType where Cell: StrictPresentableCollectionCell, Cell: UICollectionViewCell {

    public let reuseID = Cell.reuseID
    public let viewData: Cell.ViewData

    public init(_ viewData: Cell.ViewData) {
        self.viewData = viewData
    }

    public func configureCell(_ cell: UICollectionViewCell, collectionView: UICollectionView) -> UICollectionViewCell {
        if let c = cell as? Cell {
            c.updateWithViewData(viewData, collectionView: collectionView)
        }
        return cell
    }
}

public protocol StrictSupplementaryPresenter {
    var reuseIdentifier: String { get }
    var kind: String { get }
    var indexPath: IndexPath { get }
    func configure(_ view: UICollectionReusableView, collectionView: UICollectionView) -> UICollectionReusableView
}
