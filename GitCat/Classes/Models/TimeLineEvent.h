//
//  GithubEvent.h
//  GitCat
//
//  Created by niko on 13-10-17.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Repo.h"
#import "GitConstants.h"

@interface TimeLineEvent : NSObject

@property (nonatomic) NSDictionary *dicData;

-(NSMutableAttributedString*)toString;

-(NSString*)getEventDate;

-(NSString*)getEventAwesomeIcon;

- (NSString *)getType;

- (NSMutableAttributedString *)toActorRepoString:(NSString *)actionName;

- (NSString *)toActorRepoHTMLString:(NSString *)actionName;

- (NSDictionary *)getPayload;

- (NSDictionary *)getTarget;

- (NSMutableAttributedString *)decorateEmphasizedText:(NSString *)rawString;

- (NSMutableAttributedString *)toAttributedString:(NSString *)rawString;

- (User *)getActor;

- (id)initWithData:(NSDictionary *)eventData;

@end
