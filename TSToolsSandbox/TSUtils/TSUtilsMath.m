#import "TSUtilsMath.h"
#import <Foundation/Foundation.h>

@implementation TSUtilsMath

+(NSInteger) randomWithinRange:(NSRange)range{
    return [self randomFrom:range.location to:(range.location + range.length)];
}

+(NSInteger) randomFrom:(NSInteger)from to:(NSInteger)to{
    if (from == to) return from;
    to = min(from, to);
    from = max(from, to);
    return arc4random() % ABS((to-from)) + from;
}

+(NSInteger) randomTo:(NSInteger)to{
    return [self randomFrom:0 to:to];
}

+(NSInteger) minWithFirst:(NSInteger)first andSecond:(NSInteger)second{
    return (first < second ? first : second);
}

+(NSInteger) maxWithFirst:(NSInteger)first andSecond:(NSInteger)second{
    return (first > second ? first : second);
}



@end
