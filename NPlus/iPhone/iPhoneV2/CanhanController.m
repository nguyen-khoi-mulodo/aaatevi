//
//  CanhanController.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/27/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "CanhanController.h"
#import "VideoView.h"
#import "NotificationCell.h"
#import "ListNotificationController.h"
#import "LocalNotif.h"
#import "ListHistoryController.h"
#import "UIViewController+AKTabBarController.h"
#import "AKTabBarController.h"
#import "DBHelper.h"
#import "CDHistory.h"
#import "AKTabBar.h"
#import "XemSauController.h"
#import "FollowController.h"
#import "LoginViewController.h"
#import "SettingController.h"

#define tagItem0 1000
#define tagItem1 1001
#define tagItem2 1002
#define tagItem3 1003
#define tagItem4 1004

@interface CanhanController () <AKTabBarDelegate,LoginControllerDelegate,VideoViewDelegate>{
    NSMutableArray *arrayNotif;
    NSMutableArray *arrayHistory;
    LoginViewController *_loginVC;
}

@end

@implementation CanhanController
- (NSString *)tabImageName
{
    return @"main-personal-v2";
}

- (NSString *)activeTabImageName
{
    return @"main-personal-h-v2";
}

- (NSString *)tabTitle
{
    return @"";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tbMain setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    self.tbMain.delegate = self;
    self.tbMain.dataSource = self;
    self.tbMain.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tbMain.separatorColor = UIColorFromRGB(0xf0f0f0);
    [self.tbMain registerNib:[UINib nibWithNibName:@"NotificationCell" bundle:nil] forCellReuseIdentifier:@"notifCellIdef"];
    [self.tbMain registerClass:[UITableViewCell self] forCellReuseIdentifier:@"emptyCell"];
    
    UIView *separatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 10)];
    separatorView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.tbMain.tableHeaderView = separatorView;
    
    //self.akTabBarController.tabBar.delegate = self;
    _avatarImg.clipsToBounds = YES;
    _avatarImg.layer.cornerRadius = _avatarImg.frame.size.width/2;
    _viewHeader.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-header-top-v2"]];
    
    _btnLogin.exclusiveTouch = YES;
    _btnFollow.exclusiveTouch = YES;
    _btnSetting.exclusiveTouch = YES;
    _btnDownload.exclusiveTouch = YES;
    _btnWatchLater.exclusiveTouch = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveDidLogout:) name:kDidLogoutNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self trackScreen:@"iOS.Profile"];
    self.navigationController.navigationBarHidden = YES;
    APPDELEGATE.rootNavController.navigationBarHidden = YES;
    [self.tbMain setContentOffset:CGPointZero];
    _viewHeader.hidden = NO;
    [self getLocalNotifData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _viewHeader.hidden = YES;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateUserInfo];
    [self getHistoryData];
//    [self getLocalNotifData];
    [self.akTabBarController showTabBarAnimated:YES];
    
    if(![[[kNSUserDefault dictionaryRepresentation] allKeys] containsObject:@"coachmark_thongbao"]){
        
        UIImageView *cm = [APPDELEGATE.window viewWithTag:904];
        if (cm) {
            return;
        }
        cm = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
        [cm setTag:904];
        
        NSString *nameCM = @"";
        if (IS_IPHONE_4_OR_LESS) {
            nameCM = @"coachmark-thongbao-ip4.png";
        } else if (IS_IPHONE_5) {
            nameCM = @"coachmark-thongbao-ip5.png";
        } else if (IS_IPHONE_6){
            nameCM = @"coachmark-thongbao-ip6.png";
        } else if (IS_IPHONE_6P) {
            nameCM = @"coachmark-thongbao-ip6p.png";
        } else {
            nameCM = @"coachmark-thongbao-ip6.png";
        }
        
        [cm setImage:[UIImage imageNamed:nameCM]];
        [APPDELEGATE.window addSubview:cm];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
        singleTap.numberOfTapsRequired = 1;
        [cm setUserInteractionEnabled:YES];
        [cm addGestureRecognizer:singleTap];
        
    }
}

