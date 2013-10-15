//
//  ProfileViewController.h
//  GitCat
//
//  Created by niko on 13-10-12.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "User.h"

@interface ProfileViewController : UIViewController

@property (nonatomic) User *user;

@property (weak, nonatomic) IBOutlet UITableView *profileTable;

@end
