#import "TSNotifier.h"
#import "MBProgressHUD.h"
#import "TSError.h"
#import "TSUtils.h"
#import "LMAlertView.h"
#import "UIWindow+UIWindow+PresentedViewController.h"

#define PRESENTED_VIEW [UIViewController presentedViewController].view

#define DEFAULT_MESSAGE nil
#define DEFAULT_VIEW PRESENTED_VIEW
#define DEFAULT_APPEARANCE nil
#define DEFAULT_TIME_INTERVAL TS_NOTIFICATION_TIME_NORMAL

static BOOL loggingEnabled = YES;

NSString* const kTSNotificationAppearanceNotificationColor = @"TSNotAppBGColor";
NSString* const kTSNotificationAppearanceNotificationOpacity = @"TSNotAppBGOpacity";
NSString* const kTSNotificationAppearanceDimBackground = @"TSNotAppDimBG";
NSString* const kTSNotificationAppearanceTextColor = @"TSNotAppTextColor";
NSString* const kTSNotificationAppearanceTextFont = @"TSNotAppTextFont";
NSString* const kTSNotificationAppearanceTextSize = @"TSNotAppTextSize";
NSString* const kTSNotificationAppearanceMargin = @"TSNotAppMargin";
NSString* const kTSNotificationAppearancePosition = @"TSNotAppPosition";
NSString* const kTSNotificationAppearancePositionXOffset = @"TSNotAppPosXOffset";
NSString* const kTSNotificationAppearancePositionYOffset = @"TSNotAppPosYOffset";

// Helper to delegate callbacks from buttons
@interface TSAlertViewDelegate  : NSObject <UIAlertViewDelegate>

+(TSAlertViewDelegate*) sharedDelegate;
-(void) setCallbacksAccept:(ButtonCallback)accept andCancel:(ButtonCallback) cancel;

@end

@implementation TSNotifier

+(void) log:(NSString*) message{
    [self logWithTitle:APP_NAME message:message];
}
+(void) logWithTitle:(NSString*) title message:(NSString*) msg{
    if (!loggingEnabled || (nonEmpty(title) && nonEmpty(msg))) return;
    if (!nonEmpty(title) && !nonEmpty(msg))
        NSLog(@"%@ : %@", title, msg);
    else
        NSLog(@"%@", (nonEmpty(title) ? title : msg));
}
+(void) logMethod:(NSString *)method{
    [self logWithTitle:@"NOT IMPLEMENTED" message:method];
}

+(void) setLoggingEnabled:(BOOL)enabled{
    loggingEnabled = enabled;
}

/// Determines where to put text in main label or details label
+(void) setText:(NSString*) text withAppearance:(NSDictionary*)appearance forHUD:(MBProgressHUD*)hud onView:(UIView*) view{
    UIFont* font = [appearance objectForKey:kTSNotificationAppearanceTextFont];
    UIColor* color = [appearance objectForKey:kTSNotificationAppearanceTextColor];
    float offsetX = [[appearance objectForKey:kTSNotificationAppearancePositionXOffset] floatValue];
    float margin = [[appearance objectForKey:kTSNotificationAppearanceMargin] floatValue];
    float fontSize = [nonNull([appearance objectForKey:kTSNotificationAppearanceTextSize]) floatValue];
    font = (fontSize == 0 ? font : [font fontWithSize:fontSize]);
    if ([text sizeWithAttributes:@{NSFontAttributeName : font}].width < (view.frame.size.width - offsetX - 4 * margin)){
        hud.labelText = text;
        hud.labelFont = font;
        hud.labelColor = color;
        hud.detailsLabelText = nil;
    }
    else{
        hud.detailsLabelText = text;
        hud.detailsLabelFont = font;
        hud.detailsLabelColor = color;
        hud.labelText = nil;
    }
}

+(NSDictionary*) notificationAppearanceWithCustomValues:(NSDictionary*) custom{
    NSMutableDictionary* appearance = [NSMutableDictionary dictionaryWithDictionary:
        @{kTSNotificationAppearanceNotificationColor : colorARGB(220, 16, 16, 16),
          kTSNotificationAppearanceNotificationOpacity : @(0.8f),
          kTSNotificationAppearanceDimBackground : @(NO),
          kTSNotificationAppearanceTextColor : [UIColor whiteColor],
          kTSNotificationAppearanceTextSize : @(0),
          kTSNotificationAppearanceTextFont : [UIFont systemFontOfSize:16.0f],
          kTSNotificationAppearanceMargin : @(10.0f),
          kTSNotificationAppearancePosition : @(TS_NOTIFICATION_POSITION_BOTTOM_CENTER),
          kTSNotificationAppearancePositionXOffset : @(0),
          kTSNotificationAppearancePositionYOffset : @(30.0f)
        }];
    [appearance setValuesForKeysWithDictionary:custom];
    return appearance;
}

