//
//  TSShareManager.m
//  GridironMoe
//
//  Created by Adya on 11/17/15.
//  Copyright (c) 2015 Ocusco Corporation. All rights reserved.
//

#import "TSShareManager.h"
#import <Social/Social.h>
#import "TSUtils.h"
#import "TSNotifier.h"
#import "TSError.h"

NSString* const TSSocialShareFacebook = @"Facebook";
NSString* const TSSocialShareTwitter = @"Twitter";

@implementation TSShareManager{
    id<TSShareDelegate> shareSocialDelegate;
}

+ (instancetype) sharedManager{
    static TSShareManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{manager = [[self alloc] init];});
    return manager;
}

+(void) setShareSocialDelegate:(id<TSShareDelegate>)delegate{
    [[TSShareManager sharedManager] setShareSocialDelegate:delegate];
}

+(void) shareWithService:(NSString *)service onViewController:(UIViewController *)viewController{
    [[TSShareManager sharedManager] shareWithService:service onViewController:viewController];
}

+(void) shareMessage:(NSString *)message withService:(NSString *)service onViewController:(UIViewController *)viewController {
    [[TSShareManager sharedManager] shareMessage:message withService:service onViewController:viewController];
}

+(void) shareMessage:(NSString*) message withImage:(UIImage*) image withService:(NSString*) service onViewController:(UIViewController*)viewController {
    [[TSShareManager sharedManager] shareMessage:message withImage:image withService:service onViewController:viewController];
}


-(void) setShareSocialDelegate:(id<TSShareDelegate>)delegate{
    shareSocialDelegate = delegate;
}


- (void) shareWithService:(NSString*) service onViewController:(UIViewController*) viewController{
    NSString* msg;
    if ([shareSocialDelegate respondsToSelector:@selector(shareSocialMessageForService:)]){
        msg = [shareSocialDelegate shareSocialMessageForService:service];
    }
    else{
        NSLog([self.class description], @"Delegate doesn't define default sharing message");
    }
    [self shareMessage:msg withService:service onViewController:viewController];
}

-(void) shareMessage:(NSString *)message withService:(NSString *)service onViewController:(UIViewController *)viewController {
    [self shareMessage:message withImage:nil withService:service onViewController:viewController];
}

-(void) shareMessage:(NSString*) message withImage:(UIImage*) image withService:(NSString*) service onViewController:(UIViewController*)viewController{
    
    NSString* slType;
    if ([TSSocialShareFacebook isEqualToString:service])
        slType = SLServiceTypeFacebook;
    else if ([TSSocialShareTwitter isEqualToString:service])
        slType = SLServiceTypeTwitter;
    
    if (slType) {
        if (!message || message.length == 0) {
            NSLog([self.class description], @"Message can't be empty");
            if ([shareSocialDelegate respondsToSelector:@selector(onShareWithService:failedWithError:)])
                [shareSocialDelegate onShareWithService:service failedWithError:[TSError errorWithTitle:@"Share failed" andDescription:@"Message can't be empty"]];
            return;
        }
        if ([SLComposeViewController isAvailableForServiceType:slType]) {
            SLComposeViewController *shareSheet = [SLComposeViewController composeViewControllerForServiceType:slType];
            [shareSheet setInitialText:message];
            if (image) [shareSheet addImage:image];
            [shareSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                if ([shareSocialDelegate respondsToSelector:@selector(onShareViewDidDisappearWithService:shared:)])
                    [shareSocialDelegate onShareViewDidDisappearWithService:service shared:result == SLComposeViewControllerResultDone];
            }];
            
            if ([shareSocialDelegate respondsToSelector:@selector(onShareViewWillAppearWithService:)])
                [shareSocialDelegate onShareViewWillAppearWithService:service];
            [viewController presentViewController:shareSheet animated:YES completion:^{
                if ([shareSocialDelegate respondsToSelector:@selector(onShareViewDidAppearWithService:)])
                    [shareSocialDelegate onShareViewDidAppearWithService:service];
            }];
        }
        else
            [self requestSocialAccountSetup:service];
    }
    else{
        if ([shareSocialDelegate respondsToSelector:@selector(onShareWithService:failedWithError:)])
            [shareSocialDelegate onShareWithService:service failedWithError:[TSError errorWithTitle:@"Share failed" andDescription:@"Unknown service requested"]];
        NSLog([self.class description], @"Unknown service requested");
    }

}


-(void) requestSocialAccountSetup:(NSString*) social{
    float ios = SYSTEM_VERSION;
    BOOL autoOpenSettings = (ios >= 8.0);
    NSString* msg = [NSString stringWithFormat:@"%@ account was not setup", social];
    msg = [NSString stringWithFormat:@"%@. %@", msg, [NSString stringWithFormat:@"Please, go to Settings->%@ and login into your social account.", social]];
    NSString* accept = (autoOpenSettings ? @"Open Settings": @"Got it!");
    if ([shareSocialDelegate respondsToSelector:@selector(onShareSetupRequestWillAppearWithService:)])
        [shareSocialDelegate onShareSetupRequestWillAppearWithService:social];
    [TSNotifier alertWithTitle:[NSString stringWithFormat:@"Share %@", social]
                message:msg
                acceptButton:accept
                acceptBlock:^{
                    if ([shareSocialDelegate respondsToSelector:@selector(onShareSetupRequestWillDisappearWithService:)])
                        [shareSocialDelegate onShareSetupRequestWillDisappearWithService:social];
                    if (autoOpenSettings)
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    
                }
                cancelButton:@"Later"
                   cancelBlock:^{
                       if ([shareSocialDelegate respondsToSelector:@selector(onShareSetupRequestWillDisappearWithService:)])
                           [shareSocialDelegate onShareSetupRequestWillDisappearWithService:social];
                   }];
}

@end
