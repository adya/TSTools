/**
 *  Author:     AdYa
 *  Version:    1.0
 *  iOS:        2.0+
 *  Date:       04/01/2016
 *  Status:     Completed
 *
 *  Dependency: @header TSStorage
 *
 *  Description:
 *
 *  TSLocalStorage conforms to TSStorage protocol and provides an interface to persistent local storage. As underlying storage it uses NSUserDefaults and therefore can store values between app launches.
 */

#import <Foundation/Foundation.h>
#import "TSStorage.h"


@interface TSLocalStorage : NSObject <TSStorage>

@end
