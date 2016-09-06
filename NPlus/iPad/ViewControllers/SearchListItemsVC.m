//
//  SubListVideoVC.m
//  NPlus
//
//  Created by Vo Chuong Thien on 11/6/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "SearchListItemsVC.h"

#define BANNER_HEIGHT 310

@interface GridListItemsVC ()

@end

@implementation SearchListItemsVC

- (void)viewDidLoad {
    
    // Do any additional setup after loading the view from its nib.
//    [self.view setBackgroundColor:kBackgroundDarkColor];
    [self.view setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    [gridView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
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
//    [gridView.tableHeaderView setBackgroundColor:[UIColor redColor]];
    [super viewDidLoad];
}


//- (void) viewWillAppear:(BOOL)animated{
//    NSLog(@"aaa");
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark LoadData

- (void) loadData{
    [self loadDataWithType:self.mListType];
}

- (void) loadDataWithType:(ListType) type{
    if (!mKeyWord || [mKeyWord isEqualToString:@""]) {
        [self showConnectionErrorView:NO];
        [self showNoDataView:YES];
    }else{
        if (type == video_type) {
            // load list videos
            [self loadSearchVideos:self.curPage pageSize:kPageSize];
        }else if(type == channel_type){
            // load list channels
            [self loadSearchChannels:self.curPage pageSize:kPageSize];
        }else if(type == artist_type){
            // load list artists
            [self loadSearchsArtists:self.curPage pageSize:kPageSize];
        }
    }
}

- (void) loadSearchVideos:(int) pageIndex pageSize:(int) pageSize{
    if (self.dataSources.count == 0) {
        [self showConnectionErrorView:NO];
        [self showNoDataView:NO];
        [self showLoadingDataView:YES];
    }
    [[APIController sharedInstance] searchVideoByKeyword:mKeyWord pageIndex:pageIndex pageSize:pageSize completed:^(int code, NSArray * results, BOOL loadmore, int total) {
        if (results) {
            self.isLoadMore = loadmore;
            if (self.curPage == kFirstPage) {
                [self.dataSources removeAllObjects];
//                [self.dataSources addObjectsFromArray:results];
                [self.dataSources addObject:[NSMutableArray arrayWithArray:results]];
                if ([[self.dataSources objectAtIndex:0] count] == 0) {
                    [self showNoDataView:YES];
                }
            }else{
                [[self.dataSources objectAtIndex:0] addObjectsFromArray:results];
            }
            [self finishLoadData];
            [self showLoadingDataView:NO];
        }else{
            [self showLoadingDataView:NO];
            [self finishLoadData];
            [self showNoDataView:YES];
        }
    } failed:^(NSError *error) {
        if ([[self.dataSources objectAtIndex:0] count] == 0) {
            [self showLoadingDataView:NO];
            [self finishLoadData];
            if (APPDELEGATE.internetConnnected) {
                [self showNoDataView:YES];
                [self showConnectionErrorView:NO];
            }else{
                [self showNoDataView:NO];
                [self showConnectionErrorView:YES];
            }
        }
    } ];
}

- (void) loadSearchChannels:(int) pageIndex pageSize:(int) pageSize{
    if (self.dataSources.count == 0) {
        [self showConnectionErrorView:NO];
        [self showNoDataView:NO];
        [self showLoadingDataView:YES];
    }
    [[APIController sharedInstance] searchChannelByKeyword:mKeyWord pageIndex:pageIndex pageSize:pageSize completed:^(int code, NSArray * results, BOOL loadmore, int total) {
        if (results) {
            self.isLoadMore = loadmore;
            if (self.curPage == kFirstPage) {
                [self.dataSources removeAllObjects];
                [self.dataSources addObject:[NSMutableArray arrayWithArray:results]];
                if ([[self.dataSources objectAtIndex:0] count] == 0) {
                    [self showNoDataView:YES];
                }
            }else{
                [[self.dataSources objectAtIndex:0] addObjectsFromArray:results];
            }
            [self finishLoadData];
            [self showLoadingDataView:NO];
        }else{
            [self showLoadingDataView:NO];
            [self finishLoadData];
            [self showNoDataView:YES];
        }
    } failed:^(NSError *error) {
        if ([[self.dataSources objectAtIndex:0] count] == 0) {
            [self showLoadingDataView:NO];
            [self finishLoadData];
            if (APPDELEGATE.internetConnnected) {
                [self showNoDataView:YES];
                [self showConnectionErrorView:NO];
            }else{
                [self showNoDataView:NO];
                [self showConnectionErrorView:YES];
            }
        }
    } ];
}

- (void) loadSearchsArtists:(int) pageIndex pageSize:(int) pageSize{
    if (self.dataSources.count == 0) {
        [self showConnectionErrorView:NO];
        [self showNoDataView:NO];
        [self showLoadingDataView:YES];
    }
    [[APIController sharedInstance] searchArtistByKeyword:mKeyWord pageIndex:pageIndex pageSize:pageSize completed:^(int code, NSArray * results, BOOL loadmore, int total) {
        if (results) {
            self.isLoadMore = loadmore;
            if (self.curPage == kFirstPage) {
                [self.dataSources removeAllObjects];
                [self.dataSources addObject:[NSMutableArray arrayWithArray:results]];
                if ([[self.dataSources objectAtIndex:0] count] == 0) {
                    [self showNoDataView:YES];
                }
            }else{
                [[self.dataSources objectAtIndex:0] addObjectsFromArray:results];
            }
            [self finishLoadData];
            [self showLoadingDataView:NO];
        }else{
            [self showLoadingDataView:NO];
            [self finishLoadData];
            [self showNoDataView:YES];
        }
    } failed:^(NSError *error) {
        if ([[self.dataSources objectAtIndex:0] count] == 0) {
            [self showLoadingDataView:NO];
            [self finishLoadData];
            if (APPDELEGATE.internetConnnected) {
                [self showNoDataView:YES];
                [self showConnectionErrorView:NO];
            }else{
                [self showNoDataView:NO];
                [self showConnectionErrorView:YES];
            }
        }
    } ];
}


- (void) loadDataWithKeyWord:(NSString*) keyWord andListType:(ListType) type{
    if (type != self.mListType || ![keyWord isEqualToString:mKeyWord]) {
        self.curPage = kFirstPage;
        [self.dataSources removeAllObjects];
        [gridView setContentOffset:CGPointZero animated:NO];
    }
    self.mListType = type;
    mKeyWord = keyWord;
    if (self.mListType == video_type) {
        [gridView setIdentifierName:@"videoItemCell"];
    }else if(self.mListType == channel_type){
        [gridView setIdentifierName:@"channelItemCell"];
    }else if(self.mListType == artist_type){
        [gridView setIdentifierName:@"artistItemCell"];
    }else if(self.mListType == cuatui_channel_type){
        [gridView setIdentifierName:@"channelLikedItemCell"];
    }else if(self.mListType == cuatui_video_type){
        [gridView setIdentifierName:@"videoDownloadedItemCell"];
    }
    [self loadData];
}

#pragma mark Grid Delegate

- (NSInteger) numberOfSectionsInGridView:(UIGridView *)grid{
    return self.dataSources.count;
}

- (NSInteger) gridView:(UIGridView *)grid numberOfRowsInSection:(NSInteger)section{
    //    return self.dataSources.count;
    if (self.dataSources.count > section) {
        return [[self.dataSources objectAtIndex:section] count];
    }
    return 0;
}

- (CGFloat) gridView:(UIGridView *)grid heightForHeaderInSection:(int) section{
    return 0;
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
    
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

#pragma mark -
#pragma mark GridView Delegate

//- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
//{
//    return 3;
//}
//
//
//- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
//{
//    return self.dataSources.count;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
