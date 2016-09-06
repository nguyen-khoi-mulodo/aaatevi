//
//  NewFeedVCViewController.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 7/7/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "NewFeedVCViewController.h"
#import "MyNavigationItem.h"
#import "UIViewController+AKTabBarController.h"
#import "AKTabBarController.h"
#import "LoginViewController.h"
#import "GenreController.h"

@interface NewFeedVCViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,LoginControllerDelegate>{
    MyNavigationItem *myNaviItem;
    BOOL isUp;
    UIRefreshControl *refreshControl;
    UIButton *rightBarBtn;
    UITextField *txfSearchField;
    UIView *titleView;
    NSMutableArray *listToday;
    NSMutableArray *listYesterday;
    NSMutableArray *listOlder;
    LoginViewController *_loginVC;
}

@property (nonatomic, assign) int pageIndex;

@end


#define Padding (IS_IPHONE_6P ? 92 : 84)
@implementation NewFeedVCViewController
- (NSString*)screenNameGA {
    return @"iOS.NewFeed";
}
- (NSString *)tabImageName
{
    if (_isNew) {
        return @"main-newfeed-dot";
    }
    return @"main-newfeed";
}

- (NSString *)activeTabImageName
{
    return @"main-newfeed-hover";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tbNewFeed setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    [self.tbNewFeed registerNib:[UINib nibWithNibName:@"ItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"itemCellIdef"];
    myNaviItem = [[MyNavigationItem alloc] initWithController:self type:1];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.tbNewFeed addSubview:refreshControl];
    rightBarBtn = myNaviItem.rightBtn;
    listToday = [[NSMutableArray alloc]init];
    listYesterday = [[NSMutableArray alloc]init];
    listOlder = [[NSMutableArray alloc]init];
    self.pageIndex = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveInternetNoti) name:kDidConnectInternet object:nil];
    if (![APPDELEGATE internetConnnected]) {
        _viewNoConnection.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Bảng tin";
    APPDELEGATE.rootNavController.navigationBarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [refreshControl endRefreshing];
    isUp = NO;
    [self.akTabBarController showTabBarAnimated:YES];
    if (titleView) {
        titleView = nil;
        txfSearchField = nil;
        self.navigationItem.titleView = nil;
        //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarBtn];
        rightBarBtn.hidden = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _isNew = NO;
    [self.akTabBarController loadTabs];
    if (APPDELEGATE.isLogined) {
        [self refreshData];
        
    } else {
        [self loadNoData];
    }
    
}

- (void)receiveInternetNoti {
    self.viewNoConnection.hidden = YES;
    [self refreshData];
}

- (IBAction)btnSignInAction:(id)sender {
    [self showLoginViewWithTask:kTaskLogin];
}

- (void)loadNoData {
    if (APPDELEGATE.internetConnnected) {
        if (!APPDELEGATE.isLogined) {
            [_imvError setImage:[UIImage imageNamed:@"default-sign-in"]];
            _lblError.text = @"Bạn chưa đăng nhập.";
            _btnsignIn.hidden = NO;
            _btnsignIn.clipsToBounds = YES;
            _btnsignIn.layer.cornerRadius = 5;
            _viewNoData.hidden = NO;
        } else {
             if ((listToday.count == 0 && listYesterday.count == 0 && listOlder.count == 0) || (self.dataSources.count == 0)) {
                [_imvError setImage:[UIImage imageNamed:@"default-newfeed"]];
                _lblError.text = @"Không có video mới. Bạn hãy theo dõi thêm kênh để được cập nhật nhiều hơn nhé!";
                _btnsignIn.hidden = YES;
                _viewNoData.hidden = NO;
            } else {
                _viewNoData.hidden = YES;
                _lblHeader.hidden = NO;
            }
        }
        self.viewNoConnection.hidden = YES;
    } else {
        self.viewNoConnection.hidden = NO;
    }
}

- (void)loadDataIsAnimation:(BOOL)isAnimation {
    if (APPDELEGATE.internetConnnected) {
        [[APIController sharedInstance]userGetNewFeedPageIndex:self.pageIndex pageSize:kPageSize completed:^(int code, id results, BOOL loadmore, BOOL isFull) {
            if (results) {
                self.dataSources =  results;
                NSDictionary *dictToday = self.dataSources[0];
                [listToday addObjectsFromArray:[dictToday objectForKey:@"2"]];
                NSDictionary *dictYesterday = self.dataSources[1];
                [listYesterday addObjectsFromArray:[dictYesterday objectForKey:@"2"]];
                NSDictionary *dictOlder = self.dataSources[2];
                [listOlder addObjectsFromArray:[dictOlder objectForKey:@"2"]];
                
                [self updateNewVideoKey];
                
                self.isLoadMore = loadmore;
                if (self.isLoadMore) {
                    self.pageIndex = self.pageIndex + 1;
                }
                if (isAnimation) {
                    [self.tbNewFeed scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
                }
                [refreshControl endRefreshing];
                [self.tbNewFeed reloadData];
                [self loadNoData];
            } else {
                if (code == kAPI_DATA_EMPTY) {
                    [self loadNoData];
                }
            }
        } failed:^(NSError *error) {
            [refreshControl endRefreshing];
        }];
    } else {
        _viewNoConnection.hidden = NO;
    }
}

- (void)refreshData {
    [self.dataSources removeAllObjects];
    [listToday removeAllObjects];
    [listYesterday removeAllObjects];
    [listOlder removeAllObjects];
    self.pageIndex = 1;
    [self loadDataIsAnimation:YES];
}
- (void)loadMore {
    if (self.isLoadMore) {
        [self loadDataIsAnimation:NO];
    }
}

- (void)updateNewVideoKey {
    if (self.pageIndex == 1) {
        NSMutableArray *arrayTotal = [[NSMutableArray alloc]init];
        [arrayTotal addObjectsFromArray:listToday];
        [arrayTotal addObjectsFromArray:listYesterday];
        [arrayTotal addObjectsFromArray:listOlder];
        int total = (int)arrayTotal.count;
        NSMutableArray *arrayLocalKey = [[NSMutableArray alloc]init];
        if (total > 10) {
            for (int i = 0; i < 10; i++) {
                Video *video = arrayTotal[i];
                [arrayLocalKey addObject:video.video_id];
            }
        } else {
            for (Video *video in arrayTotal) {
                [arrayLocalKey addObject:video.video_id];
            }
        }
        [kNSUserDefault setObject:(NSArray*)arrayLocalKey forKey:@"new_notify"];
        [kNSUserDefault synchronize];
        
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
                _viewNoData.hidden = YES;
                [self refreshData];
            }];
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

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSources.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return listToday.count == 0 ? 0.1 : 30;
    } else if (section == 1) {
        return listYesterday.count == 0 ? 0.1 : 30;
    } else if (section == 2) {
        return listOlder.count == 0 ? 0.1 : 30;
    }
    return 30;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataSources.count > section) {
        NSDictionary *dict = self.dataSources[section];
        NSString *title = [dict objectForKey:@"1"];
        UILabel *lblTitle = [[UILabel alloc]init];
        lblTitle.textColor = UIColorFromRGB(0xa4a4a4);
        lblTitle.font = [UIFont fontWithName:kFontRegular size:15];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.1);
        if (section == 0) {
            if (listToday.count > 0) {
                lblTitle.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
                lblTitle.backgroundColor = UIColorFromRGB(0xf0f0f0);
                lblTitle.text = title;
            }
        } else if (section == 1) {
            if (listYesterday.count > 0) {
                lblTitle.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
                lblTitle.backgroundColor = UIColorFromRGB(0xf0f0f0);
                lblTitle.text = title;
            }
        } else if (section == 2) {
            if (listOlder.count > 0) {
                lblTitle.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
                lblTitle.backgroundColor = UIColorFromRGB(0xf0f0f0);
                lblTitle.text = title;
            }
        }
        return lblTitle;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return listToday.count;
    } else if (section == 1) {
        return listYesterday.count;
    } else if (section == 2) {
        return listOlder.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *itemCellIdef = @"itemCellIdef";
    ItemCell *cell = (ItemCell*)[self.tbNewFeed dequeueReusableCellWithIdentifier:itemCellIdef];
    if (!cell) {
        cell = [Utilities loadView:[ItemCell class] FromNib:@"ItemCell"];
    }
    Video *video = nil;
    if (indexPath.section == 0) {
        if (listToday.count > indexPath.row) {
            video = (Video*)[listToday objectAtIndex:indexPath.row];
        }
    } else if (indexPath.section == 1) {
        if (listYesterday.count > indexPath.row) {
            video = (Video*)[listYesterday objectAtIndex:indexPath.row];
        }
    } else if (indexPath.section == 2) {
        if (listOlder.count >indexPath.row) {
            video = (Video*)[listOlder objectAtIndex:indexPath.row];
        }
        
    }
    if (video) {
        cell.video = video;
        [cell loadContentWithType:typeNewFeed];
        //cell.delegate = self;
    }
    
    cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Video *item = nil;
    if (indexPath.section == 0) {
        if (listToday.count > indexPath.row) {
             item = [listToday objectAtIndex:indexPath.row];
        }
    } else if (indexPath.section == 1) {
        if (listYesterday.count > indexPath.row) {
            item = [listYesterday objectAtIndex:indexPath.row];
        }
    } else if (indexPath.section == 2) {
        if (listOlder.count > indexPath.row) {
            item = [listOlder objectAtIndex:indexPath.row];
        }
    }
    if (item) {
        [APPDELEGATE didSelectVideoCellWith:item];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    GenreController *searchVC = [[GenreController alloc]initWithNibName:@"GenreController" bundle:nil];
    searchVC.isSearch = YES;
    searchVC.listSearch = [[NSMutableArray alloc]initWithArray:@[@"Video",@"Kênh",@"Nghệ sĩ"]];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:NO];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    GenreController *searchVC = [[GenreController alloc]initWithNibName:@"GenreController" bundle:nil];
    searchVC.isSearch = YES;
    searchVC.listSearch = [[NSMutableArray alloc]initWithArray:@[@"Video",@"Kênh",@"Nghệ sĩ"]];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [txfSearchField resignFirstResponder];
}

