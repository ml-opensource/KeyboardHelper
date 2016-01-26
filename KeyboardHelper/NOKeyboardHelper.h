//
//  NOKeyboardHelpers.h
//  NOCore
//
//  Created by Kasper Welner on 15/09/14.
//  Copyright (c) 2014 Kasper Welner. All rights reserved.
//

@import UIKit;

@class NOKeyboardAppearanceInfo;

@protocol NOKeyboardNotificationDelegate <NSObject>
@required
- (void)keyboardWillAppear:(NOKeyboardAppearanceInfo *)info;
- (void)keyboardWillDisappear:(NOKeyboardAppearanceInfo *)info;

@end

@interface NOKeyboardAppearanceInfo : NSObject

@property (nonatomic, readonly)CGRect beginFrame;
@property (nonatomic, readonly)CGRect endFrame;
@property (nonatomic, readonly)NSTimeInterval animationDuration;
@property (nonatomic, readonly)UIViewAnimationOptions animationCurve;

@property (nonatomic, strong)NSNotification *originalNotification;

- (void)animateAlong:(void(^)(void))animationBlock completion:(void(^)(BOOL finished))completion;

@end

@interface NOKeyboardHelper : NSObject

- (instancetype)initWithDelegate:(id<NOKeyboardNotificationDelegate>)delegate;
- (void)finish;

@property (nonatomic, weak)id<NOKeyboardNotificationDelegate> delegate;

@end
