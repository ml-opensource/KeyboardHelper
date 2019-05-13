//
//  KeyboardAppearanceInfo.swift
//  KeyboardHelper
//
//  Created by Kasper Welner on 04/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import UIKit

/// A struct holding all keyboard view information when it's being shown or hidden.
public struct KeyboardAppearanceInfo {
    
    public let notification: Notification
    public let userInfo: [AnyHashable: Any]
    
    public init(notification: Notification) {
        self.notification = notification
        self.userInfo = notification.userInfo ?? [:]
    }
    
    /// Getter for the UIKeyboard frame begin infokey. Returns a `CGRect` or `CGRectZero`.
    public var beginFrame: CGRect {
        return (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
    }
    
    
    /// Getter for the UIKeyboard frame end infokey. Return a `CGRect` or `CGRectZero`.
    public var endFrame: CGRect {
        return (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
    }
    
    
    @available(iOS 9.0, *)
    /// Getter for the UIKeyboard info if the keyboard is in the current app.
    /// That variable will help to keep track of which app uses the keyboard at the moment.
    /// If it is the current app it is true, if not it is false.
    public var belongsToCurrentApp: Bool {
        return (userInfo[UIResponder.keyboardIsLocalUserInfoKey] as? Bool) ?? true
        
    }
    
    
    /// Getter for the duration of the keyboard appear/disappear animation.
    /// By default: `0.25`.
    public var animationDuration: Double {
        return (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
    }

    /// Getter for the animation curve.
    /// By default: `EaseInOut`.
    public var animationCurve: UIView.AnimationCurve {
        guard let value = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else { return .easeInOut }
        return UIView.AnimationCurve(rawValue: value) ?? .easeInOut
    }
    
    
    /// Getter for the animation option.
    /// That variable will help to keep track of the keyboard appearence.
    public var animationOptions: UIView.AnimationOptions {
        return UIView.AnimationOptions(rawValue: UInt(animationCurve.rawValue << 16))
    }
    
    /// Animate a `UView` while the keyboard appears and check if animation is finished.
    /// If finished do completion.
    ///
    /// Parameters:
    ///     - animationBlock: Animation that should happen.
    ///     - completion: Function that happens after the animation is finished.
    public func animateAlong(_ animationBlock: @escaping (() -> Void), completion: @escaping ((_ finished: Bool) -> Void) = { _ in }) {
        UIView.animate(
            withDuration: animationDuration,
            delay: 0.0,
            options: animationOptions,
            animations: animationBlock,
            completion: completion
    )}
}
