#pragma "Upgrade this to vesrion 2.0"
///TODO: Break TSUtils into separated categories or classes


#import "TSUtils.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/ioctl.h>

#define DATE_PATTERN @"(.*)-(.*)-(.*)T(.*):(.*):(.*)\\.(.*)"
#define REGEX_URL_PATTERN @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
#define REGEX_EMAIL_PATTERN @"^([A-Z0-9a-z._%+-]+)@((?:[A-Za-z0-9-]+)\\.)+([A-Za-z]{2,6})$"

@implementation TSUtils

+(NSString*) formatDateTime:(NSString*)dateTime{
    if (!dateTime) return nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:DATE_PATTERN options:0 error:nil];
    
    return [regex stringByReplacingMatchesInString:dateTime options:0 range:NSMakeRange(0, dateTime.length) withTemplate:[NSString stringWithFormat:@"%@-%@-%@ %@:%@",@"$2",@"$3",@"$1",@"$4",@"$5"]];
}

+(NSString*) formatToLocalFromUTCDateTime:(NSString*)dateTime{
    NSString* dTime = [self formatDateTime:dateTime];
    
    NSDateFormatter* df_utc = [NSDateFormatter new];
    [df_utc setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [df_utc setDateFormat:@"MM-dd-yyyy HH:mm"];
    
    NSDate* date = [df_utc dateFromString:dTime];
    
    NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
    [df_local setTimeZone:[NSTimeZone defaultTimeZone]];
    [df_local setDateFormat:@"MM-dd-yyyy HH:mm"];
    return [df_local stringFromDate:date];
}

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


+ (NSString *)trim:(NSString *)target{
    if (![TSUtils nonNull:target]) return nil;
    return [target stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+(NSString*) appName{
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString*)kCFBundleNameKey];
}

+(id) nonNull:(id)target{
    return ([[NSNull null] isEqual:target] ? nil : target);
}

+(NSString*) nonEmpty:(NSString*)targetString{
    return (targetString ? (targetString.length != 0 ? targetString : nil) : nil);
}

+(BOOL) isEmpty:(NSString *)targetString{
    return (!targetString || targetString.length == 0);
}

+(NSInteger) randomFrom:(NSInteger)from to:(NSInteger)to{
    if (from == to) return from;
    return arc4random() % ABS((to-from)) + from;
}

+(NSInteger) randomTo:(NSInteger)to{
    return [self randomFrom:0 to:to];
}

+(UIColor*) colorWithRed:(int)red green:(int)green blue:(int)blue{
    return [TSUtils colorWithRed:red green:green blue:blue alpha:255];
}

+(UIColor*) colorWithRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha{
    return [UIColor colorWithRed:((float)red)/255.0f green:((float)green)/255.0f blue:((float)blue)/255.0f alpha:((float)alpha)/255.0f];
}
+(UIColor*) colorWithHexString:(NSString *)hex{
    if (!hex) return [UIColor blackColor];
    if ([hex rangeOfString:@"#"].location == 0) // cut sharp-symbol "#"
        hex = [hex substringFromIndex:1];
    if (hex.length == 6) // append alpha channel 
        hex = [NSString stringWithFormat:@"FF%@", [hex uppercaseString]];
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    unsigned int argbValue;
    [scanner scanHexInt:&argbValue];
    return [self colorWithHex:argbValue];
}

+(UIColor*) colorWithHex:(unsigned int) hex{
    return [self colorWithRed:((hex & 0x00FF0000) >> 16)
                 green:((hex & 0x0000FF00) >> 8)
                 blue:((hex & 0x000000FF) >> 0)
                 alpha:((hex & 0xFF000000) >> 24)];
}


+ (BOOL) isValidURL: (NSString *) url {
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_URL_PATTERN];
    return [urlTest evaluateWithObject:url];
}

+ (BOOL) isValidEmail:(NSString*) email{
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_EMAIL_PATTERN];
    return [emailTest evaluateWithObject:email];
}

+ (NSString*) ordinalNumber:(NSInteger) number withFormat:(NSString*) format{
    NSInteger lastDigit = number % 10;
    NSString* suffix = @"";
    if (!format || format.length == 0)
        format = @"%d%@";
    switch (lastDigit) {
        case 1:
            suffix = @"st";
            break;
        case 2:
            suffix = @"nd";
            break;
        case 3:
            suffix = @"rd";
            break;
        default:
            suffix = @"th";
            break;
    }
    return [NSString stringWithFormat:format, number, suffix];
}

/// Returns string with number with delimeters
+ (NSString*) prettyNumber:(NSNumber*) number{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    [formatter setUsesGroupingSeparator:YES];
    return [formatter stringFromNumber:number];
}


+ (UIImage*) takeScreenshotOnView:(UIView*) view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(NSString*) getIPAddress{
    @try {
        // Set a string for the address
        NSString *IPAddress;
        // Set up structs to hold the interfaces and the temporary address
        struct ifaddrs *Interfaces;
        struct ifaddrs *Temp;
        struct sockaddr_in *s4;
        char buf[64];
        
        // If it's 0, then it's good
        if (!getifaddrs(&Interfaces))
        {
            // Loop through the list of interfaces
            Temp = Interfaces;
            
            // Run through it while it's still available
            while(Temp != NULL)
            {
                // If the temp interface is a valid interface
                if(Temp->ifa_addr->sa_family == AF_INET)
                {
                    // Check if the interface is Cell
//                    if([[NSString stringWithUTF8String:Temp->ifa_name] isEqualToString:@"pdp_ip0"])
//                    {
                        s4 = (struct sockaddr_in *)Temp->ifa_addr;
                        
                        if (inet_ntop(Temp->ifa_addr->sa_family, (void *)&(s4->sin_addr), buf, sizeof(buf)) == NULL) {
                            // Failed to find it
                            IPAddress = nil;
                        } else {
                            // Got the Cell IP Address
                            IPAddress = [NSString stringWithUTF8String:buf];
                        }
//                    }
                }
                
                // Set the temp value to the next interface
                Temp = Temp->ifa_next;
            }
        }
        
        // Free the memory of the interfaces
        freeifaddrs(Interfaces);
        
        // Check to make sure it's not empty
        if (IPAddress == nil || IPAddress.length <= 0) {
            // Empty, return not found
            return nil;
        }
        
        // Return the IP Address of the WiFi
        return IPAddress;
    }
    @catch (NSException *exception) {
        // Error, IP Not found
        return nil;
    }
}


@end
