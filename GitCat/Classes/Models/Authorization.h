//
//  Authorization.h
//  GitCat
//
//  Created by niko on 13-10-11.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Authorization : NSObject

@property (nonatomic, retain) NSDictionary *data;

- (id)initWithData:(NSDictionary *)authorizationData;

- (NSString *)getId;
- (NSString *)getUrl;
- (NSDictionary *)getApp;
- (NSString *)getName;
- (NSString *)getToken;
+ (NSArray *)appScopes;

@end
