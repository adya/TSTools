//
//  UIImageView+Animated.h
//  Midwest Ford
//
//  Created by Adya on 04/08/2014.
//  Copyright (c) 2014 Glar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@interface UIImageView (Animated)
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage animated:(BOOL) animated;
-(void) animateImage:(UIImage*)image forImageView:(UIImageView*) imageView;

-(void)setImageWithURL:(NSURL *)url
placeholderImage:(UIImage *)placeholderImage animated:(BOOL) animated
success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
               failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;
@end
