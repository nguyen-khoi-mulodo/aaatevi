//
//  GridViewBaseVC.m
//  NPlus
//
//  Created by Vo Chuong Thien on 11/6/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "GridViewBaseVC.h"
#import "FileDownloadInfo.h"
#import "VideoItemCell.h"
#import "VideoNewItemCell.h"
#import "ChannelItemCell.h"
#import "ArtistItemCell.h"
#import "VideoDownloadedItemCell.h"
#import "HomeItemViewCell.h"

@interface GridViewBaseVC ()

@end

@implementation GridViewBaseVC

#define COLUMN_NUMS_NORMAL_ITEM 7
#define COLUMN_NUMS_VIDEO_ITEM 5
#define COLUMN_NUMS_SEARCH_ITEM 6
#define COLUMN_NUMS_ARTIST_ITEM 4
#define COLUMN_NUMS_NORMAL_ITEMS 4
#define COLUMN_NUMS_CHANNEL_LIKED_ITEMS 2

#define TOP_HEIGHT 65
#define BOTTOM_HEIGHT 60
#define HEADER_HEIGHT 60

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSources = [[NSMutableArray alloc] init];
    _curPage = kFirstPage;
    [self showNoDataView:NO];
    [self showLoadingDataView:NO];
    [self showConnectionErrorView:NO];
    [self loadData];
    // Do any additional setup after loading the view.
}

//- (void) viewWillAppear:(BOOL)animated{
//    [self loadData];
//}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    if (_screenType == home_type) {
        return 250;
    }else if(_screenType == liked_type || _screenType == xemsau_type){
        return 502;
    }
    return 250;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    if (_screenType == liked_type) {
        return 144;
    }else if(_screenType == xemsau_type){
        return 144;
    }else if(_screenType == download_type){
        return 250;
    }else{
        if (_screenType == home_type) {
            return 208;
        }
//        if (_mListType == video_type) {
//            if (([_mDataType isEqualToString:NEW_TYPE] && _screenType == khampha_type) || (_screenType == search_type)) {
//                return 208;
//            }
//            return 208;
//        }else if(_mListType == channel_type){
//            return 290;
//        }else if(_mListType == artist_type){
//            return 229;
//        }
    }
    return 208;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    if (_screenType == search_type && _mListType == artist_type) {
        return COLUMN_NUMS_ARTIST_ITEM;
    }else if(_screenType == liked_type || _screenType == xemsau_type){
        return COLUMN_NUMS_CHANNEL_LIKED_ITEMS;
    }
    return COLUMN_NUMS_NORMAL_ITEMS;
}


- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex andSection:(int) section
{
    
    static NSString *CellIdentifier1 = @"videoItemCell";
    static NSString *CellIdentifier2 = @"channelItemCell";
    static NSString *CellIdentifier3 = @"homeItemCell";
    static NSString *CellIdentifier4 = @"artistItemCell";
    if (_screenType == khampha_type || _screenType == phimbo_type || _screenType == phimle_type || _screenType == giaitri_type || _screenType == phimngan_type || _screenType == tvshow_type || _screenType == search_type) {
        int index = rowIndex * (int)[grid.uiGridViewDelegate numberOfColumnsOfGridView:grid] + columnIndex;
        NSMutableArray* arr = [self.dataSources objectAtIndex:section];
        if (arr.count > index) {
            id item = [arr objectAtIndex:index];
            if ([item isKindOfClass:[Video class]]) {
                VideoItemCell *cell = (VideoItemCell *)[grid dequeueReusableCell:CellIdentifier1];
                if (cell == nil) {
                    cell = [[VideoItemCell alloc] init];
                }
                Video* video = (Video*)item;
                [cell setVideo:video isShowActionView:(_screenType == xemsau_type)];
                return cell;
            }else if([item isKindOfClass:[Channel class]]){
                ChannelItemCell *cell = (ChannelItemCell *)[grid dequeueReusableCell:CellIdentifier2];
                if (cell == nil) {
                    cell = [[ChannelItemCell alloc] init];
                }
                Channel* channel = (Channel*)item;
                [cell setContentChannel:channel];
                return cell;
            }else if([item isKindOfClass:[Artist class]]){
                ArtistItemCell *cell = (ArtistItemCell *)[grid dequeueReusableCell:CellIdentifier4];
                if (cell == nil) {
                    cell = [[ArtistItemCell alloc] init];
                }
                Artist* artist = (Artist*)item;
                [cell setContentWithArtist:artist];
                return cell;
            }
        }
    }else if(_screenType == home_type){
        int index = rowIndex * (int)[grid.uiGridViewDelegate numberOfColumnsOfGridView:grid] + columnIndex;
        NSMutableArray* arr = [self.dataSources objectAtIndex:section];
        if (arr.count > index) {
            id item = [arr objectAtIndex:index];
            HomeItemViewCell *cell = (HomeItemViewCell *)[grid dequeueReusableCell:CellIdentifier3];
            if (cell == nil) {
                cell = [[HomeItemViewCell alloc] init];
            }
            [cell setItem:item];
            return cell;

        }
    }
    
//        if (_mListType == video_type) {
//            if ((_screenType == khampha_type && [_mDataType isEqualToString:NEW_TYPE]) || _screenType == search_type) {
//                VideoNewItemCell *cell = (VideoNewItemCell *)[grid dequeueReusableCell:@"videoNewItemCell"];
//                if (cell == nil) {
//                    cell = [[VideoNewItemCell alloc] init];
//                }
//                
//                int index = rowIndex * (int)[grid.uiGridViewDelegate numberOfColumnsOfGridView:grid] + columnIndex;
//                if (self.dataSources.count > index) {
//                    id item = [self.dataSources objectAtIndex:index];
//                    if ([item isKindOfClass:[Video class]]) {
//                        Video* video = (Video*)item;
//                        [cell setVideo:video isShowActionView:(_screenType == xemsau_type)];
//                    }
//                }
//                return cell;
//            }else{
//                VideoItemCell *cell = (VideoItemCell *)[grid dequeueReusableCell:@"videoItemCell"];
//                if (cell == nil) {
//                    cell = [[VideoItemCell alloc] init];
//                }
//                
//                int index = rowIndex * (int)[grid.uiGridViewDelegate numberOfColumnsOfGridView:grid] + columnIndex;
//                if ([[self.dataSources objectAtIndex:section] count]  > index) {
//                    id item = [[self.dataSources objectAtIndex:section] objectAtIndex:index];
//                    if ([item isKindOfClass:[Video class]]) {
//                        Video* video = (Video*)item;
//                        [cell setVideo:video isShowActionView:(_screenType == xemsau_type)];
//                    }
//                }
//                return cell;
//            }
//            
//        }else if(_mListType == channel_type){
//            ChannelItemCell *cell = (ChannelItemCell *)[grid dequeueReusableCell:@"channelItemCell"];
//            if (cell == nil) {
//                cell = [[ChannelItemCell alloc] init];
//            }
//            int index = rowIndex * (int)[grid.uiGridViewDelegate numberOfColumnsOfGridView:grid] + columnIndex;
//            if (self.dataSources.count > index) {
//                id item = [self.dataSources objectAtIndex:index];
//                if ([item isKindOfClass:[Channel class]]) {
//                    Channel* channel = (Channel*)item;
//                    [cell setContentChannel:channel];
//                }
//            }
//            return cell;
//        }else if(_mListType == artist_type){
//            ArtistItemCell *cell = (ArtistItemCell *)[grid dequeueReusableCell:@"artistItemCell"];
//            if (cell == nil) {
//                cell = [[ArtistItemCell alloc] init];
//            }
//            int index = rowIndex * (int)[grid.uiGridViewDelegate numberOfColumnsOfGridView:grid] + columnIndex;
//            if (self.dataSources.count > index) {
//                id item = [self.dataSources objectAtIndex:index];
//                if ([item isKindOfClass:[Artist class]]) {
//                    Artist* artist = (Artist*)item;
//                    [cell setContentWithArtist:artist];
//                }
//            }
//            return cell;
//        }
        
        
//    }else if(_screenType == liked_type){
//        ChannelLikedItemCell *cell = (ChannelLikedItemCell *)[grid dequeueReusableCell:@"channelLikedItemCell"];
//        if (cell == nil) {
//            cell = [[ChannelLikedItemCell alloc] init];
//        }
//        [cell setDelegate:self];
//        int index = rowIndex * (int)[grid.uiGridViewDelegate numberOfColumnsOfGridView:grid] + columnIndex;
//        if (self.dataSources.count > index) {
//            id item = [self.dataSources objectAtIndex:index];
//            if ([item isKindOfClass:[Channel class]]) {
//                Channel* channel = (Channel*)item;
//                [cell setContent:channel];
//            }
//        }
//        return cell;
//    }else if(_screenType == xemsau_type){
//        VideoXemSauItemCell *cell = (VideoXemSauItemCell *)[grid dequeueReusableCell:@"videoXemSauItemCell"];
//        if (cell == nil) {
//            cell = [[VideoXemSauItemCell alloc] init];
//        }
//        [cell setDelegate:self];
//        int index = rowIndex * (int)[grid.uiGridViewDelegate numberOfColumnsOfGridView:grid] + columnIndex;
//        if (self.dataSources.count > index) {
//            id item = [self.dataSources objectAtIndex:index];
//            if ([item isKindOfClass:[Video class]]) {
//                Video* video = (Video*)item;
//                [cell setContent:video];
//            }
//        }
//        return cell;
//    }else if(_screenType == download_type){
//        DownloadItemCell *cell = (DownloadItemCell *)[grid dequeueReusableCell:@"downloadItemCell"];
//        if (cell == nil) {
//            cell = [[DownloadItemCell alloc] init];
//        }
//        [cell setDelegate:self];
//        int index = rowIndex * (int)[grid.uiGridViewDelegate numberOfColumnsOfGridView:grid] + columnIndex;
//        if (self.dataSources.count > index) {
//            id item = [self.dataSources objectAtIndex:index];
//            if ([item isKindOfClass:[FileDownloadInfo class]]) {
//                FileDownloadInfo* info = (FileDownloadInfo*)item;
//                [cell setDownloadInfo:info];
//            }
//        }
//        return cell;
//    }
    return nil;
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex andSection:(int) section
{
    int index = rowIndex * (int)[grid.uiGridViewDelegate numberOfColumnsOfGridView:grid] + colIndex;
    NSMutableArray* arr = [self.dataSources objectAtIndex:section];
    if (arr.count > index) {
        id item = [arr objectAtIndex:index];
        if ([item isKindOfClass:[Video class]]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(showVideo:)]) {
                [self.delegate showVideo:item];
            }
        }else if([item isKindOfClass:[Channel class]]){
            if (self.delegate && [self.delegate respondsToSelector:@selector(showChannel:)]){
                [self.delegate showChannel:item];
            }
        }else if([item isKindOfClass:[Artist class]]){
            if (self.delegate && [self.delegate respondsToSelector:@selector(showArtist:)]) {
                [self.delegate showArtist:item];
            }
        }else if ([item isKindOfClass:[FileDownloadInfo class]]){
            if (self.delegate && [self.delegate respondsToSelector:@selector(showVideo:)]) {
                [self.delegate showVideo:item];
            }
        }
    }
}

