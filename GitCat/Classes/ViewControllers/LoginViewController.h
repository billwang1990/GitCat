//
//  LoginViewController.h
//  GitCat
//
//  Created by niko on 13-10-11.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (copy) void(^completeBlock)(void);

@end
