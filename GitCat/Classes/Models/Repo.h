//
//  Repo.h
//  GitCat
//
//  Created by niko on 13-10-17.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repo : NSObject

@property (nonatomic, strong) NSDictionary *data;

- (id)initWithData:(NSDictionary *)data;

- (NSString *)getName;
- (NSString *)getFullName;
- (NSInteger)getForks;
- (NSInteger)getWatchers;
- (NSString *)getLanguage;
- (NSString *)getUrl;
- (NSString *)getBranchesUrl;
- (NSString *)getTreeUrl;
- (NSString *)getStarredUrl;
- (NSInteger)getSize;
- (NSString *)getPushedAt;
- (NSString *)getDescription;
- (NSString *)getHomepage;
- (NSInteger)getOpenIssues;
- (NSString *)getIssuesUrl;
- (NSString *)getCommitsUrl;
- (NSString *)getCreatedAt;
- (NSString *)getUpdatedAt;
- (NSString *)getAuthorName;
- (NSString *)convertToRelativeDate:(NSString *)originalDateString;
- (NSString *)getOwner;
- (BOOL)hasIssues;
- (BOOL)isForked;
- (BOOL)isPrivate;
- (NSString *)getGithubUrl;
- (void)checkStar;
- (void)fetchBranches;
- (void)fetchIssuesForPage:(int)page;
- (void)fetchFullInfo;
- (void)fetchReadme;
- (void)fetchLanguages;
- (void)fetchContributors;
- (void)fetchCommitActivity;
- (void)forkForAuthenticatedUser;
- (void)save:(NSDictionary *)info;
- (BOOL)isDestroyable;
- (void)destroy;

- (void)createIssueWithData:(NSDictionary *)issueData;

//- (void)fetchTopLayerForBranch:(Branch *)branch;

+ (void)createNewWithData:(NSDictionary *)data;

@end
