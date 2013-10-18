//
//  ForkEvent.m
//  GitCat
//
//  Created by niko on 13-10-17.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "ForkEvent.h"

@implementation ForkEvent

- (NSMutableAttributedString *)toString
{
    return [self toActorRepoString:@"forked"];
}

- (NSString *)toHTMLString
{
    return [self toActorRepoHTMLString:@"forked"];
}

- (NSString *)getURLPrefix
{
    return REPO_EVENT_PREFIX;
}

@end
