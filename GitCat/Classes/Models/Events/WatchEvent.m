//
//  WatchEvent.m
//  GitCat
//
//  Created by niko on 13-10-17.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "WatchEvent.h"

@implementation WatchEvent


- (NSMutableAttributedString *)toString
{
    return [self toActorRepoString:@"watched"];
}

- (NSString *)toHTMLString
{
    return [self toActorRepoHTMLString:@"watched"];
}

- (NSString *)getURLPrefixForObject:(NSObject *)object
{
    return REPO_EVENT_PREFIX;
}

@end
