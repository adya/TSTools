//
//  UIWindow+UIWindow_PresentedViewController.m
//  GridironMoe
//
//  Created by Adya on 11/18/15.
//  Copyright (c) 2015 Ocusco Corporation. All rights reserved.
//

#import "UIWindow+UIWindow+PresentedViewController.h"

@implementation UIWindow (PresentedViewController)
- (UIViewController*) presentedViewController {
    UIViewController* rootViewController = self.rootViewController;
    return [UIWindow getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [UIWindow getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}
@end

@implementation UIViewController (PresentedViewController)

+ (UIViewController*) presentedViewController{
    return [[UIApplication sharedApplication].keyWindow presentedViewController];
}

@end
