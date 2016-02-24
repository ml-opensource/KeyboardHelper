//
//  KeyboardHelperTests.swift
//  KeyboardHelperTests
//
//  Created by Chris Combs on 26/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest
@testable import KeyboardHelper

class ShowSpyDelegate : KeyboardNotificationDelegate {
    var kai : KeyboardAppearanceInfo?
    
    var expectation : XCTestExpectation?
    
    func keyboardWillDisappear(info: KeyboardAppearanceInfo) {
        
    }
    
    func keyboardWillAppear(info: KeyboardAppearanceInfo) {
        guard let expectation = expectation else {
            XCTFail("ShowSpyDelegate was not setup correctly. Missing XCTExpectation reference")
            return
        }
        
        kai = info
        expectation.fulfill()
    }
}

class HideSpyDelegate : KeyboardNotificationDelegate {
    var kai : KeyboardAppearanceInfo?
    
    var expectation : XCTestExpectation?
    
    func keyboardWillDisappear(info: KeyboardAppearanceInfo) {
        guard let expectation = expectation else {
            XCTFail("HideSpyDelegate was not setup correctly. Missing XCTExpectation reference")
            return
        }
        
        kai = info
        expectation.fulfill()
    }
    
    func keyboardWillAppear(info: KeyboardAppearanceInfo) {
        
    }
}

class KeyboardHelperTests: XCTestCase {

    func testKeyboardShowDelegateMethodIsCalledAsync() {
        let spyDelegate = ShowSpyDelegate()
        let kh = KeyboardHelper(delegate: spyDelegate)
        
        let expectation = expectationWithDescription("KeyboardHelper calls the delegate as the result of receiving the show notification")
        spyDelegate.expectation = expectation
        
//        NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillShowNotification, object: kh)
        let notification : NSNotification
        if #available(iOS 9.0, *) {
            notification = NSNotification(name: UIKeyboardWillShowNotification, object: kh, userInfo:[
                UIKeyboardAnimationCurveUserInfoKey : NSNumber(int: 7),
                UIKeyboardAnimationDurationUserInfoKey : NSNumber(double: 0.25),
                UIKeyboardFrameBeginUserInfoKey : NSValue(CGRect: CGRect(x: 0, y: 667, width: 375, height: 0)),
                UIKeyboardFrameEndUserInfoKey : NSValue(CGRect: CGRect(x: 0, y: 409, width: 375, height: 258)),
                UIKeyboardIsLocalUserInfoKey : NSNumber(bool: true)
                ])
        } else {
            notification = NSNotification(name: UIKeyboardWillShowNotification, object: nil, userInfo:[
                UIKeyboardAnimationCurveUserInfoKey : NSNumber(int: 7),
                UIKeyboardAnimationDurationUserInfoKey : NSNumber(double: 0.25),
                UIKeyboardFrameBeginUserInfoKey : NSValue(CGRect: CGRect(x: 0, y: 667, width: 375, height: 0)),
                UIKeyboardFrameEndUserInfoKey : NSValue(CGRect: CGRect(x: 0, y: 409, width: 375, height: 258))
                ])
        }
        
        NSNotificationCenter.defaultCenter().postNotification(notification)
        
        
        
        waitForExpectationsWithTimeout(1) { error in
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
            XCTAssertEqual(result.belongsToCurrentApp, true)

        }
    }
    
    func testKeyboardHideDelegateMethodIsCalledAsync() {
        let spyDelegate = HideSpyDelegate()
        let kh = KeyboardHelper(delegate: spyDelegate)
        
        let expectation = expectationWithDescription("KeyboardHelper calls the delegate as the result of receiving the hide notification")
        spyDelegate.expectation = expectation
        
        NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillHideNotification, object: kh)
        
        
        waitForExpectationsWithTimeout(1) { error in
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
