//
//  DownloadManager.m
//  NPlus
//
//  Created by TEVI Team on 10/3/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "DownloadManager.h"
#import "DBHelper.h"
#import "SubTitle.h"
#import "ParserObject.h"
#import "DownloadingController.h"

static void runOnMainThread(void (^block)(void))
{
    if (!block) return;
    
    if ( [[NSThread currentThread] isMainThread] ) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

@interface DownloadManager()<NSURLSessionDelegate, NSURLSessionDownloadDelegate>{
    BOOL _isDownloading;
}
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableArray *arrFileDownloadData;
-(int)getFileDownloadInfoIndexWithTaskIdentifier:(unsigned long)taskIdentifier;
@end
@implementation DownloadManager
@synthesize delegate = _delegate;

static  DownloadManager *sharedInstance = nil;
+(DownloadManager *) sharedInstance{
    @synchronized(self){
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return  sharedInstance;
}
+(id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return  sharedInstance;
        }
    }
    return nil;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            NSURLSessionConfiguration *backgroundConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.tevi.video"];
            self.session = [NSURLSession sessionWithConfiguration:backgroundConfiguration
                                                         delegate:self
                                                    delegateQueue:nil];
            
        }else{
            NSURLSessionConfiguration *backgroundConfiguration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.tevi.video"];
            self.session = [NSURLSession sessionWithConfiguration:backgroundConfiguration
                                                         delegate:self
                                                    delegateQueue:nil];
            
        }
        _isDownloading = NO;
        [self loadInfo];
        
        
    }
    return self;
}

- (void)loadInfo{
    self.arrFileDownloadData = [[NSMutableArray alloc] init];
    [self.arrFileDownloadData removeAllObjects];
    NSArray *arr = [[DBHelper sharedInstance] getAllFileDownloading];
    [self.arrFileDownloadData addObjectsFromArray:arr];
}

- (void)clearTmpDirectory
{
    NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
    for (NSString *file in tmpDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
    }
}

-(int)getFileDownloadInfoIndexWithTaskIdentifier:(unsigned long)taskIdentifier{
    int index = -1;
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:i];
        if (fdi.taskIdentifier == taskIdentifier) {
            index = i;
            break;
        }
    }
    
    return index;
}

//add video to download
-(void)downloadVideo:(Video *)video withQuality:(QualityURL*) quality completion:(void (^)(DownloadManagerCode))callback{

    if (IOS_OLDER_THAN_7) {
        [APPDELEGATE showToastMessage:@"Tải về chỉ hỗ trợ từ iOS 7.0"];
        return;
    }
    
    if (!APPDELEGATE.allowDownload) {
        callback(DownloadManagerCodeDoNotAllowDownload);
        return;
    }
    
    if (!quality || !quality.link) {
        callback(DownloadManagerCodeFileIsNull);
        return;
    }
    
    //chek video is downloaded
    if ([self videoIsDownloaded:video withQuality:quality]) {
        callback(DownloadManagerCodeFileDownloaded);
        return;
    }
    //check video is exists list download
    for (FileDownloadInfo *info in self.arrFileDownloadData) {
        Video *v = info.videoDownload;
        if ([v isEqualToVideo:video]) {
            callback(DownloadManagerCodeFileExists);
            return;
        }
    }
    
    FileDownloadInfo *downloadInfo = [[FileDownloadInfo alloc] initWithVideo:video];
    downloadInfo.quality = quality.type;
    downloadInfo.linkDown = quality.link;
    [self.arrFileDownloadData addObject:downloadInfo];
    //add video download to database with type is DOWNLOADING
    [[DBHelper sharedInstance] addVideoToDownload:downloadInfo];
    callback(DownloadManagerCodeAddFinished);
//    if ([self.delegate isKindOfClass:[DownloadingController class]]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kDidAddDownloadVideoNotification object:nil];
//    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidAddDownloadVideoNotification object:nil];
    [self startDownload];
}

