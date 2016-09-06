//
//  HomeVC.m
//  NPlus
//
//  Created by TEVI Team on 7/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "HomeVC.h"
#import "EAIntroView.h"
#import "UIViewController+AKTabBarController.h"
#import "AKTabBarController.h"
#import "TSMiniWebBrowser.h"

@interface HomeVC ()<CycleScrollViewDelegate, EAIntroDelegate>{
    UILabel *lblEmpty;
}
@property(nonatomic, getter = shouldHideStatusBar) BOOL hideStatusBar;
@end

@implementation HomeVC
@synthesize scrollToTop;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.lastContentOffset = 0.0f;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    _tbMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_tbMain.backgroundColor = BACKGROUND_COLOR;
    _tbMain.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    //_tbMain.contentOffset = CGPointMake(_tbMain.contentOffset.x, _tbMain.contentOffset.y + 100);
    _tbMain.clipsToBounds = NO;
    _tbMain.scrollsToTop = YES;
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(reloadTableViewDataSource) forControlEvents:UIControlEventValueChanged];
//    tableViewController = [[UITableViewController alloc] init];
//    tableViewController.tableView = _tbMain;
//    tableViewController.refreshControl = refreshControl;
    self.tbMain.tableFooterView = [[UIView alloc] init];
    self.tbMain.scrollsToTop = YES;
    [_tbMain addSubview:refreshControl];
    
    lblEmpty = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, SCREEN_SIZE.width - 40, 30)];
    lblEmpty.textAlignment = NSTextAlignmentCenter;
    lblEmpty.textColor = UIColorFromRGB(0xa4a4a4);
    lblEmpty.font = [UIFont fontWithName:@"SanFranciscoDisplay-Semibold.otf" size:17];
    lblEmpty.text = @"Chưa có dữ liệu.";
    lblEmpty.backgroundColor = [UIColor clearColor];
    lblEmpty.hidden = YES;
    [self.tbMain addSubview:lblEmpty];
    if (!APPDELEGATE.internetConnnected) {
        //[self showConnectionErrorView:YES];
    }
}

- (void)didLoginNotify {};
- (void)didLogoutNotify {};

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    lblEmpty.frame = CGRectMake(lblEmpty.frame.origin.x, self.tbMain.frame.size.height/2 - lblEmpty.frame.size.height, lblEmpty.frame.size.width, lblEmpty.frame.size.height);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnReloadAction:(id)sender {
    if (APPDELEGATE.internetConnnected) {
        [self showConnectionErrorView:NO];
        [self loadDataIsAnimation:YES];
    }
}

- (MBProgressHUD *)showProgressHUDWithTitle:(NSString *)title {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = title;
    [hud hide:YES afterDelay:20];
    return hud;
}
- (void)dismissHUD {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)reloadTableViewDataSource {
    [super reloadTableViewDataSource];
    [refreshControl endRefreshing];
}

- (void) finishLoadData
{
    
    self.dataView.hidden = NO;
    [self doneLoadingTableViewData];
    
    if ([self.dataView respondsToSelector:@selector(reloadData)])
    {
        [self.dataView performSelector:@selector(reloadData)];
    }
//    [refreshControl endRefreshing];
    [refreshControl endRefreshing];
}

- (void)loadEmptyData {
    if (self.dataSources.count > 0) {
        lblEmpty.hidden = YES;
    } else {
        lblEmpty.hidden = NO;
    }
}

- (void) showNoDataView: (BOOL) show{
    [self.noDataView setHidden:!show];
    self.noDataView.backgroundColor = [UIColor clearColor];
    if (show) {
        if ([NSStringFromClass([self class]) isEqualToString:@"ListHistoryController"]) {
            [self.imgViewNodata setImage:[UIImage imageNamed:@"icon-default-lichsu-v2"]];
            [self.lbNodata setText:@"Danh sách lịch sử xem trống."];
            [self.lbNodata setTextColor:UIColorFromRGB(0xa4a4a4)];
            [self.lbNodata setFont:[UIFont fontWithName:kFontRegular size:16.0f]];
        }else if([NSStringFromClass([self class]) isEqualToString:@"DownloadController"]){
            [self.imgViewNodata setImage:[UIImage imageNamed:@"icon-default-tai-v2"]];
            [self.lbNodata setText:@"Chưa có video đã tải nào."];
            [self.lbNodata setTextColor:UIColorFromRGB(0xa4a4a4)];
            [self.lbNodata setFont:[UIFont fontWithName:kFontRegular size:16.0f]];
        }else if([NSStringFromClass([self class]) isEqualToString:@"XemSauController"]){
            [self.imgViewNodata setImage:[UIImage imageNamed:@"icon-default-xemsau-v2"]];
            [self.lbNodata setText:@"Chưa có video xem sau nào."];
            [self.lbNodata setTextColor:UIColorFromRGB(0xa4a4a4)];
            [self.lbNodata setFont:[UIFont fontWithName:kFontRegular size:16.0f]];
        }else if([NSStringFromClass([self class]) isEqualToString:@"FollowController"]){
            [self.imgViewNodata setImage:[UIImage imageNamed:@"icon-default-theodoi-v2"]];
            [self.lbNodata setText:@"Chưa có kênh theo dõi nào."];
            [self.lbNodata setTextColor:UIColorFromRGB(0xa4a4a4)];
            [self.lbNodata setFont:[UIFont fontWithName:kFontRegular size:16.0f]];
        }
    }
}


#pragma mark - HomeDelegate

- (void)scrollShowHideBottomBar:(BOOL)hidden {
    if (hidden) {
        if (self.akTabBarController.tabBar.frame.origin.y == SCREEN_SIZE.height - self.akTabBarController.tabBar.frame.size.height){
            [UIView animateWithDuration:0.5f
                             animations:^{
                                 [self.akTabBarController hideTabBarAnimated:YES];
                                 
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        }
        
    } else {
        NSLog(@"%f %f %f",SCREEN_SIZE.height, self.akTabBarController.tabBar.frame.origin.y,self.akTabBarController.tabBar.frame.size.height);
        if (self.akTabBarController.tabBar.frame.origin.y == SCREEN_SIZE.height) {
            [UIView animateWithDuration:0.5f
                             animations:^{
                                 [self.akTabBarController showTabBarAnimated:YES];
                                 
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        }
    }
    
}


@end
