/**
 *  Author:     AdYa
 *  Version:    1.0
 *  iOS:        [2.0; 9.0)
 *  Date:       06/19/2016
 *  Status:     Updated, Undocumented
 *
 *  Dependency: @pod LMAlertView,
 *              @header TSAlert,
 *              @header TSAlertProtected
 *
 *  Description:
 *
 *  Customization extension uses 3rd party view to mimic legacy UIAlertView, but leaves an ability to customize alert view appearance.
 */

#import <Foundation/Foundation.h>
#import "TSAlert.h"

@interface TSAlert (Customization)
+(void) alertWithTitle:(nonnull NSString*) title
               message:(nonnull NSString*) msg
         withAlignment:(NSTextAlignment) alignment
          acceptButton:(nullable NSString*) ok
           acceptBlock:(TSAlertButtonCallback _Nullable) acceptBlock
          cancelButton:(nullable NSString*) cancel
           cancelBlock:(TSAlertButtonCallback _Nullable) cancelBlock;

@end
