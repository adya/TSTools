/**
 *  Author:     AdYa
 *  Version:    1.0
 *  iOS:        [2.0; 8.0)
 *  Date:       ../../2015
 *  Status:     Outdated, Undocumented
 *
 *  Dependency: @framework AFNetworking,
 *              @header TSNotifier
 *
 *  Description:
 *
 *  UIImageView Extension to provide animated loading for UIImageView.
 */

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
