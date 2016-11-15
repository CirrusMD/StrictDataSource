//
//  StrictCollectionViewDataSourceTest.swift
//  CirrusMD
//
//  Created by David Nix on 8/25/16.
//  Copyright © 2016 CirrusMD. All rights reserved.
//


import XCTest
import CirrusMD


class StrictCollectionViewDataSourceTest: CMDTestCase {
    
    fileprivate typealias Item = (Int, StrictCollectionCellPresenterType)
    
    fileprivate let dataSource = StrictCollectionViewDataSource<Int>()
    fileprivate let collectionView = TestCollectionView()
    
    override func setUp() {
        super.setUp()
        
        collectionView.dataSource = dataSource
    }
    
    func test_numberOfSections() {
        (1...10).forEach { section in
            for i in (0..<section) {
                let item = Item(i, testPresenter("section \(i)"))
                dataSource.setItems([item], forSection: i)
            }
            
            XCTAssertEqual(dataSource.numberOfSections(in: collectionView), section)
        }
    }
    
    func test_numberOfItemsInSection() {
        let count = dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
        
        XCTAssertEqual(count, 0)
        
        let tests: [(models: [Int], presenters: [StrictCollectionCellPresenterType], section: Int, expected: Int)] = [
            ([1, 2], testPresenters(["b", "c"]), 0, 2),
            ([1, 2, 3], testPresenters(["a", "b", "c"]), 1, 3),
            ([1, 2, 3, 4], testPresenters(["b", "c", "alhpa", "sigma"]), 3, 4),
        ]
        
        for test in tests {
            let items = testItems(test.models, presenters: test.presenters)
            dataSource.setItems(items, forSection: test.section)
            let count = dataSource.collectionView(collectionView, numberOfItemsInSection: test.section)
            
            XCTAssertEqual(count, test.expected)
        }
    }
    
    func test_numberOfItemsInSection_multiplePopulatedSections() {
        let presenters1 = testPresenters(["1", "2"])
        let presenters2 = testPresenters(["3", "4", "5"])
        
        let items1 = testItems([0, 1], presenters: presenters1)
        let items2 = testItems([2, 3, 4], presenters: presenters2)
        
        dataSource.setItems(items1, forSection: 0)
        dataSource.setItems(items2, forSection: 2)
        
        var count = dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
        
        XCTAssertEqual(count, 2)
        
        count = dataSource.collectionView(collectionView, numberOfItemsInSection: 1)
        
        XCTAssertEqual(count, 0)
        
        count = dataSource.collectionView(collectionView, numberOfItemsInSection: 2)
        
        XCTAssertEqual(count, 3)
    }
    
    func test_cellForItemAtIndexPath() {
        collectionView.register(TestPresentableCollectionCell.self, forCellWithReuseIdentifier: TestPresentableCollectionCell.reuseID)
        
        let tests: [(models: [Int], presenters: [StrictCollectionCellPresenterType], section: Int, row: Int, expected: String)] = [
            ([7, 8, 9],     testPresenters(["1", "2", "3"]),        0, 0, "1"),
            ([1, 2, 3],     testPresenters(["1", "2", "3"]),        0, 1, "2"),
            ([0, 2],        testPresenters(["a", "b"]),             1, 1, "b"),
            ([9, 7, 5, 4],  testPresenters(["a", "b", "c", "d"]),   2, 2, "c"),
        ]
        
        for test in tests {
            let items = testItems(test.models, presenters: test.presenters)
            dataSource.setItems(items, forSection: test.section)
            collectionView.reloadData()
            
            let cell = dataSource.collectionView(
                collectionView,
                cellForItemAt: IndexPath(item: test.row, section: test.section)
            ) as? TestPresentableCollectionCell
            
            XCTAssertEqual(cell?.label.text, test.expected)
        }
    }
    
    func test_viewForSupplementaryElementOfKind() {
        let presenter = TestSupplementaryPresenter()
        collectionView.register(TestPresentableCollectionCell.self, forCellWithReuseIdentifier: TestPresentableCollectionCell.reuseID)
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: presenter.kind,
            withReuseIdentifier: presenter.reuseIdentifier)
        dataSource.setItems([(1, testPresenter("one"))], forSection: 0)
        dataSource.setSupplementaryPresenters([presenter])
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        
        // without this step, the collection view thinks there are 0 sections...
        _ = dataSource.collectionView(
                collectionView,
                cellForItemAt: IndexPath(item: 0, section: 0))
        
        _ = dataSource.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: presenter.kind,
            at: IndexPath(item: 0, section: 0))
        
        XCTAssertNotNil(presenter.lastView)
        XCTAssertEqual(presenter.lastCollectionView, collectionView)
    }
    
    //MARK: Private
    fileprivate func testPresenter(_ value: String) -> StrictCollectionCellPresenterType {
        return StrictCollectionCellPresenter<TestPresentableCollectionCell>(value)
    }
    
    fileprivate func testPresenters(_ values: [String]) -> [StrictCollectionCellPresenterType]  {
        return values.map {
            return testPresenter($0)
        }
    }
    
    fileprivate func testItems(_ models: [Int], presenters: [StrictCollectionCellPresenterType]) -> [Item] {
        assert(models.count == presenters.count, "count mismatch")
        return zip(models, presenters).map {
            return ($0, $1)
        }
    }
}
