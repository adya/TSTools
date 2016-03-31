/**
 *  Author:     Marin Todorov
 *  Version:    1.0
 *  iOS:        2.0+
 *  Date:       10/26/2011
 *  Status:     Outdated
 *
 *  Dependency: @framework AssetsLibrary
 *
 *  Description:
 *
 *  ALAssetsLibrary category to handle a custom photo album
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^SaveImageCompletion)(NSError* error);

@interface ALAssetsLibrary (CustomPhotoAlbum)

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;

-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;

@end