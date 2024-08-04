//
//  BeliefsTests.swift
//  BeliefsTests
//
//  Created by kunal.jain on 2024/07/26.
//

import XCTest
@testable import Beliefs

class BeliefsTests: XCTestCase {
    // MARK: - View Loads
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
    
    // MARK: - Database operations
    var databaseManager: DatabaseManager!

    override func setUpWithError() throws {
        // Initialize the database manager and clear existing data
        databaseManager = DatabaseManager.shared
        databaseManager.clearAllBeliefs()
        databaseManager.clearAllCategories()
    }

    override func tearDownWithError() throws {
        // Clear data after each test
        databaseManager.clearAllBeliefs()
        databaseManager.clearAllCategories()
        databaseManager = nil
    }


    func testInsertBelief() throws {
        // Insert a new belief
        databaseManager.insertBelief(title: "Test Belief", evidence: "Test Evidence", category: "Test Category")
        
        // Fetch all beliefs
        let beliefs = databaseManager.fetchAllBeliefs()
        
        // Verify the belief was inserted
        XCTAssertEqual(beliefs.count, 1)
        XCTAssertEqual(beliefs.first?.title, "Test Belief")
        XCTAssertEqual(beliefs.first?.evidence, "Test Evidence")
        XCTAssertEqual(beliefs.first?.category, "Test Category")
    }

    func testUpdateBelief() throws {
        // Insert a new belief
        databaseManager.insertBelief(title: "Test Belief", evidence: "Test Evidence", category: "Test Category")
        var beliefs = databaseManager.fetchAllBeliefs()
        XCTAssertEqual(beliefs.count, 1)
        
        // Update the belief
        let belief = beliefs.first!
        databaseManager.updateBelief(id: belief.id, title: "Updated Belief", evidence: "Updated Evidence", category: "Updated Category")
        
        // Fetch all beliefs
        beliefs = databaseManager.fetchAllBeliefs()
        
        // Verify the belief was updated
        XCTAssertEqual(beliefs.count, 1)
        XCTAssertEqual(beliefs.first?.title, "Updated Belief")
        XCTAssertEqual(beliefs.first?.evidence, "Updated Evidence")
        XCTAssertEqual(beliefs.first?.category, "Updated Category")
    }

    func testDeleteBelief() throws {
        // Insert a new belief
        databaseManager.insertBelief(title: "Test Belief", evidence: "Test Evidence", category: "Test Category")
        var beliefs = databaseManager.fetchAllBeliefs()
        XCTAssertEqual(beliefs.count, 1)
        
        // Delete the belief
        let belief = beliefs.first!
        databaseManager.deleteBelief(id: belief.id)
        
        // Fetch all beliefs
        beliefs = databaseManager.fetchAllBeliefs()
        
        // Verify the belief was deleted
        XCTAssertEqual(beliefs.count, 0)
    }
    
    func testInsertCategory() throws {
        // Insert a new category
        databaseManager.insertCategory(name: "Test Category")
        
        // Fetch all categories
        let categories = databaseManager.fetchAllCategories()
        
        // Verify the category was inserted
        XCTAssertEqual(categories.count, 1)
        XCTAssertEqual(categories.first?.name, "Test Category")
    }
}
