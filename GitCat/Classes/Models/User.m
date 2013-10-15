//
//  User.m
//  GitCat
//
//  Created by niko on 13-10-12.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "User.h"
#import "NSDate+RelativeDate.h"


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

@end
