/**
 *  Author:     AdYa
 *  Version:    2.0
 *  iOS:        1.0+
 *  Date:       02/16/2016
 *  Status:     Updated
 *
 *  Dependency: None
 *
 *  Description:
 *
 *  TSError is a light-weighted NSError analog. Its' purpose is to gather user-presentable info.
 *  This means that you should not put any programming details here.
 *  Widely used in TSTools package to easily deliver presentable error message to user.
 *
 */

#import <Foundation/Foundation.h>


/** Pre-defined error codes. When defining custom error codes, please, use "TS_ERROR" prefix. */
#ifndef TS_ERRORS
#define TS_ERRORS

/** Represents any internal error, which was raised by bad usage of TSTools. */
#define TS_ERROR_INTERNAL -1

/** Default error, which hasn't got any category. */
#define TS_ERROR_UNCLASSIFIED 0

/** Represents error while processing purchases. */
#define TS_ERROR_PURCHASE 100

#endif

@interface TSError : NSObject

/** Describes error in short phrase. */
@property NSString* title;

/** 
 *  Contains error details and explanations for user.
 *  This means you should not put any programming details here. User-presentable info only.
 */
@property NSString* description;

/** 
 *  Contains error code identifying an error type.
 *  Usually used "behind the scenes" and isn't brought to user.
 */
@property NSInteger code;

/** In case TSError was used to wrap NSError object, this object will be stored here. */
@property NSError* underlyingError;

- (instancetype) initWithCode:(NSInteger) code;

- (instancetype) initWithCode:(NSInteger) code
                     andTitle:(NSString*) title;

- (instancetype) initWithCode:(NSInteger) code
                        title:(NSString*) title
               andDescription:(NSString*) description NS_DESIGNATED_INITIALIZER;

- (instancetype) initWithTitle:(NSString*) title;

- (instancetype) initWithDescription:(NSString*) description;

- (instancetype) initWithTitle:(NSString*) title
                andDescription:(NSString*) description;

/** Wraps NSError object. */
- (instancetype) initWithNSError:(NSError*) error;


+ (instancetype) errorWithCode:(NSInteger) code;

+ (instancetype) errorWithCode:(NSInteger) code
                      andTitle:(NSString*) title;

+ (instancetype) errorWithCode:(NSInteger) code
                         title:(NSString*) title
                andDescription:(NSString*) description;

+ (instancetype) errorWithTitle:(NSString*) title;

+ (instancetype) errorWithDescription:(NSString*) description;

+ (instancetype) errorWithTitle:(NSString*) title
                 andDescription:(NSString*) description;

/** Wraps NSError object. */
+ (instancetype) errorWithNSError:(NSError*) error;


@end
