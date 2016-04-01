/**
 *  Author:     AdYa
 *  Version:    1.0
 *  iOS:        6.0+
 *  Date:       ../../2015
 *  Status:     Outdated, Undocumented
 *
 *  Dependency: @framework Social,
 *              @header TSNotifier,
 *              @header TSUtils,
 *              @header TSError
 *
 *  Description:
 *
 *  TSShareManager utilizes Social framework to easily share info on common social networks.
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString* const TSSocialShareFacebook;
extern NSString* const TSSocialShareTwitter;

@class TSError;

@protocol TSShareDelegate <NSObject>

-(nonnull NSString*) messageForService:(nonnull NSString*) service;

    ///TODO: Rename this like failed callback;
    /// And generally rework it.

@optional -(void) onShareViewWillAppearWithService:(nonnull NSString*) service;
@optional -(void) onShareViewDidAppearWithService:(nonnull NSString*) service;
@optional -(void) onShareViewDidDisappearWithService:(nonnull NSString*) service shared:(BOOL) shared;
@optional -(void) onShareSetupRequestWillAppearWithService:(nonnull NSString*) service;

@optional -(void) onShareSetupRequestWillDisappearWithService:(nonnull NSString*) service;
@optional -(void) onShareWithService:(nonnull NSString*) service failedWithError:(nonnull TSError*) error;

@end

@interface TSShareManager : NSObject


+(void) setShareSocialDelegate:(nullable id<TSShareDelegate>) delegate;

+(void) shareWithService:(nonnull NSString*) service
        onViewController:(nonnull UIViewController*) viewController;

+(void) shareMessage:(nullable NSString*) message
         withService:(nonnull NSString*) service
    onViewController:(nonnull UIViewController*)viewController;

+(void) shareMessage:(nullable NSString*) message
           withImage:(nullable UIImage*) image
         withService:(nonnull NSString*) service
    onViewController:(nonnull UIViewController*)viewController;

@end
