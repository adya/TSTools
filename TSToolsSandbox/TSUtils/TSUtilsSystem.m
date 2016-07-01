#import "TSUtilsSystem.h"
#import <UIKit/UIDevice.h>

#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/ioctl.h>


@implementation TSUtilsSystem

#pragma mark - System versioning
+(NSString*) systemVersion{
    return [UIDevice currentDevice].systemVersion;
}
+(NSComparisonResult) compareSystemVersionWith:(NSString*) version{
    return [[self systemVersion] compare:version options:NSNumericSearch];
}
+(BOOL) systemVersionEqualTo:(NSString*) version{
    return ([self compareSystemVersionWith:version] == NSOrderedSame);
}
+(BOOL) systemVersionGreater:(NSString*) version{
    return ([self compareSystemVersionWith:version] == NSOrderedDescending);
}
+(BOOL) systemVersionGreaterOrEqual:(NSString*) version{
    return ([self compareSystemVersionWith:version] != NSOrderedAscending);
}
+(BOOL) systemVersionLess:(NSString*) version{
    return ([self compareSystemVersionWith:version] == NSOrderedAscending);
}
+(BOOL) systemVersionLessOrEqual:(NSString*) version{
    return ([self compareSystemVersionWith:version] != NSOrderedDescending);
}

+(NSString*) getIPAddress{
    @try {
        // Set a string for the address
        NSString *ipAddress;
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
                        ipAddress = nil;
                    } else {
                        // Got the Cell IP Address
                        ipAddress = [NSString stringWithUTF8String:buf];
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
        if (!ipAddress || ipAddress.length <= 0) {
            // Empty, return not found
            return nil;
        }
        
        // Return the IP Address of the WiFi
        return ipAddress;
    }
    @catch (NSException *exception) {
        // Error, IP Not found
        return nil;
    }
}


@end
