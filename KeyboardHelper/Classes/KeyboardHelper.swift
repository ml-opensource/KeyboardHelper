//
//  KeyboardHelper.swift
//  KeyboardHelper
//
//  Created by Timmi Trinks on 27/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import UIKit

/**
    Protocol `KeyboardNotificationDelegate` requires two functions.
    Function `keyboardWillAppear` and `keyboardWillDisappear` with parameter `info` struct `KeyboardAppearanceInfo`.
*/
public protocol KeyboardNotificationDelegate {
    
    /**
        This function will recongnize a change of `KeyboardAppearanceInfo` and will be fired when the keyboard will appaear.
        - Parameter info: Struct `KeyboardAppearanceInfo`.
     */
    func keyboardWillAppear(info: KeyboardAppearanceInfo)
    
    /**
        This function will recongnize a change of `KeyboardAppearanceInfo` and will be fired when the keyboard will disappaear.
        - Parameter info: Struct `KeyboardAppearanceInfo`.
     */
    func keyboardWillDisappear(info: KeyboardAppearanceInfo)
}

/**
    Useful helper to keep track of keyboard changes.
*/
public class KeyboardHelper {
    
    /**
        Delegate that conforms with the `KeyboardNotificationDelegate`.
    */
    public let delegate: KeyboardNotificationDelegate?
    
    /**
        Initialize the `delegate` and add the two observer for `keyboardWillAppear` and `keyboardWillDisappear`.
        Observers are nessecary for tracking the `UIKeyboardWillShowNotification` and `UIKeyboardWillHideNotification`, so the function that are connectet are getting fired.
    */
    required public init(delegate: KeyboardNotificationDelegate) {
        self.delegate = delegate
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private init() {
        delegate = nil
    }
    
    private func keyboardWillAppear(note: NSNotification) {
        let info = KeyboardAppearanceInfo(notification: note)
        self.delegate?.keyboardWillAppear(info)
    }
    
    private func keyboardWillDisappear(note: NSNotification) {
        let info = KeyboardAppearanceInfo(notification: note)
        self.delegate?.keyboardWillDisappear(info)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
