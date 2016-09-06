//
//  Show.h
//  NPlus
//
//  Created by TEVI Team on 7/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject<NSCopying>

@property (nonatomic, strong) NSString *channelId;
@property (nonatomic, strong) NSString *channelName;
@property (nonatomic, strong) NSString *channelDes;
@property (nonatomic, strong) NSString *national;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *broadcast;
@property (nonatomic, strong) NSString *thumb;
@property (nonatomic, strong) NSString *fullImg;
@property (nonatomic, strong) NSArray *genres;
@property (nonatomic, strong) NSArray *seasons;
@property double rating;
@property long view;
@property (nonatomic, strong) NSArray *artists;
@property (nonatomic, strong) NSString *linkShare;
@property (nonatomic, strong) NSString *director;
@property (nonatomic, strong) NSString *producer;
@property (nonatomic, assign) long totalUserRating;
@property (nonatomic, assign) BOOL isSubcribe;
@property (nonatomic, assign) long totalFollow;
@property (nonatomic, strong) NSString *videoKey;
@end
