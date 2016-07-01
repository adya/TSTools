//
//  TSUtils+NSDate.h
//  TSToolsSandbox
//
//  Created by AdYa on 6/19/16.
//  Copyright © 2016 AdYa G. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NSString;
@class NSDate;
@class NSTimeZone;

@interface TSUtilsDate : NSObject

+(NSDate*) dateFromUnixTimestamp:(double) timestamp;

+(NSString*) convertDate:(NSDate*)date toStringWithFormat:(NSString*) dateFormat;

+(NSString*) convertDate:(NSDate*)date toStringWithFormat:(NSString*) dateFormat withTimeZone:(NSTimeZone*) timezone;

+(NSDate*) convertString:(NSString*)date toDateWithFormat:(NSString*) dateFormat;

+(NSDate*) convertString:(NSString*)date toDateWithFormat:(NSString*) dateFormat withTimeZone:(NSTimeZone*) timezone;

+(NSString*) formatDateString:(NSString*) string withFormat:(NSString*)sourceFormat toFormat:(NSString*) destFormat;

+(NSString*) formatDateString:(NSString*) string withFormat:(NSString*)sourceFormat andTimeZone:(NSTimeZone*)sourceTimezone toFormat:(NSString*) destFormat andTimeZone:(NSTimeZone*)destTimezone;


@end
