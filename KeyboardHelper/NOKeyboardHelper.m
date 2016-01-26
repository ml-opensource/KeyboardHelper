//
//  NOKeyboardHelpers.m
//  Supe
//
//  Created by Kasper Welner on 15/09/14.
//  Copyright (c) 2014 Kasper Welner. All rights reserved.
//

#import "NOKeyboardHelper.h"

@implementation NOKeyboardAppearanceInfo

- (CGRect)beginFrame
{
    return [self.originalNotification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
}

- (CGRect)endFrame
{
    return [self.originalNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
}

- (NSTimeInterval)animationDuration
{
    return [self.originalNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
}

- (UIViewAnimationOptions)animationCurve
{
    return ([self.originalNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] integerValue] << 16);
}

- (void)animateAlong:(void(^)(void))animationBlock completion:(void(^)(BOOL finished))completion
{
    [UIView animateWithDuration:[self animationDuration]
                          delay:0.0
                        options:self.animationCurve
                     animations:animationBlock completion:completion];
}

@end

@implementation NOKeyboardHelper

- (instancetype)initWithDelegate:(id<NOKeyboardNotificationDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillAppear:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillDisappear:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
    }
    return self;
}

- (void)finish
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillAppear:(NSNotification *)note
{
    NOKeyboardAppearanceInfo *info = [[NOKeyboardAppearanceInfo alloc] init];
    info.originalNotification = note;
    
    [self.delegate keyboardWillAppear:info];
}

- (void)keyboardWillDisappear:(NSNotification *)note
{
    NOKeyboardAppearanceInfo *info = [[NOKeyboardAppearanceInfo alloc] init];
    info.originalNotification = note;
    
    [self.delegate keyboardWillDisappear:info];
}

@end
