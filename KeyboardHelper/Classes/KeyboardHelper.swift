//
//  KeyboardHelper.swift
//  KeyboardHelper
//
//  Created by Kasper Welner on 27/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import UIKit

/**
    Protocol `KeyboardNotificationDelegate` requires two functions.
    Function `keyboardWillAppear` and `keyboardWillDisappear` with parameter `info` struct `KeyboardAppearanceInfo`.
*/
public protocol KeyboardNotificationDelegate: class {
    
    /**
        This function will recongnize a change of `KeyboardAppearanceInfo` and will be fired when the keyboard will appaear.
        - Parameter info: Struct `KeyboardAppearanceInfo`.
     */
    func keyboardWillAppear(_ info: KeyboardAppearanceInfo)
    
    /**
        This function will recongnize a change of `KeyboardAppearanceInfo` and will be fired when the keyboard will disappaear.
        - Parameter info: Struct `KeyboardAppearanceInfo`.
     */
    func keyboardWillDisappear(_ info: KeyboardAppearanceInfo)
}

/**
    Useful helper to keep track of keyboard changes.
*/
public class KeyboardHelper {
    
    /**
        Delegate that conforms with the `KeyboardNotificationDelegate`.
    */
    public weak var delegate: KeyboardNotificationDelegate?
    
    /**
        Initialize the `delegate` and add the two observer for `keyboardWillAppear` and `keyboardWillDisappear`.
        Observers are nessecary for tracking the `UIKeyboardWillShowNotification` and `UIKeyboardWillHideNotification`, so the function that are connectet are getting fired.
    */
    required public init(delegate: KeyboardNotificationDelegate) {
        self.delegate = delegate
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardHelper.keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardHelper.keyboardWillDisappear(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private init() {
        delegate = nil
    }
    
    dynamic private func keyboardWillAppear(_ note: Notification) {
        let info = KeyboardAppearanceInfo(notification: note)
        self.delegate?.keyboardWillAppear(info)
    }
    
    dynamic private func keyboardWillDisappear(_ note: Notification) {
        let info = KeyboardAppearanceInfo(notification: note)
        self.delegate?.keyboardWillDisappear(info)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
