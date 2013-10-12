//
//  AppConfig.m
//  GitCat
//
//  Created by niko on 13-10-11.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "AppConfig.h"

@implementation AppConfig

+ (NSString *)getConfigValue:(NSString *)valueName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    return [settings valueForKey:valueName];
    
}

@end
