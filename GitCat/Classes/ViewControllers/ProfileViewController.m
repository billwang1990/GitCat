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
    
    [self handleAccessTokenFailed];
    
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

#pragma mark Handle AccessToken notification
-(void)handleAccessTokenSuccess:(NSNotification*)userInfo
{
    
}

-(void)handleAccessTokenFailed
{
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
