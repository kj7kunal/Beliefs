//
//  BeliefsTests.swift
//  BeliefsTests
//
//  Created by kunal.jain on 2024/07/26.
//

import XCTest
@testable import Beliefs

class BeliefsTests: XCTestCase {
    func testBeliefsViewLoads() {
        let view = BeliefsView()
        XCTAssertNotNil(view, "BeliefsView should load successfully")
    }
    
    func testNewBeliefViewLoads() {
        let view = NewBeliefView()
        XCTAssertNotNil(view, "NewBeliefView should load successfully")
    }
    
    func testSettingsViewLoads() {
        let view = SettingsView()
        XCTAssertNotNil(view, "SettingsView should load successfully")
    }
}
