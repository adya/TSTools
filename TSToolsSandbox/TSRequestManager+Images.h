/**
 *  Author:     AdYa
 *  Version:    1.0
 *  iOS:        [2.0; 8.0)
 *  Date:       ../../2015
 *  Status:     Outdated, Undocumented
 *
 *  Dependency: @framework AFNetworking,
 *              @header TSUtils,
 *              @header TSError
 *
 *  Description:
 *
 *  TSRequestManager extension for neat way of loading images directly to UIImageView.
 */

#import <Foundation/Foundation.h>
#import "TSRequestManager.h"


@interface TSRequestManager (Images)

-(void) requestImageFromURL:(NSString*)url
               forImageView:(UIImageView*) imageView
            withPlaceholder:(UIImage*) placeholder
                    success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                    failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

-(void) requestImageFromURL:(NSString*)url
               forImageView:(UIImageView*) imageView
            withPlaceholder:(UIImage*) placeholder;

-(void) requestImageFromURL:(NSString*)url
               forImageView:(UIImageView*) imageView
            withPlaceholder:(UIImage*) placeholder
                   animated:(BOOL)animated;
@end