+(NSDictionary*) notificationErrorAppearanceWithCustomValues:(NSDictionary*) custom{
    NSMutableDictionary* appearance = [NSMutableDictionary dictionaryWithDictionary:[self notificationAppearanceWithCustomValues:custom]];
    [appearance setValuesForKeysWithDictionary:@{kTSNotificationAppearanceTextColor : colorRGB(180, 24, 24)}];
    [appearance setValuesForKeysWithDictionary:custom];
    return appearance;
}

+(void) setAppearance:(NSDictionary*) appearance forHUD:(MBProgressHUD*)hud onView:(UIView*) view{
    hud.dimBackground = [[appearance objectForKey:kTSNotificationAppearanceDimBackground] boolValue];
    hud.color = [appearance objectForKey:kTSNotificationAppearanceNotificationColor];
    hud.opacity = [[appearance objectForKey:kTSNotificationAppearanceNotificationOpacity] floatValue];
    hud.margin = [[appearance objectForKey:kTSNotificationAppearanceMargin] floatValue];
    float x = [[appearance objectForKey:kTSNotificationAppearancePositionXOffset] floatValue];
    float y = [[appearance objectForKey:kTSNotificationAppearancePositionYOffset] floatValue];
    [self setPostition:[[appearance objectForKey:kTSNotificationAppearancePosition] integerValue]
      withCustomOffset:CGPointMake(x, y)
                forHUD:hud
                onView:view];
}

+(void) setPostition:(TSNotificationPosition)position withCustomOffset:(CGPoint) offset forHUD:(MBProgressHUD*)hud onView:(UIView*) view{
    [hud layoutIfNeeded]; // layout to calculate hud size
    [hud setNeedsLayout];
    switch (position) {
        case TS_NOTIFICATION_POSITION_TOP_LEFT:
        case TS_NOTIFICATION_POSITION_TOP_CENTER:
        case TS_NOTIFICATION_POSITION_TOP_RIGHT:{
            hud.yOffset = -(view.frame.size.height - hud.size.height - offset.y) / 2;
            break;
        }
        default:
        case TS_NOTIFICATION_POSITION_CENTER_LEFT:
        case TS_NOTIFICATION_POSITION_CENTER_CENTER:
        case TS_NOTIFICATION_POSITION_CENTER_RIGHT: {
            hud.yOffset = offset.y;
            break;
        }
        case TS_NOTIFICATION_POSITION_BOTTOM_LEFT:
        case TS_NOTIFICATION_POSITION_BOTTOM_CENTER:
        case TS_NOTIFICATION_POSITION_BOTTOM_RIGHT: {
            hud.yOffset = (view.frame.size.height - hud.size.height - offset.y) / 2;
            break;
        }
    }
    switch (position) {
        case TS_NOTIFICATION_POSITION_TOP_LEFT:
        case TS_NOTIFICATION_POSITION_CENTER_LEFT:
        case TS_NOTIFICATION_POSITION_BOTTOM_LEFT:{
            hud.xOffset = -(view.frame.size.width - hud.size.width  - offset.x) / 2;
            break;
        }
        default:
        case TS_NOTIFICATION_POSITION_TOP_CENTER:
        case TS_NOTIFICATION_POSITION_CENTER_CENTER:
        case TS_NOTIFICATION_POSITION_BOTTOM_CENTER:
         {
            hud.xOffset = offset.x;
            break;
        }
        case TS_NOTIFICATION_POSITION_TOP_RIGHT:
        case TS_NOTIFICATION_POSITION_CENTER_RIGHT:
        case TS_NOTIFICATION_POSITION_BOTTOM_RIGHT: {
            hud.xOffset = (view.frame.size.width - hud.size.width  - offset.x) / 2;
            break;
        }
    }
}

@end


@implementation TSNotifier (Alerts)

+(void) alert:(NSString*) message{
    [self alert:message acceptButton:nil];
}
+(void) alert:(NSString *)message acceptButton:(NSString *)ok{
    [self alert:message acceptButton:ok acceptBlock:nil];
}
+(void) alert:(NSString *)message acceptButton:(NSString *)ok acceptBlock:(ButtonCallback)acceptBlock{
    [self alert:message acceptButton:ok acceptBlock:acceptBlock cancelButton:nil cancelBlock:nil];
}
+(void) alert:(NSString*) message acceptButton:(NSString*) ok acceptBlock:(ButtonCallback) acceptBlock cancelButton:(NSString*) cancel cancelBlock:(ButtonCallback) cancelBlock{
    [self alertWithTitle:APP_NAME message:message acceptButton:ok acceptBlock:acceptBlock cancelButton:cancel cancelBlock:cancelBlock];
}

