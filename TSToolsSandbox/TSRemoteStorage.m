#import "TSRemoteStorage.h"


@interface TSRemoteStorage()
@property (nullable) NSMutableDictionary<NSString*, id>* chainStorage;
@end

@implementation TSRemoteStorage{
    TSRemoteStorageUpdateCallback updateCallback;
}

@synthesize chainStorage;

+ (instancetype) sharedStorage{
    static id _storage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{_storage = [self new];});
    return _storage;
}

+(void) connect{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeDidChange:)
                                                 name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object:[NSUbiquitousKeyValueStore defaultStore]];
}

+(void) disconnect{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) setUpdateCallback:(TSRemoteStorageUpdateCallback)_updateCallback {
    updateCallback = _updateCallback;
}

+(void) setOnUpdateCallback:(TSRemoteStorageUpdateCallback)updateCallback {
    [[self sharedStorage] setUpdateCallback:updateCallback];
}

+ (NSMutableDictionary<NSString*, id>*) chainStorage {
    return [[self sharedStorage] chainStorage];
}

+(void) setChainStorage:(NSMutableDictionary<NSString*, id>*) storage{
    [[self sharedStorage] setChainStorage:storage];
}

-(void) storeDidChange:(NSNotification*) notification{
    if (updateCallback) updateCallback();
}

+(void) saveObject:(id) object forKey:(NSString*) key {
    if ([self chainStorage])
        [[self chainStorage] setObject:object forKey:key];
    else{
        [[NSUbiquitousKeyValueStore defaultStore] setObject:object forKey:key];
        [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    }
}

+(id) loadObjectForKey:(NSString*) key {
    if ([self chainStorage])
        return [[self chainStorage] objectForKey:key];
    else
        return [[NSUbiquitousKeyValueStore defaultStore] objectForKey:key];
}

+(id) popObjectForKey:(NSString*) key {
    id value = [self loadObjectForKey:key];
    if (value) [self removeObjectForKey:key];
    return value;
}

+(void) removeObjectForKey:(NSString *)key {
    if ([self chainStorage])
        [[[self sharedStorage] chainStorage] removeObjectForKey:key];
    else{
        [[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey:key];
        [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    }
}

+(void) removeAllObjects {
    if ([self chainStorage])
        [[self chainStorage] removeAllObjects];
    else{
        [self clearRemote];
    }
}

+(BOOL) hasObjectForKey:(NSString *)key {
    return [self loadObjectForKey:key] != nil;
}

+(NSUInteger) count {
    if ([self chainStorage])
        return [self chainStorage].count;
    else
        return [[NSUbiquitousKeyValueStore defaultStore] dictionaryRepresentation].count;
}

+(void) beginChainUpdate {
    [self setChainStorage:[NSMutableDictionary dictionaryWithDictionary:[[NSUbiquitousKeyValueStore defaultStore] dictionaryRepresentation]]];
}
+(void) endChainUpdate {
    [self clearRemote];
    [[NSUbiquitousKeyValueStore defaultStore] setValuesForKeysWithDictionary:[self chainStorage]];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    [self setChainStorage:nil];
}

+(void) cancelChainUpdate {
    [self setChainStorage:nil];
}

+(void) clearRemote{
    NSUbiquitousKeyValueStore *kvStore = [NSUbiquitousKeyValueStore defaultStore];
    NSArray<NSString*>* arr = [[kvStore dictionaryRepresentation] allKeys];
    for (int i=0; i < arr.count; i++){
        NSString *key = [arr objectAtIndex:i];
        [kvStore removeObjectForKey:key];
    }
    [kvStore synchronize];
}
@end
