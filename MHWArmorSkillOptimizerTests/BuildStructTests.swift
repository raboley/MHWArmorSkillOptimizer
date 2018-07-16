//
//  BuildStructTests.swift
//  MHWArmorSkillOptimizerTests
//
//  Created by Russell Boley on 7/15/18.
//  Copyright © 2018 Russell Boley. All rights reserved.
//

import XCTest
@testable import MHWArmorSkillOptimizer

class BuildStructTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit_BuildWithName() {
        let testBuild = Build(name: "Test Build")
        
        XCTAssertNotNil(testBuild)
        XCTAssertEqual(testBuild.name, "Test Build")
    }
    
}
