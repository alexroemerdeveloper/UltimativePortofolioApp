//
//  ProjectTests.swift
//  UltimativePortofolioAppTests
//
//  Created by Alexander Römer on 21.01.21.
//

import XCTest
import CoreData
@testable import UltimativePortofolioApp

class ProjectTests: BaseTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCreatingProjectsAndItems() {
        let targetCount = 10

        for _ in 0..<targetCount {
            let project = Project(context: managedObjectContext)

            for _ in 0..<targetCount {
                let item = Item(context: managedObjectContext)
                item.project = project
            }
        }

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), targetCount)
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), targetCount * targetCount)
    }
    
    func testDeletingProjectCascadeDeletesItems() throws {
        try dataController.createSampleData()
        
        let request = NSFetchRequest<Project>(entityName: "Project")
        let projects = try managedObjectContext.fetch(request)
        
        dataController.delete(projects[0])
        
        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 4)
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 40)
    }

}