- (BOOL) videoIsDownloaded:(Video*)video withQuality:(QualityURL*) quality{
    NSArray *arr = [[DBHelper sharedInstance] lstVideoDownloaded];
    for (Video *vi in arr) {
        if ([video isEqualToVideo:vi]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) videoIsInListDownloading:(Video*) video {
    for (FileDownloadInfo *info in [[DownloadManager sharedInstance] arrFileDownloadData]) {
        Video *v = info.videoDownload;
        if ([v isEqualToVideo:video]) {
            return YES;
        }
    }
    return NO;
}

- (void)startDownload{
    NSInteger num = 0;
    NSInteger max = 1;
    if (_isDownloading) {
        return;
    }
    for (FileDownloadInfo *file in self.arrFileDownloadData) {
        if (!file.isError) {
            if (file.isDownloading==YES) {
                file.isWaiting = NO;
                
                if (num>max) {
                    file.isDownloading = NO;
                    file.isWaiting = YES;
                }else
                    num++;
            }
        }
    }
    if (num<max) {
        for (FileDownloadInfo *file in self.arrFileDownloadData) {
            if (!file.isError) {
                if (!file.isDownloading&&file.isWaiting) {
                    num++;
                    if (num>max) {
                        break;
                    }
                    file.isDownloading = YES;
                    file.isWaiting = NO;
                    file.status = STATUS_DOWNLOADING;
                }
            }
        }
        
    }
    for (FileDownloadInfo *file in self.arrFileDownloadData) {
        if (!file.isError) {
            if (file.isDownloading==YES) {
              runOnMainThread(^{
                [self initializeDownload:file];
              });
//                [self initializeDownload:file];
//                break;
            }
        }
    }
}

//init task download
- (void)initializeDownload:(FileDownloadInfo*)downloadInfo{
    if (downloadInfo.isDownloading) {
        if (downloadInfo.tempFile.length == 0) {
            downloadInfo.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:downloadInfo.linkDown]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *destinationFilename = downloadInfo.downloadTask.originalRequest.URL.lastPathComponent;
            NSString *destination = [[self getTempPath] stringByAppendingPathComponent:destinationFilename];
            if ([fileManager fileExistsAtPath:destination]) {
                [fileManager removeItemAtPath:destination error:nil];
            }
            downloadInfo.tempFile = destinationFilename;
            [[DBHelper sharedInstance] updateVideoDownload:downloadInfo withTempFile:destinationFilename];
        }
        else{
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *filePath = [[self getTempPath] stringByAppendingPathComponent:downloadInfo.tempFile];
            if ([fileManager fileExistsAtPath:filePath]) {
                NSData *data = [fileManager contentsAtPath:filePath];
                if ([self isValidResumeData:data]) {
                    downloadInfo.downloadTask = [self.session downloadTaskWithResumeData:data];
                }else{
                    downloadInfo.tempFile = nil;
                    downloadInfo.totalBytesWritten = 0;
                    downloadInfo.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:downloadInfo.linkDown]];
                }
                
            }else{
                downloadInfo.tempFile = nil;
                downloadInfo.totalBytesWritten = 0;
                downloadInfo.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:downloadInfo.linkDown]];
            }
        }
        downloadInfo.taskIdentifier = downloadInfo.downloadTask.taskIdentifier;
        [downloadInfo.downloadTask resume];
        _isDownloading = YES;
        runOnMainThread(^{
            if (_delegate && [_delegate respondsToSelector:@selector(downloadManager:startedDownload:)]) {
                [_delegate downloadManager:self startedDownload:downloadInfo];
            }
        });
        
        [self fireNotification:DownloadResultCodeStarted];
    }
}

- (BOOL)isValidResumeData:(NSData *)data{
    if (!data || [data length] < 1) return NO;
    
    NSError *error;
    NSDictionary *resumeDictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:&error];
    if (!resumeDictionary || error) return NO;
    return YES;
    NSString *localFilePath = [resumeDictionary objectForKey:@"NSURLSessionResumeInfoLocalPath"];
    if ([localFilePath length] < 1) return NO;
    
    return [[NSFileManager defaultManager] fileExistsAtPath:localFilePath];
}


-(NSArray *)getListVideoDownload{
    return [self.arrFileDownloadData mutableCopy];
}
 
