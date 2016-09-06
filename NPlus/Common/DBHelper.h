//
//  DBHelper.h
//  NPlus
//
//  Created by TEVI Team on 11/5/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Video.h"
#import "FileDownloadInfo.h"

#define VIDEO_TYPE_DOWNLOADED   @"downloaded"
#define VIDEO_TYPE_DOWNLOADING  @"downloading"
#define STATUS_DOWNLOADING  @"0"
#define STATUS_PAUSING      @"1"
#define STATUS_WAITING      @"2"
@interface DBHelper : NSObject{
    
}
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSMutableArray *lstVideoDownloading;
@property (nonatomic, strong) NSMutableArray *lstVideoDownloaded;
+(DBHelper *) sharedInstance;
- (void)saveContext;
-(Video*)videoIsDownloaded:(NSString *)video_id withQuality:(NSString*) quality;
- (BOOL)addVideoToDownload:(FileDownloadInfo*)downloadInfo;
- (BOOL)updateVideoDownload:(FileDownloadInfo*)downloadInfo withTempFile:(NSString*)tempFile;

-(BOOL)removeVideoDownloading:(NSString *)video_id withQuality:(NSString*) quality;
- (BOOL)videoIsDownloading:(Video*)video;
- (NSArray*)getAllFileDownloading;

-(BOOL)addVideoToOffline:(NSString *)video_id withQuality:(NSString*) quality withLocalFile:(NSString *)localFile;
- (NSArray*)getAllVideoDownloaded;
-(BOOL)deleteFileDownloaded:(NSString *)video_id withQuality:(NSString*) quality;

//history
- (BOOL) addVideoToHistory:(Video*)video withStopTime:(double)seconds;
- (double) getSecondsContinueVideo:(Video*)video;
- (int)getSecondsDurationOfVideo:(Video*)video;
- (void) clearAllHistory;
- (BOOL) removeHistory:(NSString *)video_id;
- (NSArray*)getVideoHistory;
- (void)updateSubTitleIdForVideo:(Video*)video withSubTitleId:(NSString *)subTitleId;
- (NSString*)updateJsonSeasonWithVideo:(Video*)video subTitle:(NSString*)subTitleId;
- (void)refresh;
@end
