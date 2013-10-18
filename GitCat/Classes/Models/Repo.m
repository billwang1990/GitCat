//
//  Repo.m
//  GitCat
//
//  Created by niko on 13-10-17.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "Repo.h"
#import "AppConfig.h"
#import "AccountDAO.h"
#import <AFHTTPClient.h>
#import <AFHTTPRequestOperation.h>
#import "NSDate+RelativeDate.h"

@implementation Repo
- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        
        _data = data;
    }

    return self;
}

- (NSString *)getName
{
    return [_data valueForKey:@"name"];
}

- (NSString *)getFullName
{
    NSString *fullName = [_data valueForKey:@"full_name"];
    
    if (fullName == (id)[NSNull null] || fullName.length == 0) {
        NSString *owner = [_data valueForKey:@"owner"];
        return [owner stringByAppendingString:[self getName]];
    }
    
    return fullName;
}

- (NSInteger)getForks
{
    return [[_data valueForKey:@"forks"] integerValue];
}

- (NSInteger)getWatchers
{
    return [[_data valueForKey:@"watchers"] integerValue];
}

- (NSString *)getLanguage
{
    if ([_data valueForKey:@"language"] == (id)[NSNull null]) return @"n/a";
    return [_data valueForKey:@"language"];
}

- (NSString *)getBranchesUrl
{
    NSString *url = [_data valueForKey:@"url"];
    
    if (url == (id)[NSNull null] || url.length == 0) {
        NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];
        NSString *owner = [_data valueForKey:@"owner"];
        url = [githubApiHost stringByAppendingFormat:@"/repos/%@/%@", owner, [self getName]];
    }
    
    return [url stringByAppendingFormat:@"/branches"];
}

- (NSString *)getTreeUrl
{
    NSString *url = [_data valueForKey:@"url"];
    
    if (url == (id)[NSNull null] || url.length == 0) {
        NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];
        NSString *owner = [_data valueForKey:@"owner"];
        url = [githubApiHost stringByAppendingFormat:@"/repos/%@/%@", owner, [self getName]];
    }
    
    return [url stringByAppendingFormat:@"/git/trees/"];
}

- (NSInteger)getSize
{
    return [[_data valueForKey:@"size"] integerValue];
}

- (NSString *)getPushedAt
{
    return [_data valueForKey:@"pushed_at"];
}

- (NSString *)getDescription
{
    if ([_data valueForKey:@"description"] == (id)[NSNull null]) return @"n/a";
    return [_data valueForKey:@"description"];
}

- (NSString *)getHomepage
{
    if ([_data valueForKey:@"homepage"] == (id)[NSNull null]) return @"n/a";
    if ([[_data valueForKey:@"homepage"] length] == 0) return @"n/a";
    return [_data valueForKey:@"homepage"];
}

- (NSInteger)getOpenIssues
{
    return [[_data valueForKey:@"open_issues"] integerValue];
}

- (NSString *)getIssuesUrl
{
    return [[_data valueForKey:@"issues_url"] stringByReplacingOccurrencesOfString:@"{/number}" withString:@""];
}

- (NSString *)getCommitsUrl
{
    return [[_data valueForKey:@"commits_url"] stringByReplacingOccurrencesOfString:@"{/sha}" withString:@""];
}

- (NSString *)getAuthorName
{
    if ([_data valueForKey:@"owner"] != (id)[NSNull null]) {
        if ([[_data valueForKey:@"owner"] isKindOfClass:[NSDictionary class]]) {
            return [[_data valueForKey:@"owner"] valueForKey:@"login"];
        } else {
            return [_data valueForKey:@"owner"];
        }
    } else if ([_data valueForKey:@"username"]) {
        return [_data valueForKey:@"username"];
    } else {
        return @"";
    }
}

- (NSString *)getCreatedAt
{
    return [self convertToRelativeDate:[_data valueForKey:@"created_at"]];
}

- (NSString *)getUpdatedAt
{
    return [self convertToRelativeDate:[_data valueForKey:@"updated_at"]];
}

- (NSString *)convertToRelativeDate:(NSString *)originalDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
    NSDate *date  = [dateFormatter dateFromString:originalDateString];
    
    return [date relativeDate];

}

