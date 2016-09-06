//
//  ListNotificationController.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/28/16.
//  Copyright © 2016 anhld. All rights reserved.
//

#import "ListNotificationController.h"
#import "NotificationCell.h"
#import "MyNavigationItem.h"

@interface ListNotificationController () {
    MyNavigationItem *myNavi;
}

@end

@implementation ListNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    myNavi = [[MyNavigationItem alloc]initWithController:self type:4];
    myNavi.rightBtn.hidden = YES;
    self.tbMain.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tbMain.separatorColor = UIColorFromRGB(0xf0f0f0);
    [self.tbMain setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.tbMain.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveInternetNoti) name:kDidConnectInternet object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Thông báo";
    [self trackScreen:@"iOS.ProfileNotification"];
    self.navigationController.navigationBarHidden = NO;
    APPDELEGATE.rootNavController.navigationBarHidden = YES;
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
    [self loadDataIsAnimation:NO];
}

- (void)loadDataIsAnimation:(BOOL)isAnimation {
    if (APPDELEGATE.internetConnnected) {
        [self.dataSources removeAllObjects];
        [[APIController sharedInstance]getListLocalNotifCompleted:^(int code, NSArray *results) {
            if (results) {
                self.dataSources = (NSMutableArray*)results;
                [self.tbMain reloadData];
            }
        } failed:^(NSError *error) {
            
        }];
        self.viewNoConnection.hidden = YES;
    } else {
        self.viewNoConnection.hidden = NO;
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
    
    static NSString *notifCellIdef = @"notifCellIdef";
    NotificationCell *cell = (NotificationCell*)[self.tbMain dequeueReusableCellWithIdentifier:notifCellIdef];
    if (!cell) {
        cell = [Utilities loadView:[NotificationCell class] FromNib:@"NotificationCell"];
    }
    LocalNotif *localNotif = (LocalNotif*)[self.dataSources objectAtIndex:indexPath.row];
    cell.localNotif = localNotif;
    [cell loadData];
    cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSources.count > indexPath.row) {
        LocalNotif *localNotif = (LocalNotif*)[self.dataSources objectAtIndex:indexPath.row];
        if ([localNotif.type isEqualToString:@"channel"]) {
            Channel *channel = [[Channel alloc]init];
            channel.channelId = localNotif.key;
            [APPDELEGATE didSelectChannelCellWith:channel isPush:NO];
        }else if ([localNotif.type isEqualToString:@"video"]) {
            Video *video = [[Video alloc]init];
            video.video_id = localNotif.key;
            [APPDELEGATE didSelectVideoCellWith:video];
            
        }
    }
}

@end
