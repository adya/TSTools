#import "TSLogger.h"

static BOOL loggingEnabled = YES;

@implementation TSLogger
+(void) log:(NSString*) message{
    [self logWithTitle:TS_LOG_TITLE_APP_NAME message:message];
}

+(void) logWithTitle:(NSString*) title message:(NSString*) msg{
    if (!loggingEnabled || (nonEmpty(title) && nonEmpty(msg))) return;
    if (!nonEmpty(title) && !nonEmpty(msg))
        NSLog(@"%@ : %@", title, msg);
    else
        NSLog(@"%@", (nonEmpty(title) ? title : msg));
}

+(void) setLoggingEnabled:(BOOL)enabled{
    loggingEnabled = enabled;
}
@end
