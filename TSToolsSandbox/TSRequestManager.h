
/** 
 * Dependency:    AFNetworking 3.0+
 *                TSError
 
 * Version:       1.5
 * Author:        AdYa
 * Last Modified: 02/27/16
 *
 * Description:
 *    TSRequestManager designed to speed up implementation of the API calls to the server.
 *
 *
 *   Therefore it has some restrictions and requirenments:
 *
 *   1. Subclass this interface. Do NOT use it directly.
 *
 *   2. You must implement all required methods of protocol "TSConnectionProvider" to provide connectivity with your server.
 *
 *   3. Set up your manager's headers (accept, content-types, timeout, etc.) by overriding prepareManager method.
 *   Note: you could override initManager to fully customize initialization. (But do it on your risk).
 *
 *   4. Declare your request methods and implement them using manager's methods POST, DELETE, etc.
 *
 *   5. For handling responses use predefined callback types (see below).
 **/

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;
@class TSError;

    /// Callbacks for different types of responses (void, object, array).

    /// Callback with only success acknowledgement or error.
typedef void(^OperationResponseCallback)(BOOL success, TSError* error);

    /// Callback with success acknowlesgement and either responsed object or error.
typedef void(^ObjectResponseCallback)(BOOL success, NSObject* object, TSError* error);

    /// Callback with success acknowlesgement and either responsed array or error.
typedef void(^ArrayResponseCallback)(BOOL success, NSArray* array, TSError* error);

    /// Shortcut for success handler block of AFNetworking request.
typedef void(^SuccessBlock)(NSURLSessionTask *operation, id responseObject);
    /// Shortcut for failure handler block of AFNetworking request.
typedef void(^FailureBlock)(NSURLSessionTask *operation, NSError* error);

    /// This protocol must be implemented in subclasses to provide connectivity with specific server.
@protocol TSConnectionProvider

    /// Returns base url of server api (thus not a whole url but just domain name).
@required -(NSString*) getServerUrl;

    /// Returns param name of the field with succesful response json-object.
@required -(NSString*) getResponseParamName;

    /// Returns param name of the field with error code.
@required -(NSString*) getErrorCodeParamName;

    /// Returns param name of the field with error message.
@required -(NSString*) getErrorMessageParamName;

    /// Checks whether the response is successful or not.
@required -(BOOL) isSuccessfulResponse:(NSDictionary*) response;

    /// Returns param name which contains attached files data.
@optional -(NSString*) getFilesParamName;

    /// Returns timeout given to all requests.
@optional -(NSTimeInterval) getRequestTimeout;

    /// Setup manager settings. (Headers, serialization, privacy, etc.).
@optional -(void) prepareManager:(AFHTTPSessionManager*) manager;
@end

@interface TSRequestManager : NSObject {
    AFHTTPSessionManager* afManager;
}

+ (id) sharedManager;

    /// simple POST with body params
-(void) POST:(NSString*)requestUrl
    withBody:(NSDictionary*) body
  andHeaders:(NSDictionary*) headers
successBlock:(SuccessBlock)success
failureBlock:(FailureBlock) failure;

    /// multipart POST with files.
-(void) POST:(NSString*)requestUrl
withParameters:(NSDictionary*) parameters
     andData:(NSData*) fileData
withFileNameAttribute:(NSDictionary*) fileName
    mimeType:(NSString*) mimeType
  andHeaders:(NSDictionary*) headers
successBlock:(SuccessBlock)success
failureBlock:(FailureBlock) failure;

-(void) GET:(NSString*) requestUrl
withParameters:(NSDictionary*) params
 andHeaders:(NSDictionary*) headers
successBlock:(SuccessBlock)success
failureBlock:(FailureBlock) failure;

-(void) DELETE:(NSString*)requestUrl
      withBody:(NSDictionary*) body
    andHeaders:(NSDictionary*) headers
  successBlock:(SuccessBlock)success
  failureBlock:(FailureBlock) failure;
@end

@interface TSRequestManager (HelperMethods)

-(void) setValue:(NSString*) value forHeaderField:(NSString*) header;
-(void) setAcceptTypes:(NSArray*) types;
-(void) setContentTypes:(NSArray*) types;
-(TSError*) parseError:(NSDictionary*) errorResponse;
-(TSError*) parseNSError:(NSError*) error;
-(id) getDataFromResponseObject:(id) rawResponse;
@end

@interface TSRequestManager (DefaultConnectionProvider) <TSConnectionProvider>
@end
