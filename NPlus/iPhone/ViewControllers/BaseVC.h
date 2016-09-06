//
//  BaseVC.h
//  NPlus
//
//  Created by TEVI Team on 7/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "APIController.h"
#import "Channel.h"
#import "Video.h"
#import "GAITrackedViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface BaseVC : GAITrackedViewController<EGORefreshTableHeaderDelegate>{
    BOOL _reloading;
    
    UIView *_backgroundFooter;
    UIView *_backgroundHeader;
    EGORefreshTableHeaderView *_refreshHeaderView;
}
@property (nonatomic, assign) int curPage;
@property (nonatomic, assign) BOOL isLoadMore;
@property (strong, nonatomic) UIView *errorView;
@property (strong, nonatomic) UIView *noDataView;

@property (strong, nonatomic) UIView *loadingDataView;
@property (strong, nonatomic) UIView* dataView;
@property (strong, nonatomic) NSMutableArray *dataSources;

- (void) loadData;
- (void) loadDataIsAnimation:(BOOL)isAnimation;
- (void) reloadTableViewDataSource;
- (void) doneLoadingTableViewData;
- (void) finishLoadData;
- (void) showConnectionErrorView:(BOOL) error ;
- (void) showConnectionErrorView: (BOOL) error isFull:(BOOL) isFull;
- (void) showNoDataView: (BOOL) show;
- (void) showLoadingDataView: (BOOL) show;
- (void) loadMore;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)setBackgroundHeader;
- (void)setBackgroundFooter;
- (IBAction)btnHistory_Tapped:(id)sender;
- (IBAction)btnSearch_Tapped:(id)sender;
- (IBAction)btnStore_Tapped:(id)sender;

- (void)didLoginNotify;
- (void)didLogoutNotify;

- (void)myDealloc;
- (NSString*)screenNameGA;
- (void)trackScreen:(NSString*)screen;
- (void)trackEvent:(NSString*)event;
@end
