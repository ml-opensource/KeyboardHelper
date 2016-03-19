# KeyboardHelper
> No more checking for keyboard notifications and parsing keyboard apperance info manually!

A small (but cool) tool for handling UIKeyboard appearing and disappearing in your view controllers.

[![Travis](https://img.shields.io/travis/nodes-ios/KeyboardHelper.svg)](https://travis-ci.org/nodes-ios/KeyboardHelper)
[![Codecov](https://img.shields.io/codecov/c/github/nodes-ios/KeyboardHelper.svg)](https://codecov.io/github/nodes-ios/KeyboardHelper)
[![Documentation](https://img.shields.io/cocoapods/metrics/doc-percent/KeyboardHelper.svg)](http://cocoadocs.org/docsets/KeyboardHelper/)
[![CocoaPods](https://img.shields.io/cocoapods/v/KeyboardHelper.svg)](https://cocoapods.org/pods/KeyboardHelper)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)
![Plaform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/nodes-ios/KeyboardHelper/blob/master/LICENSE)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/nodes-ios/keyboardhelper)](http://clayallsopp.github.io/readme-score?url=https://github.com/nodes-ios/keyboardhelper)
## 📦 Installation

### Carthage
~~~
github "nodes-ios/KeyboardHelper"
~~~

### CocoaPods
~~~
pod 'KeyboardHelper', '~> 0.9'
~~~ 

### Swit Package Manager
To use KeyboardHelper as a [Swift Package Manager](https://swift.org/package-manager/) package just add the following to your `Package.swift` file.  

~~~swift
import PackageDescription

let package = Package(
    name: "YourPackage",
    dependencies: [
        .Package(url: "https://github.com/nodes-ios/KeyboardHelper.git", majorVersion: 0)
    ]
)
~~~

**NOTE:** This doesn't currently work as SPM doesn't support iOS, but once it will we will already be supporting it! :)

## 🔧 Setup
Implement `KeyboardNotificationDelegate` in your UIViewController.

```swift
class ViewController: UIViewController, KeyboardNotificationDelegate
```

Add a `KeyboardHelper` private variable and initialize it, setting the delegate.

```swift
private var keyboardHelper : KeyboardHelper?
...
self.keyboardHelper = KeyboardHelper(delegate: self)
```
Implement the two methods in the `KeyboardNotificationDelegate`: 

```swift
public func keyboardWillAppear(info: KeyboardHelper.KeyboardAppearanceInfo)
public func keyboardWillDisappear(info: KeyboardHelper.KeyboardAppearanceInfo)
```

Both methods take as argument a `KeyboardAppearanceInfo` object, which is basically a wrapper over the `userInfo` dictionary of the `UIKeyboardWillShowNotification` and `UIKeyboardWillHideNotification` notifications.

One example of implementation for the two delegate methods is:

```swift
func keyboardWillAppear(info: KeyboardAppearanceInfo) {
        UIView.animateWithDuration(NSTimeInterval(info.animationDuration),
            delay: 0,
            options: info.animationOptions,
            animations: {
                let insets = UIEdgeInsetsMake(0, 0, info.endFrame.size.height, 0)
                self.scrollView.contentInset = insets
                self.scrollView.scrollIndicatorInsets = insets
            },
            completion:nil)
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
```

The `KeyboardAppearanceInfo` object has the following properties:

* `beginFrame`: a `CGRect` corresponding to the value for `UIKeyboardFrameBeginUserInfoKey`
* `endFrame `: a `CGRect` corresponding to the value for `UIKeyboardFrameEndUserInfoKey`
* `belongsToCurrentApp `: a `Bool` corresponding to the value for `UIKeyboardIsLocalUserInfoKey`
* `animationDuration `: a `Double` corresponding to the value for `UIKeyboardAnimationDurationUserInfoKey`
* `animationCurve `: a `UIViewAnimationCurve` corresponding to the value for `UIKeyboardAnimationCurveUserInfoKey`
* `animationOptions `: a `UIViewAnimationOptions ` from the value of `UIKeyboardAnimationCurveUserInfoKey`

`KeyboardAppearanceInfo` also has the convenience method `animateAlong:completion:`, which can be used like this:

```swift
func keyboardWillAppear(info: KeyboardAppearanceInfo) {
	info.animateAlong({ () -> Void in
            let insets = UIEdgeInsetsMake(0, 0, info.endFrame.size.height, 0)
            self.scrollView.contentInset = insets
            self.scrollView.scrollIndicatorInsets = insets
        })  { finished in }

```
to get the same effect as the initial `keyboardWillAppear:` implementation example above.



## 👥 Credits
Made with ❤️ at [Nodes](http://nodesagency.com).

## 📄 License
**KeyboardHelper** is available under the MIT license. See the [LICENSE](https://github.com/nodes-ios/KeyboardHelper/blob/master/LICENSE) file for more info.
