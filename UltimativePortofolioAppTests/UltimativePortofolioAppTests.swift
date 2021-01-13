//
//  UltimativePortofolioAppTests.swift
//  UltimativePortofolioAppTests
//
//  Created by Alexander Römer on 13.01.21.
//

import CoreData
import XCTest
@testable import UltimativePortofolioApp

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
