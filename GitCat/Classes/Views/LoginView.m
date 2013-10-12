//
//  LoginView.m
//  GitCat
//
//  Created by niko on 13-10-11.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "LoginView.h"
#import "UIImage+uicolor.h"
#import "Authorization.h"
#import "AppConfig.h"
#import "YQkeychain.h"
#import <AFNetworking.h>
#import <SSKeychain.h>
#import <MBProgressHUD.h>

#define TEXTFILED_W 320
#define TEXTFILED_H 30

@interface LoginView()<UITextFieldDelegate>

@property (nonatomic) UITextField *nameFiled;
@property (nonatomic) UITextField *passwordField;
@property (nonatomic) UIButton *loginButton;
@property (nonatomic) NSMutableDictionary *oauthParams;
@property (nonatomic) MBProgressHUD *hud;

@end

@implementation LoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _oauthParams = [NSDictionary dictionaryWithObjectsAndKeys:[Authorization appScopes], @"scopes",  CLIENT_ID, @"client_id",
                        CLIENT_SECRET, @"client_secret",
                        nil];
        
        [self setupUI];
    }
    return self;
}

//Initialization UI
-(void)setupUI
{

    UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TEXTFILED_W, 200)];

    _nameFiled = [[UITextField alloc]initWithFrame:CGRectMake(10 , 0, TEXTFILED_W, TEXTFILED_H)];
    _nameFiled.delegate = self;
    _nameFiled.placeholder = @"请输入用户名";
    _nameFiled.borderStyle = UITextBorderStyleRoundedRect;
    [mainView addSubview:_nameFiled];
    
    _passwordField  = [[UITextField alloc]initWithFrame:CGRectMake(10 , 60, TEXTFILED_W, TEXTFILED_H)];
    _passwordField.delegate = self;
    _passwordField.placeholder = @"请输入密码";
    _passwordField.borderStyle = UITextBorderStyleRoundedRect;
    _passwordField.secureTextEntry = YES;
    [mainView addSubview:_passwordField];
    
    _loginButton = [[UIButton alloc]initWithFrame:CGRectMake(10 , 120, 100, TEXTFILED_H)];
    [_loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(clickLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [mainView addSubview:_loginButton];
    
    [self addSubview:mainView];
    _nameFiled.center = CGPointMake(mainView.center.x, _nameFiled.center.y);
    _passwordField.center = CGPointMake(mainView.center.x, _passwordField.center.y);
    _loginButton.center = CGPointMake(mainView.center.x, _loginButton.center.y);
    
    mainView.center = self.center;
}

-(MBProgressHUD *)hud
{
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        _hud.mode = MBProgressHUDAnimationFade;
        _hud.dimBackground = YES;
        
        _hud.labelText = LOADING_MESSAGE;
    }

    return _hud;
}


-(void)clickLogin:(id)sender
{
    NSString *username = [self.nameFiled text];
    NSString *password = [self.passwordField text];
    
    if (!username || !password) {
        return;
    }
    
    [self blurFields];
    [self authenticate];
}

#pragma mark TextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self clickLogin:nil];
    
    return YES;
}

- (void)blurFields
{
    if ([self.nameFiled isFirstResponder]) [self.nameFiled resignFirstResponder];
    if ([self.passwordField isFirstResponder]) [self.passwordField resignFirstResponder];
}

- (void)authenticate
{
    NSString *username = [self.nameFiled text];
    NSString *password = [self.passwordField text];
    
    [self.hud show:YES];
    
    NSURL *url = [NSURL URLWithString:[AppConfig getConfigValue:@"GithubApiHost"]];
        
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient setAuthorizationHeaderWithUsername:username password:password];
    
    NSMutableURLRequest *postRequest = [httpClient requestWithMethod:@"POST"
                                                                path:@"/authorizations"
                                                          parameters:self.oauthParams];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:postRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         
         [self.hud hide:YES];
         self.hud = nil;
         
         NSString *response = [operation responseString];
         
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         Authorization *authorization = [[Authorization alloc] initWithData:json];
         
         NSString *token = [authorization getToken];
         NSString *account = [AppConfig getConfigValue:@"KeychainAccountName"];
         
         // Delete old access_token and store new one
         [SSKeychain deletePasswordForService:@"access_token" account:account];
         [SSKeychain setPassword:token forService:@"access_token" account:account];
         
         if ([self.delegate respondsToSelector:@selector(loginSuccess)]) {
             [self.delegate performSelector:@selector(loginSuccess)];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self.hud hide:YES];
         self.hud = nil;
         
         NSString *err = [error localizedDescription];
         
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:err delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
         
         [alert show];
         
     }];
    
    [operation start];
}
@end
