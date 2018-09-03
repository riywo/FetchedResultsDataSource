//
//  FetchedResultsView.swift
//  FetchedResultsDataSource
//
//  Created by Ryosuke Iwanaga on 2018-09-03.
//  Copyright © 2018 Ryosuke Iwanaga. All rights reserved.
//

import Foundation

public protocol FetchedResultsViewDataSource: UITableViewDataSource, UICollectionViewDataSource {}

public protocol FetchedResultsViewCell {
    init()
}
extension UITableViewCell: FetchedResultsViewCell {}
extension UICollectionViewCell: FetchedResultsViewCell {}

public protocol FetchedResultsView {
    var fetchedResultsDataSource: FetchedResultsViewDataSource? { set get }
    func dequeueReusableViewCell(withIdentifier identifier: String, for indexpath: IndexPath) -> FetchedResultsViewCell
    func reloadData()
}

extension UITableView: FetchedResultsView {
    public func dequeueReusableViewCell(withIdentifier identifier: String, for indexpath: IndexPath) -> FetchedResultsViewCell {
        return dequeueReusableCell(withIdentifier: identifier, for: indexpath) as FetchedResultsViewCell
    }
    
    public var fetchedResultsDataSource: FetchedResultsViewDataSource? {
        get { return (dataSource as! FetchedResultsViewDataSource) }
        set { dataSource = (newValue! as UITableViewDataSource) }
    }
}

extension UICollectionView: FetchedResultsView {
    public func dequeueReusableViewCell(withIdentifier identifier: String, for indexpath: IndexPath) -> FetchedResultsViewCell {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexpath) as FetchedResultsViewCell
    }
    
    public var fetchedResultsDataSource: FetchedResultsViewDataSource? {
        get { return (dataSource as! FetchedResultsViewDataSource) }
        set { dataSource = (newValue! as UICollectionViewDataSource) }
    }
}
