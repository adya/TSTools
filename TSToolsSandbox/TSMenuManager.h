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

-(NSArray<REMenuItem*>*) getMenuItemsForViewController:(UIViewController*)controller;

@end

@interface TSMenuManager : NSObject

@property (nonatomic, weak) id<TSMenuManagerItemsProvider> _Nullable itemsProvider;

@property (readonly) REMenu* _Nonnull menu;

-(nonnull id) initForViewController:(nonnull UIViewController*) viewController;
-(void) toggleMenu;
-(void) toggleMenu:(BOOL) open;
-(void) updateMenu;
@end
