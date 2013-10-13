//
//  MenuViewController.h
//  GitCat
//
//  Created by niko on 13-10-11.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuDelegate <NSObject>

-(void)clickItemAtIndex:(NSInteger)index;

@end

@interface MenuViewController : UITableViewController

@property (weak) id<MenuDelegate> delegate;


@end
