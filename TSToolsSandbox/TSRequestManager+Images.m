//
//  TSRequestManagerImage.m
//  Mindless
//
//  Created by Adya on 1/22/16.
//  Copyright (c) 2016 LiveBird Mac Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TSRequestManager+Images.h"
#import "UIImageView+AFNetworking.h"

@implementation TSRequestManager (Images)

-(void) requestImageFromURL:(NSString*)url forImageView:(UIImageView*) imageView withPlaceholder:(UIImage*) placeholder success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                    failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure{
    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
}

-(void) requestImageFromURL:(NSString*)url forImageView:(UIImageView*) imageView withPlaceholder:(UIImage*) placeholder{
    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
}

-(void) requestImageFromURL:(NSString*)url forImageView:(UIImageView*) imageView withPlaceholder:(UIImage*) placeholder animated:(BOOL)animated{
    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
}

@end
