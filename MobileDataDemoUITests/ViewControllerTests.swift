//
//  ViewControllerTests.swift
//  MobileDataDemoUITests
//
//  Created by jhm on 2021/5/123456
//  Copyright © 2021 jhm. All rights reserved.
//

import XCTest

class ViewControllerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testClearCache() throws {
        let app = XCUIApplication()
        app.navigationBars["Demo"].children(matching: .button).element.tap()
        app.alerts["Clear Cache"].scrollViews.otherElements.buttons["OK"]/*@START_MENU_TOKEN@*/.press(forDuration: 0.6);/*[[".tap()",".press(forDuration: 0.6);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    }
    
    func testClickData() throws {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["1.543719"]/*[[".cells.staticTexts[\"1.543719\"]",".staticTexts[\"1.543719\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"2009").element/*[[".cells.containing(.staticText, identifier:\"6.228985000000001\").element",".cells.containing(.staticText, identifier:\"2009\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"2011").element/*[[".cells.containing(.staticText, identifier:\"14.638703\").element",".cells.containing(.staticText, identifier:\"2011\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"2011")/*[[".cells.containing(.staticText, identifier:\"14.638703\")",".cells.containing(.staticText, identifier:\"2011\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["down"].tap()
        app.alerts.scrollViews.otherElements.buttons["OK"].tap()
        
    }
    func testExample() throws {
        // Use recording to get started writing UI tests.
                // Use XCTAssert and related functions to verify your tests produce the correct results.
        
      
    }

}
