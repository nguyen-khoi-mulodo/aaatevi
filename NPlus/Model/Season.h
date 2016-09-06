//
//  Season.h
//  NPlus
//
//  Created by TEVI Team on 8/20/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Video.h"

#define MOVIES_SERIES 1
#define NON_SERIES 2
#define UNKNOWN_SERIES 0

@interface Season : NSObject
@property (nonatomic, strong) NSString *seasonId;
@property (nonatomic, strong) NSString *seasonName;
@property (nonatomic, strong) NSString *seasonDes;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, assign) int videosCount;
@property (nonatomic, strong) NSArray *videos;
@property (nonatomic, strong) Channel* channel;
@property (nonatomic, assign) int type;
@end
