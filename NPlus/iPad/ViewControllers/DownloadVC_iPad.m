//
//  SubListVideoVC.m
//  NPlus
//
//  Created by Vo Chuong Thien on 11/6/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "DownloadVC_iPad.h"
#import "DBHelper.h"
#import "DownloadItemCell.h"
#import "UIGridViewRow.h"

@interface DownloadVC_iPad ()

@end

@implementation DownloadVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor clearColor]];
//    [self.view setBackgroundColor:[UIColor clearColor]];
    [gridView setContentInset:UIEdgeInsetsMake(0, 0, 20, 0)];
    [gridView setBackgroundColor:[UIColor clearColor]];
//    self.dataView = gridView;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self setScreenName:@"iPad.Offline"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadCategoryType:(int) categoryType andSreenType:(int) screenType andSubScreenType:(int) subScreen andIsEdit:(BOOL) showEdit{
//        if (self.dataSources.count > 0) {
//            [self.dataSources removeAllObjects];
//        }
//        mCategoryType = categoryType;
//        mScreenType = screenType;
//        mSubScreenType = subScreen;
//        isEdit = showEdit;
//        self.curPage = kFirstPage;
//        [gridView setContentOffset:CGPointZero animated:NO];
//        if (subScreen == downloadingScreen) {
//            [[DownloadManager sharedInstance] setDelegate:self];
//        }else{
//            [[DownloadManager sharedInstance] setDelegate:nil];
//        }
//        [self loadData];
}

//-(void)loadData{
//    if (mSubScreenType == downloadedScreen) {
//        [self.dataSources removeAllObjects];
//        NSArray *arr = [[DBHelper sharedInstance] getAllVideoDownloaded];
////        [self.dataSource addObjectsFromArray:arr];
//        for (int i = (int)arr.count - 1; i >= 0; i--) {
//            FileDownloadInfo* info = [arr objectAtIndex:i];
//            [self.dataSources addObject:info];
//        }
//        [self finishLoadData];
//    }else if(mSubScreenType == downloadingScreen){
//        DownloadManager *manager = [DownloadManager sharedInstance];
//        [self.dataSources removeAllObjects];
//        [self.dataSources addObjectsFromArray:[manager getListVideoDownload]];
//        [self finishLoadData];
//    }
//    
//    [nodataView setHidden:!(self.dataSources.count == 0)];
//    [lbNoData setHidden:nodataView.hidden];
//    if (mSubScreenType == downloadedScreen) {
//        [lbNoData setText:@"Chưa có video nào được tải"];
//    }else if(mSubScreenType == downloadingScreen){
//        [lbNoData setText:@"Chưa có video nào đang tải"];
//    }
//    if (self.parentDelegate && [self.parentDelegate respondsToSelector:@selector(showButtonDelete:)]) {
//        [self.parentDelegate showButtonDelete:(self.dataSources.count > 0)];
//    }
//}



//#pragma mark - download manager delegate
//-(void)downloadManager:(DownloadManager *)downloadManager startedDownload:(FileDownloadInfo *)downloadInfo{
//    [self loadData];
//}
//
//-(void)downloadManager:(DownloadManager *)downloadManager updateDownload:(FileDownloadInfo *)downloadInfo{
//    NSArray* cellArr = [gridView visibleCells];
//    for(id obj in cellArr)
//    {
//        if([obj isKindOfClass:[UIGridViewRow class]])
//        {
//            UIGridViewRow* row = (UIGridViewRow*)obj;
//            int numCols = (int)[gridView.uiGridViewDelegate numberOfColumnsOfGridView:gridView];
//            for (int i = 0; i < numCols; i++) {
//                if (row.contentView.subviews.count > i) {
//                    DownloadItemCell* cell = [row.contentView.subviews objectAtIndex:i];
//                    if (!cell.hidden) {
//                        [cell updateCell:downloadInfo.taskIdentifier];
//                    }
//                }
//            }
//        }
//    }
//}
//
//-(void)downloadManager:(DownloadManager *)downloadManager finishedDownload:(FileDownloadInfo *)downloadInfo{
//    [self loadData];
//}
//
//-(void)downloadManager:(DownloadManager *)downloadManager cancelDownload:(FileDownloadInfo *)downloadInfo{
//    [self loadData];
//}
//
//-(void)downloadManager:(DownloadManager *)downloadManager failedDownload:(FileDownloadInfo *)downloadInfo{
//    NSArray* cellArr = [gridView visibleCells];
//    for(id obj in cellArr)
//    {
//        if([obj isKindOfClass:[UIGridViewRow class]])
//        {
//            UIGridViewRow* row = (UIGridViewRow*)obj;
//            int numCols = (int)[gridView.uiGridViewDelegate numberOfColumnsOfGridView:gridView];
//            for (int i = 0; i < numCols; i++) {
//                if (row.contentView.subviews.count > i) {
//                    DownloadItemCell* cell = [row.contentView.subviews objectAtIndex:i];
//                    if (!cell.hidden) {
//                        [cell updateCell:downloadInfo.taskIdentifier];
//                    }
//                }
//            }
//        }
//    }
//}
//
//- (void) deleteItemInfo:(FileDownloadInfo*) info{
//    if (mSubScreenType == downloadedScreen) {
//        Video *vd = info.videoDownload;
//        BOOL success = [[DBHelper sharedInstance] deleteFileDownloaded:vd.video_id];
//        if (success) {
//            [self loadData];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDiskSpaceNotification object:nil userInfo:nil];
//        }
//    }else{
//        [[DownloadManager sharedInstance] stop:info];
//        [self loadData];
//    }
//    
//}


@end
