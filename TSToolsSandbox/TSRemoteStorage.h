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
 *  TSRemoteStorage conforms to TSStorage protocol and provides an interface to constant remote storage. It is similar to TSLocalStorage, but uses iCloud Key-Value storage as underlying storage, and therefore provides also sync throughout user's devices.
 *
 *  Note: Call connect and disconnect in AppDelegate didLaunch and willTerminate methods to observe changes in remote storage. And if you want to handle those updates, set update callback using setUpdateCallback: method.
 */

#import <Foundation/Foundation.h>
#import "TSStorage.h"

typedef void(^TSRemoteStorageUpdateCallback)();

@interface TSRemoteStorage : NSObject <TSStorage>

/** Connects to remote storage to receive notifications about updates. */
+(void) connect;

/** Disconnects from remote storage. */
+(void) disconnect;

/** Sets callback which will be fired every time remote storage will change. */
+(void) setUpdateCallback:(nullable TSRemoteStorageUpdateCallback) updateCallback;

@end

