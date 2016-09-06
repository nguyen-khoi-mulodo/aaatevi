//
//  DBHelper.m
//  NPlus
//
//  Created by TEVI Team on 11/5/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "DBHelper.h"
#import "CDHistory.h"
#import "CDVideo.h"

@implementation DBHelper

static  DBHelper *sharedInstance = nil;

@synthesize lstVideoDownloaded, lstVideoDownloading;

+(DBHelper *) sharedInstance{
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
//        NSLog(@"DBHelper init");
        [[DBHelper sharedInstance] refresh];
    }
    return self;
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "TEVI Team.CoreDataDemo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NPlus" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
//    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringAppendingPathComponent: @"NPlus.sqlite"]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NPlus.sqlite"];
//    NSSet *versionIdentifiers = [[self managedObjectModel] versionIdentifiers];
//    if ([versionIdentifiers containsObject:@"2.0"])
//    {
//        BOOL hasMigrated = [self checkForMigration];
//        
//        if (hasMigrated==YES)
//        {
//            storePath = nil;
//            storePath = [[self applicationDocumentsDirectory]
//                         stringByAppendingPathComponent:@"NCTTablet2.sqlite"];
//        }
//    }
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - download
-(Video*)videoIsDownloaded:(NSString *)video_id withQuality:(NSString*) quality{
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDVideo"
                                   inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"videoId=%@ AND type=%@ AND quality=%@", video_id, VIDEO_TYPE_DOWNLOADED, quality];
    if (!quality) {
        predicate = [NSPredicate predicateWithFormat:@"videoId=%@ AND type=%@", video_id, VIDEO_TYPE_DOWNLOADED];
    }
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults =
    [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults && mutableFetchResults.count > 0) {
        CDVideo *cdVideo = [mutableFetchResults firstObject];
        Video *video = [[Video alloc] init];
        video.video_id = cdVideo.videoId;
        video.time = cdVideo.time;
        video.duration = [cdVideo.duration intValue];
        video.video_title = cdVideo.videoTitle;
        video.video_subtitle = cdVideo.videoSubTitle;
        video.video_image = cdVideo.videoImage;
        video.isHadSubtitle = cdVideo.isHadSubTitle;
        video.subTitleId = cdVideo.subTitleId;
        video.stream_url = cdVideo.streamUrl;
        video.type_quality = cdVideo.quality;
        video.link_down = cdVideo.linkDown;
        QualityURL* quality = [[QualityURL alloc] init];
        quality.type = video.type_quality;
        quality.link = video.stream_url;
        video.videoStream = [[VideoStream alloc] init];
        video.videoStream.streamUrls = [NSArray arrayWithObject:quality];
        NSString *pathFile = [self getPathFromTargetFile:cdVideo.localFile];
        NSURL *fileURL = [NSURL fileURLWithPath:pathFile];
        NSString *filePath= [fileURL absoluteString];
        video.stream_url = filePath;
        video.isHadSubtitle = cdVideo.isHadSubTitle;
        if (video.isHadSubtitle) {
            video.subTitleId = cdVideo.subTitleId;
        }
        
        return video;
    }
    return nil;
}

-(BOOL)addVideoToDownload:(FileDownloadInfo *)downloadInfo{
    if (downloadInfo == nil || downloadInfo.videoDownload == nil) {
        return NO;
    }
    Video *video = downloadInfo.videoDownload;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDVideo"
                                   inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"videoId=%@ AND type=%@ AND quality=%@", video.video_id, VIDEO_TYPE_DOWNLOADING, downloadInfo.quality];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults =
    [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults) {
        for(int i =0;i<[mutableFetchResults count]; i++)
        {
            [[self managedObjectContext] deleteObject:[mutableFetchResults objectAtIndex:i]];
        }
    }
    
    CDVideo *videoDownload = (CDVideo*)[NSEntityDescription
                                                 insertNewObjectForEntityForName:@"CDVideo"
                                                 inManagedObjectContext:[self managedObjectContext]];
    [videoDownload setVideoId:video.video_id];
    [videoDownload setVideoTitle:video.video_title];
    [videoDownload setVideoSubTitle:video.video_subtitle];
    [videoDownload setVideoImage:video.video_image];
    [videoDownload setIsLiked:[NSString stringWithFormat:@"%d", video.is_like]];
    [videoDownload setLinkDown:downloadInfo.linkDown];
    [videoDownload setQuality:downloadInfo.quality];
    [videoDownload setLinkShare:video.link_share];
    [videoDownload setStreamUrl:video.stream_url];
    [videoDownload setTime:video.time];
    [videoDownload setDuration:[NSString stringWithFormat:@"%d",video.duration]];
    [videoDownload setType:VIDEO_TYPE_DOWNLOADING];
    [videoDownload setDownloadStatus:downloadInfo.status];
    [videoDownload setIsHadSubTitle :video.isHadSubtitle];
    if (videoDownload.isHadSubTitle && video.subTitleId) {
        [videoDownload setSubTitleId:video.subTitleId];
    } else {
        [videoDownload setSubTitleId:@""];
    }
    [self refresh];
    if (![self.managedObjectContext save:&error]) {
        return NO;
    }
    return YES;
}

