//
//  SubListVideoVC.m
//  NPlus
//
//  Created by Vo Chuong Thien on 11/6/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "GridListItemsVC.h"
#import "DBHelper.h"
#import "UIGridViewRow.h"
#import "HomeItem.h"

#define BANNER_HEIGHT 310
#define kPageSizeHome       6

@interface GridListItemsVC ()

@end

@implementation GridListItemsVC

- (void)viewDidLoad {
    
    // Do any additional setup after loading the view from its nib.
//    [self.view setBackgroundColor:kBackgroundDarkColor];
    [self.view setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    [gridView setContentInset:UIEdgeInsetsMake(0, 0, 70, 0)];
    [gridView setBackgroundColor:[UIColor clearColor]];
    self.dataView = gridView;
    
    // init refresh view
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - gridView.frame.size.height, self.view.frame.size.width, gridView.frame.size.height)];
        view.delegate = self;
        [gridView addSubview:view];
        _refreshHeaderView = view;
    }
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
    [gridView.tableHeaderView setBackgroundColor:[UIColor redColor]];
    self.mDataType = NEW_TYPE;
    if (self.screenType == home_type) {
//        self.mListType = video_type;
        if (!bannerItemView) {
            bannerItemView = [[BannerViewController alloc] initWithNibName:@"BannerViewController" bundle:nil];
        }
        [bannerItemView setDelegate:self];
        CGRect headerFrame = CGRectMake(0, 0, bannerItemView.view.frame.size.width, bannerItemView.view.frame.size.height);
        UIView *tempView = [[UIView alloc] initWithFrame:headerFrame];
        [tempView setBackgroundColor:[UIColor clearColor]];
        [tempView addSubview:bannerItemView.view];
        gridView.tableHeaderView = tempView;
    }
//    else if(self.screenType == khampha_type){
//        self.mListType = channel_type;
//    }else if(self.screenType == tvshow_type || self.screenType == phimngan_type || self.screenType == giaitri_type){
//        self.mListType = channel_type;
//        if (self.screenType == tvshow_type){
//            self.genreID = ID_GENRE_TVSHOW;
//        }else if(self.screenType == phimngan_type){
//            self.genreID = ID_GENRE_PHIMNGAN;
//        }else{
//            self.genreID = ID_GENRE_GIAITRI;
//        }
//    }
//    self.subGenreID = self.genreID;
    else if(self.screenType == tvshow_type || self.screenType == phimngan_type || self.screenType == giaitri_type){
//        self.mListType = channel_type;
        if (self.screenType == tvshow_type){
            self.genreID = ID_GENRE_TVSHOW;
        }else if(self.screenType == phimngan_type){
            self.genreID = ID_GENRE_PHIMNGAN;
        }else{
            self.genreID = ID_GENRE_GIAITRI;
        }
    }
    
    // nodata
    [lbNodata setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    
    if (self.screenType == download_type) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadVideoDownload) name:kDidAddDownloadVideoNotification object:nil];
    }
    
    [super viewDidLoad];
}


