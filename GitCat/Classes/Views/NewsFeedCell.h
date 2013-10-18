//
//  NewsFeedCell.h
//  GitCat
//
//  Created by niko on 13-10-17.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineEvent.h"

@interface NewsFeedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *awesomeIcon;

@property (weak, nonatomic) IBOutlet UILabel *actionDescription;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic) TimeLineEvent *event;

-(void)setupCell;

@end
