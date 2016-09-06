//
//  ParserObject.h
//  NPlus
//
//  Created by TEVI Team on 7/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubTitle.h"

@interface ParserObject : NSObject
+ (NSMutableArray *) getObjectsFromArray: (NSArray *) dataArray;
+ (NSMutableArray *) getObjectsFromArray: (NSArray *) dataArray withObjectType:(NSString*)ObjType;
+ (id) getShowFromJson:(NSString*) json;
+(NSArray *)getVideosFromJson:(NSString *)json;

// parsing subtile
+ (void)parseString:(NSString *)string parsed:(void (^)(NSMutableDictionary*, NSError *))completion;
+ (NSTimeInterval)timeFromString:(NSString *)timeString;
+ (NSString*) loadSubtitleFile:(NSString*)fileName;

// download Subtitle
+ (void)saveSubTitle:(SubTitle *)sub ofVideo:(Video *)video;
+ (void)getExistContentSubTitle:(SubTitle*)sub ofVideo:(Video *)video _completed:(void(^)(NSString *str, NSError *error))completed;
+ (void)getExistContentSubTitleOffline:(Video *)video _completed:(void(^)(NSString *str, NSError *error))completed;
+ (BOOL)checkExistSub:(NSString*)subTitleId;
+ (void)saveSubTitleAndLoadFile:(SubTitle*)sub _completed:(void(^)(NSString *str, NSError *error))completed;

@end
