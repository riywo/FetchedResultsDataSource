//
//  FetchedResultsDataSource.swift
//  NFLPlayerViewer
//
//  Created by Ryosuke Iwanaga on 2018-09-02.
//  Copyright © 2018 Ryosuke Iwanaga. All rights reserved.
//

import UIKit
import CoreData

public protocol FetchedResultsDataSourceDelegate {
    associatedtype View: FetchedResultsView
    associatedtype ViewCell: FetchedResultsViewCell
    
    associatedtype Entity: NSManagedObject
    associatedtype CustomCell: FetchedResultsViewCell
    
    static var cellIdentifier: String { get }
    func configureCell(view: View, cell: CustomCell, object: Entity) -> ViewCell
}

public class UIFetchedResultsDataSource<Delegate: FetchedResultsDataSourceDelegate>: NSObject, FetchedResultsViewDataSource {

    var fetchedResultsController: NSFetchedResultsController<Delegate.Entity>
    var delegate: Delegate?
    var fetchedResultsView: Delegate.View?
    
    public static func setup(
        fetchedResultsView: Delegate.View,
        delegate: Delegate,
        fetchRequest: NSFetchRequest<Delegate.Entity>,
        context: NSManagedObjectContext,
        sectionNameKeyPath: String? = nil) -> UIFetchedResultsDataSource
    {
        let dataSource = UIFetchedResultsDataSource(fetchRequest: fetchRequest, context: context)
        dataSource.delegate = delegate
        dataSource.performFetchAndReload(view: fetchedResultsView)
        return dataSource
    }
    
    init(fetchRequest: NSFetchRequest<Delegate.Entity>, context: NSManagedObjectContext, sectionNameKeyPath: String? = nil) {
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: nil
        )
        super.init()
    }
    
    public func performFetchAndReload(view: Delegate.View) {
        fetchedResultsView = view
        fetchedResultsView?.fetchedResultsDataSource = self
        try! fetchedResultsController.performFetch()
        DispatchQueue.main.async { view.reloadData() }
    }
    
    // MARK: Generic DataSource functions
    
    private func numberOfSections() -> Int {
        return fetchedResultsController.sections!.count
    }
    
    private func numberOfRows(in section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    private func titleForHeader(in section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
        return sectionInfo.name
    }
    
    private func section(forSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchedResultsController.section(forSectionIndexTitle: title, at: index)
    }
    
    private func cell(_ view: Delegate.View, ForRowAt indexPath: IndexPath) -> Delegate.ViewCell {
        guard let delegate = delegate else { return Delegate.CustomCell() as! Delegate.ViewCell }
        let cell = view.dequeueReusableViewCell(withIdentifier: Delegate.cellIdentifier, for: indexPath)
        guard let customCell = cell as? Delegate.CustomCell else { return cell as! Delegate.ViewCell }
        let object = fetchedResultsController.object(at: indexPath)
        return delegate.configureCell(view: view, cell: customCell, object: object)
    }
    
    // MARK: UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(in: section)
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeader(in: section)
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return section(forSectionIndexTitle: title, at: index)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(tableView as! Delegate.View, ForRowAt: indexPath) as! UITableViewCell
    }
    
    // MARK: UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfRows(in: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeader(in: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return section(forSectionIndexTitle: title, at: index)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cell(collectionView as! Delegate.View, ForRowAt: indexPath) as! UICollectionViewCell
    }
}

