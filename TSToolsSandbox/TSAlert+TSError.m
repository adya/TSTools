#import "TSAlert+TSError.h"
#import "TSError.h"
#import "TSUtils.h"

@implementation TSAlert (TSError)

+(void) alertError:(TSError *)error{
    [self alertError:error acceptButton:nil acceptBlock:nil];
}

+(void) alertError:(TSError*)error acceptButton:(NSString*)ok acceptBlock:(TSAlertButtonCallback) acceptBlock{
    [self alertError:error acceptButton:ok acceptBlock:acceptBlock cancelButton:nil cancelBlock:nil];
}
+(void) alertError:(TSError*)error acceptButton:(NSString*)ok acceptBlock:(TSAlertButtonCallback) acceptBlock cancelButton:(NSString*)cancel cancelBlock:(TSAlertButtonCallback) cancelBlock{
    if (!error.title || error.title.length == 0)
        [self alertWithTitle:APP_NAME message:error.description acceptButton:ok acceptBlock:acceptBlock cancelButton:cancel cancelBlock:cancelBlock];
    else
        [self alertWithTitle:error.title message:error.description acceptButton:ok acceptBlock:acceptBlock cancelButton:cancel cancelBlock:cancelBlock];
}

@end
