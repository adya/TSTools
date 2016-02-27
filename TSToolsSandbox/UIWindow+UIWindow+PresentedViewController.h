//
//  UIWindow+UIWindow_PresentedViewController.h
//  GridironMoe
//
//  Created by Adya on 11/18/15.
//  Copyright (c) 2015 Ocusco Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (PresentedViewController)
- (UIViewController*) presentedViewController;
@end

@interface UIViewController (PresentedViewController)
+ (UIViewController*) presentedViewController;
@end
