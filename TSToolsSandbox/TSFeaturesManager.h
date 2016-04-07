/**
 *  Author:     AdYa
 *  Version:    1.0
 *  iOS:        2.0+
 *  Date:       04/04/2016
 *  Status:     Undocumented
 *
 *  Dependency:
 *
 *  Description:
 *
 *  TSFeaturesManager provides easy way to check availability of any "unlockable" features.
 */
#import <Foundation/Foundation.h>

typedef BOOL(^TSFeatureAvailabilityBlock)();

@interface TSFeaturesManager : NSObject

+(void) addFeature:(nonnull NSString*) name withAvailabilityBlock:(TSFeatureAvailabilityBlock _Nonnull) block;

+(BOOL) isAvailableFeature:(nonnull NSString*) name;

@end
