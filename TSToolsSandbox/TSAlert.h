/**
 *  Author:     AdYa
 *  Version:    1.0
 *  iOS:        [2.0; 9.0)
 *  Date:       03/31/2016
 *  Status:     In Progress, Undocumented
 *
 *  Dependency: LMAlertView, TSUtils
 *
 *  Description:
 *
 *  Formerly TSNotifier module.
 *
 *  TSAlert provides neat way to show simple alert with title, message accept and, optionally, cancel buttons with custom button handlers defined as blocks in a single line of code.
 *
 *  TODO: Move alert with alignment to an extension method.
 */

#import <Foundation/Foundation.h>
#import <UIKit/NSText.h>
#import "TSError.h"

typedef void(^TSAlertButtonCallback)();

@interface TSAlert : NSObject
+(void) alert:(nonnull NSString*) message;

+(void) alert:(nonnull NSString*) message
 acceptButton:(nullable NSString*) ok
  acceptBlock:(TSAlertButtonCallback _Nullable) acceptBlock;

+(void) alert:(nonnull NSString*) message
 acceptButton:(nullable NSString*) ok
  acceptBlock:(TSAlertButtonCallback _Nullable) acceptBlock
 cancelButton:(nonnull NSString*) cancel
  cancelBlock:(TSAlertButtonCallback _Nullable) cancelBlock;

+(void) alertWithTitle:(nonnull NSString*) title
               message:(nonnull NSString*) msg;

+(void) alertWithTitle:(nonnull NSString*) title
               message:(nonnull NSString*) msg
          acceptButton:(nullable NSString*) ok
           acceptBlock:(TSAlertButtonCallback _Nullable) acceptBlock;

+(void) alertWithTitle:(nonnull NSString*) title
               message:(nonnull NSString*) msg
          acceptButton:(nullable NSString*) ok
           acceptBlock:(TSAlertButtonCallback _Nullable) acceptBlock
          cancelButton:(nullable NSString*) cancel
           cancelBlock:(TSAlertButtonCallback _Nullable) cancelBlock;

+(void) alertWithTitle:(nonnull NSString*) title
               message:(nonnull NSString*) msg
         withAlignment:(NSTextAlignment) alignment
          acceptButton:(nullable NSString*) ok
           acceptBlock:(TSAlertButtonCallback _Nullable) acceptBlock
          cancelButton:(nullable NSString*) cancel
           cancelBlock:(TSAlertButtonCallback _Nullable) cancelBlock;

+(void) alertError:(nonnull TSError*) error;

+(void) alertError:(nonnull TSError*) error
      acceptButton:(nullable NSString*) ok
       acceptBlock:(TSAlertButtonCallback _Nullable) acceptBlock;

+(void) alertError:(nonnull TSError*) error
      acceptButton:(nullable NSString*) ok
       acceptBlock:(TSAlertButtonCallback _Nullable) acceptBlock
      cancelButton:(nullable NSString*) cancel
       cancelBlock:(TSAlertButtonCallback _Nullable) cancelBlock;
@end
