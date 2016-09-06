//
//  HomeVC.h
//  NPlus
//
//  Created by TEVI Team on 7/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "BaseVC.h"
#import "CycleScrollView.h"
#import "ILTranslucentView.h"
#import "MBProgressHUD.h"

@protocol HomeDelegate <NSObject>

@optional
- (void) scrollToTop:(BOOL) isScrollToTop;
- (void) scrollToTopWithNoDataView:(BOOL) isScrollToTop;
- (void)scrollShowHideBottomBar:(BOOL)hidden;

@end

@interface HomeVC : BaseVC <HomeDelegate,UIGestureRecognizerDelegate> {
    UITableViewController *tableViewController;
    UIRefreshControl *refreshControl;
}
@property (strong, nonatomic) IBOutlet UIImageView *imgBG;
@property (weak, nonatomic) IBOutlet UITableView *tbMain;
@property (weak, nonatomic) IBOutlet UILabel *lbNodata;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewNodata;
@property (weak, nonatomic) IBOutlet UIView *viewNoConnection;

@property (nonatomic, strong) id <HomeDelegate> homeDelgate;
@property (nonatomic, readwrite) BOOL scrollToTop;
@property float lastContentOffset;
@property (nonatomic, assign) BOOL isNeedUpdateContraints;
@property (nonatomic, assign) TypeCell typeCell;
@property int pageIndex;
@property int total;
//- (void)didLoginNotify;

//- (void)loadDataIsAnimation:(BOOL)isAnimation;
- (void)loadEmptyData;
- (MBProgressHUD *)showProgressHUDWithTitle:(NSString *)title;
- (void)dismissHUD;

@end
