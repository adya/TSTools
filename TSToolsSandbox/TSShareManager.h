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

-(NSString*) shareSocialMessageForService:(NSString*) service;

    ///TODO: Rename this like failed callback;
    /// And generally rework it.

@optional -(void) onShareViewWillAppearWithService:(NSString*) service;
@optional -(void) onShareViewDidAppearWithService:(NSString*) service;
@optional -(void) onShareViewDidDisappearWithService:(NSString*) service shared:(BOOL) shared;
@optional -(void) onShareSetupRequestWillAppearWithService:(NSString*) service;

@optional -(void) onShareSetupRequestWillDisappearWithService:(NSString*) service;
@optional -(void) onShareWithService:(NSString*) service failedWithError:(TSError*) error;

@end

@interface TSShareManager : NSObject


+(void) setShareSocialDelegate:(id<TSShareDelegate>) delegate;

+(void) shareWithService:(NSString*) service onViewController:(UIViewController*)viewController;

+(void) shareMessage:(NSString*) message withService:(NSString*) service onViewController:(UIViewController*)viewController;

+(void) shareMessage:(NSString*) message withImage:(UIImage*) image withService:(NSString*) service onViewController:(UIViewController*)viewController;

@end
