#import "TSAlert+Customization.h"
#import "LMAlertView.h"
#import "TSAlertProtected.h"

@implementation TSAlert (Customization)
+(void) alertWithTitle:(NSString*) title message:(NSString*) msg withAlignment:(NSTextAlignment) alignment acceptButton:(NSString*) ok acceptBlock:(TSAlertButtonCallback) acceptBlock cancelButton:(NSString*) cancel cancelBlock:(TSAlertButtonCallback) cancelBlock{
    TSAlertViewDelegate* delegate = [TSAlertViewDelegate sharedDelegate];
    [delegate setCallbacksAccept:acceptBlock andCancel:cancelBlock];
    if (!ok) ok = @"OK";
    //if (!cancel) cancel = @"Cancel";
    LMAlertView* alert = [[LMAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:cancel otherButtonTitles:ok, nil];
    ((UILabel*)[alert.contentView.subviews objectAtIndex:1]).textAlignment = alignment;
    [alert show];
    
}
@end
