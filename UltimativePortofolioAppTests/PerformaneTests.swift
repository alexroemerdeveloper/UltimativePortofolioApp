//
//  PerformaneTests.swift
//  UltimativePortofolioAppTests
//
//  Created by Alexander Römer on 15.02.21.
//

import XCTest
@testable import UltimativePortofolioApp

class PerformaneTests: BaseTestCase {

    func testAwardCalculationPerformance() throws {
        try dataController.createSampleData()
        let awards = Award.allAwards

        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }
    
    func test2AwardCalculationPerformance() throws {
        // Create a significant amount of test data
        for _ in 1...100 {
            try dataController.createSampleData()
        }

        // Simulate lots of awards to check
        let awards = Array(repeating: Award.allAwards, count: 25).joined()

        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }
    
    func test3AwardCalculationPerformance() throws {
        for _ in 1...100 {
            try dataController.createSampleData()
        }

        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 500, "This checks the awards count is constant. Change this if you add awards.")

        measure {
            _ = awards.filter(dataController.hasEarned).count
        }
    }
    
//    func testWhereInFoorLoop() {
//        let array = Array(repeating: "Alexadner Röemer", count: 100).joined()
//
//        var newArray = [String]()
//
//        measure {
//            if !array.isEmpty {
//                for contact in array {
//                    newArray.append(String(contact))
//                }
//            }
//        }
//
//    }
//
//    func test2WhereInFoorLoop() {
//        let array = Array(repeating: "Alexadner Röemer", count: 100).joined()
//
//        var newArray = [String]()
//
//        measure {
//            for contact in array where !array.isEmpty {
//                    newArray.append(String(contact))
//                }
//
//        }
//    }


}
