//
//  Video.m
//  NPlus
//
//  Created by TEVI Team on 7/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "Video.h"

@implementation Video


-(BOOL)isEqualToVideo:(Video *)other{
    if ([self.video_id isEqualToString:other.video_id]) {
        return YES;
    }
    return NO;
}
@end
