//
//  GithubEvent.m
//  GitCat
//
//  Created by niko on 13-10-17.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "TimeLineEvent.h"
#import "NSDate+RelativeDate.h"
#import <FontAwesomeKit.h>

@interface TimeLineEvent()
{
    NSDictionary *fontAwesomeIcons;
    NSString *relativeDateString;
}

@end

@implementation TimeLineEvent

-(id)initWithData:(NSDictionary *)eventData
{
    if (self = [super init]) {
        
        fontAwesomeIcons = @{
                             @"ForkEvent"          : FAKIconCodeFork,
                             @"WatchEvent"         : FAKIconStar,
                             @"CreateEvent"        : FAKIconKeyboard,
                             @"FollowEvent"        : FAKIconUser,
                             @"GistEvent"          : FAKIconCode,
                             @"IssuesEvent"        : FAKIconWarningSign,
                             @"MemberEvent"        : FAKIconPlus,
                             @"IssueCommentEvent"  : FAKIconComment,
                             @"PushEvent"          : FAKIconUpload,
                             @"PullRequestEvent"   : FAKIconRetweet,
                             @"PublicEvent"        : FAKIconFolderOpen,
                             @"CommitCommentEvent" : FAKIconComments,
                             @"GollumnEvent"       : FAKIconBook
                             };
        
        relativeDateString = [self getRelativeDate];
        
        _dicData = eventData;
    }
    
    return self;
}


- (NSString *)getRelativeDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
    NSDate *date  = [dateFormatter dateFromString:[self.dicData valueForKey:@"created_at"]];
    
    return [date relativeDate];
}

-(NSMutableAttributedString*)toString
{
    return [[NSMutableAttributedString alloc] initWithString:@""];
}

-(NSString*)getEventDate
{
    return relativeDateString;
}

-(NSString*)getEventAwesomeIcon
{
   return [fontAwesomeIcons valueForKey:[self getType]];
}

- (NSString *)getType
{
    return [self.dicData valueForKey:@"type"];
}

- (Repo *)getRepo
{
    return [[Repo alloc] initWithData:[self.dicData valueForKey:@"repo"]];
}

- (NSMutableAttributedString *)toActorRepoString:(NSString *)actionName
{
    User *actor = [self getActor];
    Repo *repo = [self getRepo];
    
    NSMutableAttributedString *actorLogin = [self decorateEmphasizedText:[actor getLogin]];
    
    NSMutableAttributedString *repoName = [self decorateEmphasizedText:[repo getName]];
    
    NSMutableAttributedString *action = [self toAttributedString:[NSString stringWithFormat:@" %@ ", actionName]];
    
    [actorLogin insertAttributedString:action atIndex:actorLogin.length];
    [actorLogin insertAttributedString:repoName atIndex:actorLogin.length];
    return actorLogin;

}

- (NSString *)toActorRepoHTMLString:(NSString *)actionName
{
    User *actor = [self getActor];
    Repo *repo = [self getRepo];
    
    NSString *eventActorPath = [[NSBundle mainBundle] pathForResource:@"eventActor" ofType:@"html"];
    
    NSString *actorHTML = [NSString stringWithContentsOfFile:eventActorPath
                                                    encoding:NSUTF8StringEncoding error:nil];
    
    NSString *eventActionPath = [[NSBundle mainBundle] pathForResource:@"eventAction" ofType:@"html"];
    
    NSString *actionHTML = [NSString stringWithContentsOfFile:eventActionPath
                                                     encoding:NSUTF8StringEncoding error:nil];
    
    NSString *actoHTMLString = [NSString stringWithFormat:actorHTML, @"actor:", [actor getAvatarUrl], [actor getLogin]];
    NSString *repoHTMLString = [NSString stringWithFormat:actorHTML, @"repo:", GITHUB_OCTOCAT, [repo getName]];
    NSString *actionHTMLString = [NSString stringWithFormat:actionHTML, actionName];
    
    NSArray *strings = @[actoHTMLString, actionHTMLString, repoHTMLString];
    
    return [strings componentsJoinedByString:@""];
}

- (NSDictionary *)getPayload
{
    return [self.dicData valueForKey:@"payload"];
}

- (NSDictionary *)getTarget
{
    NSDictionary *payload = [self getPayload];
    return [payload valueForKey:@"target"];
}


- (NSMutableAttributedString *)decorateEmphasizedText:(NSString *)rawString
{
    NSMutableAttributedString *decoratedString = [[NSMutableAttributedString alloc] initWithString:rawString];
    [decoratedString setAttributes:@{
               NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT"
                                                   size:13.0],
    NSForegroundColorAttributeName:[UIColor lightGrayColor]
     } range:NSMakeRange(0, decoratedString.length)];
    
    return decoratedString;
}

- (NSMutableAttributedString *)toAttributedString:(NSString *)rawString
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:rawString];
    [attributedString setAttributes:@{
                NSFontAttributeName:[UIFont fontWithName:@"Arial" size:13.0]
     } range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

- (User *)getActor
{
    return [[User alloc] initWithData:[self.dicData valueForKey:@"actor"]];
}
@end
