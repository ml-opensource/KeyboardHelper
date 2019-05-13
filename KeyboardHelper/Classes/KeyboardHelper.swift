//
//  KeyboardHelper.swift
//  KeyboardHelper
//
//  Created by Kasper Welner on 27/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import UIKit


/// Protocol `KeyboardHelperDelegate` requires two functions, `keyboardWillAppear` and `keyboardWillDisappear` with parameter `info` struct `KeyboardAppearanceInfo`.
public protocol KeyboardHelperDelegate: class {
    

    /// This function will recongnize a change of `KeyboardAppearanceInfo` and will be fired when the keyboard will appaear.
    ///
    /// - Parameter info: Struct `KeyboardAppearanceInfo`.
    func keyboardWillAppear(_ info: KeyboardAppearanceInfo)

    
    /// This function will recongnize a change of `KeyboardAppearanceInfo` and will be fired when the keyboard will disappaear.
    ///
    /// - Parameter info: Struct `KeyboardAppearanceInfo`.
    func keyboardWillDisappear(_ info: KeyboardAppearanceInfo)
}

/// Hack to make protocol methods optional
public extension KeyboardHelperDelegate {
    func keyboardWillAppear(_ info: KeyboardAppearanceInfo) {}
    func keyboardWillDisappear(_ info: KeyboardAppearanceInfo) {}
}

/// Useful helper to keep track of keyboard changes.
public class KeyboardHelper {
    
    /// Delegate that conforms with the `KeyboardHelperDelegate`.
    public weak var delegate: KeyboardHelperDelegate?
    
    /// Initialize the `delegate` and add the two observer for `keyboardWillAppear` and `keyboardWillDisappear`.
    /// Observers are nessecary for tracking the `UIKeyboardWillShowNotification` and `UIKeyboardWillHideNotification`, so the function that are connectet are getting fired.
    ///
    /// - Parameter delegate: KeyboardHelperDelegate
    required public init(delegate: KeyboardHelperDelegate) {
        self.delegate = delegate
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardHelper.keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardHelper.keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    /// Making sure that you can't intantiate it without a delegate
    private init() {
        delegate = nil
    }
    
    @objc dynamic private func keyboardWillAppear(_ note: Notification) {
        let info = KeyboardAppearanceInfo(notification: note)
        self.delegate?.keyboardWillAppear(info)
    }
    
    @objc dynamic private func keyboardWillDisappear(_ note: Notification) {
        let info = KeyboardAppearanceInfo(notification: note)
        self.delegate?.keyboardWillDisappear(info)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

@available(*, deprecated, message: "KeyboardNotificationDelegate has been renamed to KeyboardHelperDelegate")
public typealias KeyboardNotificationDelegate = KeyboardHelperDelegate
