
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
