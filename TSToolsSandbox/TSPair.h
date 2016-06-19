/**
 *  Author:     AdYa
 *  Version:    1.0
 *  iOS:        2.0+
 *  Date:       06/02/2016
 *  Status:     New
 *
 *  Dependency: @framework AddressBook
 *
 *  Description:
 *
 *  TSPair is a single generic key-value pair.
 */

#import <Foundation/Foundation.h>

@interface TSPair <__covariant K, __covariant V> : NSObject

@property (readonly) K key;
@property (readonly) V value;

-(instancetype) initWithValue:(V) value forKey:(K) key;
+(instancetype) pairWithValue:(V) value forKey:(K) key;
@end
