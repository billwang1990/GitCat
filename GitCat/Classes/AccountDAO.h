//
//  AccountDAO.h
//  GitCat
//
//  Created by niko on 13-10-12.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SSKeychain.h>

//从keychain中获取相关数据
@interface AccountDAO : NSObject

+ (NSString *)getAccessToken;
+ (NSDictionary *)getAccessTokenParams;
+ (NSString *)getAccountUsername;
+ (NSString *)getDateFormat;

@end
