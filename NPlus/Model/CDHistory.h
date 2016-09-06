//
//  CDHistory.h
//  NPlus
//
//  Created by TEVI Team on 11/13/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDHistory : NSManagedObject

@property (nonatomic, retain) NSString *lastTime;
@property (nonatomic, retain) NSString *videoId;
@property (nonatomic, retain) NSString *videoImage;
@property (nonatomic, retain) NSString *videoTitle;
@property (nonatomic, retain) NSString *videoSubTitle;
@property (nonatomic, retain) NSString *quality;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString * duration;

@end
