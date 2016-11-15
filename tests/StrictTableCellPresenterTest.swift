//
//  StrictTableCellPresenterTest.swift
//  CirrusMD
//
//  Created by David Nix on 1/11/16.
//  Copyright © 2016 CirrusMD. All rights reserved.
//

import XCTest
import CirrusMD


class StrictTableCellPresenterTest: CMDTestCase {

    func test_updateCell() {
        let tableView = UITableView()
        let presenter = StrictTableCellPresenter<TestPresentableTableCell>("A simple test")
        let cell = presenter.configureCell(TestPresentableTableCell(), tableView: tableView)
        
        guard let configuredCell = cell as? TestPresentableTableCell else {
            XCTFail("expected \(TestPresentableTableCell.self), got \(cell)")
            return
        }
        
        XCTAssertEqual(configuredCell.textLabel?.text, "A simple test")
        XCTAssertEqual(configuredCell.tableView, tableView)
    }
}