+(void) alertWithTitle:(NSString*) title message: (NSString*) msg{
    [self alertWithTitle:title message:msg acceptButton:nil acceptBlock:nil];
}
+(void) alertWithTitle:(NSString *)title message:(NSString *)msg acceptButton:(NSString*) ok acceptBlock:(ButtonCallback) acceptBlock{
    [self alertWithTitle:title message:msg acceptButton:ok acceptBlock:acceptBlock cancelButton:nil cancelBlock:nil];
}
+(void) alertWithTitle:(NSString *)title message:(NSString *)msg acceptButton:(NSString*) ok acceptBlock:(ButtonCallback) acceptBlock cancelButton:(NSString*) cancel cancelBlock:(ButtonCallback) cancelBlock{
    [self logWithTitle:title message:msg];
    TSAlertViewDelegate* delegate = [TSAlertViewDelegate sharedDelegate];
    [delegate setCallbacksAccept:acceptBlock andCancel:cancelBlock];
    if (!ok) ok = @"OK";
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate: delegate cancelButtonTitle:cancel otherButtonTitles:ok, nil];
//    LMAlertView* alert = [[LMAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:cancel otherButtonTitles:ok, nil];
//    UILabel* label = ((UILabel*)[alert.contentView.subviews objectAtIndex:1]);
//    label.textAlignment = NSTextAlignmentCenter;
    [alert show];
}