#pragma mark Helper
- (void) myDealloc
{
    if ([self.dataView isKindOfClass:[UITableView class]])
    {
        UITableView *tableView = (UITableView *) self.dataView;
        tableView.delegate = nil;
        tableView.dataSource = nil;
        [tableView removeFromSuperview];
        self.dataView = nil;
    }
    if ([self.dataView isKindOfClass:[UICollectionView class]])
    {
        UICollectionView *tableView = (UICollectionView *) self.dataView;
        tableView.delegate = nil;
        tableView.dataSource = nil;
        [tableView removeFromSuperview];
        self.dataView = nil;
    }
    if (self.dataSources)
    {
        [self.dataSources removeAllObjects];
        self.dataSources = nil;
    }
}

- (void)reloadTableViewDataSource
{
    _reloading = YES;
    _curPage = kFirstPage;
    [self loadData];
    [self finishLoadData];
}

-(void)loadData{
    NSLog(@"a");
}
-(void) loadMore
{
    _curPage++;
    [self loadData];
}


- (void)doneLoadingTableViewData
{
    _reloading = NO;
}

-(void)finishLoadData{
    if ([self.dataView respondsToSelector:@selector(reloadData)])
    {
        [self.dataView performSelector:@selector(reloadData)];
    }
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y + scrollView.frame.size.height  > (scrollView.contentSize.height - CELL_HEIGHT_MORE))
    {
        if(_isLoadMore)
        {
            [self loadMore];
            _isLoadMore = NO;
        }
    }
}

