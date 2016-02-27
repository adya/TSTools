#ifndef TS_STORAGE_H
#define TS_STORAGE_H

#import <Foundation/Foundation.h>

// Best practice to use this storage:

// 1. Define your keys for this storage.
// 2. Feel free to use it.

@interface TSStorage : NSObject{
    NSMutableDictionary* values;
}

+ (instancetype) sharedStorage;

// Sets value for specified key.
-(void) putValue:(id)value forKey:(NSString*) key;

// Gets value for specified key.
-(id) getValueForKey:(NSString*) key;

// Gets value for specified key and removes it.
-(id) popValueForKey:(NSString*) key;

// Removes value for specified key.
-(void) removeValueForKey:(NSString*)key;
@end
#endif
