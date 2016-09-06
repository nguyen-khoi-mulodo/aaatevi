//
//  FollowController.m
//  NPlus
//
//  Created by Khoi Nguyen on 5/15/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "FollowController.h"
#import "UIViewController+AKTabBarController.h"
#import "AKTabBarController.h"
#import "ShareTask.h"
#import "MyNavigationItem.h"

@interface FollowController () {
    MyNavigationItem *myNavi;
}

@end

@implementation FollowController

- (void)viewDidLoad {
    [super viewDidLoad];
    myNavi = [[MyNavigationItem alloc] initWithController:self type:9];
    //myNavi.delegate = self;
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
    self.title = @"Kênh theo dõi";
    [self trackScreen:@"iOS.ProfileFollow"];
    self.navigationController.navigationBarHidden = NO;
    APPDELEGATE.rootNavController.navigationBarHidden = YES;
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
    
    [self getUserChannelsPageIndex:self.pageIndex pageSize:kDefaultPageSize showLoading:YES];
}

- (void)loadDataIsAnimation:(BOOL)isAnimation {
    self.pageIndex = 1;
    self.total = 0;
    self.isLoadMore = NO;
    [self.dataSources removeAllObjects];
    [self getUserChannelsPageIndex:self.pageIndex pageSize:kDefaultPageSize showLoading:NO];
}
- (void)getUserChannelsPageIndex:(int)pageIndex pageSize:(int)pageSize showLoading:(BOOL)isShowLoading{
    if (APPDELEGATE.internetConnnected) {
        if (APPDELEGATE.isLogined) {
            if (isShowLoading) {
                [self showProgressHUDWithTitle:nil];
            }
            [[APIController sharedInstance] userGetListChannelPageIndex:pageIndex pageSize:pageSize completed:^(int code, NSArray *results, BOOL loadmore, int total) {
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
        [self getUserChannelsPageIndex:self.pageIndex pageSize:kDefaultPageSize showLoading:NO];
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
        Channel* item = [self.dataSources objectAtIndex:indexPath.row];
        cell.channel = item;
        [cell loadContentWithType:typeFollow];
        cell.delegate = self;
    }
    cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSources.count > indexPath.row) {
        Channel *item = [self.dataSources objectAtIndex:indexPath.row];
        [APPDELEGATE didSelectChannelCellWith:item isPush:NO];
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
    if ([object isKindOfClass:[Channel class]]) {
        Channel *cn = (Channel*)object;
        MoreOptionView *moreView = [[MoreOptionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height) type:3 object:cn linkShare:cn.linkShare];
        moreView.delegate = self;
        [APPDELEGATE.window addSubview:moreView];
    }
}
#pragma mark - MoreOptionView Delegate
- (void)didTappedButtonIndex:(int)index object:(id)object linkShare:(NSString *)linkShare title:(NSString *)title{
    if ([object isKindOfClass:[Channel class]] && index == 1 && [title isEqualToString:@"Chia sẻ Facebook"]){
        if (!linkShare || [linkShare isEqualToString:@""]) {
            [APPDELEGATE showToastWithMessage:@"Hiện chưa có link chia sẻ cho kênh này." position:@"top" type:errorImage];
                return;
        }
        Channel *channel = (Channel*)object;
        [[ShareTask sharedInstance] setViewController:self];
        [[ShareTask sharedInstance] shareFacebook:channel];

    } else if ([object isKindOfClass:[Channel class]] && index == 2 && [title isEqualToString:@"Copy Link"]) {
        if (!linkShare || [linkShare isEqualToString:@""]) {
            [APPDELEGATE showToastWithMessage:@"Hiện chưa có link chia sẻ cho kênh này." position:@"top" type:errorImage];
                    return;
        }
        [self trackEvent:@"iOS_share_on_copy_link"];
        NSString *dataText = linkShare;
        if (dataText && ![dataText isKindOfClass:[NSNull class]]) {
            [[UIPasteboard generalPasteboard] setString:dataText];
            [APPDELEGATE showToastWithMessage:@"Đã copy link." position:@"top" type:doneImage];
        }
    } else if ([object isKindOfClass:[Channel class]] && index == 3 && [title isEqualToString:@"Bỏ theo dõi"]) {
        Channel *channel = (Channel*)object;
        [[APIController sharedInstance] userSubcribeChannel:channel.channelId subcribe:NO completed:^(int code, BOOL results) {
            if (results) {
                if (APPDELEGATE.nowPlayerVC.curChannel) {
                    if ([APPDELEGATE.nowPlayerVC.curChannel.channelId isEqualToString:channel.channelId]) {
                        APPDELEGATE.nowPlayerVC.curChannel.isSubcribe = NO;
                        [APPDELEGATE.nowPlayerVC updateChannelInfo];
                    }
                }
                [APPDELEGATE showToastWithMessage:@"Đã xóa khỏi danh sách theo dõi!" position:@"top" type:doneImage];
                //[[NSNotificationCenter defaultCenter]postNotificationName:kDidSubcribeChannel object:nil];
                [self loadDataIsAnimation:NO];
            } else {
                [APPDELEGATE showToastWithMessage:@"Bỏ theo dõi không thành công!" position:@"top" type:errorImage];
            }
        } failed:^(NSError *error) {
            
        }];
    }
}
@end
