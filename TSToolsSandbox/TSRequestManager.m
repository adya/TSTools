#import "TSRequestManager.h"
#import "TSError.h"
#import "AFHTTPSessionManager.h"
#import "TSUtils.h"

@interface TSRequestManager (DynamicHeaders)
    -(void) attachHeaders:(NSDictionary*) headers;
    -(void) detachHeaders:(NSDictionary*) headers;
@end

@implementation TSRequestManager


+ (id) sharedManager{
    static TSRequestManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{manager = [[self alloc] init];});
    return manager;
}

-(id) init{
    if (self = [super init]){
        [self initManager];
        [self prepareManager:afManager];
    }
    return self;
}

-(void) initManager{
    afManager = [AFHTTPSessionManager manager];
    afManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    afManager.securityPolicy.allowInvalidCertificates = YES;
    afManager.requestSerializer.timeoutInterval = [self getRequestTimeout];
    afManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self setAcceptTypes:@[@"image/png", @"image/jpeg"]];
    [self setContentTypes:@[@"image/png", @"image/jpeg"]];
}

-(NSString*) buildUrl:(NSString*) serverUrl andRequest:(NSString*) requestUrl{
   return [NSString stringWithFormat:@"%@/%@", serverUrl, requestUrl];
}

-(void) POST:(NSString*)requestUrl
        withBody:(NSDictionary*) body
        andHeaders:(NSDictionary*) headers
        successBlock:(SuccessBlock)success
        failureBlock:(FailureBlock) failure{
    NSString* url = [self buildUrl:[self getServerUrl] andRequest:requestUrl];
    [self attachHeaders:headers];
    [afManager POST:url parameters:body
            success:^(NSURLSessionTask *operation, id responseObject) {
                [self detachHeaders:headers];
                if (success){
                    success(operation, responseObject);
                }
            }
            failure:^(NSURLSessionTask *operation, NSError *error) {
                [self detachHeaders:headers];
                if (failure){
                    failure(operation, error);
                }
            }
     ];
}

-(void) GET:(NSString *)requestUrl
        withParameters:(NSDictionary*) params
        andHeaders:(NSDictionary*) headers
        successBlock:(SuccessBlock)success
        failureBlock:(FailureBlock)failure{
    NSString* url = [self buildUrl:[self getServerUrl] andRequest:requestUrl];
    [self attachHeaders:headers];
    [afManager GET:url parameters:params
           success:^(NSURLSessionTask *operation, id responseObject) {
        [self detachHeaders:headers];
        if (success){
            success(operation, responseObject);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [self detachHeaders:headers];
        if (failure){
            failure(operation, error);
        }
    }];
}

-(void) DELETE:(NSString*)requestUrl
    withBody:(NSDictionary*) body
  andHeaders:(NSDictionary*) headers
successBlock:(SuccessBlock)success
failureBlock:(FailureBlock) failure{
    NSString* url = [self buildUrl:[self getServerUrl] andRequest:requestUrl];
    [self attachHeaders:headers];
    [afManager DELETE:url parameters:body
            success:^(NSURLSessionTask *operation, id responseObject) {
                [self detachHeaders:headers];
                if (success){
                    success(operation, responseObject);
                }
            }
            failure:^(NSURLSessionTask *operation, NSError *error) {
                [self detachHeaders:headers];
                if (failure){
                    failure(operation, error);
                }
            }
     ];
}

-(void) POST:(NSString*)requestUrl
        withParameters:(NSDictionary*) parameters
        andData:(NSData*) fileData
        withFileNameAttribute:(NSDictionary*) fileName
        mimeType:(NSString*) mimeType
        andHeaders:(NSDictionary*) headers
        successBlock:(SuccessBlock)success
        failureBlock:(FailureBlock) failure{
    NSString* url = [self buildUrl:[self getServerUrl] andRequest:requestUrl];
    [self attachHeaders:headers];
    [afManager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString* fileNameParam = (fileName && fileName.count == 1 ? fileName.allKeys.firstObject : [self getFilesParamName]);
        NSString* fileNameValue = (fileName && fileName.count == 1 ? fileName.allValues.firstObject : [self getFilesParamName]);
        [formData appendPartWithFileData:fileData name:fileNameParam fileName:fileNameValue mimeType:mimeType];
    } success:^(NSURLSessionTask *operation, id responseObject) {
        if (success){
            success(operation, responseObject);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if (failure){
            failure(operation, error);
        }
    }];
}
@end

@implementation TSRequestManager (DynamicHeaders)

-(void) attachHeaders:(NSDictionary *)headers{
    for (id key in headers) {
        [self setValue:[headers objectForKey:key] forHeaderField:key];
    }
}
-(void) detachHeaders:(NSDictionary *)headers{
    for (id key in headers) {
        [self setValue:nil forHeaderField:key];
    }
}

@end

@implementation TSRequestManager (HelperMethods)

-(NSData*) formDataParams:(NSDictionary*) params{
    NSError* err;
    if (params == nil) return nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
    return jsonData;
}

-(void) setValue:(NSString *)value forHeaderField:(NSString *)header{
    [afManager.requestSerializer setValue: value forHTTPHeaderField:header];
}

-(void) setAcceptTypes:(NSArray *)types{
    NSString* tps = [types componentsJoinedByString:@", "];
    [self setValue:tps forHeaderField:@"Accept"];
    afManager.responseSerializer.acceptableContentTypes = [afManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:types];
}

-(void) setContentTypes:(NSArray *)types{
    NSString* tps = [types componentsJoinedByString:@", "];
    [self setValue:tps forHeaderField:@"Content-Type"];
}

-(TSError*) parseError:(NSDictionary*) errorResponse{
    TSError* err = [TSError errorWithCode:TS_ERROR_INTERNAL title:APP_NAME andDescription:errorResponse[[self getErrorMessageParamName]]];
    return err;
}

-(TSError*) parseNSError:(NSError*) error{
    return [TSError errorWithNSError:error];
}

-(id) getDataFromResponseObject:(id) rawResponse{
    NSString* name = [self getResponseParamName];
    if (name && name.length > 0)
        return [rawResponse objectForKey:name];
    else
        return rawResponse;
}

@end

@implementation TSRequestManager (DefaultConnectionProvider)

-(BOOL) isSuccessfulResponse:(NSDictionary*) response{
    AbstractMethod();
}

-(NSString*) getServerUrl{
    AbstractMethod();
}

-(NSString*) getErrorMessageParamName{
    AbstractMethod();
}

-(NSString*) getErrorCodeParamName{
    AbstractMethod();
}

-(NSString*) getResponseParamName{
    AbstractMethod();
}

-(NSString*) getFilesParamName{
    return nil;
}

-(NSTimeInterval) getRequestTimeout{
    return 30;
}

-(void) prepareManager:(AFHTTPSessionManager*) manager{}


@end