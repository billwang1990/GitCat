//
//  NewsFeedCell.m
//  GitCat
//
//  Created by niko on 13-10-17.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "NewsFeedCell.h"
#import <FontAwesomeKit.h>

@implementation NewsFeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCell
{
    self.awesomeIcon.font = [FontAwesomeKit fontWithSize:20];
    self.awesomeIcon.text = [self.event getEventAwesomeIcon];
    
    self.actionDescription.attributedText = [self.event toString];
    
    self.actionDescription.text = [self.event getEventDate];
    
}

@end
