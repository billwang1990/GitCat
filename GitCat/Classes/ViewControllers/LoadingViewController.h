//
//  LoadingViewController.h
//  GitCat
//
//  Created by niko on 13-10-14.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "User.h"

@protocol LoadingViewcontrollerDelegate <NSObject>

-(void)loadingDataSuccess;

@end

@interface LoadingViewController : UIViewController

@property (nonatomic,weak) id<LoadingViewcontrollerDelegate> delegate;


@end
