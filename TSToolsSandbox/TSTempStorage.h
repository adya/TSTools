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
 *  TSTempStorage conforms to TSStorage protocol and provides an interface to temporary local storage. As underlying storage it uses plain NSDictionary and stores values only during app running. Once app closes, all data will be lost.
 */
#import <Foundation/Foundation.h>
#import "TSStorage.h"

/** */
@interface TSTempStorage : NSObject <TSStorage>
@end