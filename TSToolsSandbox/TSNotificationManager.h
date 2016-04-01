/**
 *  Author:     AdYa
 *  Version:    1.5
 *  iOS:        [4.0; 8.0)
 *  Date:       ../../2015
 *  Status:     Outdated
 *
 *  Dependency: None
 *
 *  Description:
 *  
 *  TSNotificationManager designed to schedule local notifications and provide neat way to handle them.
 *
 *  You have to do the following:
 *
 *  1. Call startWithLaunchOptions: to initialize manager inside application:didFinishLaunchWithOptions:.
 *  2. Put handleReceivedNotification: in application:didReceiveLocalNotification: method of your AppDelegate class.
 *  3. Use one of scheduleNotification methods to schedule local notification.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** Completion block which defines notification callback upon receiving it. */
typedef void (^TSNotificationBlock)(UILocalNotification* _Nonnull notification);

/**Completeion block which is used to validate scheduled notification. */
typedef BOOL (^TSNotificationValidatingBlock)(UILocalNotification* _Nonnull notification);

/// Handles UILocalNotification lifecycle.
@interface TSNotificationManager : NSObject

/** Handler of received notifications. Put this in application:didReceiveLocalNotification: method of your AppDelegate class. */
+ (void) handleReceivedNotification:(nonnull UILocalNotification*) notification;

/** Handles application's launch and checks whether it was opened with local notification. */
+ (void) startWithLaunchOptions:(nullable NSDictionary*) launchOptions;

/** @return Returns number of scheduled notifications. */
+ (NSUInteger) scheduledNotificationsCount;

/** Invalidates all scheduled notifications using specified validation block.
    @param block Validation block which will be called for every scheduled notification.
    @return Returns YES if notification is valid, otherwise - NO.
 */
+ (void) invalidateStoredNotificationsWithBlock:(_Nonnull TSNotificationValidatingBlock) block;

/** Schedules notification on given date with specified message and handler.
    Note: date will be represented in default time zone. to specify time zone explicitly - use appropriate method's overload.
    @param notificationMessage Custom notification message.
    @param handler Handler block which will be called when notification will have fired.
    @param date Scheduled date and time.
 */
+ (void) scheduleNotificationWithMessage:(nonnull NSString*) notificationMessage
                             withHandler:(TSNotificationBlock _Nonnull) handler
                                      on:(nonnull NSDate*) date;

/** Schedules notification on given date with specified message, handler and additional user info dictionary.
     Note: date will be represented in default time zone. to specify time zone explicitly - use appropriate method's overload.
    @param notificationMessage Custom notification message.
    @param userInfo Dictionary with additional important info.
    @param handler Handler block which will be called when notification will have fired.
    @param date Scheduled date and time.
 */
+ (void) scheduleNotificationWithMessage:(nonnull NSString*) notificationMessage
                             andUserInfo:(nullable NSDictionary*) userInfo
                             withHandler:(TSNotificationBlock _Nonnull) handler
                                      on:(nonnull NSDate*) date;

/** Schedules notification on given date with specified message and handler. Date will be represented in specified time zone.
    @param notificationMessage Custom notification message.
    @param handler Handler block which will be called when notification will have fired.
    @param date Scheduled date and time.
    @param timeZone Custom time zone which will be used to convert date.
 */
+ (void) scheduleNotificationWithMessage:(nonnull NSString*) notificationMessage
                             withHandler:(TSNotificationBlock _Nonnull) handler
                                      on:(nonnull NSDate*) date
                            withTimeZone:(nullable NSTimeZone*) timeZone;

/** Schedules notification on given date with specified message, handler and additional user info dictionary. Date will be represented in specified time zone.
    @param notificationMessage Custom notification message.
    @param userInfo Dictionary with additional important info.
    @param handler Handler block which will be called when notification will have fired.
    @param date Scheduled date and time.
    @param timeZone Custom time zone which will be used to convert date.
 */
+ (void) scheduleNotificationWithMessage:(nonnull NSString*) notificationMessage
                             andUserInfo:(nullable NSDictionary*) userInfo
                             withHandler:(TSNotificationBlock _Nonnull) handler
                                      on:(nonnull NSDate*) date
                            withTimeZone:(nullable NSTimeZone*) timeZone;

@end
