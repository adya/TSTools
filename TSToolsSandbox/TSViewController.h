/**
 *  Author:     AdYa
 *  Version:    2.0
 *  iOS:        2.0+
 *  Date:       01/13/2015
 *  Status:     Outdated, Undocumented
 *
 *  Dependency: @header TSUtils,
 *              @header TSMenuManager
 *
 *  Description:
 *
 *  TSViewController provides useful methods for UIViewController.
 */
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
