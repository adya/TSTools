#import "TSMenuManager.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "REMenu.h"

@implementation TSMenuManager{
    UIViewController* managedViewController;
    id itemsProvider;
}

@synthesize menu;

-(id<TSMenuManagerItemsProvider>) itemsProvider{
    return itemsProvider;
}

-(void) setItemsProvider:(id<TSMenuManagerItemsProvider>)_itemsProvider{
    itemsProvider = _itemsProvider;
    [self updateMenu];
}

-(instancetype) initForViewController:(UIViewController *)viewController{
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

-(NSMutableArray<REMenuItem*>*) getMenuItemsForViewController{
    NSMutableArray* arr = [NSMutableArray new];
    [arr addObject:@""];
    return arr;
}
@end
