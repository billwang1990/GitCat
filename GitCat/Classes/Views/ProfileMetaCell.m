//
//  ProfileCell.m
//  GitCat
//
//  Created by niko on 13-10-15.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "ProfileMetaCell.h"
#import <FontAwesomeKit.h>

@implementation ProfileMetaCell

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

-(void)setupCellWithIndexPath:(NSIndexPath *)indexPath forUser:(User *)user
{
    self.awesomeIcon.font = [FontAwesomeKit fontWithSize:20];
    NSString *labelText, *detailsText, *fontAwesome;
    
    if (indexPath.row == 1) {
        fontAwesome = FAKIconMapMarker;
        labelText   = @"Location";
        detailsText = [user getLocation] == (id)[NSNull null] ? @"n/a" : [user getLocation];
    } else if (indexPath.row == 2) {
        fontAwesome = FAKIconGlobe;
        labelText   = @"Website";
        detailsText = [user getWebsite] == (id)[NSNull null] ? @"n/a" : [user getWebsite];
    } else if (indexPath.row == 3) {
        fontAwesome = FAKIconEnvelope;
        labelText   = @"Email";
        detailsText = [user getEmail] == (id)[NSNull null] ? @"n/a" : [user getEmail];
    } else if (indexPath.row == 4) {
        fontAwesome = FAKIconBriefcase;
        labelText   = @"Company";
        detailsText = [user getCompany] == (id)[NSNull null] ? @"n/a" : [user getCompany];
    } else if (indexPath.row == 5) {
        fontAwesome = FAKIconGroup;
        labelText   = @"Followers";
        detailsText = [NSNumberFormatter localizedStringFromNumber:@([user getFollowers]) numberStyle:NSNumberFormatterDecimalStyle];
    } else if (indexPath.row == 6) {
        fontAwesome  = FAKIconGroup;
        labelText   = @"Following";
        detailsText = [NSNumberFormatter localizedStringFromNumber:@([user getFollowing]) numberStyle:NSNumberFormatterDecimalStyle];
    } else if (indexPath.row == 7) {
        fontAwesome = FAKIconFolderOpen;
        labelText   = @"Repos";
        detailsText = [NSString stringWithFormat:@"%i", [user getNumberOfRepos]];
    } else if (indexPath.row == 8) {
        fontAwesome = FAKIconCode;
        labelText   = @"Gists";
        detailsText = [NSString stringWithFormat:@"%i", [user getNumberOfGists]];
    } else if (indexPath.row == 9) {
        fontAwesome = FAKIconCalendar;
        labelText   = @"Joined";
        detailsText = [user getCreatedAt];
    } else if (indexPath.row == 10) {
        fontAwesome = FAKIconSitemap;
        labelText   = @"Organizations";
        detailsText = @"view all";
    } else if (indexPath.row == 11) {
        fontAwesome = FAKIconRss;
        labelText   = @"Recent Activity";
        detailsText = @"view all";
    } else if (indexPath.row == 12) {
        fontAwesome = FAKIconTrophy;
        labelText   = @"Contributions";
        detailsText = @"view all";
    }
    
    self.awesomeIcon.text = fontAwesome;
    self.KeyLabel.text = labelText;
    self.valueLabel.text = detailsText;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

@end

@implementation ProfileAvatarCell


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

@end