//stop download and update info to database
-(void)pause:(FileDownloadInfo *)downloadInfo{
    if ([self.arrFileDownloadData containsObject:downloadInfo]) {
        [downloadInfo.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
            if (resumeData != nil) {
                downloadInfo.taskResumData = [[NSData alloc] initWithData:resumeData];
            }
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *destinationFilename = downloadInfo.downloadTask.originalRequest.URL.lastPathComponent;
            NSString *destination = [[self getTempPath] stringByAppendingPathComponent:destinationFilename];
            if ([fileManager fileExistsAtPath:destination]) {
                [fileManager removeItemAtPath:destination error:nil];
            }
            if([resumeData writeToFile:destination atomically:YES]){
                downloadInfo.tempFile = destinationFilename;
                [[DBHelper sharedInstance] updateVideoDownload:downloadInfo withTempFile:destinationFilename];
            }else{
                NSLog(@"Save temp file failed");
            }
            [self fireNotification:DownloadResultCodeCancel];
            downloadInfo.isDownloading = NO;
            downloadInfo.status = STATUS_PAUSING;
            _isDownloading = NO;
            runOnMainThread(^{
                if (_delegate && [_delegate respondsToSelector:@selector(downloadManager:updateDownload:)]) {
                    [_delegate downloadManager:self updateDownload:downloadInfo];
                }
            });
            [self startDownload];
        }];
    }
}

- (void) pauseList:(NSMutableArray*) list{
    for (FileDownloadInfo* downloadInfo in list) {
        if ([self.arrFileDownloadData containsObject:downloadInfo]) {
            if (downloadInfo.isWaiting) {
                downloadInfo.isDownloading = NO;
                downloadInfo.isWaiting = NO;
                downloadInfo.status = STATUS_PAUSING;
                runOnMainThread(^{
                    if (_delegate && [_delegate respondsToSelector:@selector(downloadManager:updateDownload:)]) {
                        [_delegate downloadManager:self updateDownload:downloadInfo];
                    }
                });
            }else{
                [downloadInfo.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
                    if (resumeData != nil) {
                        downloadInfo.taskResumData = [[NSData alloc] initWithData:resumeData];
                    }
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    NSString *destinationFilename = downloadInfo.downloadTask.originalRequest.URL.lastPathComponent;
                    NSString *destination = [[self getTempPath] stringByAppendingPathComponent:destinationFilename];
                    if ([fileManager fileExistsAtPath:destination]) {
                        [fileManager removeItemAtPath:destination error:nil];
                    }
                    if([resumeData writeToFile:destination atomically:YES]){
                        downloadInfo.tempFile = destinationFilename;
                        [[DBHelper sharedInstance] updateVideoDownload:downloadInfo withTempFile:destinationFilename];
                    }else{
                        NSLog(@"Save temp file failed");
                    }
                    [self fireNotification:DownloadResultCodeCancel];
                    downloadInfo.isDownloading = NO;
                    downloadInfo.status = STATUS_PAUSING;
                    _isDownloading = NO;
                    runOnMainThread(^{
                        if (_delegate && [_delegate respondsToSelector:@selector(downloadManager:updateDownload:)]) {
                            [_delegate downloadManager:self updateDownload:downloadInfo];
                        }
                    });
                }];
            }
        }
    }

}

-(void)resume:(FileDownloadInfo *)downloadInfo{
    if ([downloadInfo.status isEqualToString:STATUS_PAUSING]) {
        downloadInfo.isWaiting = YES;
        downloadInfo.isError = NO;
        downloadInfo.status = STATUS_WAITING;
        runOnMainThread(^{
            if (_delegate && [_delegate respondsToSelector:@selector(downloadManager:updateDownload:)]) {
                [_delegate downloadManager:self updateDownload:downloadInfo];
            }
        });
        
        [self fireNotification:DownloadResultCodeUpdated];
        [self startDownload];
    }else{
        downloadInfo.isWaiting = NO;
        downloadInfo.isError = NO;
        downloadInfo.status = STATUS_PAUSING;
        runOnMainThread(^{
            if (_delegate && [_delegate respondsToSelector:@selector(downloadManager:updateDownload:)]) {
                [_delegate downloadManager:self updateDownload:downloadInfo];
            }
        });
        [self fireNotification:DownloadResultCodeUpdated];
        [self startDownload];
    }
}

