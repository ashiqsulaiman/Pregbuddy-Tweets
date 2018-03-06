//
//  PregBuddy_TweetsUITests.swift
//  PregBuddy TweetsUITests
//
//  Created by Ashiq Sulaiman on 06/03/18.
//  Copyright © 2018 Ashiq Sulaiman. All rights reserved.
//

import XCTest

class PregBuddy_TweetsUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        //XCUIApplication().launch()
        app.launchArguments.append("--uitesting")

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testTweets(){
        app.launch()
        let tablesQuery = app.tables
        let tablesElement = tablesQuery.element
        tablesElement.swipeUp()
        XCTAssertTrue(app.isTweetScreen)
        let cellQuery = self.app.tables.cells.element(boundBy: 1)
        tablesElement.swipeUp()
        cellQuery.tap()
        let cellQuery2 = self.app.tables.cells.element(boundBy: 2)
        tablesElement.swipeDown()
        cellQuery2.tap()
        let cellQuery3 = self.app.tables.cells.element(boundBy: 3)
        tablesElement.swipeUp()
        cellQuery3.tap()

    }
    
    
    func testBookmark(){
        app.launch()
        let tablesQuery = app.tables
        let cellQuery = self.app.tables.cells.element(boundBy: 1)
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Bookmarks"].tap()
        XCTAssertTrue(app.isBookmarkScreen)
        cellQuery.swipeLeft()
        tablesQuery.buttons["Delete"].tap()
        tabBarsQuery.buttons["Tweets"].tap()
    }
    
    func testFilter(){
        app.launch()
        let tablesQuery = app.tables
        let tablesElement = tablesQuery.element
        let cellQuery = self.app.tables.cells.element(boundBy: 1)
        let filterButton = app.navigationBars["Tweets"].buttons["filter"]
        filterButton.tap()
        let filterBySheet = app.sheets["Filter by"]
        filterBySheet.buttons["Most Liked"].tap()
        filterButton.tap()
        filterBySheet.buttons["Most Retweeted"].tap()
        tablesElement.swipeUp()
        cellQuery.tap()
    }
    
    
}
