//
//  HomeController.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/20/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "HomeController.h"
#import "Showcase.h"
#import "DoubleItem.h"
#import "GenreController.h"
#import "UIViewController+AKTabBarController.h"
#import "AKTabBarController.h"

#define kDefaultPageSizeHome 6

#define Padding (IS_IPHONE_6P ? 92 : 84)

@interface HomeController () <AKTabBarDelegate,UITextFieldDelegate> {
    NSMutableArray *arrayNew;
    NSMutableArray *arrayHotShort;
    NSMutableArray *arrDoubleItem1;
    NSMutableArray *arrDoubleItem2;
    int _pageIndex;
    int _pageSize;
    UIButton *btnShowMore;
    UIButton *rightBarBtn;
    UITextField *txfSearchField;
    UIView *titleView;
    BOOL isReload;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingShowcase;

@end

@implementation HomeController
- (NSString*)screenNameGA {
    return @"iOS.Home";
}
- (NSString *)tabImageName
{
    return @"main-menu-v2";
}

- (NSString *)activeTabImageName
{
    return @"main-menu-h-v2";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tbMain registerNib:[UINib nibWithNibName:@"HomeItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"homeCellIdef"];
    [self.tbMain setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    myNaviItem = [[MyNavigationItem alloc] initWithController:self type:1];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [_tbMain addSubview:refreshControl];
    rightBarBtn = myNaviItem.rightBtn;
    arrDoubleItem1 = [[NSMutableArray alloc]init];
    arrDoubleItem2 = [[NSMutableArray alloc]init];
    [self getHomeData];
    _tbMain.dataSource = self;
    _tbMain.delegate = self;
    [self loadShowCaseView];
    [Utilities setTypeGenre:NEW_TYPE];
    self.akTabBarController.tabBar.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNoti) name:@"enableButton" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveInternetNoti) name:kDidConnectInternet object:nil];
    [self checkNotifyCompleted:^(BOOL new) {
        if ([APPDELEGATE newfeedVC]) {
            if (new) {
                [APPDELEGATE newfeedVC].isNew = YES;
            } else {
                [APPDELEGATE newfeedVC].isNew = NO;
            }
            [[APPDELEGATE newfeedVC].akTabBarController loadTabs];
        }
        
    }];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Trang chủ";
    [self trackScreen:@"iOS.Home"];
    APPDELEGATE.rootNavController.navigationBarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [refreshControl endRefreshing];
    [self.tbMain setContentOffset:CGPointMake(0, 0)];
    isUp = NO;
    [self.akTabBarController showTabBarAnimated:YES];
    if (titleView) {
        titleView = nil;
        txfSearchField = nil;
        self.navigationItem.titleView = nil;
        //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarBtn];
        rightBarBtn.hidden = NO;
    }
    [self enableButton:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!txfSearchField) {
        rightBarBtn.alpha = 1.0;
    }
    if (!isReload) {
        [APPDELEGATE registerPushNotification];
        isReload = YES;
    }
    
}

- (void)enableButton:(BOOL)enable {
    _btnRelax.userInteractionEnabled = enable;
    _btnShortFilm.userInteractionEnabled = enable;
    _btnTVShow.userInteractionEnabled = enable;
    _btnShortFilm.exclusiveTouch = YES;
    _btnTVShow.exclusiveTouch = YES;
    _btnRelax.exclusiveTouch = YES;
}

- (void)receiveNoti {
    [self enableButton:YES];
}
- (void)receiveInternetNoti {
    [self refreshData];
}