- (void)tapDetected {
    [kNSUserDefault setObject:@"YES" forKey:@"coachmark_thongbao"];
    [kNSUserDefault synchronize];
    UIImageView *cm = [APPDELEGATE.window viewWithTag:904];
    if ([cm isKindOfClass:[UIImageView class]]) {
        [cm removeFromSuperview];
        cm = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)receiveDidLogout:(NSNotification*)notif {
    [self updateUserInfo];
}
- (void)updateUserInfo {
    if (APPDELEGATE.user) {
        [_avatarImg setImageWithURL:[NSURL URLWithString:APPDELEGATE.user.avatar] placeholderImage:[UIImage imageNamed:@"avatar-default-v2"]];
        _lblName.text = APPDELEGATE.user.displayName;
    } else {
        [_avatarImg setImage:[UIImage imageNamed:@"avatar-default-v2"]];
        _lblName.text = @"Đăng nhập";
    }
}


#pragma mark - Data
- (void)getHistoryData{
    arrayHistory = (NSMutableArray*)[[DBHelper sharedInstance] getVideoHistory];
    NSMutableArray *arrHisTemp = [arrayHistory mutableCopy];
    for (CDHistory *item in arrHisTemp) {
        if (!item.videoTitle || [item.videoTitle isEqualToString:@""] ) {
            [arrayHistory removeObject:item];
        }
    }
    [self.tbMain reloadData];
}

- (void)getLocalNotifData {
    if (APPDELEGATE.internetConnnected) {
        [[APIController sharedInstance]getListLocalNotifCompleted:^(int code, NSArray *results) {
            if (results) {
                [self.dataSources removeAllObjects];
                arrayNotif = (NSMutableArray*)results;
                if (results.count > 3) {
                    for (int i = 0 ; i < 3; i++) {
                        LocalNotif *obj = (LocalNotif*)[results objectAtIndex:i];
                        [self.dataSources addObject:obj];
                    }
                } else {
                    self.dataSources = (NSMutableArray*)results;
                }
                [self.tbMain reloadData];
            }
        } failed:^(NSError *error) {
            
        }];
    }
}

#pragma mark - Tabbar Delegate
- (void)tabBar:(AKTabBar *)AKTabBarDelegate didSelectTabAtIndex:(NSInteger)index {
    [self.akTabBarController tabBar:self.akTabBarController.tabBar didSelectTabAtIndex:index];
    if (index == 0) {
        [self.tbMain scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}

- (void)showLoginViewWithTask:(NSString*)task {
    
    _loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    _loginVC.task = task;
    _loginVC.delegate = self;
    _loginVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:_loginVC animated:YES completion:^{
        [UIView animateWithDuration:0.5 animations:^{
            _loginVC.loginView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        }];
    }];
}

#pragma mark - LoginController Delegate
- (void)didLoginSuccessWithTask:(NSString *)task {
    if (_loginVC) {
        [UIView animateWithDuration:0.5 animations:^{
            _loginVC.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [_loginVC dismissViewControllerAnimated:YES completion:^{
                [_loginVC.view removeFromSuperview];
                _loginVC = nil;
            }];
            if ([task isEqualToString:kTaskFollowVC]){
                [self btnAction:_btnFollow];
            } else if ([task isEqualToString:kTaskViewLaterVC]){
                [self btnAction:_btnWatchLater];
            } else if ([task isEqualToString:kTaskLogin]) {
                [self updateUserInfo];
            }
        }];
    }
}
- (void)didLoginFailedWithTask:(NSString *)task {
    if (_loginVC) {
        [UIView animateWithDuration:0.5 animations:^{
            _loginVC.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [_loginVC dismissViewControllerAnimated:YES completion:^{
                [_loginVC.view removeFromSuperview];
                _loginVC = nil;
            }];
        }];
    }
}
- (void)didCancelLogin {
    if (_loginVC) {
        [UIView animateWithDuration:0.5 animations:^{
            _loginVC.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [_loginVC dismissViewControllerAnimated:YES completion:^{
                
            }];
            [_loginVC.view removeFromSuperview];
            _loginVC = nil;
        }];
    }
}

#pragma mark - VideoView Delegate (HistoryItem)
- (void)didSelectItem:(id)object {
    if ([object isKindOfClass:[Video class]]) {
        Video *v = (Video*)object;
        [APPDELEGATE didSelectVideoCellWith:v];
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
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  60;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HomeHeaderSection *headerView = [Utilities loadView:[HomeHeaderSection class] FromNib:@"HomeHeaderSection"];
    headerView.backgroundColor = UIColorFromRGB(0xfcfcfc);
    if (section == 0) {
        headerView.lblHeader.text = kGENRE_HISTORY;
    } else if (section == 1) {
        headerView.lblHeader.text = kGENRE_NOTIFICATION;
    } 
    headerView.delegate = self;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 11:1;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 11)];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, SCREEN_SIZE.width, 10)];
    paddingView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [footerView addSubview:lineView];
    [footerView addSubview:paddingView];
    
    return footerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return indexPath.section == 0 ? SCREEN_SIZE.width/3 *210/372 + 73 : 85;
    if (indexPath.section == 0) {
        if (arrayHistory) {
            CGFloat wightItem = (SCREEN_SIZE.width - 6) / 3;
            CGFloat heightItem = wightItem * 9 / 16 + 60;
            return heightItem;
        }else{
            return 50;
        }
    } else {
        if (self.dataSources.count > 0) {
            return 85;
        }
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if (self.dataSources.count > 0) {
            return self.dataSources.count;
        }
    }
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *cellId = @"cellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
            
            CGFloat wightItem = (SCREEN_SIZE.width - 6) / 3;
            CGFloat heightItem = wightItem * 9 / 16 + 60;
            VideoView *item1 = [[VideoView alloc] initWithFrame:CGRectMake(0, 0, wightItem, heightItem)];
            [item1 loadContent];
            [item1 setTag:tagItem1];
            [item1 setHidden:YES];
            [cell addSubview:item1];
            
            UIView *paddingView1 = [[UIView alloc]initWithFrame:CGRectMake(wightItem, 0, 3, heightItem)];
            [cell addSubview:paddingView1];
            
            VideoView *item2 = [[VideoView alloc]initWithFrame:CGRectMake(wightItem + 3, 0, wightItem, heightItem)];
            [item2 loadContent];
            [item2 setTag:tagItem2];
            [item2 setHidden:YES];
            [cell addSubview:item2];
            
            UIView *paddingView2 = [[UIView alloc]initWithFrame:CGRectMake(wightItem*2 + 3, 0, 3, heightItem)];
            [cell addSubview:paddingView2];
            
            VideoView *item3 = [[VideoView alloc]initWithFrame:CGRectMake(wightItem*2 + 6, 0, wightItem, heightItem)];
            [item3 loadContent];
            [item3 setTag:tagItem3];
            [item3 setHidden:YES];
            [cell addSubview:item3];
            
            UILabel* lbNoti = [[UILabel alloc] initWithFrame:CGRectMake(0, 50/2 - 21/2, SCREEN_SIZE.width, 21)];
            [lbNoti setBackgroundColor:[UIColor clearColor]];
            [lbNoti setText:@"Danh sách lịch sử xem trống"];
            [lbNoti setTextColor:UIColorFromRGB(0xa4a4a4)];
            [lbNoti setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
            [lbNoti setTextAlignment:NSTextAlignmentCenter];
            [lbNoti setTag:tagItem0];
            [lbNoti setHidden:YES];
            [cell addSubview:lbNoti];
        }
        
        UIView* view = [cell viewWithTag:tagItem0];
        [view setHidden:(arrayHistory != nil)];
        
        VideoView* item1 = (VideoView*)[cell viewWithTag:tagItem1];
        [item1 setHidden:!(arrayHistory.count > 0)];
        if (arrayHistory.count > 0) {
            CDHistory* his1 = [arrayHistory objectAtIndex:0];
            [item1 setContent:his1];
            item1.delegate = self;
        }
        
        VideoView* item2 = (VideoView*)[cell viewWithTag:tagItem2];
        [item2 setHidden:!(arrayHistory.count > 1)];
        if (arrayHistory.count > 1) {
            CDHistory* his2 = [arrayHistory objectAtIndex:1];
            [item2 setContent:his2];
            item2.delegate = self;
        }
        
        VideoView* item3 = (VideoView*)[cell viewWithTag:tagItem3];
        [item3 setHidden:!(arrayHistory.count > 2)];
        if (arrayHistory.count > 2) {
            CDHistory* his3 = [arrayHistory objectAtIndex:2];
            [item3 setContent:his3];
            item3.delegate = self;
        }

        return cell;
    } else if (indexPath.section == 1){
        if (self.dataSources.count > 0) {
            static NSString *notifCellIdef = @"notifCellIdef";
            NotificationCell *cell = (NotificationCell*)[_tbMain dequeueReusableCellWithIdentifier:notifCellIdef];
//            if (!cell) {
//                cell = [Utilities loadView:[NotificationCell class] FromNib:@"NotificationCell"];
//            }
            LocalNotif *localNotif = (LocalNotif*)[self.dataSources objectAtIndex:indexPath.row];
            cell.localNotif = localNotif;
            [cell loadData];
            cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
            return cell;
        } else {
//            static NSString *emptyCelll = @"emptyCell";
//            UITableViewCell *cell = (UITableViewCell*)[_tbMain dequeueReusableCellWithIdentifier:emptyCelll forIndexPath:indexPath];
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0,0, SCREEN_SIZE.width, 50)];
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            UILabel* lbNoti = [[UILabel alloc] initWithFrame:CGRectMake(0, 50/2 - 21/2, SCREEN_SIZE.width, 21)];
            [lbNoti setBackgroundColor:[UIColor clearColor]];
            [lbNoti setText:@"Danh sách thông báo trống"];
            [lbNoti setTextColor:UIColorFromRGB(0xa4a4a4)];
            [lbNoti setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
            [lbNoti setTextAlignment:NSTextAlignmentCenter];
            [cell addSubview:lbNoti];
            cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
            
            
            return cell;
        }
        
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
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
}

