/**
 *  Author:     AdYa
 *  Version:    1.0
 *  iOS:        [3.0; 8.0)
 *  Date:       03/../2016
 *  Status:     In Progress, Undocumented
 *
 *  Dependency: @header TSUtils
 *
 *  Description:
 *
 *  Not implemented Manager. Still has no clear design and purposes. 
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
