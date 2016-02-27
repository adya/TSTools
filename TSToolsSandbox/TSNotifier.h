
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TSError;
@class MBProgressHUD;

typedef void(^ButtonCallback)();

typedef NS_ENUM(NSInteger, TSNotificationTimeInterval){
    TS_NOTIFICATION_TIME_SWIFT = 1,
    TS_NOTIFICATION_TIME_SHORT = 3,
    TS_NOTIFICATION_TIME_NORMAL = 5,
    TS_NOTIFICATION_TIME_LONG = 8
};

typedef NS_ENUM(NSInteger, TSNotificationPosition) {
    TS_NOTIFICATION_POSITION_TOP_LEFT,
    TS_NOTIFICATION_POSITION_TOP_CENTER,
    TS_NOTIFICATION_POSITION_TOP_RIGHT,
    TS_NOTIFICATION_POSITION_CENTER_LEFT,
    TS_NOTIFICATION_POSITION_CENTER_CENTER,
    TS_NOTIFICATION_POSITION_CENTER_RIGHT,
    TS_NOTIFICATION_POSITION_BOTTOM_LEFT,
    TS_NOTIFICATION_POSITION_BOTTOM_CENTER,
    TS_NOTIFICATION_POSITION_BOTTOM_RIGHT
};
/// UIColor value
extern NSString* const kTSNotificationAppearanceNotificationColor;
/// CGFloat value
extern NSString* const kTSNotificationAppearanceNotificationOpacity;
/// BOOL value
extern NSString* const kTSNotificationAppearanceDimBackground;
/// UIColor value
extern NSString* const kTSNotificationAppearanceTextColor;
/// UIFont value
extern NSString* const kTSNotificationAppearanceTextFont;
/// CGFloat value
extern NSString* const kTSNotificationAppearanceTextSize;
///CGFloat value
extern NSString* const kTSNotificationAppearanceMargin;
/// TSNotificationPosition value
extern NSString* const kTSNotificationAppearancePosition;
/// CGFloat value
extern NSString* const kTSNotificationAppearancePositionXOffset;
/// CGFloat value
extern NSString* const kTSNotificationAppearancePositionYOffset;


#define TSLog(title, msg) [TSNotifier logWithTitle:title message:msg]
#define TSLog(msg) [TSNotifier log:msg]

// Logs and notifies (popup) messages
@interface TSNotifier : NSObject
+(void) log:(NSString*) message;
+(void) logWithTitle:(NSString*) title message:(NSString*) msg;
+(void) logMethod:(NSString*) method;

+(void) setLoggingEnabled:(BOOL)enabled;
@end

@interface TSNotifier (Alerts)

+(void) alert:(NSString*) message;
+(void) alert:(NSString*) message acceptButton:(NSString*) ok acceptBlock:(ButtonCallback) acceptBlock;
+(void) alert:(NSString*) message acceptButton:(NSString*) ok acceptBlock:(ButtonCallback) acceptBlock cancelButton:(NSString*) cancel cancelBlock:(ButtonCallback) cancelBlock;

+(void) alertWithTitle:(NSString*) title message:(NSString*) msg;
+(void) alertWithTitle:(NSString*) title message:(NSString*) msg acceptButton:(NSString*) ok acceptBlock:(ButtonCallback) acceptBlock;
+(void) alertWithTitle:(NSString*) title message:(NSString*) msg acceptButton:(NSString*) ok acceptBlock:(ButtonCallback) acceptBlock cancelButton:(NSString*) cancel cancelBlock:(ButtonCallback) cancelBlock;

+(void) alertWithTitle:(NSString*) title message:(NSString*) msg withAlignment:(NSTextAlignment) alignment acceptButton:(NSString*) ok acceptBlock:(ButtonCallback) acceptBlock cancelButton:(NSString*) cancel cancelBlock:(ButtonCallback) cancelBlock;

+(void) alertError:(TSError*)error;
+(void) alertError:(TSError*)error acceptButton:(NSString*)ok acceptBlock:(ButtonCallback) acceptBlock;
+(void) alertError:(TSError*)error acceptButton:(NSString*)ok acceptBlock:(ButtonCallback) acceptBlock cancelButton:(NSString*)cancel cancelBlock:(ButtonCallback) cancelBlock;
@end

@interface TSNotifier (Notifications)

+(void) notify:(NSString*) message;
+(void) notify:(NSString*) message onView:(UIView*) view;
+(void) notify:(NSString*) message timeInterval:(TSNotificationTimeInterval) time;
+(void) notify:(NSString*) message timeInterval:(TSNotificationTimeInterval) time onView:(UIView*) view;
+(void) notify:(NSString*) message withAppearance:(NSDictionary*)appearance;
+(void) notify:(NSString*) message withAppearance:(NSDictionary*)appearance onView:(UIView*) view;
+(void) notify:(NSString*) message withAppearance:(NSDictionary*)appearance timeInterval:(TSNotificationTimeInterval) time;
+(void) notify:(NSString*) message withAppearance:(NSDictionary*)appearance timeInterval:(TSNotificationTimeInterval) time onView:(UIView*) view;

+(void) notifyError:(TSError*) error;
+(void) notifyError:(TSError*) error onView:(UIView*) view;
+(void) notifyError:(TSError*) error timeInterval:(TSNotificationTimeInterval) time;
+(void) notifyError:(TSError*) error timeInterval:(TSNotificationTimeInterval) time onView:(UIView*) view;

+(void) notifyError:(TSError*) error withAppearance:(NSDictionary*)appearance;
+(void) notifyError:(TSError*) error withAppearance:(NSDictionary*)appearance onView:(UIView*) view;
+(void) notifyError:(TSError*) error withAppearance:(NSDictionary*)appearance timeInterval:(TSNotificationTimeInterval) time;
+(void) notifyError:(TSError*) error withAppearance:(NSDictionary*)appearance timeInterval:(TSNotificationTimeInterval) time onView:(UIView*) view;

+(void) hideNotification;
+(void) hideNotificationOnView:(UIView*) view;
@end

@interface TSNotifier (ProgressBars)

+(void) showProgressOnView:(UIView*)view;
+(void) showProgressWithMessage:(NSString*)message;
+(void) showProgressWithMessage:(NSString*)message onView:(UIView*)view;
+(void) showProgressWithMessage:(NSString*)message withAppearance:(NSDictionary*)appearance;
+(void) showProgressWithMessage:(NSString*)message withAppearance:(NSDictionary*)appearance onView:(UIView*)view;

+(void) hideProgress;
+(void) hideProgressOnView:(UIView*)view;
@end