- (void)loadShowCaseView {
    float width = SCREEN_WIDTH;
    float height = SCREEN_WIDTH * 0.33f;
    _viewShowcase.frame = CGRectMake(0, 0, width, height);
    _cycleScroll = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height) animationDuration:5];
    _cycleScroll.backgroundColor = UIColorFromRGB(0xfcfcfc);
    _cycleScroll.delegate = self;
    [_viewShowcase addSubview:_cycleScroll];
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, height - 30, width, 37)];
    [_viewShowcase addSubview:_pageControl];
    if ([_pageControl respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)])
    {
        [_pageControl setCurrentPageIndicatorTintColor:COLOR_MAIN_BLUE];
    }
    if ([_pageControl respondsToSelector:@selector(setPageIndicatorTintColor:)])
    {
        [_pageControl setPageIndicatorTintColor: [UIColor colorWithWhite:1.0f alpha:0.5f]];
    }
    _viewGenre.translatesAutoresizingMaskIntoConstraints = YES;
    _viewGenre.frame = CGRectMake(0, _viewShowcase.frame.size.height, SCREEN_SIZE.width, 90);
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, height + 90, SCREEN_SIZE.width, 11)];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, SCREEN_SIZE.width, 10)];
    paddingView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [footerView addSubview:lineView];
    [footerView addSubview:paddingView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, _viewShowcase.frame.size.height + _viewGenre.frame.size.height + footerView.frame.size.height)];
    [view addSubview:_viewShowcase];
    [view addSubview:_viewGenre];
    [view addSubview:footerView];
    _tbMain.tableHeaderView = view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    [arrayNew removeAllObjects];
    [arrayHotShort removeAllObjects];
    [arrDoubleItem1 removeAllObjects];
    [arrDoubleItem2 removeAllObjects];
    [self getHomeData];
    [refreshControl endRefreshing];
}

- (void)getHomeData {
    if (APPDELEGATE.internetConnnected) {
        [_loadingShowcase startAnimating];
        _loadingShowcase.hidden = NO;
        [_viewShowcase bringSubviewToFront:_loadingShowcase];
        [[APIController sharedInstance]getHomeItemCompleted:^(int code, HomeItem *results) {
            if (code == kAPI_SUCCESS) {
                _homeItem = results;
                if (_homeItem.listVideoHot.count > 6) {
                    NSMutableArray *arrayHot1 = [[NSMutableArray alloc]init];
                    NSMutableArray *arrayHot2 = [[NSMutableArray alloc]init];
                    btnShowMore.selected = NO;
                    for (int i = 0; i < _homeItem.listVideoHot.count; i++) {
                        if (i < 6) {
                            if (!arrayHot1) {
                                arrayHot1 = [[NSMutableArray alloc]init];
                            }
                            [arrayHot1 addObject:[_homeItem.listVideoHot objectAtIndex:i]];
                        } else {
                            if (!arrayHot2) {
                                arrayHot2 = [[NSMutableArray alloc]init];
                            }
                            [arrayHot2 addObject:[_homeItem.listVideoHot objectAtIndex:i]];
                        }
                    }
                    
                    for (int i = 0; i < arrayHot1.count; i++) {
                        if (i%2==0) {
                            Video *v1 = (Video*)[arrayHot1 objectAtIndex:i];
                            if (i+1 < arrayHot1.count) {
                                Video *v2 = (Video*)[arrayHot1 objectAtIndex:i + 1];
                                DoubleItem *d = [[DoubleItem alloc]init];
                                if (v1 && v2) {
                                    d.video1 = v1;
                                    d.video2 = v2;
                                    [arrDoubleItem1 addObject:d];
                                }
                            }
                        }
                    }
                    for (int i = 0; i < arrayHot2.count; i++) {
                        if (i%2==0) {
                            Video *v1 = (Video*)[arrayHot2 objectAtIndex:i];
                            if (i+1 < arrayHot2.count) {
                                Video *v2 = (Video*)[arrayHot2 objectAtIndex:i + 1];
                                DoubleItem *d = [[DoubleItem alloc]init];
                                if (v1 && v2) {
                                    d.video1 = v1;
                                    d.video2 = v2;
                                    [arrDoubleItem2 addObject:d];
                                }
                            }
                            
                            
                        }
                    }
                    if (!arrayHotShort) {
                        arrayHotShort = [[NSMutableArray alloc]init];
                    }
                    [arrayHotShort addObjectsFromArray:arrDoubleItem1];
                }
                if (_homeItem.listVideoNew.count > 0) {
                    arrayNew = (NSMutableArray*)_homeItem.listVideoNew;
                    self.isLoadMore = YES;
                    _pageIndex = 2;
                    _pageSize = kDefaultPageSizeHome;
                }
                [self createShowcase];
                [_loadingShowcase stopAnimating];
                //_loadingShowcase.hidden = YES;
                [_tbMain reloadData];
            }
        } failed:^(NSError *error) {
            [_loadingShowcase stopAnimating];
            //_loadingShowcase.hidden = YES;
        }];
        _viewNoConnection.hidden = YES;
    } else {
        _viewNoConnection.hidden = NO;
    }
}

