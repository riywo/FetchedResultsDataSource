//
//  FetchedResultsView.swift
//  FetchedResultsDataSource
//
//  Created by Ryosuke Iwanaga on 2018-09-03.
//  Copyright © 2018 Ryosuke Iwanaga. All rights reserved.
//

import Foundation

protocol FetchedResultsViewDataSource: UITableViewDataSource, UICollectionViewDataSource {}

protocol FetchedResultsViewCell {
    init()
}
extension UITableViewCell: FetchedResultsViewCell {}
extension UICollectionViewCell: FetchedResultsViewCell {}

protocol FetchedResultsView {
    var fetchedResultsDataSource: FetchedResultsViewDataSource? { set get }
    func dequeueReusableViewCell(withIdentifier identifier: String, for indexpath: IndexPath) -> FetchedResultsViewCell
    func reloadData()
}

extension UITableView: FetchedResultsView {
    func dequeueReusableViewCell(withIdentifier identifier: String, for indexpath: IndexPath) -> FetchedResultsViewCell {
        return dequeueReusableCell(withIdentifier: identifier, for: indexpath) as FetchedResultsViewCell
    }
    
    var fetchedResultsDataSource: FetchedResultsViewDataSource? {
        get { return (dataSource as! FetchedResultsViewDataSource) }
        set { dataSource = (newValue! as UITableViewDataSource) }
    }
}

extension UICollectionView: FetchedResultsView {
    func dequeueReusableViewCell(withIdentifier identifier: String, for indexpath: IndexPath) -> FetchedResultsViewCell {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexpath) as FetchedResultsViewCell
    }
    
    var fetchedResultsDataSource: FetchedResultsViewDataSource? {
        get { return (dataSource as! FetchedResultsViewDataSource) }
        set { dataSource = (newValue! as UICollectionViewDataSource) }
    }
}
