//
//  GridViewBaseVC.h
//  NPlus
//
//  Created by Vo Chuong Thien on 11/6/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "BaseVC.h"
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "Constant.h"
#import "DownloadItemCell.h"
#import "EGORefreshTableHeaderView.h"
#import "VideoXemSauItemCell.h"
#import "ChannelLikedItemCell.h"

@protocol GridViewBaseDelegate <NSObject>
- (void) showVideo:(id) item;
- (void) showChannel:(id) item;
- (void) showArtist:(id) item;
- (void) shareFacebookWithItem:(id) item;


@end

@interface GridViewBaseVC : UIViewController <UIGridViewDelegate, DownloadItemDelegate, EGORefreshTableHeaderDelegate, VideoXemSauItemDelegate, ChannelLikedItemDelegate>
{
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
}

@property (nonatomic, strong) id <GridViewBaseDelegate> delegate;

@property MainScreenType screenType;
@property ListType mListType;
@property NSString* mDataType;

@property (nonatomic, strong) NSMutableArray* dataSources;
@property (nonatomic, assign) int curPage;
@property (nonatomic, assign) BOOL isLoadMore;
@property (strong, nonatomic) UIView* dataView;
@property (strong, nonatomic) UIView *errorView;
@property (strong, nonatomic) UIView *noDataView;
@property (strong, nonatomic) UIView *loadingDataView;


//@property BOOL isEdit;

- (void) loadData;
- (void) reloadTableViewDataSource;
- (void) doneLoadingTableViewData;
- (void) finishLoadData;
- (void) loadMore;
- (void) showConnectionErrorView:(BOOL) error;
- (void) showNoDataView: (BOOL) show;
- (void) showLoadingDataView: (BOOL) show;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void) setMListType:(ListType)mListType;
@end