-(void)stop:(FileDownloadInfo *)downloadInfo{
    for (FileDownloadInfo *fdi in self.arrFileDownloadData) {
        if ([fdi.videoDownload.video_id isEqualToString:downloadInfo.videoDownload.video_id] && [fdi.quality isEqualToString:downloadInfo.quality]) {
            [self.arrFileDownloadData removeObject:fdi];
            [[DBHelper sharedInstance]removeVideoDownloading:downloadInfo.videoDownload.video_id withQuality:downloadInfo.quality];
            [[DBHelper sharedInstance]deleteFileDownloaded:downloadInfo.videoDownload.video_id withQuality:downloadInfo.quality];
            [[DBHelper sharedInstance]refresh];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *destination = [[self getTempPath] stringByAppendingPathComponent:downloadInfo.tempFile];
            if ([fileManager fileExistsAtPath:destination]) {
                NSError *error;
                [fileManager removeItemAtPath:destination error:&error];
                if (error) {
                    NSLog(@"Can not delete tmp file: %@", destination);
                }
            }
            break;
        }
    }
    if (downloadInfo.isDownloading) {
        [downloadInfo.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
            if (resumeData == nil) {
                return;
            }
            NSDictionary *resumeDictionary = [NSPropertyListSerialization propertyListWithData:resumeData options:NSPropertyListImmutable format:NULL error:nil];
//            NSLog(@"dic: %@", resumeDictionary);
//            if (resumeDictionary && [resumeDictionary objectForKey:@"NSURLSessionResumeInfoLocalPath"]) {
//                NSString *file = [resumeDictionary objectForKey:@"NSURLSessionResumeInfoLocalPath"];
//                NSFileManager *fileManager = [NSFileManager defaultManager];
//                NSError *error;
//                if ([fileManager fileExistsAtPath:file]) {
//                    [fileManager removeItemAtPath:file error:&error];
//                    if (error) {
//                        NSLog(@"Can not delete tmp file: %@", file);
//                    }
//                }
//            }
            if (resumeDictionary) {
                NSString *file = downloadInfo.tempFile;
                NSString *destination = [[self getTempPath] stringByAppendingPathComponent:file];
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSError *error;
                if ([fileManager fileExistsAtPath:destination]) {
                    [fileManager removeItemAtPath:file error:&error];
                    if (error) {
                        NSLog(@"Can not delete tmp file: %@", destination);
                    }
                }
            }
        }];
        _isDownloading = NO;
    }
    if ([downloadInfo.status isEqualToString:STATUS_PAUSING]) {
        if (downloadInfo.taskResumData) {
            NSDictionary *resumeDictionary = [NSPropertyListSerialization propertyListWithData:downloadInfo.taskResumData options:NSPropertyListImmutable format:NULL error:nil];
            //            NSLog(@"dic: %@", resumeDictionary);
//            if (resumeDictionary && [resumeDictionary objectForKey:@"NSURLSessionResumeInfoLocalPath"]) {
//                NSString *file = [resumeDictionary objectForKey:@"NSURLSessionResumeInfoLocalPath"];
//                NSFileManager *fileManager = [NSFileManager defaultManager];
//                NSError *error;
//                if ([fileManager fileExistsAtPath:file]) {
//                    [fileManager removeItemAtPath:file error:&error];
//                    if (error) {
//                        NSLog(@"Can not delete tmp file: %@", file);
//                    }
//                }
//            }
            if (resumeDictionary) {
                NSString *file = downloadInfo.tempFile;
                NSString *destination = [[self getTempPath] stringByAppendingPathComponent:file];

                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSError *error;
                if ([fileManager fileExistsAtPath:destination]) {
                    [fileManager removeItemAtPath:file error:&error];
                    if (error) {
                        NSLog(@"Can not delete tmp file: %@", destination);
                    }
                }
            }
        } else {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *destination = [[self getTempPath] stringByAppendingPathComponent:downloadInfo.tempFile];
            if ([fileManager fileExistsAtPath:destination]) {
                NSError *error;
                [fileManager removeItemAtPath:destination error:&error];
                if (error) {
                    NSLog(@"Can not delete tmp file: %@", destination);
                }
            }
        }
    }
    [[DBHelper sharedInstance] removeVideoDownloading:downloadInfo.videoDownload.video_id withQuality:downloadInfo.quality];
    runOnMainThread(^{
        if (_delegate && [_delegate respondsToSelector:@selector(downloadManager:cancelDownload:)]) {
            [_delegate downloadManager:self cancelDownload:downloadInfo];
        }
    });
    
    [self fireNotification:DownloadResultCodeCancel];
    if ([self.arrFileDownloadData containsObject:downloadInfo]) {
        [self.arrFileDownloadData removeObject:downloadInfo];
    }
    [self startDownload];
}

