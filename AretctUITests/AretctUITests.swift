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
    
    func testLoginVC_EmailInput_WhenGivinEmail_FillsTextField() {
        app.launch()
        app.buttons["loginOutBtn"].tap()
        
        let emailTextfield = app.textFields["メールアドレス"]
        emailTextfield.tap()
        emailTextfield.typeText("uitest@deci.com")
        
        XCTAssertTrue(app.textFields["uitest@deci.com"].exists)
    }
    
    func testPasswordInput_WhenGivinPassword_FillsTextField() {
        app.launch()
        app.buttons["loginOutBtn"].tap()
        XCTAssertTrue(app.secureTextFields["パスワード"].exists)
    }
    
    func testLoginVC_WhenloginBtnTappedNOtextField_shouldDisplaySimpleAleart() {
        app.launch()
        app.buttons["loginOutBtn"].tap()
        
        app.buttons["loginBtn"].tap()
        XCTAssertTrue(app.isDisplayingSimpleAlert)
    }
    
    func testLoginVCt_WhenNologinBtnTapped_shouldDisplayHomeVC() {
        app.launch()
        app.buttons["loginOutBtn"].tap()
        app.buttons["ログインせずに使う"].tap()
        XCTAssertTrue(app.isDisplayingHome)
    }

}

extension XCUIApplication {
    var isDisplayingLogin: Bool {
        return otherElements["loginView"].exists
    }
    
    var isDisplayingHome: Bool {
        return otherElements["homeView"].exists
    }
    
    var isDisplayingSimpleAlert: Bool {
        return alerts["Error"].exists
    }
}
