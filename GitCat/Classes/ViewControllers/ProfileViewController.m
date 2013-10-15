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
    
    self.title = @"Profile";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
