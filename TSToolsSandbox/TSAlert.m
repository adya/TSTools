#import "TSAlert.h"
#import <UIKit/UIKit.h>
#import "TSAlertProtected.h"

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
+(void) alertWithTitle:(NSString *)title message:(NSString *)msg acceptButton:(NSString*) ok acceptBlock:(TSAlertButtonCallback) acceptBlock cancelButton:(NSString*) cancel cancelBlock:(TSAlertButtonCallback) cancelBlock {
    TSAlertViewDelegate* delegate = [TSAlertViewDelegate sharedDelegate];
    [delegate setCallbacksAccept:acceptBlock andCancel:cancelBlock];
    if (!ok) ok = DEFAULT_ACCEPT_BUTTON;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate: delegate cancelButtonTitle:cancel otherButtonTitles:ok, nil];
    [alert show];
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

-(void) setCallbacksAccept:(TSAlertButtonCallback)_accept andCancel:(TSAlertButtonCallback)_cancel{
    accept = _accept;
    cancel = _cancel;
}

-(void) alertView:(UIAlertView*) alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.cancelButtonIndex){
        if (cancel)
            cancel();
        else
            NSLog(@"Cancel callback wasn't defined.");
    }
    else {
        if (accept)
            accept();
        else
            NSLog(@"Accept callback wasn't defined.");
    }
}

@end
