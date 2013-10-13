//
//  LoginViewController.m
//  GitCat
//
//  Created by niko on 13-10-11.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"


@interface LoginViewController ()<LoginViewDelegate>

@property (nonatomic) LoginView *loginView;

@end

@implementation LoginViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.loginView = [[LoginView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.loginView.delegate = self;
    
    [self.view addSubview:self.loginView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark LoginSuccess
-(void)loginSuccess
{
    self.completeBlock();
}

@end