#pragma mark - UIScrollView Delegate
- (void)showTitleVC {
    self.navigationItem.titleView = nil;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        if (isUp) {
            isUp = !isUp;
            [self doAnimation:isUp];
        }
    }else if(scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 50){
        if (!isUp) {
            isUp = !isUp;
            if (!titleView) {
                titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width - Padding, 36)];
                titleView.backgroundColor = [UIColor clearColor];
                
                if (!txfSearchField) {
                    txfSearchField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width - Padding - 30, 3,30, 30)];
                    txfSearchField.backgroundColor = RGBA(171, 174, 174, 0.15);
                    txfSearchField.textColor = UIColorFromRGB(0x212121);
                    txfSearchField.tintColor = UIColorFromRGB(0x212121);
                    txfSearchField.placeholder = @"Tìm kiếm";
                    txfSearchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Tìm kiếm"
                                                                                           attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xa4a4a4), NSFontAttributeName : [UIFont fontWithName:kFontRegular size:15.0]
                                                                                                        }
                                                            ];
                    txfSearchField.clipsToBounds = YES;
                    txfSearchField.layer.cornerRadius = 5;
                    UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-search-thumb-v2"]];
                    [leftView setFrame:CGRectMake(0, 0, 35, 35)];
                    leftView.contentMode = UIViewContentModeCenter;
                    txfSearchField.leftView = leftView;
                    txfSearchField.leftViewMode = UITextFieldViewModeAlways;
                    txfSearchField.delegate = self;
                    [titleView addSubview:txfSearchField];
                }
                self.navigationItem.titleView = titleView;
                
            }
            [self doAnimation:isUp];
        }
    }
    
    if(scrollView.contentOffset.y + scrollView.frame.size.height  > (scrollView.contentSize.height - CELL_HEIGHT_MORE))
    {
        if(self.isLoadMore)
        {
            [self loadMore];
            self.isLoadMore = NO;
        }
    }
}

- (void) doAnimation:(BOOL) is_up{
    if (is_up) {
        [UIView animateWithDuration:0.05 animations:^{
            rightBarBtn.alpha = 0.0;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.4 animations:^{
                txfSearchField.backgroundColor = RGBA(171, 174, 174, 0.15);
                txfSearchField.frame = CGRectMake(0, 3, SCREEN_SIZE.width - Padding, 30);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }else{
        if (titleView && txfSearchField) {
            
            [UIView animateWithDuration:0.4 animations:^{
                txfSearchField.backgroundColor = [UIColor clearColor];
                txfSearchField.frame = CGRectMake(SCREEN_SIZE.width - Padding - 30, 3, 30, 30);
                //                txfSearchField.leftView.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                txfSearchField.backgroundColor = [UIColor clearColor];
                [UIView animateWithDuration:0.05 animations:^{
                    rightBarBtn.alpha = 1.0;
                    txfSearchField.leftView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    titleView = nil;
                    txfSearchField = nil;
                    self.navigationItem.titleView = nil;
                }];
            }];
        }
    }
}
@end
