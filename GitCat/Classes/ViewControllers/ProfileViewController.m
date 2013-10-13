//
//  ProfileViewController.m
//  GitCat
//
//  Created by niko on 13-10-12.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>

@interface ProfileViewController ()<UIAlertViewDelegate>

@property (nonatomic) MBProgressHUD *loadHud;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleAccessTokenSuccess:) name:ACCESSTOKEN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleAccessTokenFailed) name:ACCESSTOKEN_FAILED object:nil];

    self.title = @"Profile";
    
    [self.loadHud show:YES];
    [UserManager fetchUserInfoWithToken:[AccountDAO getAccessToken]];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MBProgressHUD *)loadHud
{
    if (!_loadHud) {
        _loadHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _loadHud.mode = MBProgressHUDAnimationFade;
        _loadHud.labelText = LOADING_MESSAGE;
    }
    return  _loadHud;
}

#pragma mark Handle AccessToken notification
-(void)handleAccessTokenSuccess:(NSNotification*)userInfo
{
    [self.loadHud hide:YES];
    
    User *user = (User*)userInfo.object;
    [UserManager setUserSingleton:user];
    
    NSString *account = [AppConfig getConfigValue:@"KeychainAccountName"];
    [SSKeychain setPassword:[user getLogin] forService:@"username" account:account];
    
}

-(void)handleAccessTokenFailed
{
    [self.loadHud hide:YES];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"认证失败" message:@"登录失败，需要重新登录Github！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate addLoginViewController];
    }
}

@end