- (NSString *)getOwner
{
    return [_data valueForKey:@"owner"];
}

- (BOOL)hasIssues
{
    return [[_data valueForKey:@"has_issues"] boolValue];
}

- (BOOL)isForked
{
    return [[_data valueForKey:@"fork"] integerValue] == 1;
}

- (BOOL)isPrivate
{
    return [[_data valueForKey:@"private"] integerValue] == 1;
}

- (NSString *)getUrl
{
    return [_data valueForKey:@"url"];
}

- (NSString *)getSubscriptionUrl
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];
    return [githubApiHost stringByAppendingFormat:@"/user/subscriptions/%@", [self getFullName]];
}

- (NSString *)getStarredUrl
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];
    return [githubApiHost stringByAppendingFormat:@"/user/starred/%@", [self getFullName]];
}

- (NSString *)getGithubUrl
{
    NSString *githubHost = [AppConfig getConfigValue:@"GithubHost"];
    return [githubHost stringByAppendingFormat:@"/%@", [self getFullName]];
}

- (void)fetchFullInfo
{
    NSURL *url = [NSURL URLWithString:[self getUrl]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                                                               path:url.absoluteString
                                                         parameters:[AccountDAO getAccessTokenParams]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RepoInfoFetched" object:[NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil]];
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     }];
    
    [operation start];
}

- (void)checkStar
{
    NSURL *starredUrl = [NSURL URLWithString:[self getStarredUrl]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:starredUrl];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                                                               path:starredUrl.absoluteString
                                                         parameters:[AccountDAO getAccessTokenParams]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StarChecked" object:operation];
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"StarChecked" object:operation];
                                     }];
    
    [operation start];
}

- (void)fetchBranches
{
//    NSURL *branchesUrl = [NSURL URLWithString:[self getBranchesUrl]];
//    
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:branchesUrl];
//    
//    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
//                                                               path:branchesUrl.absoluteString
//                                                         parameters:[AccountDAO getAccessTokenParams]];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
//    
//    [operation setCompletionBlockWithSuccess:
//     ^(AFHTTPRequestOperation *operation, id responseObject){
//         NSString *response = [operation responseString];
//         
//         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//         
//         NSMutableArray *branches = [[NSMutableArray alloc] initWithCapacity:0];
//         
//         for (NSDictionary *branchData in json) {
//             [branches addObject:[[Branch alloc] initWithData:branchData]];
//         }
//         
//         NSDictionary *userInfo = [NSDictionary dictionaryWithObject:branches forKey:@"Branches"];
//         
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"BranchesFetched"
//                                                             object:self
//                                                           userInfo:userInfo];
//     }
//                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                         NSLog(@"%@", error);
//                                     }];
//    [operation start];
}

//- (void)fetchTopLayerForBranch:(Branch *)branch
//{
//    NSString *treeUrl = [[self getTreeUrl] stringByAppendingString:[branch getName]];
//    
//    NSURL *repoTreeUrl = [NSURL URLWithString:treeUrl];
//    
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:repoTreeUrl];
//    
//    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:repoTreeUrl.absoluteString parameters:[AppHelper getAccessTokenParams]];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
//    
//    [operation setCompletionBlockWithSuccess:
//     ^(AFHTTPRequestOperation *operation, id responseObject){
//         NSString *response = [operation responseString];
//         
//         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//         
//         NSArray *treeNodes = [json valueForKey:@"tree"];
//         
//         NSMutableArray *nodes = [[NSMutableArray alloc] initWithCapacity:0];
//         
//         for (int i=0; i < treeNodes.count; i++) {
//             [nodes addObject:[[RepoTreeNode alloc] initWithData:[treeNodes objectAtIndex:i]]];
//         }
//         
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"TreeFetched" object:nodes];
//     }
//                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                         NSLog(@"%@", error);
//                                     }];
//    
//    [operation start];
//}

