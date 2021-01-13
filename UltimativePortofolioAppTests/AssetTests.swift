//
//  AssetTests.swift
//  UltimativePortofolioAppTests
//
//  Created by Alexander Römer on 13.01.21.
//

import XCTest
@testable import UltimativePortofolioApp

class AssetTests: XCTestCase {
    
    func testColorsExist() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog.")
        }
    }
    
    func testJSONLoadsCorrectly() {
        XCTAssertTrue(Award.allAwards.isEmpty == false, "Failed to load awards from JSON.")
    }

    
}