-(void) showConnectionErrorView: (BOOL) error
{
    if (self.errorView == nil)
    {
        self.errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.errorView.backgroundColor = [UIColor clearColor];
        
        UIView* containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 328, 161)];
        [containView setBackgroundColor:[UIColor clearColor]];
        [containView setCenter:self.errorView.center];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(96, 16, 135, 91)];
        imageview.image = [UIImage imageNamed:@"mat-ket-noi-ipad"];
        [containView addSubview:imageview];
        
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, containView.frame.size.width, 21)];
        text.text = @"Mất kết nối, vui lòng thử lại sau.";
        text.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        text.backgroundColor = [UIColor clearColor];
        text.font = [UIFont fontWithName:kFontRegular size:18.0f];
        text.textAlignment = NSTextAlignmentCenter;
        [containView addSubview:text];
        [containView setTag:1000];
        
        [self.errorView addSubview:containView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.errorView.bounds;
        [button addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
        [self.errorView addSubview:button];
        [self.view addSubview:self.errorView];
    }else{
        float bottomHeight = 0;
        float topHeight = 0;
        if(self.screenType == home_type || self.screenType == download_type){
            bottomHeight = BOTTOM_HEIGHT;
            topHeight = (self.view.frame.origin.y > 0) ? 0 : TOP_HEIGHT;
        }else if(self.screenType == giaitri_type || self.screenType == phimngan_type || self.screenType == tvshow_type || self.screenType == khampha_type || self.screenType == search_type){
            bottomHeight = BOTTOM_HEIGHT;
            topHeight = (self.view.frame.origin.y > 0) ? 0 : (TOP_HEIGHT + BOTTOM_HEIGHT);
        }else if(self.screenType == liked_type || self.screenType == xemsau_type){
            bottomHeight = BOTTOM_HEIGHT;
            topHeight = (self.view.frame.origin.y > 0) ? 0 : (287 + BOTTOM_HEIGHT);
        }
        [self.errorView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomHeight - topHeight)];
        UIView* view = [self.errorView viewWithTag:1000];
        [view setCenter:self.errorView.center];
    }
    self.dataView.hidden = error;
    self.errorView.hidden = !error;
}

- (void) showNoDataView: (BOOL) show
{
    if (self.noDataView == nil) {
        if (IS_IPAD) {
            self.noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        }else{
            self.noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, self.view.frame.size.height)];
        }
        self.noDataView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:self.noDataView atIndex:0];
        UILabel *text = [[UILabel alloc] initWithFrame:self.noDataView.bounds];
        text.text = @"Chưa có dữ liệu";
        text.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        text.backgroundColor = [UIColor clearColor];
        text.font = [UIFont fontWithName:kFontRegular size:18.0f];
        text.textAlignment = NSTextAlignmentCenter;
        text.tag = 1000;
        [self.noDataView addSubview:text];
    }
    else{
        float bottomHeight = 0;
        float topHeight = 0;
        if(self.screenType == home_type || self.screenType == download_type){
            bottomHeight = BOTTOM_HEIGHT;
            topHeight = (self.view.frame.origin.y > 0) ? 0 : TOP_HEIGHT;
        }else if(self.screenType == giaitri_type || self.screenType == phimngan_type || self.screenType == tvshow_type || self.screenType == khampha_type || self.screenType == search_type){
            bottomHeight = BOTTOM_HEIGHT;
            topHeight = (self.view.frame.origin.y > 0) ? 0 : (TOP_HEIGHT + BOTTOM_HEIGHT);
        }
        [self.noDataView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomHeight - topHeight)];
        UIView* view = [self.noDataView viewWithTag:1000];
        [view setCenter:self.noDataView.center];
    }
    
    self.dataView.hidden = show;
    self.noDataView.hidden = !show;
}

-(void)showLoadingDataView:(BOOL)show{
    if (self.loadingDataView == nil) {
        if (IS_IPAD) {
            self.loadingDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        }else{
            self.loadingDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, self.view.frame.size.height)];
        }
        self.loadingDataView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.loadingDataView];
        UIActivityIndicatorView* loadView;
        if (IS_IPAD) {
            loadView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        }else{
            loadView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
        loadView.center = self.loadingDataView.center;
        loadView.tag = 1000;
        [loadView startAnimating];
        [self.loadingDataView addSubview:loadView];
    }else{
        float bottomHeight = 0;
        float topHeight = 0;
        if(self.screenType == home_type || self.screenType == download_type){
            bottomHeight = BOTTOM_HEIGHT;
            topHeight = (self.view.frame.origin.y > 0) ? 0 : TOP_HEIGHT;
        }else if(self.screenType == giaitri_type || self.screenType == phimngan_type || self.screenType == tvshow_type || self.screenType == khampha_type || self.screenType == search_type){
            bottomHeight = BOTTOM_HEIGHT;
            topHeight = (self.view.frame.origin.y > 0) ? 0 : (TOP_HEIGHT + BOTTOM_HEIGHT);
        }else if(self.screenType == liked_type || self.screenType == xemsau_type){
            bottomHeight = BOTTOM_HEIGHT;
            topHeight = (self.view.frame.origin.y > 0) ? 0 : (287 + BOTTOM_HEIGHT);
        }
        [self.loadingDataView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomHeight- topHeight)];
        UIView* view = [self.loadingDataView viewWithTag:1000];
        [view setCenter:self.loadingDataView.center];
    }
    self.dataView.hidden = show;
    self.loadingDataView.hidden = !show;
}





@end