-(BOOL)updateVideoDownload:(FileDownloadInfo *)downloadInfo withTempFile:(NSString *)tempFile{
    if (downloadInfo == nil || downloadInfo.videoDownload == nil) {
        return NO;
    }
    Video *video = downloadInfo.videoDownload;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDVideo"
                                   inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"videoId=%@ AND type=%@ AND quality=%@", video.video_id, VIDEO_TYPE_DOWNLOADING, downloadInfo.quality];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults =
    [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults) {
        CDVideo *videoDownload = [mutableFetchResults firstObject];
        [videoDownload setDownloadSize:[NSString stringWithFormat:@"%f", downloadInfo.totalBytesWritten]];
        [videoDownload setFileSize:[NSString stringWithFormat:@"%f", downloadInfo.totalBytesExpectedToWrite]];
        double downloadProgress = (double)downloadInfo.totalBytesWritten / (double)downloadInfo.totalBytesExpectedToWrite;
        [videoDownload setDownloadCent:[NSString stringWithFormat:@"%f", downloadProgress]];
        [videoDownload setTempFile:tempFile];
        if (![self.managedObjectContext save:&error]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

//remove video downloading
-(BOOL)removeVideoDownloading:(NSString *)video_id withQuality:(NSString*) quality{
    if (video_id == nil) {
        return NO;
    }
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDVideo"
                                   inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"videoId=%@ AND type=%@ AND quality=%@", video_id, VIDEO_TYPE_DOWNLOADING, quality];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults =
    [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults.count > 0) {
        CDVideo *video = [mutableFetchResults lastObject];
        [self.managedObjectContext deleteObject:video];
        if ([self.managedObjectContext save:nil]) {
            [self refresh];
            return YES;
        }
    }
    return NO;
}

- (NSArray *)getAllFileDownloading{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDVideo"
                                   inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type=%@", VIDEO_TYPE_DOWNLOADING];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults =
    [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults.count > 0) {
        for (int i = 0; i < mutableFetchResults.count; i++) {
            CDVideo *videoDownload = [mutableFetchResults objectAtIndex:i];
            Video *video = [[Video alloc] init];
            video.video_id = videoDownload.videoId;
            video.video_subtitle = videoDownload.videoSubTitle;
            video.video_title = videoDownload.videoTitle;
            video.video_image = videoDownload.videoImage;
            video.link_down = videoDownload.linkDown;
            video.type_quality = videoDownload.quality;
            video.time = video.time;
            video.isHadSubtitle = videoDownload.isHadSubTitle;
            if (video.isHadSubtitle && videoDownload.subTitleId) {
                video.subTitleId = videoDownload.subTitleId;
            }
            //video.subTitleId = videoDownload.subTitleId;
            FileDownloadInfo *downloadInfo = [[FileDownloadInfo alloc] init];
            downloadInfo.videoDownload = video;
            downloadInfo.totalBytesWritten = [videoDownload.downloadSize doubleValue];
            downloadInfo.totalBytesExpectedToWrite = [videoDownload.fileSize doubleValue];
            downloadInfo.status = STATUS_PAUSING;
            downloadInfo.tempFile = videoDownload.tempFile;
            downloadInfo.downloadProgress = [videoDownload.downloadCent doubleValue];
            downloadInfo.isWaiting = NO;
            downloadInfo.isError = NO;
            downloadInfo.isDownloading = NO;
            downloadInfo.updateDB = YES;
            downloadInfo.taskIdentifier = -1;
            downloadInfo.quality = videoDownload.quality;
            downloadInfo.linkDown = videoDownload.linkDown;
            [arr addObject:downloadInfo];
        }
    }
    return arr;
}

-(BOOL)videoIsDownloading:(Video *)video{
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDVideo"
                                   inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"videoId=%@ AND type=%@ AND quality=%@", video.video_id, VIDEO_TYPE_DOWNLOADING, video.type_quality];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults =
    [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults && mutableFetchResults.count > 0) {
        return YES;
    }
    return NO;
}

