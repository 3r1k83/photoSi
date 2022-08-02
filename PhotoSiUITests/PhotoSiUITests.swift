//
//  PhotoSiUITests.swift
//  PhotoSiUITests
//
//  Created by Erik Peruzzi on 30/07/22.
//

import XCTest

class PhotoSiUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launch()
        
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
    // test a static text
    func testStaticTexts() throws {
    
        let pickCountry = app.staticTexts["Pick your country"]
        
        XCTAssert(pickCountry.exists)

        XCTAssertEqual(pickCountry.label, "Pick your country")

    }
    
    // test the first loading and flow until the second view
    func testBasicFlow() throws {
        
        let myTable = app.tables["countriesList"]
        let row = myTable.cells.element(boundBy: 0)
        row.tap()
        let choosePictures = app.staticTexts["Choose pictures to upload"]
        XCTAssert(choosePictures.exists)

        let buttonAction = app.buttons["showActionSheet"]
        XCTAssert(buttonAction.exists)
    }
    
}