- (void)fetchIssuesForPage:(int)page
{
//    NSURL *issuesUrl = [NSURL URLWithString:[self getIssuesUrl]];
//    
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:issuesUrl];
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   [AppConfig getAccessToken], @"access_token",
//                                   [NSString stringWithFormat:@"%i", page], @"page",
//                                   nil];
//    
//    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
//                                                               path:issuesUrl.absoluteString
//                                                         parameters:params];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
//    
//    [operation setCompletionBlockWithSuccess:
//     ^(AFHTTPRequestOperation *operation, id responseObject){
//         NSString *response = [operation responseString];
//         
//         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//         
//         NSMutableArray *issues = [[NSMutableArray alloc] initWithCapacity:0];
//         
//         for (NSDictionary *issueData in json) {
//             [issues addObject:[[Issue alloc] initWithData:issueData]];
//         }
//         
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"IssuesFetched"
//                                                             object:issues];
//     }
//                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                         NSLog(@"%@", error);
//                                     }];
//    
//    [operation start];
}

- (void)save:(NSDictionary *)info
{
//    NSURL *createRepoUrl = [AppHelper prepUrlForApiCall:[NSString stringWithFormat:@"/user/repos?access_token=%@", [AppHelper getAccessToken]]];
//    
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:createRepoUrl];
//    [httpClient setParameterEncoding:AFJSONParameterEncoding];
//    
//    NSMutableURLRequest *postRequest = [httpClient requestWithMethod:@"POST"
//                                                                path:createRepoUrl.absoluteString
//                                                          parameters:info];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:postRequest];
//    
//    [operation setCompletionBlockWithSuccess:
//     ^(AFHTTPRequestOperation *operation, id responseObject){
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"NewRepoSubmitted"
//                                                             object:operation];
//     }
//                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                         NSLog(@"%@", error);
//                                     }];
//    
//    [operation start];
}

- (void)fetchReadme
{
//    NSURL *readmeUrl = [AppHelper prepUrlForApiCall:[NSString stringWithFormat:@"/repos/%@/readme", [self getFullName]]];
//    
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:readmeUrl];
//    
//    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
//                                                               path:readmeUrl.absoluteString
//                                                         parameters:[AppHelper getAccessTokenParams]];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
//    
//    [operation setCompletionBlockWithSuccess:
//     ^(AFHTTPRequestOperation *operation, id responseObject){
//         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//         
//         Readme *readme = [[Readme alloc] initWithData:json];
//         
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"ReadmeFetched"
//                                                             object:readme];
//     }
//                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"ReadmeFetched"
//                                                                                             object:nil];
//                                         NSLog(@"%@", error);
//                                     }];
//    
//    [operation start];
}

- (void)fetchLanguages
{
//    NSURL *languagesUrl = [AppHelper prepUrlForApiCall:[NSString stringWithFormat:@"/repos/%@/languages", [self getFullName]]];
//    
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:languagesUrl];
//    
//    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
//                                                               path:languagesUrl.absoluteString
//                                                         parameters:[AppHelper getAccessTokenParams]];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
//    
//    [operation setCompletionBlockWithSuccess:
//     ^(AFHTTPRequestOperation *operation, id responseObject){
//         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//         
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"RepoLanguagesFetched"
//                                                             object:json];
//     }
//                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"RepoLanguagesFetched"
//                                                                                             object:nil];
//                                         NSLog(@"%@", error);
//                                     }];
//    
//    [operation start];
}

- (void)fetchContributors
{
//    NSURL *contributorsUrl = [AppHelper prepUrlForApiCall:[NSString stringWithFormat:@"/repos/%@/stats/contributors", [self getFullName]]];
//    
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:contributorsUrl];
//    
//    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
//                                                               path:contributorsUrl.absoluteString
//                                                         parameters:[AppHelper getAccessTokenParams]];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSArray *json = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//        
//        NSMutableArray *contributors = [NSMutableArray arrayWithCapacity:0];
//        
//        for (NSDictionary *contributorData in json) {
//            [contributors addObject:[[Contribution alloc] initWithData:contributorData]];
//        }
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"RepoContributorsFetched"
//                                                            object:contributors];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", error);
//    }];
//    
//    [operation start];
}

- (void)fetchCommitActivity
{
//    NSURL *commitActivityUrl = [AppHelper prepUrlForApiCall:[NSString stringWithFormat:@"/repos/%@/stats/commit_activity", [self getFullName]]];
//    
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:commitActivityUrl];
//    
//    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
//                                                               path:commitActivityUrl.absoluteString
//                                                         parameters:[AppHelper getAccessTokenParams]];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSArray *json = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//        
//        NSMutableArray *commitActivity = [NSMutableArray arrayWithCapacity:0];
//        
//        for (NSDictionary *commitActivityData in json) {
//            [commitActivity addObject:[[CommitActivity alloc] initWithCommitActivityData:commitActivityData]];
//        }
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"RepoCommitActivityDataFetched"
//                                                            object:commitActivity];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", error);
//    }];
//    
//    [operation start];
}