#pragma mark - NSURLSession Delegate method implementation
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSLog(@"Session %@ download task %@ finished downloading to URL %@\n",
          session, downloadTask, location);
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSInteger index = [self getFileDownloadInfoIndexWithTaskIdentifier:downloadTask.taskIdentifier];
    if (index == -1) {
        return;
    }
    
    
    NSString *destinationFilename = downloadTask.originalRequest.URL.lastPathComponent;
    NSString *destination = [[self getTargetPath] stringByAppendingPathComponent:destinationFilename];
    NSURL *destinationURL = [NSURL fileURLWithPath:destination];
    if ([fileManager fileExistsAtPath:destination]) {
        [fileManager removeItemAtPath:destination error:nil];
    }
    
    BOOL success= [fileManager copyItemAtURL:location
                                       toURL:destinationURL
                                       error:&error];
    if (success) {
        FileDownloadInfo *downloadInfo = [self.arrFileDownloadData objectAtIndex:index];
        downloadInfo.isDownloading = NO;
        downloadInfo.isWaiting = NO;
        downloadInfo.taskIdentifier = -1;
        downloadInfo.taskResumData = nil;
        downloadInfo.isDownloaded = YES;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //update table view
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = [NSDate date];
            localNotification.alertBody = [NSString stringWithFormat:@"Video \"%@\" đã tải về hoàn tất.", downloadInfo.videoDownload.video_subtitle];
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        }];
        
        //update video type DOWNLOADING to DOWNLOADED in database
        [[DBHelper sharedInstance] addVideoToOffline:[downloadInfo.videoDownload video_id] withQuality:downloadInfo.quality withLocalFile:destinationFilename];
        if ([self.arrFileDownloadData containsObject:downloadInfo]) {
            [self.arrFileDownloadData removeObject:downloadInfo];
        }
        _isDownloading = NO;
        runOnMainThread(^{
            if (_delegate && [_delegate respondsToSelector:@selector(downloadManager:finishedDownload:)]) {
                [_delegate downloadManager:self finishedDownload:downloadInfo];
            }
        });
        [self fireNotification:DownloadResultCodeFinished];
        [self startDownload];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Không thể hoàn tất quá trình tải về." delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    NSInteger index = [self getFileDownloadInfoIndexWithTaskIdentifier:downloadTask.taskIdentifier];
    if (index == -1) {
        return;
    }
    FileDownloadInfo *downloadInfo = [self.arrFileDownloadData objectAtIndex:index];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[self getTempPath] stringByAppendingPathComponent:downloadInfo.tempFile];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    downloadInfo.tempFile = nil;
    downloadInfo.totalBytesWritten = (double)fileOffset;
    downloadInfo.totalBytesExpectedToWrite = (double)expectedTotalBytes;
    downloadInfo.downloadProgress = (double)fileOffset / (double)expectedTotalBytes;
    [[DBHelper sharedInstance] updateVideoDownload:downloadInfo withTempFile:@""];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error != nil) {
        NSLog(@"Download completed with error: %@", [error localizedDescription]);
        NSInteger index = [self getFileDownloadInfoIndexWithTaskIdentifier:task.taskIdentifier];
        if (index == -1) {
            return;
        }
        FileDownloadInfo *downloadInfo = [self.arrFileDownloadData objectAtIndex:index];
        if ([error.localizedDescription isEqualToString:@"cancelled"]) {
            if (_delegate && [_delegate respondsToSelector:@selector(downloadManager:cancelDownload:)]) {
                [_delegate downloadManager:self cancelDownload:downloadInfo];
            }
            return;
        }
        if ([error.localizedDescription isEqualToString:@"The requested URL was not found on this server."]) {
            NSLog(@"Link download error: %@", downloadInfo.linkDown);
        }
        downloadInfo.isDownloading = NO;
        downloadInfo.isError = YES;
        downloadInfo.isWaiting = YES;
        downloadInfo.status = STATUS_PAUSING;
        runOnMainThread(^{
            if (_delegate && [_delegate respondsToSelector:@selector(downloadManager:failedDownload:)]) {
                [_delegate downloadManager:self failedDownload:downloadInfo];
            }
        });
        
        _isDownloading = NO;
        [self startDownload];
    }
    else{
        NSLog(@"Download finished successfully.");
        
        //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
            if (self.arrFileDownloadData.count == 0) {
                if (APPDELEGATE.backgroundTransferCompletionHandler != nil) {
                    void (^completionHandler)() = APPDELEGATE.backgroundTransferCompletionHandler;
                    APPDELEGATE.backgroundTransferCompletionHandler = nil;
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        completionHandler();
//                        NSLog(@"All files have been downloaded!");
//                        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//                        localNotification.alertBody = @"All files have been downloaded!";
//                        localNotification.fireDate = [NSDate date];
//                        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                        runOnMainThread(^{
                            if (_delegate && [_delegate respondsToSelector:@selector(downloadManagerDidFinishDownloadBackground:)]) {
                                [_delegate downloadManagerDidFinishDownloadBackground:self];
                            }
                        });
                    }];
                }
            }
        }];
        [[NSNotificationCenter defaultCenter]postNotificationName:kDidDownloadedVideoNotification object:nil];
    }
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
        NSLog(@"Unknow tranfer size");
    }else{
        NSInteger index = [self getFileDownloadInfoIndexWithTaskIdentifier:downloadTask.taskIdentifier];
        if (index == -1) {
            [downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
                NSLog(@"cancel download task id: %lu", (unsigned long)downloadTask.taskIdentifier);
            }];
            return;
        }
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:index];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // Calculate the progress.
            fdi.totalBytesWritten = (double)totalBytesWritten;
            fdi.totalBytesExpectedToWrite = (double)totalBytesExpectedToWrite;
            fdi.downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
