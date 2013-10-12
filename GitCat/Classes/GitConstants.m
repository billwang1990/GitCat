//
//  GitConstants.m
//  GitCat
//
//  Created by niko on 13-10-11.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "GitConstants.h"

@implementation GitConstants

const NSString *CLIENT_ID = @"6df1d6a8ce01da3d2860";
const NSString *CLIENT_SECRET = @"8d0008712a51cb00f77744f7ecd8262cc5162df3";
NSString * const LOADING_MESSAGE = @"请稍候";
const float HIDE_AFTER = 2.0f;
const int REPO_DETAILS_MAX_CHARS = 65;
NSString * const GITHUB_OCTOCAT = @"http://octodex.github.com/images/original.jpg";

NSString * const EVENT_ACTOR_PREFIX           = @"actor:";
NSString * const EVENT_TARGET_ACTOR_PREFIX    = @"targetactor:";
NSString * const REPO_EVENT_PREFIX            = @"repo:";
NSString * const GIST_EVENT_PREFIX            = @"gist:";
NSString * const MEMBER_EVENT_PREFIX          = @"targetactor:";
NSString * const ISSUE_EVENT_PREFIX           = @"issue:";
NSString * const FOLLOW_EVENT_PREFIX          = @"targetactor:";
NSString * const GOLLUM_EVENT_PREFIX          = @"gollum:";
NSString * const PULL_REQUEST_EVENT_PREFIX    = @"pullrequest:";
NSString * const COMMIT_COMMENT_EVENT_PREFIX  = @"commit:";
NSString * const ISSUE_COMMENT_EVENT_PREFIX   = @"issuecomment:";

@end
