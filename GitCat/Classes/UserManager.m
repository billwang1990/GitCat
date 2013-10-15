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

+(void)fetchUserInfo
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];
    
    NSURL *userUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/%@", githubApiHost, [UserManager shareUserSingleton].getLogin]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:userUrl];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:userUrl.absoluteString parameters:[AccountDAO getAccessTokenParams]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];
         
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         User *user = [[User alloc] initWithData:json];
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"ProfileInfoFetched" object:user];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         DLog(@"%@", error);
                                     }];
    
    [operation start];
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
                                         DLog(@"%@", error);
                                         [[NSNotificationCenter defaultCenter] postNotificationName:ACCESSTOKEN_FAILED                                                                                             object:nil];
                                     }];
    
    [operation start];
}


- (void)fetchNewsFeedForPage:(int)page
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];
    
    NSURL *userReceivedEventsUrl = [NSURL URLWithString:[githubApiHost stringByAppendingFormat:@"/users/%@", [[UserManager shareUserSingleton] getLogin]]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:userReceivedEventsUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[AccountDAO getAccessTokenParams]];
    [params addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSString stringWithFormat:@"%i", page], @"page", nil]];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:@"received_events" parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];
         
         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         NSMutableArray *newsFeed = [[NSMutableArray alloc] initWithCapacity:0];
         NSDictionary *_data;
         
         for (int i=0; i < json.count; i++) {
             _data = [json objectAtIndex:i];
             id klass = [NSClassFromString([_data valueForKey:@"type"]) alloc];
             id obj = objc_msgSend(klass, sel_getUid("initWithData:"), _data);
             [newsFeed addObject:obj];
         }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsFeedFetched" object:newsFeed];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"%@", error);
                                     }];
    
    [operation start];
}

@end