-(BOOL)addVideoToOffline:(NSString *)video_id withQuality:(NSString*) quality withLocalFile:(NSString *)localFile{
    if (video_id == nil  || video_id.length < 1) {
        return NO;
    }
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDVideo"
                                   inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"videoId=%@ AND type=%@ AND quality=%@", video_id, VIDEO_TYPE_DOWNLOADING, quality];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults =
    [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults) {
        CDVideo *videoDownload = [mutableFetchResults firstObject];
        [videoDownload setDownloadSize:videoDownload.fileSize];
        [videoDownload setDownloadCent:@"1"];
        [videoDownload setTempFile:@""];
        [videoDownload setLocalFile:localFile];
        [videoDownload setType:VIDEO_TYPE_DOWNLOADED];
        if (![self.managedObjectContext save:&error]) {
            return NO;
            // This is a serious error saying the record could not be saved.
            // Advise the user to restart the application
        }
        [self refresh];
        return YES;
    }
    return NO;
}

- (NSArray *)getAllVideoDownloaded{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDVideo"
                                   inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type=%@", VIDEO_TYPE_DOWNLOADED];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults =
    [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults.count > 0) {
        for (int i = 0; i < mutableFetchResults.count; i++) {
            CDVideo *videoDownload = [mutableFetchResults objectAtIndex:i];
            Video *video = [[Video alloc] init];
            video.video_id = videoDownload.videoId;
            video.time = videoDownload.time;
            video.duration = [videoDownload.duration intValue];
            video.video_title = videoDownload.videoTitle;
            video.video_subtitle = videoDownload.videoSubTitle;
            video.video_image = videoDownload.videoImage;
            video.isHadSubtitle = videoDownload.isHadSubTitle;
            video.subTitleId = videoDownload.subTitleId;
            video.type_quality = videoDownload.quality;
            video.link_down = videoDownload.linkDown;
            NSString *pathFile = [self getPathFromTargetFile:videoDownload.localFile];
            NSURL *fileURL = [NSURL fileURLWithPath:pathFile];
            NSString *filePath= [fileURL absoluteString];
            video.stream_url = filePath;
            QualityURL* quality = [[QualityURL alloc] init];
            quality.type = video.type_quality;
            quality.link = video.stream_url;
            video.videoStream = [[VideoStream alloc] init];
            video.videoStream.streamUrls = [NSArray arrayWithObject:quality];
            FileDownloadInfo *downloadInfo = [[FileDownloadInfo alloc] init];
            downloadInfo.videoDownload = video;
            downloadInfo.quality = videoDownload.quality;
            downloadInfo.linkDown = videoDownload.linkDown;
            downloadInfo.totalBytesExpectedToWrite = [videoDownload.fileSize doubleValue];
            downloadInfo.isDownloaded = YES;
            [arr addObject:downloadInfo];
        }
    }
    return arr;
}

