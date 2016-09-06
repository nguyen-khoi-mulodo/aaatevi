//
//  CDVideo.h
//  NPlus
//
//  Created by TEVI Team on 11/13/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDVideo : NSManagedObject

@property (nonatomic, retain) NSString * downloadCent;
@property (nonatomic, retain) NSString * downloadSize;
@property (nonatomic, retain) NSString * downloadStatus;
@property (nonatomic, retain) NSString * fileSize;
@property (nonatomic, retain) NSString * isLiked;
@property (nonatomic, retain) NSString * linkDown;
@property (nonatomic, retain) NSString * linkShare;
@property (nonatomic, retain) NSString * listened;
@property (nonatomic, retain) NSString * localFile;
@property (nonatomic, retain) NSString * videoSubTitle;
@property (nonatomic, retain) NSString * streamUrl;
@property (nonatomic, retain) NSString * tempFile;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * videoId;
@property (nonatomic, retain) NSString * videoImage;
@property (nonatomic, retain) NSString * videoTitle;
@property (nonatomic, assign) BOOL isHadSubTitle;
@property (nonatomic, retain) NSString * subTitleId;
@property (nonatomic, retain) NSString * quality;
@property (nonatomic, retain) NSString * duration;
@end
