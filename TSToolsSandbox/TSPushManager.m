#import "TSPushManager.h"
#import "TSUtils.h"

@implementation TSPushManager

+(BOOL) isOldEnvironment{
    return SYSTEM_VERSION_LESS_THAN(@"8.0.0");
}

+(void) registerPushNotificationsTypes:(TSPushNotificationType) types{
    if ([self isOldEnvironment]){
        [self registerRemoteNotificationsTypes:[self getRemoteNotificationTypesFrom:types]];
    }
    else{
        [self registerUserNotificationsTypes:[self getUserNotificationTypesFrom:types]];
    }
}

+ (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken  {
    NSLog(@"My token is: %@", deviceToken);
}

+ (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to get token, error: %@", error);
}

+(UIRemoteNotificationType) getRemoteNotificationTypesFrom:(TSPushNotificationType) types{
    UIRemoteNotificationType remoteTypes;
    if (types | TSNotificationTypeAlert) remoteTypes |= UIRemoteNotificationTypeAlert;
    if (types | TSNotificationTypeBadge) remoteTypes |= UIRemoteNotificationTypeBadge;
    if (types | TSNotificationTypeSound) remoteTypes |= UIRemoteNotificationTypeSound;
    return remoteTypes;
}

+(UIUserNotificationType) getUserNotificationTypesFrom:(TSPushNotificationType) types{
    UIUserNotificationType remoteTypes;
    if (types | TSNotificationTypeAlert) remoteTypes |= UIUserNotificationTypeAlert;
    if (types | TSNotificationTypeBadge) remoteTypes |= UIUserNotificationTypeBadge;
    if (types | TSNotificationTypeSound) remoteTypes |= UIUserNotificationTypeSound;
    return remoteTypes;
}

+(void) registerRemoteNotificationsTypes:(UIRemoteNotificationType) types {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

}

+(void) registerUserNotificationsTypes:(UIUserNotificationType) types {
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

@end
