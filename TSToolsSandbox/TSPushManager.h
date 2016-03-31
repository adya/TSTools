/**
 *  Author:     AdYa
 *  Version:    1.0
 *  iOS:        [3.0; 8.0)
 *  Date:       03/../2016
 *  Status:     In Progress, Undocumented
 *
 *  Dependency: @framework LMAlertView, 
 *              @header TSUtils
 *
 *  Description:
 *
 *  TSAlert provides neat way to show simple alert with title, message accept and, optionally, cancel buttons with custom button handlers defined as blocks in a single line of code.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TSPushNotificationType) {
    TSNotificationTypeBadge,
    TSNotificationTypeSound,
    TSNotificationTypeAlert
};

@interface TSPushManager : NSObject


+ (void) registerPushNotificationsTypes:(TSPushNotificationType) types;

+ (void)application:(UIApplication*) application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

+ (void)application:(UIApplication*) application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
@end
