/**
 *  Author:     AdYa
 *  Version:    1.0
 *  iOS:        [2.0; 9.0)
 *  Date:       06/19/2016
 *  Status:     Updated, Undocumented
 *
 *  Dependency: @header TSAlert
 *
 *  Description:
 *
 *  Formerly TSNotifier module.
 *
 *  TSAlert provides neat way to show simple alert with title, message accept and, optionally, cancel buttons with custom button handlers defined as blocks in a single line of code.
 */

#ifndef TSAlertProtected_h
#define TSAlertProtected_h

#define DEFAULT_TITLE [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString*)kCFBundleNameKey]
#define DEFAULT_ACCEPT_BUTTON @"OK"
#define DEFAULT_CANCEL_BUTTON nil

// Helper to delegate callbacks from buttons
@interface TSAlertViewDelegate  : NSObject <UIAlertViewDelegate>

+(TSAlertViewDelegate*) sharedDelegate;
-(void) setCallbacksAccept:(TSAlertButtonCallback)accept andCancel:(TSAlertButtonCallback) cancel;

@end

#endif /* TSAlertProtected_h */
