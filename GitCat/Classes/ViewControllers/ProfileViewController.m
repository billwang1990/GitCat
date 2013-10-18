//
//  ProfileViewController.m
//  GitCat
//
//  Created by niko on 13-10-12.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "ProfileMetaCell.h"
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>

@interface ProfileViewController ()<UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

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
    
    [self registerEvents];
    
    [self requestUserInfo];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchUserInfo:) name:ProfileInfoFetched object:nil];
}

-(void)requestUserInfo
{
    [self.loadHud show:YES];
    [[UserManager shareUserSingleton] fetchUserInfo];
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

#pragma mark NSNotification Method
-(void)fetchUserInfo:(NSNotification*)notify
{
    [self.loadHud hide:YES];
    
    self.user = notify.object;
    self.title = [self.user getLogin];
    
    [self.profileTable reloadData];
    
}

#pragma mark uitableviewdelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80.0f;
    }
    return 45.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        ProfileAvatarCell *avatar = [tableView dequeueReusableCellWithIdentifier:@"ProfileAvatarCell"];
        
        [avatar.avatarImg setImageWithURL:[NSURL URLWithString:[self.user getAvatarUrl]]];
        
        if ([self.user getName] == (id)[NSNull null] || [self.user getName] == nil) {
            avatar.avatarName.text = [self.user getLogin];
            avatar.loginName.hidden = YES;
        } else {
            avatar.avatarName.text  = [self.user getName];
            avatar.loginName.text = [self.user getLogin];
        }
        return avatar;
    }
    else
    {
        ProfileMetaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileMetaCell"];
        
        [cell setupCellWithIndexPath:indexPath forUser:self.user];
        
        return cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 13;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end
