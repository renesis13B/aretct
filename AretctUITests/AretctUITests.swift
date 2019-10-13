//
//  AretctUITests.swift
//  AretctUITests
//
//  Created by yw on 2019/10/13.
//  Copyright © 2019 yw. All rights reserved.
//

import XCTest

import Firebase
@testable import Aretct

class AretctUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testHome_WhenLoginOutBtnTapped_LoginVCViewLoads() {
        app.launch()
        app.buttons["loginOutBtn"].tap()
        XCTAssertTrue(app.isDisplayingLogin)
    }

}

extension XCUIApplication {
    var isDisplayingLogin: Bool {
        return otherElements["loginView"].exists
    }
}
