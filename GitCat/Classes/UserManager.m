//
//  UserManager.m
//  GitCat
//
//  Created by niko on 13-10-12.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "UserManager.h"

static User *userSingleton = nil;

@implementation UserManager

+(void)setUserSingleton:(User *)user{
    userSingleton = [[User alloc]initWithData:user.data];
}

+(User *)shareUserSingleton
{
    return userSingleton;
}

+(void)fetchUserInfoWithToken:(NSString *)fetchInfoForUserWithToken
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];
    
    NSURL *userUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user", githubApiHost]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:userUrl];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                                                               path:userUrl.absoluteString
                                                         parameters:[AccountDAO getAccessTokenParams]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];
         
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         [[NSNotificationCenter defaultCenter] postNotificationName:ACCESSTOKEN_SUCCESS
                                                             object:[[User alloc] initWithData:json]];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"%@", error);
                                         [[NSNotificationCenter defaultCenter] postNotificationName:ACCESSTOKEN_FAILED                                                                                             object:nil];
                                     }];
    
    [operation start];
}


@end
