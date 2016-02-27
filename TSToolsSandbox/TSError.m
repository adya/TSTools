
#import "TSError.h"

#define DEFAULT_ERROR_TITLE @"Unexpected error"
#define DEFAULT_ERROR_CODE TS_ERROR_UNCLASSIFIED
#define DEFAULT_ERROR_DESCRIPTION nil

@implementation TSError

@synthesize title, description, code, underlyingError;


- (TSError*) initWithCode:(NSInteger) errorCode{
    return [self initWithCode:errorCode andTitle:DEFAULT_ERROR_TITLE];
}
- (TSError*) initWithCode:(NSInteger) errorCode andTitle:(NSString*) errorTitle{
    return [self initWithCode:errorCode title:errorTitle andDescription:DEFAULT_ERROR_DESCRIPTION];
}
- (TSError*) initWithCode:(NSInteger) errorCode title:(NSString*) errorTitle andDescription:(NSString*) errorDescription{
    self = [self init];
    code = errorCode;
    title = errorTitle;
    description = errorDescription;
    return self;
}

- (TSError*) initWithTitle:(NSString*) errorTitle{
    return [self initWithCode:DEFAULT_ERROR_CODE andTitle:errorTitle];
}
- (TSError*) initWithDescription:(NSString*) errorDescription{
    return [self initWithTitle:DEFAULT_ERROR_TITLE andDescription:errorDescription];
}

- (TSError*) initWithTitle:(NSString*) errorTitle andDescription:(NSString*) errorDescription{
    return [self initWithCode:DEFAULT_ERROR_CODE title:errorTitle andDescription:errorDescription];
}

- (TSError*) initWithNSError:(NSError*) error{
    underlyingError = error;
    return [self initWithCode:error.code title:DEFAULT_ERROR_TITLE andDescription:error.localizedDescription];
}

+ (TSError*) errorWithCode:(NSInteger) code{
    return [self errorWithCode:code andTitle:DEFAULT_ERROR_TITLE];
}
+ (TSError*) errorWithCode:(NSInteger) code andTitle:(NSString*) title{
    return [self errorWithCode:code title:title andDescription:DEFAULT_ERROR_TITLE];
}
+ (TSError*) errorWithCode:(NSInteger) code title:(NSString*) title andDescription:(NSString*) description{
    return [[TSError alloc] initWithCode:code title:title andDescription:description];
}

+ (TSError*) errorWithTitle:(NSString*) title{
    return [[TSError alloc] initWithTitle:title];
}
+ (TSError*) errorWithDescription:(NSString*) description {
    return [[TSError alloc] initWithDescription:description];
}

+ (TSError*) errorWithTitle:(NSString*) title andDescription:(NSString*) description{
    return [[TSError alloc] initWithTitle:title andDescription:description];
}

+ (TSError*) errorWithNSError:(NSError*) error{
    return [[TSError alloc] initWithNSError:error];
}


@end
