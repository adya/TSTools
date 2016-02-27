//
//  TSRequestManagerImage.h
//  Mindless
//
//  Created by Adya on 1/22/16.
//  Copyright (c) 2016 LiveBird Mac Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSRequestManager.h"


@interface TSRequestManager (Images)
-(void) requestImageFromURL:(NSString*)url forImageView:(UIImageView*) imageView withPlaceholder:(UIImage*) placeholder success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                    failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;
-(void) requestImageFromURL:(NSString*)url forImageView:(UIImageView*) imageView withPlaceholder:(UIImage*) placeholder;
-(void) requestImageFromURL:(NSString*)url forImageView:(UIImageView*) imageView withPlaceholder:(UIImage*) placeholder animated:(BOOL)animated;
@end
