//
//  KeyboardAppearanceInfo.swift
//  KeyboardHelper
//
//  Created by Timmi Trinks on 04/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import UIKit

public struct KeyboardAppearanceInfo {
    
    public let notification: NSNotification
    public let userInfo: [NSObject: AnyObject]
    
    public init(notification: NSNotification) {
        self.notification = notification
        self.userInfo = notification.userInfo ?? [:]
    }
    
    /**
    Getter for the UIKeyboard Info
    */
    public var beginFrame: CGRect {
        return userInfo[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue ?? CGRectZero
    }
    
    public var endFrame: CGRect {
        return userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue ?? CGRectZero
    }
    
    public var belongsToCurrentApp: Bool {
        if #available(iOS 9.0, *) {
            return userInfo[UIKeyboardIsLocalUserInfoKey]?.boolValue ?? true
        } else {
            return true
        }
    }
    
    public var animationDuration: Double {
        return userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue ?? 0.25
    }
    
    public var animationCurve: UIViewAnimationCurve {
        guard let value = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int else { return .EaseInOut }
        return UIViewAnimationCurve(rawValue: value) ?? .EaseInOut
    }
    
    public var animationOptions: UIViewAnimationOptions {
        return UIViewAnimationOptions(rawValue: UInt(animationCurve.rawValue << 16))
    }
    
    func animateAlong(animationBlock: () -> Void, completion: (finished: Bool) -> Void) {
        UIView.animateWithDuration(
            animationDuration,
            delay: 0.0,
            options: animationOptions,
            animations: animationBlock,
            completion: completion
    )}
}