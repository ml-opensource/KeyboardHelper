//
//  ViewController.swift
//  KeyboardHelperDemo
//
//  Created by Marius Constantinescu on 26/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import UIKit
import KeyboardHelper

class ViewController: UIViewController, KeyboardNotificationDelegate {
    
    private var tapGesture: UITapGestureRecognizer!
    private var keyboardHelper : KeyboardHelper?
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        self.tapGesture.enabled = true
        
        self.keyboardHelper = KeyboardHelper(delegate: self)
    }

    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func keyboardWillAppear(info: KeyboardAppearanceInfo) {
        info.animateAlong({ () -> Void in
            let insets = UIEdgeInsetsMake(0, 0, info.endFrame.size.height, 0)
            self.scrollView.contentInset = insets
            self.scrollView.scrollIndicatorInsets = insets
        })  { finished in }
    }
    
    func keyboardWillDisappear(info: KeyboardAppearanceInfo) {
        UIView.animateWithDuration(NSTimeInterval(info.animationDuration),
            delay: 0,
            options: info.animationOptions,
            animations: {
                let insets = UIEdgeInsetsZero
                self.scrollView.contentInset = insets
                self.scrollView.scrollIndicatorInsets = insets
            },
            completion:nil)
    }


}

