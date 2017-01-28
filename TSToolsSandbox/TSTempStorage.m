#import "TSTempStorage.h"

@interface TSTempStorage()
@property (nonnull) NSMutableDictionary<NSString*, id>* storage;
@property (nullable) NSMutableDictionary<NSString*, id>* chainStorage;
@end

@implementation TSTempStorage

@synthesize storage, chainStorage
;

+ (NSMutableDictionary<NSString*, id>*) chainStorage {
    return [[self sharedStorage] chainStorage];
}

+(void) setChainStorage:(NSMutableDictionary<NSString*, id>*) storage{
    [[self sharedStorage] setChainStorage:storage];
}


+ (instancetype) sharedStorage{
    static TSTempStorage* _storage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{_storage = [self new];});
    return _storage;
}

-(id) init{
    self = [super init];
    if (self != nil){
        storage = [NSMutableDictionary new];
    }
    return self;
}

+(void) saveObject:(id) object forKey:(NSString*) key {
    if ([self chainStorage])
        [[self chainStorage] setObject:object forKey:key];
    else
        [[[self sharedStorage] storage] setObject:object forKey:key];
    
}

+(id) loadObjectForKey:(NSString*) key {
    if ([self chainStorage])
        return [[self chainStorage] objectForKey:key];
    else
        return [[[self sharedStorage] storage] objectForKey:key];
}

+(id) popObjectForKey:(NSString*) key {
    id value = [self loadObjectForKey:key];
    if (value) [self removeObjectForKey:key];
    return value;
}

+(void) removeObjectForKey:(NSString *)key {
    if ([self chainStorage])
        [[[self sharedStorage] chainStorage] removeObjectForKey:key];
    else
        [[[self sharedStorage] storage] removeObjectForKey:key];
}

+(void) removeAllObjects {
    if ([self chainStorage])
        [[self chainStorage] removeAllObjects];
    else
        [[[self sharedStorage] storage] removeAllObjects];
}

+(BOOL) hasObjectForKey:(NSString *)key {
    return [self loadObjectForKey:key] != nil;
}

+(NSInteger) count {
    if ([self chainStorage])
        return [self chainStorage].count;
    else
        return [[self sharedStorage] storage].count;
}

+(void) beginChainUpdate {
    [self setChainStorage:[NSMutableDictionary dictionaryWithDictionary:[[self sharedStorage] storage]]];
}
+(void) endChainUpdate {
    [[self sharedStorage] setStorage:[NSMutableDictionary dictionaryWithDictionary:[self chainStorage]]];
}
+(void) cancelChainUpdate {
    [self setChainStorage:nil];
}

@end

