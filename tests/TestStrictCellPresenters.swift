//
//  CirrusMD
//
//  Created by David Nix on 1/11/16.
//  Copyright © 2016 CirrusMD. All rights reserved.
//

import Foundation
import CirrusMD
import UIKit


class TestPresentableTableCell: UITableViewCell, StrictPresentableTableCell {
    typealias ViewData = String
    
    var tableView: UITableView?
    
    static var reuseID: String {
        return "TestTablePresentableCell"
    }
    
    func updateWithViewData(_ viewData: ViewData, tableView: UITableView) {
        self.tableView = tableView
        textLabel?.text = viewData
    }
}

struct StubbedTableCellPresenter: StrictTableCellPresenterType {
    
    var reuseID: String {
        return "I'm just a stub"
    }
    
    func configureCell(_ cell: UITableViewCell, tableView: UITableView) -> UITableViewCell {
        return cell
    }
}

class TestPresentableCollectionCell: UICollectionViewCell, StrictPresentableCollectionCell {
    typealias ViewData = String
    
    let label = UILabel()
    
    var collectionView: UICollectionView?
    
    static var reuseID: String {
        return "TestCollectionPresentableCell"
    }
    
    func updateWithViewData(_ viewData: ViewData, collectionView: UICollectionView) {
        self.collectionView = collectionView
        label.text = viewData
    }
}

class TestSupplementaryPresenter: StrictSupplementaryPresenter {
    var reuseIdentifier: String = "TestSupplementaryPresentable"

    
    let kind = UICollectionElementKindSectionHeader
    let indexPath = IndexPath(row: 0, section: 0)
    
    var lastView: UIView?
    var lastCollectionView: UICollectionView?
    func configure(_ view: UICollectionReusableView, collectionView: UICollectionView) -> UICollectionReusableView {
        lastView = view
        lastCollectionView = collectionView
        return view
    }
}
