#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TSNotificationBlock)(UILocalNotification* notification);
typedef BOOL (^TSNotificationValidatingBlock)(UILocalNotification* notification);

/// Handles UILocalNotification lifecycle.
@interface TSNotificationManager : NSObject

// put this in the App Delegate appropriate method
+ (void) application:(UIApplication *) application didReceiveLocalNotification:(UILocalNotification *) notification;
+ (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions;


+ (NSUInteger) scheduledNotificationsCount;

/// block should return YES if notification is valid, otherwise - NO.
+ (void) invalidateStoredNotificationsWithBlock:(TSNotificationValidatingBlock) block;

+ (void) scheduleNotificationWithMessage:(NSString*) notificationMessage withHandler:(TSNotificationBlock) handler on:(NSDate*) date;

+ (void) scheduleNotificationWithMessage:(NSString*) notificationMessage andUserInfo:(NSDictionary*) userInfo withHandler:(TSNotificationBlock) handler on:(NSDate*) date;

+ (void) scheduleNotificationWithMessage:(NSString*) notificationMessage withHandler:(TSNotificationBlock) handler on:(NSDate*) date withTimeZone:(NSTimeZone*) timeZone;


+ (void) scheduleNotificationWithMessage:(NSString*) notificationMessage andUserInfo:(NSDictionary*) userInfo withHandler:(TSNotificationBlock) handler on:(NSDate*) date withTimeZone:(NSTimeZone*) timeZone;

@end
