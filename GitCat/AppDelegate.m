//
//  AppDelegate.m
//  GitCat
//
//  Created by niko on 13-10-11.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "ProfileViewController.h"
#import "NewsFeedViewController.h"
#import "LoginViewController.h"
#import <MMDrawerController.h>
#import <SSKeychain.h>

@interface AppDelegate ()<MenuDelegate>

@property (nonatomic) MMDrawerController *viewController;
@property (nonatomic) LoginViewController *LoginVC;
@property (nonatomic) MenuViewController *menuVC;
@property (nonatomic) UINavigationController *ProfileNav;
@property (nonatomic) UINavigationController *NewsFeedNav;
@property (nonatomic) UIStoryboard *storyboard;

//包含所有的子菜单控制器
@property (nonatomic) NSMutableArray *viewControllers;

@end

@implementation AppDelegate

#pragma mark MenuDelegate
-(void)clickItemAtIndex:(NSInteger)index
{
    [self.viewController setCenterViewController:[self.viewControllers objectAtIndex:index] withCloseAnimation:YES completion:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
#ifdef DEBUG
    [SSKeychain deletePasswordForService:@"access_token" account:@"gitos"];
#endif
   

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (![self readAccessTokenFromKeyChain]) {
        //should login
        [self addLoginViewController];
    }
    else
    {
        [self loadViewController];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)addLoginViewController
{
    self.LoginVC = [[LoginViewController alloc]init];
    
    __weak AppDelegate *weakSelf = self;
    
    [self.LoginVC setCompleteBlock:^{
        
        [weakSelf loadViewController];
    }];
    
    self.window.rootViewController = self.LoginVC;
    [self.window makeKeyAndVisible];
    
}

-(void)loadViewController
{
    self.storyboard = MainStoryBoard;
 
    self.menuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    self.menuVC.delegate = self;
    
    self.viewController = [[MMDrawerController alloc]initWithCenterViewController:self.ProfileNav leftDrawerViewController:self.menuVC];
    
    [self.viewController setMaximumRightDrawerWidth:200.0];
    [self.viewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.viewController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    //change the default rootviewcontroller;
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
}


-(BOOL)readAccessTokenFromKeyChain
{
    NSString *authToken = [SSKeychain passwordForService:@"access_token" account:@"gitos"];
    
    NSLog(@"authToken when app starts is %@", authToken);
    
    if (!authToken || authToken.length == 0) {
        return NO;
    }
    return YES;
}

//lazy loading
-(UINavigationController *)NewsFeedNav{
    if (!_NewsFeedNav) {
        NewsFeedViewController *newsFeed = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsFeedViewController"];
        _NewsFeedNav = [[UINavigationController alloc]initWithRootViewController:newsFeed];
    }
    
    return _NewsFeedNav;
}

-(UINavigationController *)ProfileNav
{
    if (!_ProfileNav) {
        ProfileViewController *profile = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        
        _ProfileNav = [[UINavigationController alloc]initWithRootViewController:profile];
    }
    
    return _ProfileNav;
}


-(NSMutableArray *)viewControllers
{
    if (!_viewControllers) {
        _viewControllers = [[NSMutableArray alloc]initWithCapacity:10];
        
        //profile
        [_viewControllers addObject:self.ProfileNav];
        
        //news feed v
        [_viewControllers addObject:self.NewsFeedNav];
        
    }
    return _viewControllers;
}


@end
