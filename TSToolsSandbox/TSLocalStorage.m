#import "TSLocalStorage.h"

@interface TSLocalStorage()
@property (nullable) NSMutableDictionary<NSString*, id>* chainStorage;
@end

@implementation TSLocalStorage

@synthesize chainStorage;

+ (instancetype) sharedStorage{
    static id _storage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{_storage = [self new];});
    return _storage;
}

+ (NSMutableDictionary<NSString*, id>*) chainStorage {
    return [[self sharedStorage] chainStorage];
}

+(void) setChainStorage:(NSMutableDictionary<NSString*, id>*) storage{
    [[self sharedStorage] setChainStorage:storage];
}

+(void) saveObject:(id) object forKey:(NSString*) key {
    if ([self chainStorage])
        [[self chainStorage] setObject:object forKey:key];
    else{
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+(id) loadObjectForKey:(NSString*) key {
    if ([self chainStorage])
        return [[self chainStorage] objectForKey:key];
    else
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
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
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+(void) removeAllObjects {
    if ([self chainStorage])
        [[self chainStorage] removeAllObjects];
    else{
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+(BOOL) hasObjectForKey:(NSString *)key {
    return [self loadObjectForKey:key] != nil;
}

+(NSInteger) count {
    if ([self chainStorage])
        return [self chainStorage].count;
    else
        return [[NSUserDefaults standardUserDefaults] dictionaryRepresentation].count;
}

+(void) beginChainUpdate {
    [self setChainStorage:[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]]];
}
+(void) endChainUpdate {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:[self chainStorage] forName:appDomain];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setChainStorage:nil];
}

+(void) cancelChainUpdate {
    [self setChainStorage:nil];
}

@end
