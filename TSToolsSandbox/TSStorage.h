/**
 *  Author:     AdYa
 *  Version:    2.0
 *  iOS:        2.0+
 *  Date:       04/01/2015
 *  Status:     Completed
 *
 *  Description:
 *
 *  TSStorage provides set of methods to implement common way of saving values in different storages.
 */
#ifndef TS_STORAGE_H
#define TS_STORAGE_H

#import <Foundation/Foundation.h>

/**  */
@protocol TSStorage <NSObject>

/** Saves object in storage and associates it with given key.
 *  @param object Object to be saved.
 *  @param key Key which represents an object.
 */
+(void) saveObject:(nonnull id) object forKey:(nonnull NSString*) key;

/** Loads object associated with given key.
 *  @param key Key which represents an object.
 *  @return Returns object if any or nil.
 */
+(nullable id) loadObjectForKey:(nonnull NSString*) key;

/** Loads object associated with given key and if exists - removes it from storage. 
 *  @param key Key which represents an object.
 *  @return Returns object if any or nil.
 */
+(nullable id) popObjectForKey:(nonnull NSString*) key;

/** Removes object associated with specified key. 
 *  @param key Key which represents an object.
 */
+(void) removeObjectForKey:(nonnull NSString*) key;

/** Removes all objects from the storage. */
+(void) removeAllObjects;

/** Checks whether the object, associated with given key, exists in storage. 
 *  @param key Key which represents an object.
 *  @return Returns YES if object exists.
 */
+(BOOL) hasObjectForKey:(nonnull NSString*) key;

/** Number of stored objects.
 *  @return Returns number of stored objects.
 */
+(NSUInteger) count;

/** Begins a chain update. Chain update will not automatically synchronize storage until you call endChainUpdate. */
+(void) beginChainUpdate;

/** Ends a chain update and synchronizes all changes made to the storage with underlying storage. */
+(void) endChainUpdate;

/** Cancel a chain update and discards any changes made to the storage. */
+(void) cancelChainUpdate;

@end





#endif
