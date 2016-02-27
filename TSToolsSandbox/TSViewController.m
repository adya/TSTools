
#import "TSViewController.h"
#import "TSUtils.h"
#import "TSMenuManager.h"


@implementation TSViewController{
    UIBarButtonItem* _menuButton;
    NSString* _backButtonTitle;
}

@synthesize menuManager;


-(UIBarButtonItem*) menuButton{
    return _menuButton;
}

-(void) setMenuButton:(UIBarButtonItem *)menuBarItem{
    [_menuButton setAction:nil];
    [_menuButton setTarget:nil];
    _menuButton = menuBarItem;
    [_menuButton setTarget:self];
    [_menuButton setAction:@selector(menuButtonClick:)];
    self.navigationItem.rightBarButtonItem = _menuButton;
}

-(void) setMenuButtonWithTitle:(NSString*) title
{
    [self setMenuButton:[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil]];
}

-(void) setMenuButtonWithImage:(UIImage*) image{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [button addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self setMenuButton: barButton];
}

-(void) setBackButtonWithTitle:(NSString*) title
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}

-(void) setBackButtonWithImage:(UIImage*) image{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [button addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.backBarButtonItem = barButton;
}

-(void) setShowBackButton:(BOOL)showBackButton{
    self.navigationItem.hidesBackButton = !showBackButton;
}

-(BOOL) showBackButton{
    return !self.navigationItem || !self.navigationItem.hidesBackButton;
}

-(void) setShowMenuButton:(BOOL)showMenuButton{
    self.navigationItem.rightBarButtonItem = (showMenuButton ? _menuButton : nil);
}

-(BOOL) showMenuButton{
    return !self.navigationItem || self.navigationItem.rightBarButtonItem != nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0.0")) // set white color to nav. bar in ios6 and greater. (This will fix cases when nav bar has weird darker color.)
        self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    [self initMenu];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [menuManager toggleMenu:NO];
}

/// Method to support both iOS 7 and iOS 8
-(void) showSafeViewController:(UIViewController *)vc sender:(id)sender{
    if (SYSTEM_VERSION >= 8.0)
        [self showViewController:vc sender:sender];
    else 
        [self.navigationController pushViewController:vc animated:YES];
}

-(void) initMenu{
    menuManager = [[TSMenuManager alloc] initForViewController:self];
    [self initMenuButton];
}

-(void) initMenuButton{
    _menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonClick:)];
    self.navigationItem.rightBarButtonItem = _menuButton;
}

-(void) dismissKeyboard{
    [self.view endEditing:YES];
}

-(void) menuButtonClick:(id)sender{
    [menuManager toggleMenu];
}


@end
