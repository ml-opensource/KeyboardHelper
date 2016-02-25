//
//  KeyboardAppearanceInfoTests.swift
//  KeyboardHelper
//
//  Created by Timmi Trinks on 05/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest
import KeyboardHelper

class KeyboardAppearanceInfoTests: XCTestCase {
    
    var apperanceInfo: KeyboardAppearanceInfo!
    var defaultsAppearanceInfo : KeyboardAppearanceInfo!
    
    override func setUp() {
        super.setUp()

        // Create test info
        var testUserInfo: [String: AnyObject] = [
            UIKeyboardFrameBeginUserInfoKey: NSValue(CGRect: CGRect(x: 100, y: 100, width: 100, height: 100)),
            UIKeyboardFrameEndUserInfoKey: NSValue(CGRect: CGRect(x: 200, y: 200, width: 200, height: 200)),
            UIKeyboardAnimationDurationUserInfoKey: 3.0,
            UIKeyboardAnimationCurveUserInfoKey: UIViewAnimationCurve.EaseOut.rawValue,
        ]
        
        if #available(iOS 9.0, *) {
            testUserInfo[UIKeyboardIsLocalUserInfoKey] = false
        } else {
            print("UIKeyboardIsLocalUserInfoKey is not available before iOS9.")
        }
    
        // Fake the notification
        let note = NSNotification(name: UIKeyboardWillShowNotification, object: nil, userInfo: testUserInfo)
        apperanceInfo = KeyboardAppearanceInfo(notification: note)
        let defaultNote = NSNotification(name: UIKeyboardWillShowNotification, object: nil, userInfo: nil)
        defaultsAppearanceInfo = KeyboardAppearanceInfo(notification: defaultNote)
    }
    
    func testBeginFrame() {
        XCTAssertEqual(apperanceInfo.beginFrame, CGRect(x: 100, y: 100, width: 100, height: 100),
            "Parsing beginFrame from keyboard appearance info failed.")
        XCTAssertEqual(defaultsAppearanceInfo.beginFrame, CGRectZero,
            "Parsing default beginFrame from keyboard appearance info failed.")
    }
    
    func testEndFrame() {
        XCTAssertEqual(apperanceInfo.endFrame, CGRect(x: 200, y: 200, width: 200, height: 200),
            "Parsing endFrame from keyboard appearance info failed.")
        XCTAssertEqual(defaultsAppearanceInfo.endFrame, CGRectZero,
            "Parsing default endFrame from keyboard appearance info failed.")
    }
    
    @available(iOS 9.0, *)
    func testBelongsToCurrentApp() {
        XCTAssertEqual(apperanceInfo.belongsToCurrentApp, false,
            "Parsing belongsToCurrentApp from keyboard appearance info failed.")
        XCTAssertEqual(defaultsAppearanceInfo.belongsToCurrentApp, true,
            "Parsing default belongsToCurrentApp from keyboard appearance info failed.")
    }
    
    func testAnimationDuration() {
        XCTAssertEqual(apperanceInfo.animationDuration, Double(3),
            "Parsing animationDuration from keyboard appearance info failed.")
        XCTAssertEqual(defaultsAppearanceInfo.animationDuration, Double(0.25),
            "Parsing default animationDuration from keyboard appearance info failed.")
    }
    
    func testAnimationCurve() {
        XCTAssertEqual(apperanceInfo.animationCurve, UIViewAnimationCurve(rawValue: 2),
            "Parsing animationCurve from keyboard appearance info failed.")
        XCTAssertEqual(defaultsAppearanceInfo.animationCurve, UIViewAnimationCurve(rawValue: defaultsAppearanceInfo.animationCurve.rawValue),
            "Parsing default animationCurve from keyboard appearance info failed.")
    }
    
    func testAnimateAlong() {
        let expectation = expectationWithDescription("Animate along should take 3 seconds")
        
        apperanceInfo.animateAlong({ () -> Void in
            // Do animations
            }) { (finished) -> Void in
                if finished {
                    expectation.fulfill()
                }
        }
        
        waitForExpectationsWithTimeout(3.005, handler: nil)
    }
    
}
