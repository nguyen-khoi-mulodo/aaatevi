//
//  XemSauController.m
//  NPlus
//
//  Created by Khoi Nguyen on 5/15/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "XemSauController.h"
#import "UIViewController+AKTabBarController.h"
#import "AKTabBarController.h"
#import "ShareTask.h"
#import "MyNavigationItem.h"

@interface XemSauController () {
    MyNavigationItem *myNavi;
}

@end

@implementation XemSauController

- (void)viewDidLoad {
    [super viewDidLoad];
    myNavi = [[MyNavigationItem alloc] initWithController:self type:9];
    self.tbMain.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tbMain.separatorColor = UIColorFromRGB(0xf0f0f0);
    [self.tbMain setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    [self.tbMain registerNib:[UINib nibWithNibName:@"ItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"itemCellIdef"];
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.tbMain.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveInternetNoti) name:kDidConnectInternet object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Video xem sau";
    [self trackScreen:@"iOS.ProfileWatchlater"];
    self.navigationController.navigationBarHidden = NO;
    APPDELEGATE.rootNavController.navigationBarHidden = YES;
    //[self showNoDataView:(self.dataSources.count == 0)];
    [self firstLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    NSLayoutConstraint *constranitTopTable = [self.view.constraints objectAtIndex:6];
//    constranitTopTable.constant = 64;
    [self.view layoutIfNeeded];
    [self.view setNeedsLayout];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receiveInternetNoti {
    self.viewNoConnection.hidden = YES;
    [self firstLoad];
}

- (void)firstLoad {
    self.pageIndex = 1;
    self.total = 0;
    self.isLoadMore = NO;
    [self.dataSources removeAllObjects];
    
    [self getUserVideosPageIndex:self.pageIndex pageSize:kDefaultPageSize showLoading:YES];
}

- (void)loadDataIsAnimation:(BOOL)isAnimation {
    self.pageIndex = 1;
    self.total = 0;
    self.isLoadMore = NO;
    [self.dataSources removeAllObjects];
    [self getUserVideosPageIndex:self.pageIndex pageSize:kDefaultPageSize showLoading:NO];
}
- (void)getUserVideosPageIndex:(int)pageIndex pageSize:(int)pageSize showLoading:(BOOL)isShowLoading{
    if (APPDELEGATE.internetConnnected) {
        if (APPDELEGATE.isLogined) {
            if (isShowLoading) {
                [self showProgressHUDWithTitle:nil];
            }
            [[APIController sharedInstance]userGetListVideoPageIndex:pageIndex pageSize:pageSize completed:^(int code, NSArray *results, BOOL loadmore, int total) {
                if (results) {
                    NSArray *array = results;
                    [self.dataSources addObjectsFromArray:array];
                }
                self.isLoadMore = loadmore;
                if (loadmore) {
                    self.pageIndex = self.pageIndex + 1;
                }
                [self.tbMain reloadData];
                [self dismissHUD];
                [self showNoDataView:(self.dataSources.count == 0)];
            } failed:^(NSError *error) {
                [self dismissHUD];
                [self showNoDataView:(self.dataSources.count == 0)];
            }];
        }
        self.viewNoConnection.hidden = YES;
    } else {
        self.viewNoConnection.hidden = NO;
    }
}

- (void)loadMore {
    if (self.isLoadMore) {
        [self getUserVideosPageIndex:self.pageIndex pageSize:kDefaultPageSize showLoading:NO];
    }
}
#pragma mark - UITableView

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *itemCellIdef = @"itemCellIdef";
    ItemCell *cell = (ItemCell*)[self.tbMain dequeueReusableCellWithIdentifier:itemCellIdef];
    if (!cell) {
        cell = [Utilities loadView:[ItemCell class] FromNib:@"ItemCell"];
    }
    
    if (indexPath.row < self.dataSources.count) {
        Video* item = [self.dataSources objectAtIndex:indexPath.row];
        cell.video = item;
        [cell loadContentWithType:typeWatchLater];
        cell.delegate = self;
    }
    cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSources.count > indexPath.row) {
        Video *item = [self.dataSources objectAtIndex:indexPath.row];
        [APPDELEGATE didSelectVideoCellWith:item];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSources.count > indexPath.row) {
            
    }
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"commit editing");
}

- (void) showNoDataView: (BOOL) show{
    //[myNavi.rightBtn setHidden:show];
    [super showNoDataView:show];
}

#pragma mark - ItemCell Delegate
- (void)didButtonMoreTapped:(id)object {
    if ([object isKindOfClass:[Video class]]) {
        Video *video = (Video*)object;
        MoreOptionView *moreView = [[MoreOptionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height) type:1 object:video linkShare:video.link_share];
        moreView.delegate = self;
        [APPDELEGATE.window addSubview:moreView];
    }
}
#pragma mark - MoreOptionView Delegate
- (void)didTappedButtonIndex:(int)index object:(id)object linkShare:(NSString *)linkShare title:(NSString *)title{
    if (index == 1 || index == 2) {
        if ( !linkShare || [linkShare isEqualToString:@""]) {
            if ([object isKindOfClass:[Video class]]) {
                Video *video = (Video*)object;
                [[APIController sharedInstance]getVideoDetailWithKey:video.video_id completed:^(int code, Video *results) {
                    if (results) {
                        if (!results.link_share || [results.link_share isEqualToString:@""]) {
                            [APPDELEGATE showToastWithMessage:@"Hiện chưa có link chia sẻ cho video này." position:@"top" type:errorImage];
                            return;
                        }
                        if (index == 1 && [title isEqualToString:@"Chia sẻ Facebook"]) {
                            [[ShareTask sharedInstance] setViewController:self];
                            [[ShareTask sharedInstance] shareFacebook:results];
                        } else if (index == 2 && [title isEqualToString:@"Copy Link"]) {
                            [self trackEvent:@"iOS_share_on_copy_link"];
                            NSString *dataText = results.link_share;
                            if (dataText && ![dataText isKindOfClass:[NSNull class]]) {
                                [[UIPasteboard generalPasteboard] setString:dataText];
                                [APPDELEGATE showToastWithMessage:@"Đã copy link" position:@"top" type:doneImage];
                            }
                        }
                    }
                } failed:^(NSError *error) {
                    
                }];
            }
            
            return;
        }
        if ([object isKindOfClass:[Video class]] && index == 1 && [title isEqualToString:@"Chia sẻ Facebook"]){
            if (!linkShare || [linkShare isEqualToString:@""]) {
                [APPDELEGATE showToastWithMessage:@"Hiện chưa có link chia sẻ cho video này." position:@"top" type:errorImage];
                return;
            }
            Video *video = (Video*)object;
            [[ShareTask sharedInstance] setViewController:self];
            [[ShareTask sharedInstance] shareFacebook:video];
            
        } else if ([object isKindOfClass:[Video class]] && index == 2 && [title isEqualToString:@"Copy Link"]) {
            if (!linkShare || [linkShare isEqualToString:@""]) {
                [APPDELEGATE showToastWithMessage:@"Hiện chưa có link chia sẻ cho video này." position:@"top" type:errorImage];
                return;
            }
            [self trackEvent:@"iOS_share_on_copy_link"];
            NSString *dataText = linkShare;
            if (dataText && ![dataText isKindOfClass:[NSNull class]]) {
                [[UIPasteboard generalPasteboard] setString:dataText];
                [APPDELEGATE showToastWithMessage:@"Đã copy link." position:@"top" type:doneImage];
            }
        }
    }
    else if ([object isKindOfClass:[Video class]] && index == 3 && [title isEqualToString:@"Bỏ xem sau"]) {
        Video *video = (Video*)object;
        [[APIController sharedInstance] userSubcribeVideo:video.video_id subcribe:NO completed:^(int code, BOOL results) {
            if (results) {
                if (APPDELEGATE.nowPlayerVC.currentVideo && [APPDELEGATE.nowPlayerVC.currentVideo.video_id isEqualToString:video.video_id]) {
                    APPDELEGATE.nowPlayerVC.currentVideo.is_like = NO;
                    [APPDELEGATE.nowPlayerVC.player.view.btnLike setImage:[UIImage imageNamed:@"icon-xemsau-white-v2"]  forState:UIControlStateNormal];
                    [APPDELEGATE.nowPlayerVC.btnViewLater setImage:[UIImage imageNamed:@"icon-xemsau-black-v2"] forState:UIControlStateNormal];
                }
                [self loadDataIsAnimation:NO];
                
            }
        } failed:^(NSError *error) {
            
        }];
    }
}

@end
