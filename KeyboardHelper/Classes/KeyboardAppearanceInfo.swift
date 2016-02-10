//
//  KeyboardAppearanceInfo.swift
//  KeyboardHelper
//
//  Created by Timmi Trinks on 04/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import UIKit

/**
 A struct holding all keyboard view information when it's being shown or hidden.
*/
public struct KeyboardAppearanceInfo {
    
    public let notification: NSNotification
    public let userInfo: [NSObject: AnyObject]
    
    public init(notification: NSNotification) {
        self.notification = notification
        self.userInfo = notification.userInfo ?? [:]
    }
    
    /**
     Getter for the UIKeyboard frame begin infokey.
     Return a `CGRect` or `CGRectZero`.
    */
    public var beginFrame: CGRect {
        return userInfo[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue ?? CGRectZero
    }
    
    /**
     Getter for the UIKeyboard frame end infokey.
     Return a `CGRect` or `CGRectZero`.
     */
    public var endFrame: CGRect {
        return userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue ?? CGRectZero
    }
    
    /**
     Getter for the UIKeyboard info if the keyboard is in the current app.
     That variable will help to keep track of which app uses the keyboard at the moment.
     If it is the current app it is true, if not it is false.
     */
    public var belongsToCurrentApp: Bool {
        if #available(iOS 9.0, *) {
            return userInfo[UIKeyboardIsLocalUserInfoKey]?.boolValue ?? true
        } else {
            return true
        }
    }
    
    /**
     Getter for the duration of the keyboard appear/disappear animation.
     By default: `0.25`.
     */
    public var animationDuration: Double {
        return userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue ?? 0.25
    }
    
    /**
     Getter for the animation curve.
     By default: `EaseInOut`.
     */
    public var animationCurve: UIViewAnimationCurve {
        guard let value = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int else { return .EaseInOut }
        return UIViewAnimationCurve(rawValue: value) ?? .EaseInOut
    }
    
    /**
     Getter for the animation option.
     That variable will help to keep track of the keyboard appearence.
     */
    public var animationOptions: UIViewAnimationOptions {
        return UIViewAnimationOptions(rawValue: UInt(animationCurve.rawValue << 16))
    }
    
    /**
     Animate a `UView` while the keyboard appears and check if animation is finished.
     If finished do completion.
     
     Parameters:
        - animationBlock: Animation that should happen.
        - completion: Function that happens after the animation is finished.
    */
    public func animateAlong(animationBlock: () -> Void, completion: (finished: Bool) -> Void) {
        UIView.animateWithDuration(
            animationDuration,
            delay: 0.0,
            options: animationOptions,
            animations: animationBlock,
            completion: completion
    )}
}