- (void) viewWillAppear:(BOOL)animated{
    [gridView setContentOffset:CGPointZero animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark LoadData

- (void) loadData{
    if (self.screenType == home_type) {
        if (!self.isLoadMore) {
            [self loadHomeData];
        }else{
            [self loadHomeMore];
        }
    }else{
        [self loadOtherPageData];
    }
}

- (void) loadOtherPageData{
//    if (type == video_type) {
//        if(self.screenType == khampha_type){
//            [self loadVideoDiscoverWithPageIndex:self.curPage pageSize:kPageSize];
//        }else if(self.screenType == search_type){
////            [self showNoDataView:YES];
////            [self showConnectionErrorView:YES isFull:YES];
//        }else if(self.screenType == download_type){
//            [self loadVideoDownload];
//        }
//        
//    }else if(type == channel_type){
//        if (self.screenType == khampha_type) {
//            [self loadChannelDiscoverWithPageIndex:self.curPage pageSize:kPageSize];
//        }else{
//            [self loadChannelByGenreWithPageIndex:self.curPage pageSize:kPageSize];
//        }
//    }
    [self loadChannelByGenreWithPageIndex:self.curPage pageSize:kPageSize];
}

- (void) loadHomeData{
    if (self.dataSources.count == 0) {
        [self showConnectionErrorView:NO];
        [self showNoDataView:NO];
        [self showLoadingDataView:YES];
    }
    
    [[APIController sharedInstance] getHomeItemCompleted:^(int code, HomeItem *results) {
        if (results) {
            HomeItem* homeItem = (HomeItem*)results;
            [bannerItemView setListShowcases:(NSMutableArray*)homeItem.listShowcases];
            [bannerItemView createShowcaseWithList:(NSMutableArray*)homeItem.listShowcases];
            if (self.dataSources.count > 0) {
                [self.dataSources removeAllObjects];
            }
            [self.dataSources addObject:homeItem.listVideoHot];
            [self.dataSources addObject:homeItem.listShortFilm];
            [self.dataSources addObject:homeItem.listTVShow];
            [self.dataSources addObject:homeItem.listRelax];
            [self.dataSources addObject:homeItem.listVideoNew];
            
            self.isLoadMore = YES;
            
            [self finishLoadData];
            [self showLoadingDataView:NO];
        }else{
            [self showLoadingDataView:NO];
            [self finishLoadData];
            [self showNoDataView:YES];
        }
    } failed:^(NSError *error) {
        if (self.dataSources.count == 0) {
            [self showLoadingDataView:NO];
            [self finishLoadData];
            if (APPDELEGATE.internetConnnected) {
                [self showConnectionErrorView:NO];
                [self showNoDataView:YES];
            }else{
                [self showNoDataView:NO];
                [self showConnectionErrorView:YES];
            }
        }
    }];
}

- (void) loadHomeMore{
    [[APIController sharedInstance] getDiscoverVideoWithType:@"new" pageIndex:self.curPage pageSize:kPageSizeHome completed:^(int code ,NSArray *results, BOOL loadmore, int total) {
        if (results) {
            NSArray *array = results;
            NSMutableArray* arrNewVideos = [self.dataSources objectAtIndex:4];
            [arrNewVideos addObjectsFromArray:array];
            self.isLoadMore = loadmore;
            if (self.isLoadMore && self.curPage == 8) {
                self.isLoadMore = NO;
            }
            [self finishLoadData];
            [self showLoadingDataView:NO];
        } else {
            
        }
        
    } failed:^(NSError *error) {
        
    }];
}

- (void) loadVideoByGenreWithPageIndex:(int)pageIndex pageSize:(int)pageSize {
    if (self.dataSources.count == 0) {
        [self showConnectionErrorView:NO];
        [self showNoDataView:NO];
        [self showLoadingDataView:YES];
    }

    [[APIController sharedInstance] getListVideoByGenre:self.subGenreID type:self.mDataType pageIndex:pageIndex pageSize:pageSize completed:^(int code ,NSArray *results, BOOL loadmore, int total) {
        if (results) {
            self.isLoadMore = loadmore;
            if (self.curPage == kFirstPage) {
                [self.dataSources removeAllObjects];
                [self.dataSources addObjectsFromArray:results];
                if (self.dataSources.count == 0) {
                    [self showNoDataView:YES];
                }
            }else{
                [self.dataSources addObjectsFromArray:results];
            }
            [self finishLoadData];
            [self showLoadingDataView:NO];
        }else{
            [self showLoadingDataView:NO];
            [self finishLoadData];
            [self showNoDataView:YES];
        }
    } failed:^(NSError *error) {
        if (self.dataSources.count == 0) {
            [self showLoadingDataView:NO];
            [self finishLoadData];
            if (APPDELEGATE.internetConnnected) {
                [self showConnectionErrorView:NO];
                [self showNoDataView:YES];
            }else{
                [self showNoDataView:NO];
                [self showConnectionErrorView:YES];
            }
        }
    }];
}

- (void) loadVideoDiscoverWithPageIndex:(int)pageIndex pageSize:(int)pageSize {
    if (self.dataSources.count == 0) {
        [self showConnectionErrorView:NO];
        [self showNoDataView:NO];
        [self showLoadingDataView:YES];
    }
    
    [[APIController sharedInstance] getDiscoverVideoWithType:self.mDataType pageIndex:pageIndex pageSize:pageSize completed:^(int code ,NSArray *results, BOOL loadmore, int total) {
        if (results) {
            self.isLoadMore = loadmore;
            if (self.curPage == kFirstPage) {
                [self.dataSources removeAllObjects];
                [self.dataSources addObjectsFromArray:results];
                if (self.dataSources.count == 0) {
                    [self showNoDataView:YES];
                }
            }else{
                [self.dataSources addObjectsFromArray:results];
            }
            [self finishLoadData];
            [self showLoadingDataView:NO];
        }else{
            [self showLoadingDataView:NO];
            [self finishLoadData];
            [self showNoDataView:YES];
        }
    } failed:^(NSError *error) {
        if (self.dataSources.count == 0) {
            [self showLoadingDataView:NO];
            [self finishLoadData];
            if (APPDELEGATE.internetConnnected) {
                [self showConnectionErrorView:NO];
                [self showNoDataView:YES];
            }else{
                [self showNoDataView:NO];
                [self showConnectionErrorView:YES];
            }
        }
    }];
}


- (void) loadChannelByGenreWithPageIndex:(int) pageIndex pageSize:(int) pageSize{
    if (self.dataSources.count == 0) {
        [self showConnectionErrorView:NO];
        [self showNoDataView:NO];
        [self showLoadingDataView:YES];
    }
    
    [[APIController sharedInstance] getListChannelsWithGenreId:self.genreID type:self.mDataType pageIndex:pageIndex pageSize:pageSize completed:^(int code ,NSArray *results, BOOL loadmore, int total) {
        if (results) {
            self.isLoadMore = loadmore;
            if (self.curPage == kFirstPage) {
                [self.dataSources removeAllObjects];
            }
            if (self.dataSources.count == 0) {
                [self.dataSources addObject:[NSMutableArray arrayWithArray:results]];
            }else{
                [[self.dataSources objectAtIndex:0] addObjectsFromArray:results];
            }
            [self finishLoadData];
            [self showLoadingDataView:NO];
        }else{ // data not exits
            [self.dataSources removeAllObjects];
            [self showLoadingDataView:NO];
            [self finishLoadData];
            [self showNoDataView:YES];
        }
    } failed:^(NSError *error) {
        if (self.dataSources.count == 0) {
            [self showLoadingDataView:NO];
            [self finishLoadData];
            if (APPDELEGATE.internetConnnected) {
                [self showConnectionErrorView:NO];
                [self showNoDataView:YES];
            }else{
                [self showNoDataView:NO];
                [self showConnectionErrorView:YES];
            }
        }
    }];
}

- (void) loadChannelDiscoverWithPageIndex:(int) pageIndex pageSize:(int) pageSize{
    if (self.dataSources.count == 0) {
        [self showConnectionErrorView:NO];
        [self showNoDataView:NO];
        [self showLoadingDataView:YES];
    }
    
    [[APIController sharedInstance] getDiscoverChannelWithPageIndex:pageIndex pageSize:pageSize completed:^(int code ,NSArray *results, BOOL loadmore, int total) {
        if (results) {
            self.isLoadMore = loadmore;
            if (self.curPage == kFirstPage) {
                [self.dataSources removeAllObjects];
            }
            [self.dataSources addObjectsFromArray:results];
            [self finishLoadData];
            [self showLoadingDataView:NO];
        }else{ // data not exits
            [self.dataSources removeAllObjects];
            [self showLoadingDataView:NO];
            [self finishLoadData];
            [self showNoDataView:YES];
        }
    } failed:^(NSError *error) {
        if (self.dataSources.count == 0) {
            [self showLoadingDataView:NO];
            [self finishLoadData];
            if (APPDELEGATE.internetConnnected) {
                [self showConnectionErrorView:NO];
                [self showNoDataView:YES];
            }else{
                [self showNoDataView:NO];
                [self showConnectionErrorView:YES];
            }
        }
    }];
}

- (void) loadVideoDownload{
    if (self.dataSources.count  > 0) {
        [self.dataSources removeAllObjects];
        [self showLoadingDataView:YES];
    }
    
    NSArray *arrDownloaded = [[DBHelper sharedInstance] getAllVideoDownloaded];
    if (arrDownloaded.count > 0) {
        [self.dataSources addObjectsFromArray:arrDownloaded];
    }
    NSArray *arrDownloading = [[DownloadManager sharedInstance] getListVideoDownload];
    if (arrDownloading.count) {
        [self.dataSources addObjectsFromArray:arrDownloading];
    }
    
    if (arrDownloading.count > 0) {
        [DownloadManager sharedInstance].delegate = self;
    }
    [self showLoadingDataView:NO];
    [self finishLoadData];
    [self.defaultView setHidden:(self.dataSources.count > 0)];
}

//- (void) setListType:(ListType) listType withDataType:(NSString*) dataType withGenreId:(NSString*) sId{
//    if (self.mListType != listType || ![self.mDataType isEqualToString:dataType] || ![self.subGenreID isEqualToString:sId]) {
//        self.curPage = kFirstPage;
//        [self.dataSources removeAllObjects];
//        [gridView setContentOffset:CGPointZero animated:NO];
//    }
//    self.mListType = listType;
//    self.mDataType = dataType;
//    self.subGenreID = sId;
//    if (self.mListType == video_type) {
//        if ([self.mDataType isEqualToString:NEW_TYPE]) {
//            [gridView setIdentifierName:@"videoNewItemCell"];
//        }else{
//            [gridView setIdentifierName:@"videoItemCell"];
//        }
//    }else if(self.mListType == channel_type){
//        [gridView setIdentifierName:@"channelItemCell"];
//    }else if(self.mListType == artist_type){
//        [gridView setIdentifierName:@"artistItemCell"];
//    }else if(self.mListType == cuatui_channel_type){
//        [gridView setIdentifierName:@"channelLikedItemCell"];
//    }else if(self.mListType == cuatui_video_type){
//        [gridView setIdentifierName:@"videoDownloadedItemCell"];
//    }
//    [self loadData];
//}

- (void) setFilterType:(NSString*) filterType andGenreId:(NSString*) gId{
    if (![self.genreID isEqualToString:gId] || ![self.mDataType isEqualToString:filterType]) {
        self.curPage = kFirstPage;
        [self.dataSources removeAllObjects];
        [gridView setContentOffset:CGPointZero animated:NO];
    }
    
    self.mDataType = filterType;
    self.genreID = gId;
    if (self.screenType == home_type) {
        [gridView setIdentifierName:@"homeItemCell"];
    }else if(self.screenType == phimngan_type || self.screenType == tvshow_type || self.screenType == giaitri_type){
        [gridView setIdentifierName:@"channelItemCell"];
    }
    
    [self loadData];
}

- (void) showVideo:(Video *)video{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showVideo:)]) {
        [self.delegate showVideo:video];
    }
}

