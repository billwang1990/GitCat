//
//  MenuViewController.m
//  GitCat
//
//  Created by niko on 13-10-11.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"


#define TableHeader_H 30

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark uitableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TableHeader_H;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TableHeader_H + 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 1, 300, TableHeader_H)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    headerLabel.textColor = [UIColor colorWithRed:179/255.0
                                            green:179/255.0
                                             blue:179/255.0
                                            alpha:1.0];
    
    headerLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14.0];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, TableHeader_H)];
    
    backgroundView.backgroundColor = [UIColor colorWithRed:49/255.0
                                                     green:49/255.0
                                                      blue:49/255.0
                                                     alpha:0.9];
    [backgroundView addSubview:headerLabel];
    
    return backgroundView;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headerTitle;
    
    switch (section) {
        case 0:
            headerTitle = @"Profile";
            break;
        case 1:
            headerTitle = @"News Feed";
            break;

    }
    
    return headerTitle;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows;
    
    switch (section) {
        case 0:
            rows = 1;
            break;
        case 1:
            rows = 1;
            break;
    }
    return rows;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profile"];
        
        if (!cell) {
            
            cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"profile"];
            
            cell.textLabel.text = @"profile";
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            return cell;
        }
    }
    else if(indexPath.section == 1)
    {
        MenuCell *cell = (MenuCell*)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
        [cell setupCellwithIndexPath:indexPath];
        
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(clickItemAtIndex:)]) {
        if (indexPath.section == 0) {
            [self.delegate clickItemAtIndex:0];
        }
        else if(indexPath.section == 1)
        {
            [self.delegate clickItemAtIndex:1];
        }
    }
}


@end
