#import "TSUtils.h"
#import "TSAlert.h"
#import "LMAlertView.h"

#define DEFAULT_TITLE APP_NAME
#define DEFAULT_ACCEPT_BUTTON @"OK"
#define DEFAULT_CANCEL_BUTTON @"Cancel"

    // Helper to delegate callbacks from buttons
@interface TSAlertViewDelegate  : NSObject <UIAlertViewDelegate>

+(TSAlertViewDelegate*) sharedDelegate;
-(void) setCallbacksAccept:(TSAlertButtonCallback)accept andCancel:(TSAlertButtonCallback) cancel;

@end

@implementation TSAlert
+(void) alert:(NSString*) message{
    [self alert:message acceptButton:DEFAULT_ACCEPT_BUTTON];
}
+(void) alert:(NSString *)message acceptButton:(NSString *)ok{
    [self alert:message acceptButton:ok acceptBlock:NULL];
}
+(void) alert:(NSString *)message acceptButton:(NSString *)ok acceptBlock:(TSAlertButtonCallback)acceptBlock{
    [self alert:message acceptButton:ok acceptBlock:acceptBlock cancelButton:DEFAULT_CANCEL_BUTTON cancelBlock:NULL];
}
+(void) alert:(NSString*) message acceptButton:(NSString*) ok acceptBlock:(TSAlertButtonCallback) acceptBlock cancelButton:(NSString*) cancel cancelBlock:(TSAlertButtonCallback) cancelBlock{
    [self alertWithTitle:DEFAULT_TITLE message:message acceptButton:ok acceptBlock:acceptBlock cancelButton:cancel cancelBlock:cancelBlock];
}

+(void) alertWithTitle:(NSString*) title message: (NSString*) msg{
    [self alertWithTitle:title message:msg acceptButton:DEFAULT_ACCEPT_BUTTON acceptBlock:NULL];
}
+(void) alertWithTitle:(NSString *)title message:(NSString *)msg acceptButton:(NSString*) ok acceptBlock:(TSAlertButtonCallback) acceptBlock{
    [self alertWithTitle:title message:msg acceptButton:ok acceptBlock:acceptBlock cancelButton:DEFAULT_CANCEL_BUTTON cancelBlock:NULL];
}
+(void) alertWithTitle:(NSString *)title message:(NSString *)msg acceptButton:(NSString*) ok acceptBlock:(TSAlertButtonCallback) acceptBlock cancelButton:(NSString*) cancel cancelBlock:(TSAlertButtonCallback) cancelBlock{
    TSAlertViewDelegate* delegate = [TSAlertViewDelegate sharedDelegate];
    [delegate setCallbacksAccept:acceptBlock andCancel:cancelBlock];
    if (!ok) ok = @"OK";
        //if (!cancel) cancel = @"Cancel";
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate: delegate cancelButtonTitle:cancel otherButtonTitles:ok, nil];
    [alert show];
}

+(void) alertWithTitle:(NSString*) title message:(NSString*) msg withAlignment:(NSTextAlignment) alignment acceptButton:(NSString*) ok acceptBlock:(TSAlertButtonCallback) acceptBlock cancelButton:(NSString*) cancel cancelBlock:(TSAlertButtonCallback) cancelBlock{
    TSAlertViewDelegate* delegate = [TSAlertViewDelegate sharedDelegate];
    [delegate setCallbacksAccept:acceptBlock andCancel:cancelBlock];
    if (!ok) ok = @"OK";
        //if (!cancel) cancel = @"Cancel";
    LMAlertView* alert = [[LMAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:cancel otherButtonTitles:ok, nil];
    ((UILabel*)[alert.contentView.subviews objectAtIndex:1]).textAlignment = alignment;
    [alert show];
    
}


+(void) alertError:(TSError *)error{
    [self alertError:error acceptButton:nil acceptBlock:nil];
}

+(void) alertError:(TSError*)error acceptButton:(NSString*)ok acceptBlock:(TSAlertButtonCallback) acceptBlock{
    [self alertError:error acceptButton:ok acceptBlock:acceptBlock cancelButton:nil cancelBlock:nil];
}
+(void) alertError:(TSError*)error acceptButton:(NSString*)ok acceptBlock:(TSAlertButtonCallback) acceptBlock cancelButton:(NSString*)cancel cancelBlock:(TSAlertButtonCallback) cancelBlock{
    if (!error.title || [error.title isEqualToString:@""])
        [self alertWithTitle:APP_NAME message:error.description acceptButton:ok acceptBlock:acceptBlock cancelButton:cancel cancelBlock:cancelBlock];
    else
        [self alertWithTitle:error.title message:error.description acceptButton:ok acceptBlock:acceptBlock cancelButton:cancel cancelBlock:cancelBlock];
}

@end


@implementation TSAlertViewDelegate{
    TSAlertButtonCallback accept;
    TSAlertButtonCallback cancel;
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