- (void)loadMoreNewVideos {
    if (APPDELEGATE.internetConnnected) {
        [[APIController sharedInstance]getDiscoverVideoWithType:@"new" pageIndex:_pageIndex pageSize:_pageSize completed:^(int code ,NSArray *results, BOOL loadmore, int total) {
            if (results) {
                NSArray *array = results;
                [arrayNew addObjectsFromArray:array];
                self.isLoadMore = loadmore;
                if (self.isLoadMore) {
                    _pageIndex = _pageIndex + 1;
                    if (_pageIndex > 8) {
                        self.isLoadMore = NO;
                    }
                }
                [self.tbMain reloadData];
            } else {
                
            }
            
        } failed:^(NSError *error) {
            
        }];
    }
}

- (void) createShowcase {
    if (_homeItem.listShowcases.count > 0)
    {
        NSMutableArray *data = (NSMutableArray*)_homeItem.listShowcases;
        NSMutableArray *viewsArray = [@[] mutableCopy];
        for (int i = 0; i < data.count; i++)
        {
            CGRect frame;
            frame.origin.x = 0;
            frame.origin.y = 0;
            frame.size.width = _cycleScroll.frame.size.width;
            frame.size.height = _cycleScroll.frame.size.height;
            
            UIView *view = [[UIView alloc] initWithFrame:frame];
            id obj = [data objectAtIndex:i];
            
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            imageview.contentMode = UIViewContentModeScaleAspectFill;
            if ([obj isKindOfClass:[Showcase class]])
            {
                Showcase *item = (Showcase *) obj;
                [imageview setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:[UIImage imageNamed:@"default_showcase"]];
            }
            [view addSubview:imageview];
            [viewsArray addObject:view];
        }
        _cycleScroll.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return viewsArray[pageIndex];
        };
        _cycleScroll.totalPagesCount = ^NSInteger(void){
            return viewsArray.count;
        };
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = viewsArray.count;
    }
}

- (void)checkNotifyCompleted:(void (^)(BOOL new))_completed {
    BOOL __block isNew = NO;
    if (APPDELEGATE.internetConnnected) {
        [[APIController sharedInstance]userCheckNotifyCompleted:^(int code, NSArray *results) {
            if (results) {
                if ([kNSUserDefault objectForKey:@"new_notify"]) {
                    NSArray *localNotifyKeys = [kNSUserDefault objectForKey:@"new_notify"];
                    NSArray *arrayTemp = [results copy];
                    for (int i = 0; i < arrayTemp.count; i++) {
                        NSString *key = results[i];
                        if (![localNotifyKeys containsObject:key]) {
                            isNew = YES;
                            
//                            [kNSUserDefault setObject:results forKey:@"new_notify"];
//                            [kNSUserDefault synchronize];
                            break;
                        }
                    }
                } else {
//                    [kNSUserDefault setObject:results forKey:@"new_notify"];
//                    [kNSUserDefault synchronize];
                    isNew = YES;
                }
                _completed(isNew);
            }
        } failed:^(NSError *error) {
            
        }];
    }
}

