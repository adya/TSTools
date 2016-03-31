#import "TSError.h"

#define DEFAULT_ERROR_TITLE @"Unexpected error"
#define DEFAULT_ERROR_CODE TS_ERROR_UNCLASSIFIED
#define DEFAULT_ERROR_DESCRIPTION nil

@implementation TSError

@synthesize title, description, code, underlyingError;

-(instancetype) init{
    return [self initWithCode:TS_ERROR_INTERNAL];
}

- (instancetype) initWithCode:(NSInteger) errorCode {
    return [self initWithCode:errorCode andTitle:DEFAULT_ERROR_TITLE];
}
- (instancetype) initWithCode:(NSInteger) errorCode andTitle:(NSString*) errorTitle{
    return [self initWithCode:errorCode title:errorTitle andDescription:DEFAULT_ERROR_DESCRIPTION];
}
- (instancetype) initWithCode:(NSInteger) errorCode title:(NSString*) errorTitle andDescription:(NSString*) errorDescription {
    self = [super init];
    code = errorCode;
    title = errorTitle;
    description = errorDescription;
    return self;
}

- (instancetype) initWithTitle:(NSString*) errorTitle{
    return [self initWithCode:DEFAULT_ERROR_CODE andTitle:errorTitle];
}
- (instancetype) initWithDescription:(NSString*) errorDescription{
    return [self initWithTitle:DEFAULT_ERROR_TITLE andDescription:errorDescription];
}

- (instancetype) initWithTitle:(NSString*) errorTitle andDescription:(NSString*) errorDescription{
    return [self initWithCode:DEFAULT_ERROR_CODE title:errorTitle andDescription:errorDescription];
}

- (instancetype) initWithNSError:(NSError*) error{
    underlyingError = error;
    return [self initWithCode:error.code title:DEFAULT_ERROR_TITLE andDescription:error.localizedDescription];
}

+ (instancetype) errorWithCode:(NSInteger) code{
    return [self errorWithCode:code andTitle:DEFAULT_ERROR_TITLE];
}
+ (instancetype) errorWithCode:(NSInteger) code andTitle:(NSString*) title{
    return [self errorWithCode:code title:title andDescription:DEFAULT_ERROR_TITLE];
}
+ (instancetype) errorWithCode:(NSInteger) code title:(NSString*) title andDescription:(NSString*) description{
    return [[TSError alloc] initWithCode:code title:title andDescription:description];
}

+ (instancetype) errorWithTitle:(NSString*) title{
    return [[TSError alloc] initWithTitle:title];
}
+ (instancetype) errorWithDescription:(NSString*) description {
    return [[TSError alloc] initWithDescription:description];
}

+ (instancetype) errorWithTitle:(NSString*) title andDescription:(NSString*) description{
    return [[TSError alloc] initWithTitle:title andDescription:description];
}

+ (instancetype) errorWithNSError:(NSError*) error{
    return [[TSError alloc] initWithNSError:error];
}


@end
