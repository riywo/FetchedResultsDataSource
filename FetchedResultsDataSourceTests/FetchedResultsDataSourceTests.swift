//
//  FetchedResultsDataSourceTests.swift
//  FetchedResultsDataSourceTests
//
//  Created by Ryosuke Iwanaga on 2018-09-03.
//  Copyright © 2018 Ryosuke Iwanaga. All rights reserved.
//

import XCTest
import UIKit
import CoreData
@testable import FetchedResultsDataSource


class Dummy: FetchedResultsDataSourceDelegate {
    static var cellIdentifier = "Cell"
    
    func configureCell(view: UITableView, cell: UITableViewCell, object: NSManagedObject) -> UITableViewCell {
        return cell
    }
}

class Foo: UIFetchedResultsDataSource<Dummy> {
    
}


class FetchedResultsDataSourceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