- (void)forkForAuthenticatedUser
{
//    NSURL *forkUrl = [AppHelper prepUrlForApiCall:[NSString stringWithFormat:@"/repos/%@/forks?access_token=%@", [self getFullName], [AppHelper getAccessToken]]];
//    
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:forkUrl];
//    
//    NSMutableURLRequest *postRequest = [httpClient requestWithMethod:@"GET"
//                                                                path:forkUrl.absoluteString
//                                                          parameters:nil];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:postRequest];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"RepoForked"
//                                                            object:operation];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"RepoForked"
//                                                            object:operation];
//    }];
//    
//    [operation start];
}

+ (void)createNewWithData:(NSDictionary *)data
{
//    NSURL *newRepoUrl = [AppHelper prepUrlForApiCall:[NSString stringWithFormat:@"/user/repos?access_token=%@", [AppHelper getAccessToken]]];
//    
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:newRepoUrl];
//    [httpClient setParameterEncoding:AFJSONParameterEncoding];
//    
//    NSMutableURLRequest *postRequest = [httpClient requestWithMethod:@"POST"
//                                                                path:newRepoUrl.absoluteString
//                                                          parameters:data];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:postRequest];
//    
//    [operation setCompletionBlockWithSuccess:
//     ^(AFHTTPRequestOperation *operation, id responseObject){
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"RepoCreationSucceeded"
//                                                             object:operation];
//     }
//                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                         NSLog(@"%@", error.description);
//                                         
//                                         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//                                         
//                                         NSArray *_errors = [json valueForKey:@"errors"];
//                                         NSMutableArray *errors = [[NSMutableArray alloc] initWithCapacity:0];
//                                         
//                                         for (int i=0; i < _errors.count; i++) {
//                                             NSDictionary *err = [_errors objectAtIndex:i];
//                                             [errors addObject:[NSString stringWithFormat:@"%@ %@", [err valueForKey:@"resource"], [err valueForKey:@"message"]]];
//                                         }
//                                         
//                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"RepoCreationFailed"
//                                                                                             object:errors];
//                                     }];
//    
//    [operation start];
}

- (void)createIssueWithData:(NSDictionary *)issueData
{
//    NSURL *newIssueUrl = [AppHelper prepUrlForApiCall:[NSString stringWithFormat:@"/repos/%@/issues?access_token=%@", [self getFullName], [AppHelper getAccessToken]]];
//    
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:newIssueUrl];
//    [httpClient setParameterEncoding:AFJSONParameterEncoding];
//    
//    NSMutableURLRequest *postRequest = [httpClient requestWithMethod:@"POST"
//                                                                path:newIssueUrl.absoluteString
//                                                          parameters:issueData];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:postRequest];
//    
//    [operation setCompletionBlockWithSuccess:
//     ^(AFHTTPRequestOperation *operation, id responseObject){
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"IssueSubmitted"
//                                                             object:operation];
//     }
//                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"IssueSubmitted"
//                                                                                             object:operation];
//                                     }];
//    
//    [operation start];
}

- (BOOL)isDestroyable
{
    return [[AccountDAO getAccountUsername] isEqualToString:[self getAuthorName]];
}

- (void)destroy
{
    NSURL *deleteRepoUrl = [AccountDAO prepUrlForApiCall:[NSString stringWithFormat:@"/repos/%@?access_token=%@",
                                                         [self getFullName],
                                                         [AccountDAO getAccessToken]]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:deleteRepoUrl];
    
    NSMutableURLRequest *deleteRequest = [httpClient requestWithMethod:@"DELETE"
                                                                  path:deleteRepoUrl.absoluteString
                                                            parameters:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:deleteRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         [[NSNotificationCenter defaultCenter] postNotificationName:@"RepoDestroyed"
                                                             object:operation];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"%@", error);
                                     }];
    
    [operation start];
}

@end
