//
//  TSMenuManager.m
//  CelcoinUsuario
//
//  Created by Adya on 7/2/15.
//  Copyright (c) 2015 Adya. All rights reserved.
//

#import "TSMenuManager.h"
#import "REMenu.h"

@implementation TSMenuManager{
    UIViewController* managedViewController;
    id itemsProvider;
}

@synthesize menu;

-(id) itemsProvider{
    return itemsProvider;
}

-(void) setItemsProvider:(id<TSMenuManagerItemsProvider>)_itemsProvider{
    itemsProvider = _itemsProvider;
    [self updateMenu];
}

-(id) initForViewController:(UIViewController *)viewController{
    self = [super init];
    managedViewController = viewController;
    return self;
}

-(void) toggleMenu{
    [self toggleMenu:!menu.isOpen];
}

-(void) toggleMenu:(BOOL)open{
    if (!open)
        [menu close];
    else
        [menu showFromNavigationController:managedViewController.navigationController];
}


-(void) updateMenu{
    if (itemsProvider)
        menu = [[REMenu alloc] initWithItems:[itemsProvider getMenuItemsForViewController:managedViewController]];
    else{
        menu = nil;
        NSLog(@"MenuItemsProvider wasn't set.");
    }
}
@end
