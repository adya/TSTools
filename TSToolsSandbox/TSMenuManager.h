//
//  TSMenuManager.h
//  CelcoinUsuario
//
//  Created by Adya on 7/2/15.
//  Copyright (c) 2015 Adya. All rights reserved.
//

#import <Foundation/Foundation.h>


// Usage guide:
// 1. Implement items provider.

@class REMenu;

@protocol TSMenuManagerItemsProvider

-(NSArray*) getMenuItemsForViewController:(UIViewController*)controller;

@end

@interface TSMenuManager : NSObject

@property (nonatomic, weak) id<TSMenuManagerItemsProvider> itemsProvider;

@property (readonly) REMenu* menu;

-(id) initForViewController:(UIViewController *)viewController;
-(void) toggleMenu;
-(void) toggleMenu:(BOOL) open;
-(void) updateMenu;
@end
