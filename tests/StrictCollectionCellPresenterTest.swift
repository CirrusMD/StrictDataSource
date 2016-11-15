//
//  StrictCollectionCellPresenterTest.swift
//  CirrusMD
//
//  Created by David Nix on 8/25/16.
//  Copyright © 2016 CirrusMD. All rights reserved.
//


import XCTest
import CirrusMD


class CollectionCellPresenterTest: CMDTestCase {
    
    func test_updateCell() {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        let presenter = StrictCollectionCellPresenter<TestPresentableCollectionCell>("A simple test")
        let cell = presenter.configureCell(TestPresentableCollectionCell(), collectionView: collectionView)
        
        guard let configuredCell = cell as? TestPresentableCollectionCell else {
            XCTFail("expected \(TestPresentableCollectionCell.self), got \(cell)")
            return
        }
        
        XCTAssertEqual(configuredCell.label.text, "A simple test")
        XCTAssertEqual(configuredCell.collectionView, collectionView)
    }
}
