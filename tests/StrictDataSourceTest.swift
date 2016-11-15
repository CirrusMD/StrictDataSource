//
//  StrictDataSourceTest.swift
//  CirrusMD
//
//  Created by David Nix on 8/25/16.
//  Copyright © 2016 CirrusMD. All rights reserved.
//


import XCTest
import CirrusMD


class StrictDataSourceTest: CMDTestCase {
    
    fileprivate typealias Item = (Int, String)
    
    fileprivate var dataSource = StrictDataSource<Int, String>()
    fileprivate let tableView = UITableView(frame: CGRect.zero)
    
    func test_itemForIndexPath() {
        let item: Item = (1, "one")
        dataSource.setItems([item], forSection: 1)
        
        XCTAssertNotNil(dataSource.itemForIndexPath(IndexPath(row: 0, section: 1)))
        
        XCTAssertNil(dataSource.itemForIndexPath(IndexPath(row: 0, section: 0)))
        XCTAssertNil(dataSource.itemForIndexPath(IndexPath(row: 0, section: 2)))
        XCTAssertNil(dataSource.itemForIndexPath(IndexPath(row: 10, section: 1)))
    }
    
    func test_itemsForSection() {
        let items: [Item] = [
            (1, "one"),
            (2, "two"),
            (3, "three"),
        ]
        dataSource.setItems(items, forSection: 2)
        
        XCTAssertEqual(dataSource.itemsForSection(0)?.count, 0)
        XCTAssertEqual(dataSource.itemsForSection(1)?.count, 0)
        XCTAssertEqual(dataSource.itemsForSection(2)?.count, 3)
        
        XCTAssertNil(dataSource.itemsForSection(3))
    }
    
    func test_modelForIndexPath() {
        let items: [Item] = [
            (1, "1"),
            (2, "2"),
            (3, "3"),
        ]
        
        dataSource.setItems(items, forSection: 1)
        
        let tests: [(Int, Int, Int?)] = [
            (1, 1, 2),
            (2, 1, 3),
            (1, 5, nil),
            (0, 0, nil),
        ]
        
        for (index, (row, section, expected)) in tests.enumerated() {
            let model = self.dataSource.modelForIndexPath(IndexPath(row: row, section: section))
            
            if model != expected {
                XCTFail("example# \(index+1) expected \(expected), got \(model)")
            }
        }
    }
    
    func test_modelsForSection() {
        
        let firstItems: [Item] = [
            (1, "1"),
            (2, "2"),
            (3, "3"),
        ]
        
        let secondItems: [Item] = [
            (4, "4"),
            (5, "5"),
        ]
        
        dataSource.setItems(firstItems, forSection: 0)
        dataSource.setItems(secondItems, forSection: 1)
        
        XCTAssertEqual(dataSource.modelsForSection(0)?.count, 3)
        XCTAssertEqual(dataSource.modelsForSection(1)?.count, 2)
        XCTAssertNil(dataSource.modelsForSection(2))
        
        guard let firstModels = dataSource.modelsForSection(0)?.flatMap(({ return $0 })) else {
            XCTFail("expected array of models")
            return
        }
        
        XCTAssertEqual(firstModels, [1, 2, 3])
        
        guard let secondModels = dataSource.modelsForSection(1)?.flatMap({ return $0 }) else {
            XCTFail("expected array of models")
            return
        }
        
        XCTAssertEqual(secondModels, [4, 5])
    }
    
}
