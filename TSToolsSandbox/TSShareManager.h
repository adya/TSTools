//
//  TSShareManager.h
//  GridironMoe
//
//  Created by Adya on 11/17/15.
//  Copyright (c) 2015 Ocusco Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString* const TSSocialShareFacebook;
extern NSString* const TSSocialShareTwitter;

@class TSError;

@protocol TSShareDelegate <NSObject>

-(NSString*) shareSocialMessageForService:(NSString*) service;

@optional -(void) onShareViewWillAppearWithService:(NSString*) service;
@optional -(void) onShareViewDidDisappearWithService:(NSString*) service shared:(BOOL) shared;
@optional -(void) onShareWithService:(NSString*) service failedWithError:(TSError*) error;

@end

@interface TSShareManager : NSObject


+(void) setShareSocialDelegate:(id<TSShareDelegate>) delegate;

+(void) shareWithService:(NSString*) service onViewController:(UIViewController*)viewController;

+(void) shareMessage:(NSString*) message withService:(NSString*) service onViewController:(UIViewController*)viewController;

+(void) shareMessage:(NSString*) message withImage:(UIImage*) image withService:(NSString*) service onViewController:(UIViewController*)viewController;

@end
