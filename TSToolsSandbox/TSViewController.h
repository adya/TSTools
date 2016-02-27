//
//  TSViewController.h
//  PictPerfect
//
//  Created by Adya on 13/01/2015.
//  Copyright (c) 2015 vvteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSMenuManager;

@interface TSViewController : UIViewController <UITextFieldDelegate>

@property BOOL showBackButton;
@property BOOL showMenuButton;

@property UIBarButtonItem* menuButton;

@property (readonly) TSMenuManager* menuManager;

-(void) setMenuButtonWithTitle:(NSString*) title;
-(void) setMenuButtonWithImage:(UIImage*) image;

-(void) setBackButtonWithTitle:(NSString*) title;
-(void) setBackButtonWithImage:(UIImage*) image;

-(void) dismissKeyboard;

/// Method to support both iOS 7 and iOS 8
-(void) showSafeViewController:(UIViewController *)vc sender:(id)sender;

@end
