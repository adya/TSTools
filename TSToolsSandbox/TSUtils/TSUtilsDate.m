//
//  TSUtils+NSDate.m
//  TSToolsSandbox
//
//  Created by AdYa on 6/19/16.
//  Copyright © 2016 AdYa G. All rights reserved.
//

#import "TSUtilsDate.h"
#import <Foundation/NSString.h>
#import <Foundation/NSTimeZone.h>
#import <Foundation/NSDate.h>
#import <Foundation/NSDateFormatter.h>

@implementation TSUtilsDate

+(NSDate*) dateFromUnixTimestamp:(double) timestamp{
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

+(NSString*) convertDate:(NSDate*)date toStringWithFormat:(NSString*) dateFormat{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:dateFormat];
    return [formatter stringFromDate:date];
}
+(NSString*) convertDate:(NSDate*)date toStringWithFormat:(NSString*) dateFormat withTimeZone:(NSTimeZone*) timezone{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setTimeZone:timezone];
    [formatter setDateFormat:dateFormat];
    return [formatter stringFromDate:date];
}

+(NSDate*) convertString:(NSString*)date toDateWithFormat:(NSString*) dateFormat{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:dateFormat];
    return [formatter dateFromString:date];
}

+(NSDate*) convertString:(NSString*)date toDateWithFormat:(NSString*) dateFormat withTimeZone:(NSTimeZone*) timezone{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setTimeZone:timezone];
    [formatter setDateFormat:dateFormat];
    return [formatter dateFromString:date];
}

+(NSString*) formatDateString:(NSString*) string withFormat:(NSString*)sourceFormat toFormat:(NSString*) destFormat{
    NSDate* date = [self convertString:string toDateWithFormat:sourceFormat];
    if (!date) return nil;
    return [self convertDate:date toStringWithFormat:destFormat];
}
+(NSString*) formatDateString:(NSString*) string withFormat:(NSString*)sourceFormat andTimeZone:(NSTimeZone*)sourceTimezone toFormat:(NSString*) destFormat andTimeZone:(NSTimeZone*)destTimezone{
    NSDate* date = [self convertString:string toDateWithFormat:sourceFormat withTimeZone:sourceTimezone];
    if (!date) return nil;
    return [self convertDate:date toStringWithFormat:destFormat withTimeZone:destTimezone];
}

@end
