//
//  ProfileCell.h
//  GitCat
//
//  Created by niko on 13-10-15.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"


@interface ProfileMetaCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *awesomeIcon;

@property (weak, nonatomic) IBOutlet UILabel *KeyLabel;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

-(void)setupCellWithIndexPath:(NSIndexPath*)indexPath forUser:(User*)user;

@end

@interface ProfileAvatarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;

@property (weak, nonatomic) IBOutlet UILabel *loginName;

@property (weak, nonatomic) IBOutlet UILabel *avatarName;

@end

