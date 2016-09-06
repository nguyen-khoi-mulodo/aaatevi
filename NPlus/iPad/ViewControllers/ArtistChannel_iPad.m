//
//  ArtistSuggestVC.m
//  NPlus
//
//  Created by Vo Chuong Thien on 1/19/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "ArtistChannel_iPad.h"
#import "Channel.h"
#import "ChannelsOfArtistItemCell.h"

#define pSize 9

@interface ArtistChannel_iPad ()

@end

@implementation ArtistChannel_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Load Data

- (void) loadData{
    [self loadDataWithArtist:self.mArtist];
}

- (void) loadDataWithArtist:(Artist*) artist{
    if (self.mArtist.artistId != artist.artistId) {
        self.mArtist = artist;
        self.curPage = kFirstPage;
        [gridView setContentOffset:CGPointZero animated:NO];
    }
    
    if (self.dataSources.count == 0) {
        [self showConnectionErrorView:NO];
        [self showNoDataView:NO];
        [self showLoadingDataView:YES];
    }
    [[APIController sharedInstance] getChannelOfArtist:artist.artistId pageIndex:(int)self.curPage pageSize:pSize completed:^(int code ,NSArray *results, BOOL loadmore, int total) {
        if (results) {
            self.isLoadMore = loadmore;
            if (self.curPage == kFirstPage) {
                [self.dataSources removeAllObjects];
//                [self.dataSources addObjectsFromArray:results];
                [self.dataSources addObject:[NSMutableArray arrayWithArray:results]];
                if (self.dataSources.count == 0) {
                    [self showNoDataView:YES];
                }
            }else{
//                [self.dataSources addObjectsFromArray:results];
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
                [self showNoDataView:YES];
                [self showConnectionErrorView:NO];
            }else{
                [self showNoDataView:NO];
                [self showConnectionErrorView:YES];
            }
        }
    }];
}

#pragma mark TableView Delegate

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

//-(void)viewDidLayoutSubviews
//{
//    if ([myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [myTableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [myTableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return 1;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataSources.count;
//}
//
//
//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 184;
//}
//
//// Customize the appearance of table view cells.
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *Identifier = @"channelFollowItemCell";
//    ChannelFollowItemCell *cell = (ChannelFollowItemCell *)[tableView dequeueReusableCellWithIdentifier:Identifier];
//    if (cell == nil)
//    {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChannelFollowItemCell" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//    }
//    if (indexPath.row < self.dataSources.count) {
//        Channel* channel = [self.dataSources objectAtIndex:indexPath.row];
//        [cell setContentWithChannel:channel];
//    }
//    return cell;
//}
//
//- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
//    if (indexPath.row < self.dataSources.count) {
//        Channel* channel = [self.dataSources objectAtIndex:indexPath.row];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(showChannel:)]) {
//            [self.delegate showChannel:channel];
//        }
//    }
//}

#pragma mark Grid Delegate

- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    return 208;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    return 177;
}

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

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    return 3;
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex andSection:(int) section
{
    
    static NSString *CellIdentifier1 = @"channelsOfArtistItemCell";
    int index = rowIndex * (int)[grid.uiGridViewDelegate numberOfColumnsOfGridView:grid] + columnIndex;
    NSMutableArray* arr = [self.dataSources objectAtIndex:section];
    if (arr.count > index) {
        id item = [arr objectAtIndex:index];
        if([item isKindOfClass:[Channel class]]){
            ChannelsOfArtistItemCell *cell = (ChannelsOfArtistItemCell *)[grid dequeueReusableCell:CellIdentifier1];
            if (cell == nil) {
                cell = [[ChannelsOfArtistItemCell alloc] init];
            }
            Channel* channel = (Channel*)item;
            [cell setContentChannel:channel];
            return cell;
        }
    }
    return nil;
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

@end
