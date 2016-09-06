//
//  FileDownloadInfo.m
//  NPlus
//
//  Created by TEVI Team on 10/3/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "FileDownloadInfo.h"
@implementation FileDownloadInfo
@synthesize videoDownload;
@synthesize downloadTask;
@synthesize taskResumData;
@synthesize downloadProgress;
@synthesize isDownloading;
@synthesize isDownloaded;
@synthesize isWaiting;
@synthesize isError;
@synthesize updateDB;
@synthesize taskIdentifier;
@synthesize totalBytesWritten;
@synthesize totalBytesExpectedToWrite;
@synthesize status;
@synthesize tempFile;
//@synthesize showId;
//@synthesize jsonShow;
//@synthesize jsonSeason;
- (id)initWithVideo:(Video *)v{
    if (self == [super init]) {
        self.videoDownload = v;
        self.downloadProgress = 0.0;
        self.isWaiting = YES;
        self.isError = NO;
        self.isDownloading = NO;
        self.isDownloaded = NO;
        self.updateDB = NO;
        self.taskIdentifier = -1;
        self.status = @"2";
    }
    return self;
}
@end
