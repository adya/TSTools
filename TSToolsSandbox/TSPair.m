//
//  TSPair.m
//  zoom-survey
//
//  Created by AdYa on 5/28/16.
//  Copyright © 2016 Whatever. All rights reserved.
//

#import "TSPair.h"

@implementation TSPair

-(instancetype) initWithValue:(id)value forKey:(id)key{
    self = [super init];
    if (self){
        _key = key;
        _value = value;
    }
    return self;
}
+(instancetype) pairWithValue:(id)value forKey:(id)key{
    return [[TSPair alloc] initWithValue:value forKey:key];
}


@end
