//
//  User.m
//  GitCat
//
//  Created by niko on 13-10-12.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "User.h"
#import "NSDate+RelativeDate.h"
#import "AppConfig.h"
#import "AccountDAO.h"
#import <AFHTTPClient.h>
#import <AFHTTPRequestOperation.h>
#import <objc/message.h>

@implementation User

- (id)initWithData:(NSDictionary *)userData
{
    self = [super init];
    _data = userData;
    return self;
}

- (NSString *)getAvatarUrl
{
    return [_data valueForKey:@"avatar_url"];
}

- (NSString *)getGravatarId
{
    return [_data valueForKey:@"gravatar_id"];
}

- (NSString *)getGistsUrl
{
    NSString *gistsUrl = [_data valueForKey:@"gists_url"];
    return [gistsUrl stringByReplacingOccurrencesOfString:@"{/gist_id}" withString:@""];
}

- (NSString *)getReceivedEventsUrl
{
    return [_data valueForKey:@"received_events_url"];
}

- (NSString *)getEventsUrl
{
    NSString *eventsUrl = [_data valueForKey:@"events_url"];
    return [eventsUrl stringByReplacingOccurrencesOfString:@"{/privacy}"
                                                withString:@""];
}

- (NSString *)getStarredUrl
{
    NSString *starredUrl = [_data valueForKey:@"starred_url"];
    return [starredUrl stringByReplacingOccurrencesOfString:@"{/owner}{/repo}"
                                                 withString:@""];
}

- (NSString *)getFollowingUrl
{
    NSString *followingUrl = [_data valueForKey:@"following_url"];
    return [followingUrl stringByReplacingOccurrencesOfString:@"{/other_user}"
                                                   withString:@""];
}

- (NSString *)getFollowersUrl
{
    return [_data valueForKey:@"followers_url"];
}

- (NSString *)getReposUrl
{
    return [_data valueForKey:@"repos_url"];
}

- (NSString *)getOrganizationsUrl
{
    return [_data valueForKey:@"organizations_url"];
}

- (NSString *)getSubscriptionsUrl
{
    return [_data valueForKey:@"subscriptions_url"];
}

- (NSString *)getLogin
{
    return [_data valueForKey:@"login"];
}

- (NSString *)getName
{
    if ([_data valueForKey:@"name"] == (id)[NSNull null]) return @"n/a";
    return [_data valueForKey:@"name"];
}

- (NSString *)getLocation
{
    if ([_data valueForKey:@"location"] == (id)[NSNull null]) return @"n/a";
    return [_data valueForKey:@"location"];
}

- (NSString *)getWebsite
{
    if ([_data valueForKey:@"blog"] == (id)[NSNull null]) return @"n/a";
    return [_data valueForKey:@"blog"];
}

- (NSString *)getEmail
{
    if ([_data valueForKey:@"email"] == nil) return @"n/a";
    if ([_data valueForKey:@"email"] == (id)[NSNull null]) return @"n/a";
    if ([[_data valueForKey:@"email"] isEqualToString:@""]) return @"n/a";
    return [_data valueForKey:@"email"];
}

- (NSInteger)getFollowers
{
    return [[_data valueForKey:@"followers"] integerValue];
}

- (NSInteger)getFollowing
{
    return [[_data valueForKey:@"following"] integerValue];
}

- (NSString *)getCompany
{
    if ([_data valueForKey:@"company"] == (id)[NSNull null]) return @"n/a";
    return [_data valueForKey:@"company"];
}

- (NSInteger)getNumberOfRepos
{
    return [[_data valueForKey:@"public_repos"] integerValue];
}

- (NSInteger)getNumberOfGists
{
    return [[_data valueForKey:@"public_gists"] integerValue];
}

- (NSString *)getCreatedAt
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
    NSDate *date  = [dateFormatter dateFromString:[_data valueForKey:@"created_at"]];
    
    return [date relativeDate];
}

- (NSString *)getHtmlUrl
{
    return [_data valueForKey:@"html_url"];
}


-(void)fetchUserInfo
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];
    
    NSURL *userUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/%@", githubApiHost, [self getLogin]]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:userUrl];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:userUrl.absoluteString parameters:[AccountDAO getAccessTokenParams]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];
         
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         User *user = [[User alloc] initWithData:json];
         
         [[NSNotificationCenter defaultCenter] postNotificationName:ProfileInfoFetched object:user];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         DLog(@"%@", error);
                                     }];
    
    [operation start];
}

+(void)fetchUserInfoWithToken:(NSString *)token
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


-(void)fetchNewsFeedForPage:(int)page
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];
    
    NSURL *userReceivedEventsUrl = [NSURL URLWithString:[githubApiHost stringByAppendingFormat:@"/users/%@", [self getLogin]]];
    
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
         NSDictionary *dicData;
         
         for (int i=0; i < json.count; i++) {
             dicData = [json objectAtIndex:i];
             
             id klass = [NSClassFromString([dicData valueForKey:@"type"]) alloc];
             
             id obj = objc_msgSend(klass, sel_getUid("initWithData:"), dicData);
             
             [newsFeed addObject:obj];
         }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:NewsFeedFetched object:newsFeed];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"%@", error);
                                     }];
    
    
    [operation start];
}


@end
