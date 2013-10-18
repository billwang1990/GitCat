//
//  CreateEvent.m
//  GitCat
//
//  Created by niko on 13-10-17.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "CreateEvent.h"

@implementation CreateEvent

- (NSMutableAttributedString *)toString
{
    return [self toActorRepoString:@"created"];
}

- (NSString *)toHTMLString
{
    return [self toActorRepoHTMLString:@"created"];
}

- (NSString *)getURLPrefixForObject:(NSObject *)object
{
    return REPO_EVENT_PREFIX;
}

@end