//            NSLog(@"download progress: %f", fdi.downloadProgress);
//            NSLog(@"downloading:%@ ", fdi.videoDownload.video_subtitle);
            if (!fdi.updateDB) {
                fdi.totalBytesWritten = 0;
                [[DBHelper sharedInstance] updateVideoDownload:fdi withTempFile:fdi.tempFile];
                fdi.updateDB = YES;
            }
            runOnMainThread(^{
                if (_delegate && [_delegate respondsToSelector:@selector(downloadManager:updateDownload:)]) {
                    [_delegate downloadManager:self updateDownload:fdi];
                }
            });
            
            [self fireNotification:DownloadResultCodeUpdated];
        }];
    }
}

-(void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error{
    NSLog(@"Error: %@", error);
//    [self startDownload];
}

-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        if (downloadTasks.count == 0) {
            if (APPDELEGATE.backgroundTransferCompletionHandler != nil) {
                void (^completionHandler)() = APPDELEGATE.backgroundTransferCompletionHandler;
                APPDELEGATE.backgroundTransferCompletionHandler = nil;
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    completionHandler();
                    NSLog(@"All files have been downloaded!");
//                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//                    localNotification.alertBody = @"All files have been downloaded!";
//                    localNotification.fireDate = [NSDate date];
//                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                }];
            }
        }
    }];
}

-(NSString *)getTargetPath{
    NSString *pathstr = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    pathstr = [pathstr stringByAppendingPathComponent:@"Download"];
    pathstr = [pathstr stringByAppendingPathComponent:@"TeVi"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    if(![fileManager fileExistsAtPath:pathstr])
    {
        [fileManager createDirectoryAtPath:pathstr withIntermediateDirectories:YES attributes:nil error:&error];
        if(!error)
        {
            NSLog(@"%@",[error description]);
        }
    }
    
    return pathstr;
}

-(NSString *)getTempPath{
    NSString *pathstr = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    pathstr = [pathstr stringByAppendingPathComponent:@"Download"];
    pathstr = [pathstr stringByAppendingPathComponent:@"Temp"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    if(![fileManager fileExistsAtPath:pathstr])
    {
        [fileManager createDirectoryAtPath:pathstr withIntermediateDirectories:YES attributes:nil error:&error];
        if(!error)
        {
            NSLog(@"%@",[error description]);
        }
    }
    
    return pathstr;
}

- (BOOL) checkDownloading{
    return _isDownloading;
}

- (void)fireNotification:(DownloadResultCode)code{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadStatusChangeNotification object:nil userInfo:@{
                                                                                                                      @"code" : [NSNumber numberWithInteger:code],
                                                                                                                      }];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDiskSpaceNotification object:nil userInfo:nil];
}

@end