+(void) alertWithTitle:(NSString*) title message:(NSString*) msg withAlignment:(NSTextAlignment) alignment acceptButton:(NSString*) ok acceptBlock:(ButtonCallback) acceptBlock cancelButton:(NSString*) cancel cancelBlock:(ButtonCallback) cancelBlock{
    [self logWithTitle:title message:msg];
    TSAlertViewDelegate* delegate = [TSAlertViewDelegate sharedDelegate];
    [delegate setCallbacksAccept:acceptBlock andCancel:cancelBlock];
    if (!ok) ok = @"OK";
    LMAlertView* alert = [[LMAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:cancel otherButtonTitles:ok, nil];
    ((UILabel*)[alert.contentView.subviews objectAtIndex:1]).textAlignment = alignment;
//    [[UIAlertView alloc] initWithTitle:title message:msg delegate: delegate cancelButtonTitle:cancel otherButtonTitles:ok, nil];
    
    [alert show];

}


+(void) alertError:(TSError *)error{
    [self alertError:error acceptButton:nil acceptBlock:nil];
}

+(void) alertError:(TSError*)error acceptButton:(NSString*)ok acceptBlock:(ButtonCallback) acceptBlock{
    [self alertError:error acceptButton:ok acceptBlock:acceptBlock cancelButton:nil cancelBlock:nil];
}
+(void) alertError:(TSError*)error acceptButton:(NSString*)ok acceptBlock:(ButtonCallback) acceptBlock cancelButton:(NSString*)cancel cancelBlock:(ButtonCallback) cancelBlock{
    if (!error.title || [error.title isEqualToString:@""])
        [self alertWithTitle:APP_NAME message:error.description acceptButton:ok acceptBlock:acceptBlock cancelButton:cancel cancelBlock:cancelBlock];
    else
        [self alertWithTitle:error.title message:error.description acceptButton:ok acceptBlock:acceptBlock cancelButton:cancel cancelBlock:cancelBlock];
}

@end

@implementation TSNotifier (Notifications)

+(void) notify:(NSString*) message{
    [self notify:message withAppearance:DEFAULT_APPEARANCE];
}
+(void) notify:(NSString*) message onView:(UIView*) view{
    [self notify:message withAppearance:DEFAULT_APPEARANCE onView:view];
}
+(void) notify:(NSString*) message timeInterval:(TSNotificationTimeInterval) time{
    [self notify:message withAppearance:DEFAULT_APPEARANCE timeInterval:time];
}
+(void) notify:(NSString*) message timeInterval:(TSNotificationTimeInterval) time onView:(UIView*) view{
    [self notify:message withAppearance:DEFAULT_APPEARANCE timeInterval:time onView:view];
}

+(void) notify:(NSString*) message withAppearance:(NSDictionary*)appearance{
    [self notify:message withAppearance:appearance onView:DEFAULT_VIEW];
}
+(void) notify:(NSString*) message withAppearance:(NSDictionary*)appearance onView:(UIView*) view{
    [self notify:message withAppearance:appearance timeInterval:DEFAULT_TIME_INTERVAL onView:view];
}
+(void) notify:(NSString*) message withAppearance:(NSDictionary*)appearance timeInterval:(TSNotificationTimeInterval) time{
    [self notify:message withAppearance:appearance timeInterval:time onView:DEFAULT_VIEW];
}
+(void) notify:(NSString*) message withAppearance:(NSDictionary*)appearance timeInterval:(TSNotificationTimeInterval) time onView:(UIView*) view{
    if (!view || !nonEmpty(message) || time <= 0) return;
    [self hideNotificationOnView:view];
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    appearance = [self notificationAppearanceWithCustomValues:appearance];
    [self setText:message withAppearance:appearance forHUD:hud onView:view];
    [self setAppearance:appearance forHUD:hud onView:view];
    [hud hide:YES afterDelay:time];
}

+(void) notifyError:(TSError*) error{
    [self notifyError:error withAppearance:DEFAULT_APPEARANCE];
}
+(void) notifyError:(TSError*) error onView:(UIView*) view{
    [self notifyError:error withAppearance:DEFAULT_APPEARANCE onView:view];
}
+(void) notifyError:(TSError*) error timeInterval:(TSNotificationTimeInterval) time{
    [self notifyError:error withAppearance:DEFAULT_APPEARANCE timeInterval:time onView:DEFAULT_VIEW];
}
+(void) notifyError:(TSError*) error timeInterval:(TSNotificationTimeInterval) time onView:(UIView*) view{
    [self notifyError:error withAppearance:DEFAULT_APPEARANCE timeInterval:time onView:view];
}

+(void) notifyError:(TSError*) error withAppearance:(NSDictionary*)appearance{
    [self notifyError:error withAppearance:appearance onView:DEFAULT_VIEW];
}
+(void) notifyError:(TSError*) error withAppearance:(NSDictionary*)appearance onView:(UIView*) view{
    [self notifyError:error withAppearance:appearance timeInterval:DEFAULT_TIME_INTERVAL onView:view];
}
+(void) notifyError:(TSError*) error withAppearance:(NSDictionary*)appearance timeInterval:(TSNotificationTimeInterval) time{
    [self notifyError:error withAppearance:appearance timeInterval:time onView:DEFAULT_VIEW];
}
+(void) notifyError:(TSError*) error withAppearance:(NSDictionary*)appearance timeInterval:(TSNotificationTimeInterval) time onView:(UIView*) view{
    appearance = [self notificationErrorAppearanceWithCustomValues:appearance];
    if (!error.title || [error.title isEqualToString:@""])
        [self notify:[NSString stringWithFormat: @"%@", error.description] withAppearance:appearance timeInterval:time onView:view];
    else
        [self notify:[NSString stringWithFormat: @"%@ : %@", error.title, error.description] withAppearance:appearance timeInterval:time onView:view];

}

+(void) hideNotification{
    [MBProgressHUD hideHUDForView:PRESENTED_VIEW animated:YES];
}
+(void) hideNotificationOnView:(UIView*) view{
    [MBProgressHUD hideHUDForView:view animated:YES];
}


@end

@implementation TSNotifier (ProgressBars)


+(void) showProgressOnView:(UIView*)view{
    [self showProgressWithMessage:DEFAULT_MESSAGE onView:view];
}

+(void) showProgressWithMessage:(NSString*)message{
    [self showProgressWithMessage:message withAppearance:DEFAULT_APPEARANCE];
}
+(void) showProgressWithMessage:(NSString*)message onView:(UIView*)view{
    [self showProgressWithMessage:message withAppearance:DEFAULT_APPEARANCE onView:view];
}
+(void) showProgressWithMessage:(NSString*)message withAppearance:(NSDictionary*)appearance{
    [self showProgressWithMessage:message withAppearance:appearance onView:DEFAULT_VIEW];
}
+(void) showProgressWithMessage:(NSString*)message withAppearance:(NSDictionary*)appearance onView:(UIView*)view{
    if (!view) return;
    [self hideNotificationOnView:view];
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    hud.removeFromSuperViewOnHide = YES;
}

+(void) hideProgress{
    [self hideProgressOnView:PRESENTED_VIEW];
}
+(void) hideProgressOnView:(UIView*)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end

@implementation TSAlertViewDelegate{
    ButtonCallback accept;
    ButtonCallback cancel;
}

+(instancetype) sharedDelegate{
    static TSAlertViewDelegate* delegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{delegate = [[self alloc] init];});
    return delegate;
}

-(void) setCallbacksAccept:(ButtonCallback)_accept andCancel:(ButtonCallback)_cancel{
    accept = _accept;
    cancel = _cancel;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.cancelButtonIndex){
        if (cancel)
            cancel();
        else
            [TSNotifier log:@"Cancel callback wasn't defined."];
    }
    else {
        if (accept)
            accept();
        else
            [TSNotifier log:@"Accept callback wasn't defined."];
    }
}

@end