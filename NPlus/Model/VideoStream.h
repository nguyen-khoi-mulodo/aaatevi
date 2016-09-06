//
//  VideoStream.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 2/23/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoStream : NSObject

@property (nonatomic, strong) NSString *videoStreamId;
@property (nonatomic, strong) NSArray *streamUrls;
@property (nonatomic, strong) NSArray *streamDownloads;

@end
