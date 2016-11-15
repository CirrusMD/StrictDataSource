//
//  StrictCollectionViewDataSource.swift
//  CirrusMD
//
//  Created by David Nix on 8/25/16.
//  Copyright © 2016 CirrusMD. All rights reserved.
//


open class StrictCollectionViewDataSource<Model: Equatable>: NSObject, UICollectionViewDataSource {
    
    public typealias Item = StrictDataSource<Model, StrictCollectionCellPresenterType>.Item
    public typealias Items = [Item]
    
    fileprivate var supplementaryPresenters = [StrictSupplementaryPresenter]()
    
    public override init() {
        super.init()
    }

    fileprivate var dataSource = StrictDataSource<Model, StrictCollectionCellPresenterType>()

    @discardableResult open func setItems(_ newItems: Items, forSection section: Int) -> Diff<Model> {
        return dataSource.setItems(newItems, forSection: section)
    }
    
    open func modelForIndexPath(_ indexPath: IndexPath) -> Model? {
        return dataSource.modelForIndexPath(indexPath)
    }
    
    open func modelsForSection(_ section: Int) -> [Model?]? {
        return dataSource.modelsForSection(section)
    }
    
    open func setSupplementaryPresenters(_ presenters: [StrictSupplementaryPresenter]) {
        self.supplementaryPresenters = presenters
    }
    
    //MARK: UICollectionViewDataSource
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.items.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.itemsForSection(section)?.count ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        precondition(collectionView.dataSource != nil, "CollectionView must have a dataSource.")
        guard let presenter = dataSource.itemForIndexPath(indexPath)?.1 else {
            assertionFailure("could not find presenter")
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: presenter.reuseID, for: indexPath)
        return presenter.configureCell(cell, collectionView: collectionView)
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let index = supplementaryPresenters.index(where: { $0.indexPath as IndexPath == indexPath && $0.kind == kind }) else {
            preconditionFailure("Could not find supplementary presenter")
        }
        let presenter = supplementaryPresenters[index]
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: presenter.reuseIdentifier, for: indexPath)
        return presenter.configure(view, collectionView: collectionView)
    }
}