#pragma mark - Tabbar Delegate
- (void)tabBar:(AKTabBar *)AKTabBarDelegate didSelectTabAtIndex:(NSInteger)index {
    if (self.akTabBarController.selectedIndex == 0 && index == 0) {
        [self.tbMain scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
    [self.akTabBarController tabBar:self.akTabBarController.tabBar didSelectTabAtIndex:index];
}

#pragma mark - CycleScrollView Delegate
- (void)cycleScrollView:(CycleScrollView *)cycleScroll scrollAtIndex:(NSInteger)pageIndex{
    _pageControl.currentPage = pageIndex;
}
- (void)cycleScrollView:(CycleScrollView *)cycleScroll tapAtIndex:(NSInteger)pageIndex {
    [self trackEvent:@"iOS_showcase"];
    NSArray *arrayShowcase = _homeItem.listShowcases;
    if (pageIndex > arrayShowcase.count) {
        return;
    }
    Showcase *sc = (Showcase*)[arrayShowcase objectAtIndex:pageIndex];
    if ([sc.type isEqualToString:@"video"]) {
        Video *v = [[Video alloc]init];
        v.video_id = sc.itemKey;
        [APPDELEGATE didSelectVideoCellWith:v];
    } else if ([sc.type isEqualToString:@"channel"]) {
        Channel *c = [[Channel alloc]init];
        c.channelId = sc.itemKey;
        [APPDELEGATE didSelectChannelCellWith:c isPush:NO];
    }
}
#pragma mark UITableView delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  60;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HomeHeaderSection *headerView = [Utilities loadView:[HomeHeaderSection class] FromNib:@"HomeHeaderSection"];
    headerView.backgroundColor = UIColorFromRGB(0xfcfcfc);
    if (section == kSECTION_HOT) {
        headerView.lblHeader.text = kGENRE_HOT_VIDEO;
        headerView.iconHeader.hidden = YES;
    } else if (section == kSECTION_SHORT_FILM) {
        headerView.lblHeader.text = kGENRE_SHORT_FILM;
    } else if (section == kSECTION_TVSHOW) {
        headerView.lblHeader.text = kGENRE_TV_SHOW;
    } else if (section == kSECTION_RELAX) {
        headerView.lblHeader.text = kGENRE_RELAX;
    } else if (section == kSECTION_NEW) {
        headerView.lblHeader.text = kGENRE_NEW_VIDEO;
        headerView.iconHeader.hidden = YES;
    }
    headerView.delegate = self;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == kSECTION_HOT) {
        return 41;
    }
    return 11;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 11)];
    if (section == kSECTION_HOT) {
        footerView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, 41);
        UIView *showMoreView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 30)];
        if (!btnShowMore) {
            btnShowMore = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 30)];
            btnShowMore.selected = NO;
            [btnShowMore addTarget:self action:@selector(showMoreAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        [btnShowMore setImage:btnShowMore.selected?[UIImage imageNamed:@"icon-thulai-v2"]:[UIImage imageNamed:@"icon-view-more-v2"] forState:UIControlStateNormal];
        [showMoreView addSubview:btnShowMore];
        showMoreView.backgroundColor = UIColorFromRGB(0xfcfcfc);
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_SIZE.width, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
        UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 31, SCREEN_SIZE.width, 10)];
        paddingView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        
        [footerView addSubview:showMoreView];
        //[footerView addSubview:lineView];
        [footerView addSubview:paddingView];
    } else {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
        UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, SCREEN_SIZE.width, 10)];
        paddingView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        //[footerView addSubview:lineView];
        [footerView addSubview:paddingView];
    }
    return footerView;
}

