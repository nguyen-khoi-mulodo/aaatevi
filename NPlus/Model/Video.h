//
//  Video.h
//  NPlus
//
//  Created by TEVI Team on 7/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoStream.h"

@interface Video : NSObject
@property (nonatomic, strong) NSString *video_id;
@property (nonatomic, strong) NSString *video_title;
@property (nonatomic, strong) NSString *video_subtitle;
@property (nonatomic, strong) NSString *video_shortDes;
@property (nonatomic, strong) NSString *video_image;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSArray *genres;
@property (nonatomic, strong) NSArray *channels;
@property (nonatomic, assign) int viewCount;
@property (nonatomic, assign) int likes;
@property (nonatomic, strong) NSString *link_share;
@property (nonatomic, assign) BOOL is_like;
@property (nonatomic, strong) VideoStream *videoStream;
@property (nonatomic, assign) BOOL isSingle;
@property TypePlayer typeInitPlayer;
@property (nonatomic, strong) NSString *stream_url;
@property (nonatomic, strong) NSString *link_down;
@property (nonatomic, strong) NSString *type_quality;
@property (nonatomic, strong) NSString *seasonKey;
@property (nonatomic, assign) long long dateCreated;
@property (nonatomic, assign) BOOL isHD;
@property (nonatomic, assign) int duration;
@property (nonatomic, assign) int lastTime;


@property (nonatomic, assign) BOOL isHadSubtitle;
@property (nonatomic, strong) NSString *subTitleId;

- (BOOL)isEqualToVideo:(Video*)other;
@end
