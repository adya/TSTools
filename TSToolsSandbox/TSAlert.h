/**
 *  Author:     AdYa
 *  Version:    1.0
 *  iOS:        [2.0; 9.0)
 *  Date:       06/19/2016
 *  Status:     Updated, Undocumented, Deprecated for iOS 9.0+
 *
 *  Dependency: @header TSAlertProtected,
 *              @header TSUtils
 *
 *  Description:
 *
 *  Formerly TSNotifier module.
 *
 *  TSAlert provides neat way to show simple alert with title, message accept and, optionally, cancel buttons with custom button handlers defined as blocks in a single line of code.
 */

#import <Foundation/Foundation.h>
#import <UIKit/NSText.h>

typedef void(^TSAlertButtonCallback)();

@interface TSAlert : NSObject
+(void) alert:(nonnull NSString*) message NS_DEPRECATED_IOS(2_0, 9_0, "UIAlertView is deprecated. Use UIAlertController with a preferredStyle of UIAlertControllerStyleAlert instead");

+(void) alert:(nonnull NSString*) message
 acceptButton:(nullable NSString*) ok
  acceptBlock:(TSAlertButtonCallback _Nullable) acceptBlock NS_DEPRECATED_IOS(2_0, 9_0, "UIAlertView is deprecated. Use UIAlertController with a preferredStyle of UIAlertControllerStyleAlert instead");

+(void) alert:(nonnull NSString*) message
 acceptButton:(nullable NSString*) ok
  acceptBlock:(TSAlertButtonCallback _Nullable) acceptBlock
 cancelButton:(nullable NSString*) cancel
  cancelBlock:(TSAlertButtonCallback _Nullable) cancelBlock NS_DEPRECATED_IOS(2_0, 9_0, "UIAlertView is deprecated. Use UIAlertController with a preferredStyle of UIAlertControllerStyleAlert instead");

+(void) alertWithTitle:(nonnull NSString*) title
               message:(nonnull NSString*) msg NS_DEPRECATED_IOS(2_0, 9_0, "UIAlertView is deprecated. Use UIAlertController with a preferredStyle of UIAlertControllerStyleAlert instead");

+(void) alertWithTitle:(nonnull NSString*) title
               message:(nonnull NSString*) msg
          acceptButton:(nullable NSString*) ok
           acceptBlock:(TSAlertButtonCallback _Nullable) acceptBlock NS_DEPRECATED_IOS(2_0, 9_0, "UIAlertView is deprecated. Use UIAlertController with a preferredStyle of UIAlertControllerStyleAlert instead");

+(void) alertWithTitle:(nonnull NSString*) title
               message:(nonnull NSString*) msg
          acceptButton:(nullable NSString*) ok
           acceptBlock:(TSAlertButtonCallback _Nullable) acceptBlock
          cancelButton:(nullable NSString*) cancel
           cancelBlock:(TSAlertButtonCallback _Nullable) cancelBlock NS_DEPRECATED_IOS(2_0, 9_0, "UIAlertView is deprecated. Use UIAlertController with a preferredStyle of UIAlertControllerStyleAlert instead");


@end
