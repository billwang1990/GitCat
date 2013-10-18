//
//  ForkEvent.h
//  GitCat
//
//  Created by niko on 13-10-17.
//  Copyright (c) 2013年 billwang. All rights reserved.
//

#import "TimeLineEvent.h"

@interface ForkEvent : TimeLineEvent

- (NSMutableAttributedString *)toString;
- (NSString *)toHTMLString;

@end
