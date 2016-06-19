/**
 *  Author:     AdYa
 *  Version:    1.0
 *  iOS:        [2.0; 9.0)
 *  Date:       06/19/2016
 *  Status:     Updated, Undocumented
 *
 *  Dependency: @header TSAlert,
                @header TSAlertProtected,
                @header TSError
 *
 *  Description:
 *
 *  TSError extenstion supports TSError objects to alert it.
 */

#import <Foundation/Foundation.h>
#import "TSAlert.h"

@class TSError;

@interface TSAlert (TSError)

+(void) alertError:(nonnull TSError*) error NS_DEPRECATED_IOS(2_0, 9_0, "UIAlertView is deprecated. Use UIAlertController with a preferredStyle of UIAlertControllerStyleAlert instead");

+(void) alertError:(nonnull TSError*) error
      acceptButton:(nullable NSString*) ok
       acceptBlock:(TSAlertButtonCallback _Nullable) acceptBlock NS_DEPRECATED_IOS(2_0, 9_0, "UIAlertView is deprecated. Use UIAlertController with a preferredStyle of UIAlertControllerStyleAlert instead");

+(void) alertError:(nonnull TSError*) error
      acceptButton:(nullable NSString*) ok
       acceptBlock:(TSAlertButtonCallback _Nullable) acceptBlock
      cancelButton:(nullable NSString*) cancel
       cancelBlock:(TSAlertButtonCallback _Nullable) cancelBlock NS_DEPRECATED_IOS(2_0, 9_0, "UIAlertView is deprecated. Use UIAlertController with a preferredStyle of UIAlertControllerStyleAlert instead");

@end
