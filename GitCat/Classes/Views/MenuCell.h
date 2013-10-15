//
//  MenuCell.h
//  GitCat
//
//  Created by niko on 13-10-11.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *awesomeIcon;
@property (weak, nonatomic) IBOutlet UILabel *description;

-(void)setupCellwithIndexPath:(NSIndexPath*)indexPath;

@end