#pragma mark Grid Delegate

- (NSInteger) numberOfSectionsInGridView:(UIGridView *)grid{
    return self.dataSources.count;
}

- (NSInteger) gridView:(UIGridView *)grid numberOfRowsInSection:(NSInteger)section{
    if (self.dataSources.count > section) {
        return [[self.dataSources objectAtIndex:section] count];
    }
    return 0;
}

- (CGFloat) gridView:(UIGridView *)grid heightForHeaderInSection:(int) section{
    if (self.screenType == home_type) {
        return 56;
    }
    return 0;
}

- (UIView*) gridView:(UIGridView *)grid viewForHeaderInSection:(NSInteger)section{
    UIView* headerOfSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 56)];
    [headerOfSection setBackgroundColor:UIColorFromRGB(0xfcfcfc)];
    UILabel* vLine1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1024, 8)];
    [vLine1 setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    [vLine1 setText:@""];
    [headerOfSection addSubview:vLine1];
    
    UILabel* vLine2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 2, 24)];
    [vLine2 setText:@""];
    [vLine2 setBackgroundColor:UIColorFromRGB(0x00adef)];
    [headerOfSection addSubview:vLine2];
    
    UILabel* lbHeaderTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 20, 1008, 24)];
    [lbHeaderTitle setBackgroundColor:[UIColor clearColor]];
    NSString* strTitle = @"";
    switch (section) {
        case 0:
            strTitle = @"Hot nhất trong tuần";
            break;
        case 1:
            strTitle = @"Phim ngắn";
            break;
        case 2:
            strTitle = @"TV Show";
            break;
        case 3:
            strTitle = @"Giải trí";
            break;
        case 4:
            strTitle = @"Video mới";
            break;
        default:
            break;
    }
    [lbHeaderTitle setText:strTitle];
    [lbHeaderTitle setFont:[UIFont fontWithName:kFontRegular size:17]];
    [lbHeaderTitle setTextColor:UIColorFromRGB(0x212121)];
    [headerOfSection addSubview:lbHeaderTitle];
    
    return  headerOfSection;
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    [super doneLoadingTableViewData];
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:gridView];
    
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [super scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    self.isLoadMore = NO;
    [self reloadTableViewDataSource];
    
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

#pragma mark - download manager delegate

-(void)downloadManager:(DownloadManager *)downloadManager finishedDownload:(FileDownloadInfo *)downloadInfo{
    [self loadVideoDownload];
}

-(void)downloadManager:(DownloadManager *)downloadManager startedDownload:(FileDownloadInfo *)downloadInfo{
    [self loadVideoDownload];
}

-(void)downloadManager:(DownloadManager *)downloadManager updateDownload:(FileDownloadInfo *)downloadInfo{
    NSArray* cellArr = [gridView visibleCells];
    for(id obj in cellArr)
    {
        if([obj isKindOfClass:[UIGridViewRow class]])
        {
            UIGridViewRow* row = (UIGridViewRow*)obj;
            int numCols = (int)[gridView.uiGridViewDelegate numberOfColumnsOfGridView:gridView];
            for (int i = 0; i < numCols; i++) {
                if (row.contentView.subviews.count > i) {
                    DownloadItemCell* cell = [row.contentView.subviews objectAtIndex:i];
                    if (!cell.hidden) {
                        [cell updateCell:downloadInfo.taskIdentifier];
                    }
                }
            }
        }
    }
}
-(void)downloadManager:(DownloadManager *)downloadManager cancelDownload:(FileDownloadInfo *)downloadInfo{
//    [self loadVideoDownload];
}

-(void)downloadManager:(DownloadManager *)downloadManager failedDownload:(FileDownloadInfo *)downloadInfo{
    NSArray* cellArr = [gridView visibleCells];
    for(id obj in cellArr)
    {
        if([obj isKindOfClass:[UIGridViewRow class]])
        {
            UIGridViewRow* row = (UIGridViewRow*)obj;
            int numCols = (int)[gridView.uiGridViewDelegate numberOfColumnsOfGridView:gridView];
            for (int i = 0; i < numCols; i++) {
                if (row.contentView.subviews.count > i) {
                    DownloadItemCell* cell = [row.contentView.subviews objectAtIndex:i];
                    if (!cell.hidden) {
                        [cell updateCell:downloadInfo.taskIdentifier];
                    }
                }
            }
        }
    }
    NSLog(@"download fail :%ld", downloadInfo.taskIdentifier);
}

- (void) deleteItemInfo:(FileDownloadInfo*) info{
    if (info.isDownloaded) {
        Video *vd = info.videoDownload;
        BOOL success = [[DBHelper sharedInstance] deleteFileDownloaded:vd.video_id withQuality:info.quality];
        if (success) {
            [self loadVideoDownload];
        }
    }else{
        [[DownloadManager sharedInstance] stop:info];
        [self loadVideoDownload];
    }
    
}


@end
