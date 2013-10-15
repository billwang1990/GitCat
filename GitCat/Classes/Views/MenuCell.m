//
//  MenuCell.m
//  GitCat
//
//  Created by niko on 13-10-11.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "MenuCell.h"
#import <FontAwesomeKit.h>

@implementation MenuCell

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

-(void)setupCellwithIndexPath:(NSIndexPath *)indexPath
{
    self.awesomeIcon.font = [FontAwesomeKit fontWithSize:20];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        self.awesomeIcon.text  = FAKIconRss;
        self.description.text = @"News Feed";
    }
}

@end
