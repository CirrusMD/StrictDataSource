//
//  CirrusMD
//
//  Created by David Nix on 11/5/15.
//  Copyright © 2015 CirrusMD. All rights reserved.
//


open class StrictTableViewDataSource<Model: Equatable>: NSObject, UITableViewDataSource {
    
    public typealias Item = StrictDataSource<Model, StrictTableCellPresenterType>.Item
    public typealias Items = [Item]
    
    public override init() {
        super.init()
    }

    fileprivate var dataSource = StrictDataSource<Model, StrictTableCellPresenterType>()

    @discardableResult open func setItems(_ newItems: Items, forSection section: Int) -> Diff<Model> {
        return dataSource.setItems(newItems, forSection: section)
    }
    
    open func modelForIndexPath(_ indexPath: IndexPath) -> Model? {
        return dataSource.modelForIndexPath(indexPath)
    }
    
    open func modelsForSection(_ section: Int) -> [Model?]? {
        return dataSource.modelsForSection(section)
    }

    //MARK: UITableViewDataSource
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.items.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.itemsForSection(section)?.count ?? 0
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter = dataSource.itemForIndexPath(indexPath)?.1,
              let cell = tableView.dequeueReusableCell(withIdentifier: presenter.reuseID) else {
              return UITableViewCell()
        }
        
        return presenter.configureCell(cell, tableView: tableView)
    }
}
