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
    
    override func setUp() {
        super.setUp()
        
        var animationCurve = UIViewAnimationCurve.EaseInOut
        NSNumber(integer: 7).getValue(&animationCurve)

        // Create test info
        var testUserInfo: [String: AnyObject] = [
            UIKeyboardFrameBeginUserInfoKey: NSValue(CGRect: CGRect(x: 100, y: 100, width: 100, height: 100)),
            UIKeyboardFrameEndUserInfoKey: NSValue(CGRect: CGRect(x: 200, y: 200, width: 200, height: 200)),
            UIKeyboardAnimationDurationUserInfoKey: Double(3),
            UIKeyboardAnimationCurveUserInfoKey: animationCurve.rawValue,
        ]
        
        if #available(iOS 9.0, *) {
            testUserInfo[UIKeyboardIsLocalUserInfoKey] = false
        } else {
            print("UIKeyboardIsLocalUserInfoKey is not available before iOS9.")
        }
    
        // Fake the notification
        let note = NSNotification(name: UIKeyboardWillShowNotification, object: nil, userInfo: testUserInfo)
        apperanceInfo = KeyboardAppearanceInfo(notification: note)
    }
    
    func testBeginFrame() {
        XCTAssertEqual(apperanceInfo.beginFrame, CGRect(x: 100, y: 100, width: 100, height: 100),
            "Parsing beginFrame from keyboard appearance info failed.")
    }
    
    func testEndFrame() {
        XCTAssertEqual(apperanceInfo.endFrame, CGRect(x: 200, y: 200, width: 200, height: 200),
            "Parsing endFrame from keyboard appearance info failed.")
    }
    
    @available(iOS 9.0, *)
    func testBelongsToCurrentApp() {
        XCTAssertEqual(apperanceInfo.belongsToCurrentApp, false,
            "Parsing endFrame from keyboard appearance info failed.")
    }
    
    func testAnimationDuration() {
        XCTAssertEqual(apperanceInfo.animationDuration, Double(3),
            "Parsing animationDuration from keyboard appearance info failed.")
    }
    
    func testAnimationCurve() {
        XCTAssertEqual(apperanceInfo.animationCurve, UIViewAnimationCurve(rawValue: 7),
            "Parsing animationCurve from keyboard appearance info failed.")
    }
    
//    func testAnimateAlong() {
//        XCTAssertEqual(apperanceInfo., <#T##expression2: T?##T?#>, <#T##message: String##String#>)
//    }
    
}
