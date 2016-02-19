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

        NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillShowNotification, object: kh)
        
        
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
