//
//  KeyboardHelper.swift
//  KeyboardHelper
//
//  Created by Timmi Trinks on 27/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import UIKit

public protocol KeyboardNotificationDelegate {
    func keyboardWillAppear(info: KeyboardAppearanceInfo)
    func keyboardWillDisappear(info: KeyboardAppearanceInfo)
}

public class KeyboardHelper {
    
    public let delegate: KeyboardNotificationDelegate?
    
    required public init(delegate: KeyboardNotificationDelegate) {
        self.delegate = delegate
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private init() {
        delegate = nil
    }
    
    public func keyboardWillAppear(note: NSNotification) {
        let info = KeyboardAppearanceInfo(notification: note)
        self.delegate?.keyboardWillAppear(info)
    }
    
    public func keyboardWillDisappear(note: NSNotification) {
        let info = KeyboardAppearanceInfo(notification: note)
        self.delegate?.keyboardWillDisappear(info)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