- (void)showMoreAction:(id)sender {
    btnShowMore.selected = !btnShowMore.selected;
    [btnShowMore setImage:btnShowMore.selected?[UIImage imageNamed:@"icon-thulai-v2"]:[UIImage imageNamed:@"icon-view-more-v2"] forState:UIControlStateNormal];
    NSMutableArray *tempArr = arrDoubleItem1;
    if (arrDoubleItem2.count) {
        if (!btnShowMore.selected) {
            [self collapseRows:(NSMutableArray*)arrDoubleItem2 inIndexPath:[NSIndexPath indexPathForRow:arrDoubleItem1.count-1 inSection:kSECTION_HOT]];
        } else {
            NSUInteger count=arrDoubleItem1.count;
            NSMutableArray *arrCells=[NSMutableArray array];
            for(DoubleItem *innerD in arrDoubleItem2)
            {
                [arrCells addObject:[NSIndexPath indexPathForRow:count inSection:kSECTION_HOT]];
                [tempArr insertObject:innerD atIndex:count++];
            }
            [_tbMain insertRowsAtIndexPaths:arrCells withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

- (void)collapseRows:(NSMutableArray*)ar inIndexPath:(NSIndexPath*)indexPath
{
    NSMutableArray *tempArr = arrDoubleItem1;
    if (arrDoubleItem2.count) {
        for (DoubleItem *d in arrDoubleItem2) {
            NSUInteger indexToRemove=[tempArr indexOfObjectIdenticalTo:d];
            
            if([tempArr indexOfObjectIdenticalTo:d]!=NSNotFound)
            {
                [tempArr removeObjectIdenticalTo:d];
                [_tbMain deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                [NSIndexPath indexPathForRow:indexToRemove inSection:kSECTION_HOT]
                                                ]
                              withRowAnimation:UITableViewRowAnimationTop];
            }
        }
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return arrDoubleItem1.count;
            break;
        case 1:
            return _homeItem.listShortFilm.count%2 > 0 ? _homeItem.listShortFilm.count/2 : _homeItem.listShortFilm.count/2;
            break;
        case 2:
            return _homeItem.listTVShow.count%2 > 0 ? _homeItem.listTVShow.count/2 : _homeItem.listTVShow.count/2;
            break;
        case 3:
            return _homeItem.listRelax.count%2 > 0 ? _homeItem.listRelax.count/2  : _homeItem.listRelax.count/2;
            break;
        case 4:
            return arrayNew.count%2 > 0 ? arrayNew.count/2  : arrayNew.count/2;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_SIZE.width/2 *210/372 + 65;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *hotCellIdenf = @"homeCellIdef";
    HomeItemCell *homeCell = [tableView dequeueReusableCellWithIdentifier:hotCellIdenf];
    if (!homeCell) {
        homeCell = [Utilities loadView:[HomeItemCell class] FromNib:@"HomeItemCell"];
    }
    homeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    homeCell.delegate = self;
    int index = (int)indexPath.row*2;
    if (indexPath.section == kSECTION_HOT){
        if (arrDoubleItem1.count > indexPath.row) {
            DoubleItem *d = (DoubleItem*)[arrDoubleItem1 objectAtIndex:indexPath.row];
            homeCell.video1 = d.video1;
            homeCell.video2 = d.video2;
        }
        [homeCell loadContentViewWithType:typeVideo];
    } else if (indexPath.section == kSECTION_SHORT_FILM) {
        if (_homeItem.listShortFilm.count > index) {
            Channel *channel1 = [_homeItem.listShortFilm objectAtIndex:index];
            homeCell.channel1 = channel1;
        }
        if (_homeItem.listShortFilm.count > index + 1) {
            Channel *channel2 = [_homeItem.listShortFilm objectAtIndex:index +1];
            homeCell.channel2 = channel2;
        }
        [homeCell loadContentViewWithType:typeChannel];
    } else if (indexPath.section == kSECTION_TVSHOW) {
        if (_homeItem.listTVShow.count > index) {
            Channel *channel1 = [_homeItem.listTVShow objectAtIndex:index];
            homeCell.channel1 = channel1;
        }
        if (_homeItem.listTVShow.count > index + 1) {
            Channel *channel2 = [_homeItem.listTVShow objectAtIndex:index +1];
            homeCell.channel2 = channel2;
        }
        [homeCell loadContentViewWithType:typeChannel];
    } else if (indexPath.section == kSECTION_RELAX) {
        if (_homeItem.listRelax.count > index) {
            Channel *channel1 = [_homeItem.listRelax objectAtIndex:index];
            homeCell.channel1 = channel1;
        }
        if (_homeItem.listRelax.count > index + 1) {
            Channel *channel2 = [_homeItem.listRelax objectAtIndex:index +1];
            homeCell.channel2 = channel2;
        }
        [homeCell loadContentViewWithType:typeChannel];
    } else if (indexPath.section == kSECTION_NEW) {
        if (arrayNew.count > index) {
            Video *video1 = [arrayNew objectAtIndex:index];
            homeCell.video1 = video1;
        }
        if (arrayNew.count > index + 1) {
            Video *video2 = [arrayNew objectAtIndex:index +1];
            homeCell.video2 = video2;
        }
        [homeCell loadContentViewWithType:typeVideo];
    }
    
    return homeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {};

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - HomeHeaderSectionDelegate
- (void)headerTappedWithTitle:(NSString *)headerTitle isHide:(BOOL)hidden{
    if ([headerTitle isEqualToString:kGENRE_HOT_VIDEO] || [headerTitle isEqualToString:kGENRE_NEW_VIDEO]) {
        return;
    }
    Genre *genre = [[Genre alloc]init];
    [Utilities setTypeGenre:NEW_TYPE];
    if ([headerTitle isEqualToString:kGENRE_SHORT_FILM]) {
        genre.genreId = ID_GENRE_PHIMNGAN;
        genre.genreName = kGENRE_SHORT_FILM;
        [self trackScreen:@"iOS.Shortfilm"];
    } else if ([headerTitle isEqualToString:kGENRE_TV_SHOW]) {
        genre.genreId =ID_GENRE_TVSHOW;
        genre.genreName = kGENRE_TV_SHOW;
        [self trackScreen:@"iOS.TVShow"];
    } else if ([headerTitle isEqualToString:kGENRE_RELAX]) {
        genre.genreId =ID_GENRE_GIAITRI;
        genre.genreName = kGENRE_RELAX;
        [self trackScreen:@"iOS.Relax"];
    }
    [APPDELEGATE didSelectGenre:genre listGenres:nil index:0];
}

#pragma mark - Button Action
- (IBAction)btnGenreAction:(id)sender {
    [self enableButton:NO];
    UIButton *btn = (UIButton*)sender;
    Genre *genre = [[Genre alloc]init];
    [Utilities setTypeGenre:NEW_TYPE];
    switch (btn.tag) {
        case 0:
            genre.genreId = ID_GENRE_PHIMNGAN;
            genre.genreName = kGENRE_SHORT_FILM;
            [self trackScreen:@"iOS.Shortfilm"];
            break;
        case 1:
            genre.genreId =ID_GENRE_TVSHOW;
            genre.genreName = kGENRE_TV_SHOW;
            [self trackScreen:@"iOS.TVShow"];
            break;
        case 2:
            genre.genreId =ID_GENRE_GIAITRI;
            genre.genreName = kGENRE_RELAX;
            [self trackScreen:@"iOS.Relax"];
            break;
        default:
            break;
    }
    [APPDELEGATE didSelectGenre:genre listGenres:nil index:0];
}


#pragma mark - HomeCell Delegate 
- (void)itemTapped:(id)object {
    if ([object isKindOfClass:[Video class]]) {
        Video *v = (Video*)object;
        [APPDELEGATE didSelectVideoCellWith:v];
    } else if ([object isKindOfClass:[Channel class]]) {
        Channel *c = (Channel*)object;
        [APPDELEGATE didSelectChannelCellWith:c isPush:NO];
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
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
//    title.text = @"Trang chủ";
//    title.font = [UIFont boldSystemFontOfSize:17];
//    title.textAlignment = NSTextAlignmentCenter;
//    self.navigationItem.titleView = title;
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
    
//    if ([scrollView.panGestureRecognizer translationInView:scrollView].y > 0) {
//            if (_tbMain.contentOffset.y < 10) {
//                if (isUp) {
//                    isUp = !isUp;
////                    NSLog(@"scroll xuong");
//                    [self doAnimation:isUp];
//                }
//            }
//    } else if ([scrollView.panGestureRecognizer translationInView:scrollView].y < 0){
//        if (!isUp) {
//            isUp = !isUp;
////             NSLog(@"scroll len");
//            if (!titleView) {
//                titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width - Padding, 36)];
//                titleView.backgroundColor = [UIColor clearColor];
//                
//                if (!txfSearchField) {
//                    txfSearchField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width - Padding - 30, 3,30, 30)];
//                    txfSearchField.backgroundColor = RGBA(171, 174, 174, 0.15);
//                    txfSearchField.textColor = UIColorFromRGB(0x212121);
//                    txfSearchField.tintColor = UIColorFromRGB(0x212121);
//                    txfSearchField.placeholder = @"Tìm kiếm";
//                    txfSearchField.clipsToBounds = YES;
//                    txfSearchField.layer.cornerRadius = 5;
//                    UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-search-thumb-v2"]];
//                    [leftView setFrame:CGRectMake(0, 0, 35, 35)];
//                    leftView.contentMode = UIViewContentModeCenter;
//                    txfSearchField.leftView = leftView;
//                    txfSearchField.leftViewMode = UITextFieldViewModeAlways;
//                    txfSearchField.delegate = self;
//                    [titleView addSubview:txfSearchField];
//                }
//                self.navigationItem.titleView = titleView;
//                
//            }
//            [self doAnimation:isUp];
//        }
//    }
    if(scrollView.contentOffset.y + scrollView.frame.size.height  > (scrollView.contentSize.height - CELL_HEIGHT_MORE))
    {
        if(self.isLoadMore)
        {
            [self loadMoreNewVideos];
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

//- (void)navigationController:(UINavigationController *)navigationController
//      willShowViewController:(UIViewController *)viewController
//                    animated:(BOOL)animated
//{
//    if([navigationController.viewControllers containsObject:self])
//    {
//        NSLog(@"push");
//    }
//    else
//    {
//        NSLog(@"pop");
//    }
//}


@end
