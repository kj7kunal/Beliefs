//
//  BeliefsUITests.swift
//  BeliefsUITests
//
//  Created by kunal.jain on 2024/07/26.
//

import XCTest

final class BeliefsUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testAddDeleteBelief() throws {
        // Launch the app
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to "My Beliefs" tab
        app.tabBars.buttons["My Beliefs"].tap()
        
        // Tap "New Belief" button
        app.buttons["New Belief"].tap()
        
        // Enter belief details and save
        let beliefTextField = app.textFields["beliefTextField"]
        XCTAssertTrue(beliefTextField.exists, "The beliefTextField should exist")
        beliefTextField.tap()
        beliefTextField.typeText("UI Test Belief")
        
        let evidenceTextField = app.textFields["evidenceTextField"]
        XCTAssertTrue(evidenceTextField.exists, "The evidenceTextField should exist")
        evidenceTextField.tap()
        evidenceTextField.typeText("UI Test Evidence")
        
        app.buttons["Save"].tap()
        
        // Verify the belief appears in the "My Beliefs" list
        XCTAssertTrue(app.staticTexts["UI Test Belief"].exists)
        
        // Locate UI Test Belief cell by its text
        let beliefCell = app.staticTexts["UI Test Belief"].firstMatch
        XCTAssertTrue(beliefCell.exists, "The belief cell should exist")
        
        // Swipe left to delete the belief
        beliefCell.swipeLeft()
        app.buttons["Delete"].tap()
        
        // Verify the belief was deleted
        XCTAssertFalse(app.staticTexts["UI Test Belief"].exists)
    }
}
