//
//  DownloadManager.h
//  NPlus
//
//  Created by TEVI Team on 10/3/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileDownloadInfo.h"
#import "Video.h"
#import "Channel.h"
#import "QualityURL.h"
typedef NS_ENUM(NSInteger, DownloadManagerCode) {
    DownloadManagerCodeFileExists,
    DownloadManagerCodeFileIsNull,
    DownloadManagerCodeFileDownloaded,
    DownloadManagerCodeAddFinished,
    DownloadManagerCodeDoNotAllowDownload,
};


@protocol DownloadManagerDelegate;
@interface DownloadManager : NSObject
@property (nonatomic, weak) id<DownloadManagerDelegate> delegate;
+(DownloadManager *) sharedInstance;
-(void)downloadVideo:(Video *)video withQuality:(QualityURL*) quality completion:(void (^)(DownloadManagerCode))callback;
- (void) pause:(FileDownloadInfo*)downloadInfo;
- (void) pauseList:(NSMutableArray*) list;
- (void)resume:(FileDownloadInfo*)downloadInfo;
- (void)stop:(FileDownloadInfo*)downloadInfo;
- (NSArray*)getListVideoDownload;
- (BOOL) checkDownloading;
- (BOOL) videoIsDownloaded:(Video*)video withQuality:(QualityURL*) quality;
- (BOOL) videoIsInListDownloading:(Video*) video;
@end

@protocol DownloadManagerDelegate <NSObject>

@optional
- (void)downloadManager:(DownloadManager*)downloadManager startedDownload:(FileDownloadInfo*)downloadInfo;
- (void)downloadManager:(DownloadManager*)downloadManager updateDownload:(FileDownloadInfo*)downloadInfo;
- (void)downloadManager:(DownloadManager*)downloadManager finishedDownload:(FileDownloadInfo*)downloadInfo;
- (void)downloadManager:(DownloadManager*)downloadManager cancelDownload:(FileDownloadInfo*)downloadInfo;
- (void)downloadManager:(DownloadManager*)downloadManager failedDownload:(FileDownloadInfo*)downloadInfo;
- (void)downloadManagerDidFinishDownloadBackground:(DownloadManager*)downloadManager ;
@end