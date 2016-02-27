#import "TSStorage.h"

@implementation TSStorage


+ (instancetype) sharedStorage{
    static TSStorage* storage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{storage = [[self alloc] init];});
    return storage;
}

-(id) init{
    self = [super init];
    if (self != nil){
        values = [NSMutableDictionary new];
    }
    return self;
}

-(void) putValue:(id)value forKey:(NSString *)key{
    [values setObject:value forKey:key];
}

-(id) getValueForKey:(NSString *)key{
    return [values objectForKey:key];
}

-(id) popValueForKey:(NSString *)key{
    id value = [self getValueForKey:key];
    [self removeValueForKey:key];
    return value;
}

-(void) removeValueForKey:(NSString *)key{
    [values removeObjectForKey:key];
}
@end