-(BOOL)deleteFileDownloaded:(NSString *)video_id withQuality:(NSString*) quality{
    if (video_id == nil) {
        return NO;
    }
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDVideo"
                                   inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"videoId=%@ AND type=%@ AND quality=%@", video_id, VIDEO_TYPE_DOWNLOADED, quality];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults =
    [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults.count > 0) {
        CDVideo *video = [mutableFetchResults lastObject];
        NSString *filePath = [self getPathFromTargetFile:video.localFile];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            NSError *error;
            [fileManager removeItemAtPath:filePath error:&error];
            if (error) {
                return NO;
            }else{
                [self.managedObjectContext deleteObject:video];
                [self refresh];
                if ([self.managedObjectContext save:nil]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}


- (NSString*)getPathFromTargetFile:(NSString*)fileName{
    NSString *pathstr = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    pathstr = [pathstr stringByAppendingPathComponent:@"Download"];
    pathstr = [pathstr stringByAppendingPathComponent:@"TeVi"];
    pathstr = [pathstr stringByAppendingPathComponent:fileName];
    return pathstr;
}

- (NSString*)getPathFromTempFile:(NSString*)fileName{
    NSString *pathstr = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    pathstr = [pathstr stringByAppendingPathComponent:@"Download"];
    pathstr = [pathstr stringByAppendingPathComponent:@"Temp"];
    pathstr = [pathstr stringByAppendingPathComponent:fileName];
    return pathstr;
}

#pragma mark - History
- (BOOL)addVideoToHistory:(Video *)video withStopTime:(double)seconds{
    if (video == nil) {
        return NO;
    }
    
    double lastTime = [self getSecondsContinueVideo:video];
    if (seconds < lastTime) {
        return NO;
    }
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDHistory"
                                   inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"videoId=%@", video.video_id];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults =
    [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults) {
        for (int i = 0; i < mutableFetchResults.count; i ++) {
            CDHistory *history = [mutableFetchResults objectAtIndex:i];
//            NSLog(@"remove video title:%@ video id:%@", history.videoTitle, history.videoId);
            [self.managedObjectContext deleteObject:history];
            [self.managedObjectContext save:nil];
        }
        CDHistory *his = (CDHistory*)[NSEntityDescription
                                            insertNewObjectForEntityForName:@"CDHistory"
                                            inManagedObjectContext:[self managedObjectContext]];
        [his setVideoId:video.video_id];
        [his setVideoTitle:video.video_subtitle];
        [his setVideoSubTitle:video.video_title];
        [his setLastTime:[NSString stringWithFormat:@"%f", seconds]];
        [his setVideoImage:video.video_image];
        [his setTime:video.time];
        if (video.duration < 0) {
            video.duration = 0;
        }
        [his setDuration:[NSString stringWithFormat:@"%d", video.duration]];
        
        if (![self.managedObjectContext save:&error]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

- (NSArray*) getVideoHistory{
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDHistory"
                                   inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError *error;
    NSMutableArray *mutableFetchResults =
    [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
//    NSLog(@"%d", (int)mutableFetchResults.count);
    if (mutableFetchResults.count > 0) {
        return [NSMutableArray arrayWithArray: [[mutableFetchResults reverseObjectEnumerator] allObjects]];
    }
    return nil;
}

-(double)getSecondsContinueVideo:(Video *)video{
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDHistory"
                                   inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"videoId=%@", video.video_id];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults =
    [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults) {
        CDHistory *history = [mutableFetchResults firstObject];
        double seconds = [history.lastTime doubleValue];
//        if (seconds < 0) {
//            seconds = 0;
//        }
        return seconds;
    }
    return 0;
}

- (int)getSecondsDurationOfVideo:(Video*)video {
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDHistory"
                                   inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"videoId=%@", video.video_id];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults =
    [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults) {
        CDHistory *history = [mutableFetchResults firstObject];
        int seconds = [history.duration intValue];
        if (seconds < 0) {
            seconds = 0;
        }
        return seconds;
    }
    return 0;
}

-(void)clearAllHistory{
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDHistory"
                                   inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError *error;
    NSMutableArray *mutableFetchResults =
    [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults.count > 0) {
        for (CDHistory *his in mutableFetchResults) {
            [self.managedObjectContext deleteObject:his];
        }
        [self.managedObjectContext save:nil];
    }
}

-(BOOL) removeHistory:(NSString *)video_id{
    if (video_id == nil) {
        return NO;
    }
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDHistory"
                                   inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"videoId=%@", video_id];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults =
    [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults.count > 0) {
        CDHistory *his = [mutableFetchResults lastObject];
        [self.managedObjectContext deleteObject:his];
        if ([self.managedObjectContext save:nil]) {
//            [self refresh];
            return YES;
        }
    }
    return NO;
}

#pragma mark refresh update list video downloading, downloaded
-(void)refresh{
    [self updateVideoDownloaded];
    [self updateVideoDownloading];
    //[[NSNotificationCenter defaultCenter]postNotificationName:kDidRefreshDownloadData object:nil];
}

- (void)updateVideoDownloading{
    if (self.lstVideoDownloading) {
        [self.lstVideoDownloading removeAllObjects];
        self.lstVideoDownloading = nil;
    }
    self.lstVideoDownloading = [[NSMutableArray alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDVideo"
                                   inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type=%@", VIDEO_TYPE_DOWNLOADING];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults =
    [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults.count > 0) {
        for (int i = 0; i < mutableFetchResults.count; i++) {
            CDVideo *videoDownload = [mutableFetchResults objectAtIndex:i];
            Video *video = [[Video alloc] init];
            video.video_id = videoDownload.videoId;
            video.video_title = videoDownload.videoTitle;
            video.video_subtitle = videoDownload.videoSubTitle;
            video.time = videoDownload.time;
            video.video_image = videoDownload.videoImage;
            video.isHadSubtitle = videoDownload.isHadSubTitle;
            if (video.isHadSubtitle && videoDownload.subTitleId) {
                video.subTitleId = videoDownload.subTitleId;
            }
            
            video.type_quality = videoDownload.quality;
            video.link_down = videoDownload.linkDown;
            [self.lstVideoDownloading addObject:video];
        }
    }

}

- (void)updateVideoDownloaded{
    if (self.lstVideoDownloaded) {
        [self.lstVideoDownloaded removeAllObjects];
        self.lstVideoDownloaded = nil;
    }
    self.lstVideoDownloaded = [[NSMutableArray alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDVideo"
                                   inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type=%@", VIDEO_TYPE_DOWNLOADED];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults =
    [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults.count > 0) {
        for (int i = 0; i < mutableFetchResults.count; i++) {
            CDVideo *videoDownload = [mutableFetchResults objectAtIndex:i];
            Video *video = [[Video alloc] init];
            video.video_id = videoDownload.videoId;
            video.video_title = videoDownload.videoTitle;
            video.video_subtitle = videoDownload.videoSubTitle;
            video.time = videoDownload.time;
            video.video_image = videoDownload.videoImage;
            video.isHadSubtitle = videoDownload.isHadSubTitle;
            video.subTitleId = videoDownload.subTitleId;
            video.type_quality = videoDownload.quality;
            video.link_down = videoDownload.linkDown;
            video.type_quality = videoDownload.quality;
            video.link_down = videoDownload.linkDown;
            NSString *pathFile = [self getPathFromTargetFile:videoDownload.localFile];
            NSURL *fileURL = [NSURL fileURLWithPath:pathFile];
            NSString *filePath= [fileURL absoluteString];
            video.stream_url = filePath;
            [self.lstVideoDownloaded addObject:video];
        }
    }
    
}

- (void)updateSubTitleIdForVideo:(Video*)video withSubTitleId:(NSString *)subTitleId {
    CDVideo *cdVideo = nil;
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDVideo"
                                   inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"videoId=%@ AND quality=%@", video.video_id, video.type_quality];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults =
    [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    cdVideo = [mutableFetchResults lastObject];
    if (error) {
        // handle error
    }
    if (!cdVideo) {
        // handle data not found
        
    }
    cdVideo.subTitleId = subTitleId;
    [self saveContext];
    
}

- (NSString*)updateJsonSeasonWithVideo:(Video*)video subTitle:(NSString*)subTitleId {
    CDVideo *cdVideo = nil;
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CDVideo"
                                   inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"videoId=%@", video.video_id];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults =
    [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    cdVideo = [mutableFetchResults lastObject];
    if (error) {
        // handle error
    }
    if (!cdVideo) {
        // handle data not found
    }
//    NSString *tempJson = cdVideo.seasonDetail;
    NSString *tempJson = @"";
    NSString *findStr = [NSString stringWithFormat:@"\"1\":\"%@\"",video.video_id];
    NSString *subStr = [NSString stringWithFormat:@"%@,\"17\":\"%@\"",findStr,subTitleId];
    tempJson = [tempJson stringByReplacingOccurrencesOfString:findStr withString:subStr];
    //cdVideo.seasonDetail = tempJson;
    [self saveContext];
    return tempJson;
}
@end
