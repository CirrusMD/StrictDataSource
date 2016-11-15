//
//  StrictDataSource.swift
//  CirrusMD
//
//  Created by David Nix on 8/25/16.
//  Copyright © 2016 CirrusMD. All rights reserved.
//

// Don't use directly. Internal object used by TableDataSource and CollectionDataSource

public struct StrictDataSource<Model: Equatable, Presenter> {
    public typealias Item = (Model, Presenter)
    public typealias Items = [Item]

    public fileprivate(set) var items: [Items] = []

    public init() {}

    @discardableResult public mutating func setItems(_ newItems: Items, forSection section: Int) -> Diff<Model> {
        for i in 0...section {
            if items[safe: i] == nil {
                items.append([])
            }
        }
        
        defer { items[section] = newItems }

        let oldModels = items[safe: section]?.map({ $0.0 }) ?? []
        let newModels = newItems.map({ $0.0 })
        
        return oldModels.diff(newModels)
    }
    
    public func itemForIndexPath(_ indexPath: IndexPath) -> Item? {
        return items[safe: (indexPath as NSIndexPath).section]?[safe: (indexPath as NSIndexPath).row]
    }
    
    public func modelForIndexPath(_ indexPath: IndexPath) -> Model? {
       return itemForIndexPath(indexPath)?.0
    }
    
    public func itemsForSection(_ section: Int) -> Items? {
        return items[safe: section]
    }
    
    public func modelsForSection(_ section: Int) -> [Model?]? {
        guard let items = itemsForSection(section) else {
            return nil
        }
        
        return items.map { return $0.0 }
    }
}
