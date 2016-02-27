#import "TSNotificationManager.h"

#define TS_NOTIFICATIONS_HANDLERS @"TSNotificationsHandlers"

@implementation TSNotificationManager{
    NSMutableDictionary* pendingNotifications;
}

+ (instancetype) sharedManager{
    static TSNotificationManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{manager = [[self alloc] init];});
    return manager;
}

+(BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        application.applicationIconBadgeNumber = 0;
        [[TSNotificationManager sharedManager] handleReceivedNotification:localNotification];
    }
    
    NSLog(@"Clearing %lu scheduled notifications", (unsigned long)[self scheduledNotificationsCount]);
    [application cancelAllLocalNotifications];
    return YES;
}

+(void) application:(UIApplication*) application didReceiveLocalNotification:(UILocalNotification*) notification {
    application.applicationIconBadgeNumber = 0;
    
    [[TSNotificationManager sharedManager] handleReceivedNotification:notification];
}

+ (NSUInteger) scheduledNotificationsCount{
    return [UIApplication sharedApplication].scheduledLocalNotifications.count;
}


+ (void) scheduleNotificationWithMessage:(NSString*) notificationMessage withHandler:(TSNotificationBlock) handler on:(NSDate*) date{
    [TSNotificationManager scheduleNotificationWithMessage:notificationMessage andUserInfo:nil withHandler:handler on:date];
}

+ (void) scheduleNotificationWithMessage:(NSString*) notificationMessage andUserInfo:(NSDictionary*) userInfo withHandler:(TSNotificationBlock) handler on:(NSDate*) date{
    [TSNotificationManager scheduleNotificationWithMessage:notificationMessage andUserInfo:userInfo withHandler:handler on:date withTimeZone:[NSTimeZone defaultTimeZone]];
}

+ (void) scheduleNotificationWithMessage:(NSString*) notificationMessage withHandler:(TSNotificationBlock) handler on:(NSDate*) date withTimeZone:(NSTimeZone*) timeZone{
	[TSNotificationManager scheduleNotificationWithMessage:notificationMessage andUserInfo:nil withHandler:handler on:date withTimeZone:timeZone];
}

+ (void) scheduleNotificationWithMessage:(NSString*) notificationMessage andUserInfo:(NSDictionary*) userInfo withHandler:(TSNotificationBlock) handler on:(NSDate*) date withTimeZone:(NSTimeZone*) timeZone{
    [[TSNotificationManager sharedManager] scheduleNotificationWithMessage:notificationMessage andUserInfo:userInfo withHandler:handler on:date withTimeZone:timeZone];
}

+(void) invalidateStoredNotificationsWithBlock:(TSNotificationValidatingBlock)block{
    [[TSNotificationManager sharedManager] invalidateStoredNotificationsWithBlock:block];
}

-(void) handleReceivedNotification:(UILocalNotification*)notification{
    if (!notification || !pendingNotifications) return;
    NSLog(@"Notification handled: %@", notification);
    TSNotificationBlock handler = [pendingNotifications objectForKey:notification];
    if (handler)
        handler(notification);
    else
        NSLog(@"No handler for notification: %@", notification);
}

-(void) invalidateStoredNotificationsWithBlock:(TSNotificationValidatingBlock)block{
    if (!block || !pendingNotifications) return;
    NSMutableDictionary* updatedNotifications = [NSMutableDictionary new];
    [pendingNotifications enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (block(key))
            [updatedNotifications setObject:obj forKey:key];
        else
            NSLog(@"Notification removed: %@", key);
    }];
    pendingNotifications = updatedNotifications;
}

-(void) scheduleNotificationWithMessage:(NSString *)notificationMessage andUserInfo:(NSDictionary*) userInfo withHandler:(TSNotificationBlock) handler on:(NSDate *)date withTimeZone:(NSTimeZone *)timeZone{
    
    if (!pendingNotifications) pendingNotifications = [NSMutableDictionary new];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = date;
    localNotification.alertBody = notificationMessage;
    localNotification.timeZone = timeZone;
    localNotification.userInfo = userInfo;
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    if (![pendingNotifications objectForKey:localNotification]){
    [pendingNotifications setObject:handler forKey:localNotification];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Notification scheduled: %@", localNotification);}
    else{
        NSLog(@"Notification already scheduled: %@", localNotification);
    }
}

@end
