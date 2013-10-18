//
//  User.h
//  GitCat
//
//  Created by niko on 13-10-12.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSDictionary *data;

- (id)initWithData:(NSDictionary *)userData;

- (NSString *)getAvatarUrl;
- (NSString *)getGravatarId;
- (NSString *)getGistsUrl;
- (NSString *)getReceivedEventsUrl;
- (NSString *)getEventsUrl;
- (NSString *)getStarredUrl;
- (NSString *)getReposUrl;
- (NSString *)getOrganizationsUrl;
- (NSString *)getSubscriptionsUrl;
- (NSString *)getFollowersUrl;
- (NSString *)getFollowingUrl;
- (NSString *)getLogin;
- (NSString *)getName;
- (NSString *)getLocation;
- (NSString *)getWebsite;
- (NSString *)getEmail;
- (NSInteger)getFollowers;
- (NSInteger)getFollowing;
- (NSString *)getCompany;
- (NSInteger)getNumberOfRepos;
- (NSInteger)getNumberOfGists;
- (NSString *)getCreatedAt;
- (NSString *)getHtmlUrl;


+(void)fetchUserInfoWithToken:(NSString*)token;

-(void)fetchUserInfo;

-(void)fetchNewsFeedForPage:(int)page;

@end
