//
//  CirrusMD
//
//  Created by David Nix on 11/5/15.
//  Copyright © 2015 CirrusMD. All rights reserved.
//

import XCTest
import CirrusMD


class StrictTableViewDataSourceTest: CMDTestCase {
    
    fileprivate typealias Item = (Int, StrictTableCellPresenterType)
    
    fileprivate let dataSource = StrictTableViewDataSource<Int>()
    fileprivate let tableView = UITableView(frame: CGRect.zero)
    
    func test_numberOfSections() {
        (1...10).forEach { section in
            for i in (0..<section) {
                let item = Item(i, testPresenter("section \(i)"))
                dataSource.setItems([item], forSection: i)
            }
            
            XCTAssertEqual(dataSource.numberOfSections(in: tableView), section)
        }
    }
    
    func test_numberOfRowsInSection() {
        let count = dataSource.tableView(tableView, numberOfRowsInSection: 0)
        
        XCTAssertEqual(count, 0)
        
        let tests: [(models: [Int], presenters: [StrictTableCellPresenterType], section: Int, expected: Int)] = [
            ([1, 2], testPresenters(["b", "c"]), 0, 2),
            ([1, 2, 3], testPresenters(["a", "b", "c"]), 1, 3),
            ([1, 2, 3, 4], testPresenters(["b", "c", "alhpa", "sigma"]), 3, 4),
        ]
        
        for test in tests {
            let items = testItems(test.models, presenters: test.presenters)
            dataSource.setItems(items, forSection: test.section)
            let count = dataSource.tableView(tableView, numberOfRowsInSection: test.section)
            
            XCTAssertEqual(count, test.expected)
        }
    }
    
    func test_numberOfRowsInSection_multiplePopulatedSections() {
        let presenters1 = testPresenters(["1", "2"])
        let presenters2 = testPresenters(["3", "4", "5"])
        
        let items1 = testItems([0, 1], presenters: presenters1)
        let items2 = testItems([2, 3, 4], presenters: presenters2)
        
        dataSource.setItems(items1, forSection: 0)
        dataSource.setItems(items2, forSection: 2)
        
        var count = dataSource.tableView(tableView, numberOfRowsInSection: 0)
        
        XCTAssertEqual(count, 2)
        
        count = dataSource.tableView(tableView, numberOfRowsInSection: 1)
        
        XCTAssertEqual(count, 0)
        
        count = dataSource.tableView(tableView, numberOfRowsInSection: 2)
        
        XCTAssertEqual(count, 3)
    }
    
    func test_cellForRowAtIndexPath() {
        tableView.register(TestPresentableTableCell.self, forCellReuseIdentifier: TestPresentableTableCell.reuseID)
        
        let tests: [(models: [Int], presenters: [StrictTableCellPresenterType], section: Int, row: Int, expected: String)] = [
            ([7, 8, 9], testPresenters(["1", "2", "3"]), 0, 0, "1"),
            ([1, 2, 3], testPresenters(["1", "2", "3"]), 0, 1, "2"),
            ([0, 2], testPresenters(["a", "b"]), 2, 1, "b"),
            ([9, 7, 5, 4], testPresenters(["a", "b", "c", "d"]), 4, 2, "c"),
        ]
        
        for test in tests {
            let items = testItems(test.models, presenters: test.presenters)
            dataSource.setItems(items, forSection: test.section)
            
            let cell = dataSource.tableView(
                tableView,
                cellForRowAt: IndexPath(item: test.row, section: test.section)
            ) as? TestPresentableTableCell
            
            XCTAssertEqual(cell?.textLabel?.text, test.expected)
            XCTAssertEqual(cell?.tableView, tableView)
        }
    }
    
    //MARK: Private
    fileprivate func testPresenter(_ value: String) -> StrictTableCellPresenterType {
        return StrictTableCellPresenter<TestPresentableTableCell>(value)
    }
    
    fileprivate func testPresenters(_ values: [String]) -> [StrictTableCellPresenterType]  {
        return values.map {
            return testPresenter($0)
        }
    }
    
    fileprivate func testItems(_ models: [Int], presenters: [StrictTableCellPresenterType]) -> [Item] {
        assert(models.count == presenters.count, "count mismatch")
        return zip(models, presenters).map {
            return ($0, $1)
        }
    }
}
