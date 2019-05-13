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
    
    var appearanceInfo: KeyboardAppearanceInfo!
    var defaultsAppearanceInfo : KeyboardAppearanceInfo!
    
    override func setUp() {
        super.setUp()

        // Create test info
        var testUserInfo: [String: Any] = [
            UIResponder.keyboardFrameBeginUserInfoKey: NSValue(cgRect: CGRect(x: 100, y: 100, width: 100, height: 100)),
            UIResponder.keyboardFrameEndUserInfoKey: NSValue(cgRect: CGRect(x: 200, y: 200, width: 200, height: 200)),
            UIResponder.keyboardAnimationDurationUserInfoKey: 3.0,
            UIResponder.keyboardAnimationCurveUserInfoKey: NSNumber(integerLiteral: UIView.AnimationCurve.easeOut.rawValue),
        ]
        
        if #available(iOS 9.0, *) {
            testUserInfo[UIResponder.keyboardIsLocalUserInfoKey] = false
        } else {
            print("UIKeyboardIsLocalUserInfoKey is not available before iOS9.")
        }
    
        // Fake the notification
        let note = Notification(name: UIResponder.keyboardWillShowNotification, object: nil, userInfo: testUserInfo)
        appearanceInfo = KeyboardAppearanceInfo(notification: note)
        let defaultNote = Notification(name: UIResponder.keyboardWillShowNotification, object: nil, userInfo: nil)
        defaultsAppearanceInfo = KeyboardAppearanceInfo(notification: defaultNote)
    }
    
    func testBeginFrame() {
        XCTAssertEqual(appearanceInfo.beginFrame, CGRect(x: 100, y: 100, width: 100, height: 100),
            "Parsing beginFrame from keyboard appearance info failed.")
        XCTAssertEqual(defaultsAppearanceInfo.beginFrame, CGRect.zero,
            "Parsing default beginFrame from keyboard appearance info failed.")
    }
    
    func testEndFrame() {
        XCTAssertEqual(appearanceInfo.endFrame, CGRect(x: 200, y: 200, width: 200, height: 200),
            "Parsing endFrame from keyboard appearance info failed.")
        XCTAssertEqual(defaultsAppearanceInfo.endFrame, CGRect.zero,
            "Parsing default endFrame from keyboard appearance info failed.")
    }
    
    @available(iOS 9.0, *)
    func testBelongsToCurrentApp() {
        XCTAssertEqual(appearanceInfo.belongsToCurrentApp, false,
            "Parsing belongsToCurrentApp from keyboard appearance info failed.")
        XCTAssertEqual(defaultsAppearanceInfo.belongsToCurrentApp, true,
            "Parsing default belongsToCurrentApp from keyboard appearance info failed.")
    }
    
    func testAnimationDuration() {
        
        XCTAssertEqual(appearanceInfo.animationDuration, Double(3),
            "Parsing animationDuration from keyboard appearance info failed.")
        XCTAssertEqual(defaultsAppearanceInfo.animationDuration, Double(0.25),
            "Parsing default animationDuration from keyboard appearance info failed.")
    }
    
    func testAnimationCurve() {
        XCTAssertEqual(appearanceInfo.animationCurve, UIView.AnimationCurve.easeOut,
            "Parsing animationCurve from keyboard appearance info failed.")
        XCTAssertEqual(defaultsAppearanceInfo.animationCurve, UIView.AnimationCurve.easeInOut,
            "Parsing default animationCurve from keyboard appearance info failed.")
    }
    
    func testAnimateAlong() {
        let expectation = self.expectation(description: "Animate along should take 3 seconds")
        
        appearanceInfo.animateAlong({ () -> Void in
            // Do animations
            }) { (finished) -> Void in
                if finished {
                    expectation.fulfill()
                }
        }
        
        waitForExpectations(timeout: 3.005, handler: nil)
    }
    
}
