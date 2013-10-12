//
//  Authorization.m
//  GitCat
//
//  Created by niko on 13-10-11.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "Authorization.h"

@implementation Authorization

- (id)initWithData:(NSDictionary *)authorizationData
{
    self = [super init];
    _data = authorizationData;
    return self;
}

- (NSString *)getId
{
    return [NSString stringWithFormat:@"%@", [_data valueForKey:@"id"]];
}

- (NSString *)getUrl
{
    return [_data valueForKey:@"url"];
}

- (NSDictionary *)getApp
{
    return [_data valueForKey:@"app"];
}

- (NSString *)getName
{
    NSDictionary *app = [self getApp];
    return [app valueForKey:@"name"];
}

- (NSString *)getToken
{
    return [_data valueForKey:@"token"];
}

+ (NSArray *)appScopes
{
    return @[@"user",
             @"user:follow",
             @"public_repo",
             @"repo",
             @"repo:status",
             @"delete_repo",
             @"notifications",
             @"gist"];
}


@end
