//
//  TSUtils.h
//
//  Created by Adya on 13/01/2015.
//  Copyright (c) 2015 Adya. All rights reserved.
//


#ifndef UTILS
#define UTILS

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 *  Replaces NSNull object with plain nil value.
 */

#define nonNull(value) [TSUtils nonNull:value]

#define nonEmpty(string) [TSUtils nonEmpty:string]

/*
 * random shortcuts
 */

#define randomInRange(min, max) [TSUtils randomFrom:min to:max]
#define random(max) [TSUtils randomTo:max]

/*
 *  NSString shortcuts
 */
#define trim(string) [TSUtils trim:string]


#define isValidURL(url) [TSUtils isValidURL:url]

/*
 * UIColor shortcuts with int values (255-base)
 */
#define colorARGB(a,r,g,b) [TSUtils colorWithRed:r green:g blue:b alpha:a]

#define colorRGB(r,g,b) [TSUtils colorWithRed:r green:g blue:b]

#define colorHexString(string) [TSUtils colorWithHexString:string]

#define colorHex(hex) [TSUtils colorWithHex:hex]

/*
 *  Shortuct to application name
 */
#define APP_NAME [TSUtils appName]

#define IP_ADDRESS [TSUtils getIPAddress]

/*
 * Marks method as abstract
 */
#define AbstractMethod() @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo:nil];

/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

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

@interface TSUtils : NSObject
+(NSString*) formatDateTime:(NSString*)dateTime DEPRECATED_MSG_ATTRIBUTE("Is under reconstruction.");
+(NSString*) formatToLocalFromUTCDateTime:(NSString*)dateTime DEPRECATED_MSG_ATTRIBUTE("Is under reconstruction.");

+(NSDate*) dateFromUnixTimestamp:(double) timestamp;

+(NSString*) convertDate:(NSDate*)date toStringWithFormat:(NSString*) dateFormat;

+(NSString*) convertDate:(NSDate*)date toStringWithFormat:(NSString*) dateFormat withTimeZone:(NSTimeZone*) timezone;

+(NSDate*) convertString:(NSString*)date toDateWithFormat:(NSString*) dateFormat;

+(NSDate*) convertString:(NSString*)date toDateWithFormat:(NSString*) dateFormat withTimeZone:(NSTimeZone*) timezone;

+(NSString*) formatDateString:(NSString*) string withFormat:(NSString*)sourceFormat toFormat:(NSString*) destFormat;

+(NSString*) formatDateString:(NSString*) string withFormat:(NSString*)sourceFormat andTimeZone:(NSTimeZone*)sourceTimezone toFormat:(NSString*) destFormat andTimeZone:(NSTimeZone*)destTimezone;

+(NSString*) trim:(NSString*) target;
+(BOOL) isValidURL:(NSString*) url;
+(BOOL) isValidEmail:(NSString*) email;

/// Returns string with ordinal format. Provide format with %d for number and %@ for suffix
+(NSString*) ordinalNumber:(NSInteger) number withFormat:(NSString*) format;
+(NSString*) prettyNumber:(NSNumber*) number;


/// Creates an image of the screen
+ (UIImage*) takeScreenshotOnView:(UIView*) view;

/// Shortuct to application name
+(NSString*) appName;

/// Replaces NSNull object with plain nil
+(id) nonNull:(id)target;

/// Replaces empty strings with plain nil
+(NSString*) nonEmpty:(NSString*)targetString;
+(BOOL) isEmpty:(NSString*) targetString;

+(NSInteger) randomFrom:(NSInteger)from to:(NSInteger)to;
+(NSInteger) randomTo:(NSInteger)to;

/// 255-base UIColor construuctor.
+(UIColor*) colorWithRed:(int) red green:(int) green blue:(int)blue;
+(UIColor*) colorWithRed:(int) red green:(int) green blue:(int)blue alpha:(int)alpha;
+(UIColor*) colorWithHexString:(NSString*) hexString;
+(UIColor*) colorWithHex:(unsigned int) hex;
+(NSString*) getIPAddress DEPRECATED_MSG_ATTRIBUTE("Will be moved to separate SystemManager.");
@end
