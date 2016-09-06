//
//  FileDownloadInfo.h
//  NPlus
//
//  Created by TEVI Team on 10/3/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Video.h"
@interface FileDownloadInfo : NSObject
@property (nonatomic, strong) Video *videoDownload;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *taskResumData;
@property (nonatomic) double downloadProgress;
@property (nonatomic) double totalBytesWritten;
@property (nonatomic) double totalBytesExpectedToWrite;
@property (nonatomic) BOOL isDownloading;
@property (nonatomic) BOOL isDownloaded;
@property (nonatomic) BOOL isWaiting;
@property (nonatomic) BOOL isError;
@property (nonatomic) BOOL updateDB;

@property (nonatomic) unsigned long taskIdentifier;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSString* tempFile;
@property (nonatomic, strong) NSString* quality;
@property (nonatomic, strong) NSString* linkDown;
- (id)initWithVideo:(Video*)v;
@end
