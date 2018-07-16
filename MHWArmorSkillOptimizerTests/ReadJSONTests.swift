//
//  ReadJSONTests.swift
//  MHWArmorSkillOptimizerTests
//
//  Created by Russell Boley on 7/15/18.
//  Copyright © 2018 Russell Boley. All rights reserved.
//

import XCTest

@testable import MHWArmorSkillOptimizer

struct Repository {
    let id: Int
    let name: String
}

/* todo make an extension that will template the skills JSON
extension Repository: Unboxable {
    init(unboxer: Unboxer) throws {
        id = try unboxer.unbox(key: "id")
        name = try unboxer.unbox(key: "name")
    }
}
*/

class ReadJSONTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJSONMapping_SkillNotNil() throws {

        guard Bundle.main.url(forResource: "SkillsData", withExtension: "json") != nil else {
            XCTFail("Missing file: SkillsData.json")
            return
        }
        
        let jsonReader = ReadJSON.init()
        let skillsList = jsonReader.readJSONObjectSkill(forResource: "SkillsData", withExtension: "json")
        // We can't make any assumptions about the data here, since it can update
        // at any time. We'll simply verify that the data is there.
        XCTAssertFalse(skillsList.isEmpty)
    }
    
}
