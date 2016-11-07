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
    
    fileprivate var tapGesture: UITapGestureRecognizer!
    fileprivate var keyboardHelper : KeyboardHelper?
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        self.tapGesture.isEnabled = true
        
        self.keyboardHelper = KeyboardHelper(delegate: self)
    }

    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func keyboardWillAppear(_ info: KeyboardAppearanceInfo) {
        info.animateAlong({ () -> Void in
            let insets = UIEdgeInsetsMake(0, 0, info.endFrame.size.height, 0)
            self.scrollView.contentInset = insets
            self.scrollView.scrollIndicatorInsets = insets
        })  { finished in }
    }
    
    func keyboardWillDisappear(_ info: KeyboardAppearanceInfo) {
        UIView.animate(withDuration: TimeInterval(info.animationDuration),
            delay: 0,
            options: info.animationOptions,
            animations: {
                let insets = UIEdgeInsets.zero
                self.scrollView.contentInset = insets
                self.scrollView.scrollIndicatorInsets = insets
            },
            completion:nil)
    }


}

