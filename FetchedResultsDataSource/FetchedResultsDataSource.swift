//
//  FetchedResultsDataSource.swift
//  NFLPlayerViewer
//
//  Created by Ryosuke Iwanaga on 2018-09-02.
//  Copyright © 2018 Ryosuke Iwanaga. All rights reserved.
//

import UIKit
import CoreData

protocol FetchedResultsDataSourceDelegate {
    associatedtype View: FetchedResultsView
    associatedtype ViewCell: FetchedResultsViewCell
    
    associatedtype Entity: NSManagedObject
    associatedtype CustomCell: FetchedResultsViewCell
    
    static var cellIdentifier: String { get }
    func configureCell(view: View, cell: CustomCell, object: Entity) -> ViewCell
}

class FetchedResultsDataSource<Delegate: FetchedResultsDataSourceDelegate>: NSObject, FetchedResultsViewDataSource {
    typealias View = Delegate.View
    typealias ViewCell = Delegate.ViewCell
    typealias Entity = Delegate.Entity
    typealias CustomCell = Delegate.CustomCell
    
    var fetchedResultsController: NSFetchedResultsController<Entity>
    var delegate: Delegate?
    var fetchedResultsView: View?
    
    static func setup(
        fetchedResultsView: View,
        delegate: Delegate,
        fetchRequest: NSFetchRequest<Entity>,
        context: NSManagedObjectContext,
        sectionNameKeyPath: String? = nil) -> FetchedResultsDataSource
    {
        let dataSource = FetchedResultsDataSource(fetchRequest: fetchRequest, context: context)
        dataSource.delegate = delegate
        dataSource.performFetchAndReload(view: fetchedResultsView)
        return dataSource
    }
    
    init(fetchRequest: NSFetchRequest<Entity>, context: NSManagedObjectContext, sectionNameKeyPath: String? = nil) {
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: nil
        )
        super.init()
    }
    
    func performFetchAndReload(view: View) {
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
    
    private func cell(_ view: View, ForRowAt indexPath: IndexPath) -> ViewCell {
        guard let delegate = delegate else { return CustomCell() as! ViewCell }
        let cell = view.dequeueReusableViewCell(withIdentifier: Delegate.cellIdentifier, for: indexPath)
        guard let customCell = cell as? CustomCell else { return cell as! ViewCell }
        let object = fetchedResultsController.object(at: indexPath)
        return delegate.configureCell(view: view, cell: customCell, object: object)
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeader(in: section)
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return section(forSectionIndexTitle: title, at: index)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(tableView as! View, ForRowAt: indexPath) as! UITableViewCell
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfRows(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeader(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return section(forSectionIndexTitle: title, at: index)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cell(collectionView as! View, ForRowAt: indexPath) as! UICollectionViewCell
    }
}

