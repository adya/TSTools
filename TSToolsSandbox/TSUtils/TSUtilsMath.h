

#ifndef TSUtils_Math
#define TSUtils_Math

/*
 * random shortcuts
 */

#define randomInRange(min, max) [TSUtilsMath randomFrom:min to:max]
#define random(max) [TSUtilsMath randomTo:max]
#define min(f,s) [TSUtilsMath minWithFirst:f andSecond:s]
#define max(f,s) [TSUtilsMath maxWithFirst:f andSecond:s]
#endif

#import <Foundation/NSObject.h>
#import <Foundation/NSRange.h>

@interface TSUtilsMath : NSObject

+(NSInteger) randomWithinRange:(NSRange) range;
+(NSInteger) randomFrom:(NSInteger)from to:(NSInteger)to;
+(NSInteger) randomTo:(NSInteger)to;

+(NSInteger) minWithFirst:(NSInteger) first andSecond:(NSInteger) second;
+(NSInteger) maxWithFirst:(NSInteger) first andSecond:(NSInteger) second;
@end
