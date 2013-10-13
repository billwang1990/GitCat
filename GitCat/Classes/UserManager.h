//
//  UserManager.h
//  GitCat
//
//  Created by niko on 13-10-12.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPClient.h>
#import <AFHTTPRequestOperation.h>
#import "AccountDAO.h"
#import "User.h"
#import "AppConfig.h"

@interface UserManager : NSObject

+(void)setUserSingleton:(User*)user;

+(User*)shareUserSingleton;

+(void)fetchUserInfoWithToken:(NSString*)fetchInfoForUserWithToken;

@end