#pragma mark - Button Action
- (IBAction)btnAction:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if (btn.tag == 0) {
        if (APPDELEGATE.isLogined) {
            XemSauController  *xemsauVC = [[XemSauController alloc]initWithNibName:@"HomeVC" bundle:nil];
            xemsauVC.navigationController.navigationBarHidden = NO;
            //xemsauVC.dataSources = [NSMutableArray arrayWithArray:arrayHistory];
            [self.navigationController pushViewController:xemsauVC animated:YES];
        } else {
            [self showLoginViewWithTask:kTaskViewLaterVC];
        }
        
    } else if (btn.tag == 1) {
        if (APPDELEGATE.isLogined) {
            FollowController  *followVC = [[FollowController alloc]initWithNibName:@"HomeVC" bundle:nil];
            followVC.navigationController.navigationBarHidden = NO;
            //xemsauVC.dataSources = [NSMutableArray arrayWithArray:arrayHistory];
            [self.navigationController pushViewController:followVC animated:YES];
        } else {
            [self showLoginViewWithTask:kTaskFollowVC];
        }
        
    }else if (btn.tag == 2) {
        if (APPDELEGATE.tabBarController) {
            UIViewController *vc = APPDELEGATE.tabBarController.viewControllers[4];
            
            if (APPDELEGATE.tabBarController.selectedViewController == vc)
            {
                if ([vc isKindOfClass:[UINavigationController class]])
                    [(UINavigationController *)APPDELEGATE.tabBarController.selectedViewController popToRootViewControllerAnimated:YES];
            }
            else
            {
                [[APPDELEGATE.tabBarController navigationItem] setTitle:[vc title]];
                APPDELEGATE.tabBarController.selectedViewController = vc;
            }
        }
    }else if (btn.tag == 3) {
        if (!APPDELEGATE.isLogined) {
            [self showLoginViewWithTask:kTaskLogin];
        }
    } else if (btn.tag == 4) {
        SettingController *settingVC = [[SettingController alloc]initWithNibName:@"SettingController" bundle:nil];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}


#pragma mark - HeaderSection Delegate
- (void)headerTappedWithTitle:(NSString *)headerTitle isHide:(BOOL)hidden{
    if ([headerTitle isEqualToString:kGENRE_HISTORY]) {
        ListHistoryController *historyVC = [[ListHistoryController alloc]initWithNibName:@"HomeVC" bundle:nil];
        historyVC.navigationController.navigationBarHidden = NO;
        historyVC.dataSources = [NSMutableArray arrayWithArray:arrayHistory];
        [self.navigationController pushViewController:historyVC animated:YES];
    } else if ([headerTitle isEqualToString:kGENRE_NOTIFICATION]){
        if (self.dataSources.count > 0) {
            ListNotificationController *notifVC = [[ListNotificationController alloc]initWithNibName:@"HomeVC" bundle:nil];
            notifVC.navigationController.navigationBarHidden = NO;
            notifVC.dataSources = arrayNotif;
            [self.navigationController pushViewController:notifVC animated:YES];
        }
    }
}
@end
