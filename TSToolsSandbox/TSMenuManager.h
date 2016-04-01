/**
 *  Version:    1.0
 *  Author:     AdYa
 *  iOS:        6.0+
 *  Date:       ../../2015
 *  Status:     Outdated, Undocumented
 *
 *  Dependency: @framework REMenu
 *
 *  Description:
 *
 *  TSMenuManager provides easy way to implement dropdown REMenu, by utilizing REMenu library.
 *  In order to add this menu you'll need to follow these steps:
 *  1. Make desired view controller conform to TSMenuManagerItemsProvider and implement its' getMenuItemsForViewController: to provide menu items.
 *  2. Set itemsProvider property.
 *  3. Manage menu by toogleMenu methods.
 */

#import <Foundation/NSObject.h>

@class NSArray;
@class REMenu;
@class REMenuItem;
@class UIViewController;

@protocol TSMenuManagerItemsProvider

-(nonnull NSArray<REMenuItem*>*) getMenuItemsForViewController:(nonnull UIViewController*)controller;

@end

@interface TSMenuManager : NSObject

@property (weak, nullable) id<TSMenuManagerItemsProvider> itemsProvider;

@property (readonly, nonnull) REMenu* menu;

-(nonnull instancetype) initForViewController:(nonnull UIViewController*) viewController;
-(void) toggleMenu;
-(void) toggleMenu:(BOOL) open;
-(void) updateMenu;
@end
