/**
 *  Author:     AdYa
 *  Version:    1.0
 *  iOS:        
 *  Date:       03/31/2016
 *  Status:     In Progress, Undocumented
 *
 *  Dependency: @header TSUtils
 *
 *  Description:
 *
 *  Formerly TSNotifier module.
 *
 *  TSLogger provides standardized way to log messages.
 */

#import <Foundation/Foundation.h>
#import "TSUtils.h"

#define TS_LOG_TITLE_ERROR @"Error"
#define TS_LOG_TITLE_NOT_IMPLEMENTED @"Not Implemented"
#define TS_LOG_TITLE_CLASS(obj) NSStringFromClass([obj class])
#define TS_LOG_TITLE_APP_NAME APP_NAME

@interface TSLogger : NSObject
+(void) log:(nonnull NSString*) message;
+(void) logWithTitle:(nonnull NSString*) title message:(nonnull NSString*) msg;

+(void) setLoggingEnabled:(BOOL) enabled;
@end
