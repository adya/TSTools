
#import <Foundation/NSObject.h>
#import <Foundation/NSObjCRuntime.h>

#ifndef TSUtilsSystem_h
#define TSUtilsSystem_h

/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION

#define IPAddress [TSUtils getIPAddress]

#define iOSVersion [TSUtilsSystem systemVersion]
#define iOSEqual(v) [TSUtilsSystem systemVersionEqualTo:v]
#define iOSGreater(v) [TSUtilsSystem systemVersoinGreater:v]
#define iOSGreaterOrEqual(v) [TSUtilsSystem systemVersionGreaterOrEqual:v]
#define iOSLess(v) [TSUtilsSystem systemVersionLess:v]
#define iOSLessOrEqual(v) [TSUtilsSystem systemVersionLessOrEqual:v]

/*
 *  Device Size Classes Preprocessor Macros
 */

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#endif

@class NSString;

@interface TSUtilsSystem : NSObject

+(NSString*) getIPAddress;

+(NSString*) systemVersion;
+(NSComparisonResult) compareSystemVersionWith:(NSString*) version;
+(BOOL) systemVersionEqualTo:(NSString*) version;
+(BOOL) systemVersionGreater:(NSString*) version;
+(BOOL) systemVersionGreaterOrEqual:(NSString*) version;
+(BOOL) systemVersionLess:(NSString*) version;
+(BOOL) systemVersionLessOrEqual:(NSString*) version;


@end
