//
//  KeyboardHelperTests.swift
//  KeyboardHelperTests
//
//  Created by Chris Combs on 26/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest
@testable import KeyboardHelper

class ShowSpyDelegate : KeyboardHelperDelegate {
    var kai : KeyboardAppearanceInfo?
    
    var expectation : XCTestExpectation?
    
    func keyboardWillDisappear(_ info: KeyboardAppearanceInfo) {
        
    }
    
    func keyboardWillAppear(_ info: KeyboardAppearanceInfo) {
        guard let expectation = expectation else {
            XCTFail("ShowSpyDelegate was not setup correctly. Missing XCTExpectation reference")
            return
        }
        
        kai = info
        expectation.fulfill()
    }
}

class HideSpyDelegate : KeyboardHelperDelegate {
    var kai : KeyboardAppearanceInfo?
    
    var expectation : XCTestExpectation?
    
    func keyboardWillDisappear(_ info: KeyboardAppearanceInfo) {
        guard let expectation = expectation else {
            XCTFail("HideSpyDelegate was not setup correctly. Missing XCTExpectation reference")
            return
        }
        
        kai = info
        expectation.fulfill()
    }
    
    func keyboardWillAppear(_ info: KeyboardAppearanceInfo) {
        
    }
}

class KeyboardHelperTests: XCTestCase {

    func testKeyboardShowDelegateMethodIsCalledAsync() {
        let spyDelegate = ShowSpyDelegate()
        let kh = KeyboardHelper(delegate: spyDelegate)
        
        let expectation = self.expectation(description: "KeyboardHelper calls the delegate as the result of receiving the show notification")
        spyDelegate.expectation = expectation
        
//        NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillShowNotification, object: kh)
        let notification : Notification
        if #available(iOS 9.0, *) {
            notification = Notification(name: NSNotification.Name.UIKeyboardWillShow, object: kh, userInfo:[
                UIKeyboardAnimationCurveUserInfoKey : NSNumber(value: 7),
                UIKeyboardAnimationDurationUserInfoKey : NSNumber(value: 0.25),
                UIKeyboardFrameBeginUserInfoKey : NSValue(cgRect: CGRect(x: 0, y: 667, width: 375, height: 0)),
                UIKeyboardFrameEndUserInfoKey : NSValue(cgRect: CGRect(x: 0, y: 409, width: 375, height: 258)),
                UIKeyboardIsLocalUserInfoKey : NSNumber(value: true)
                ])
        } else {
            notification = Notification(name: NSNotification.Name.UIKeyboardWillShow, object: nil, userInfo:[
                UIKeyboardAnimationCurveUserInfoKey : NSNumber(value: 7),
                UIKeyboardAnimationDurationUserInfoKey : NSNumber(value: 0.25),
                UIKeyboardFrameBeginUserInfoKey : NSValue(cgRect: CGRect(x: 0, y: 667, width: 375, height: 0)),
                UIKeyboardFrameEndUserInfoKey : NSValue(cgRect: CGRect(x: 0, y: 409, width: 375, height: 258))
                ])
        }
        
        NotificationCenter.default.post(notification)
        
        
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard let result = spyDelegate.kai else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertNotNil(result)
            XCTAssertEqual(result.animationCurve, UIViewAnimationCurve(rawValue: 7))
            XCTAssertEqual(result.animationDuration, 0.25)
            XCTAssertEqual(result.beginFrame, CGRect(x: 0, y: 667, width: 375, height: 0))
            XCTAssertEqual(result.endFrame, CGRect(x: 0, y: 409, width: 375, height: 258))
            if #available(iOS 9.0, *) {
                XCTAssertEqual(result.belongsToCurrentApp, true)
            } else {
                // don't test this
            }

        }
    }
    
    func testKeyboardHideDelegateMethodIsCalledAsync() {
        let spyDelegate = HideSpyDelegate()
        let kh = KeyboardHelper(delegate: spyDelegate)
        
        let expectation = self.expectation(description: "KeyboardHelper calls the delegate as the result of receiving the hide notification")
        spyDelegate.expectation = expectation
        
        NotificationCenter.default.post(name: NSNotification.Name.UIKeyboardWillHide, object: kh)
        
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard let result = spyDelegate.kai else {
                XCTFail("Expected delegate to be called")
                return
            }
            
            XCTAssertNotNil(result)
        }
    }
}
