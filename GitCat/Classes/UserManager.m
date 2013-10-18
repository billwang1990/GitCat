//
//  UserManager.m
//  GitCat
//
//  Created by niko on 13-10-12.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "UserManager.h"
#import <objc/message.h>

static User *userSingleton = nil;

@implementation UserManager

+(void)setUserSingleton:(User *)user{
    userSingleton = [[User alloc]initWithData:user.data];
}

+(User *)shareUserSingleton
{
    return userSingleton;
}

@end
