//
//  DetailGenreController.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/12/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "DetailGenreController.h"

@interface DetailGenreController () {
    BOOL isReload;
    NSString *nextType;
}

@end

@implementation DetailGenreController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tbMain registerNib:[UINib nibWithNibName:@"HomeItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"homeCellIdef"];
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.tbMain.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveInternetNoti) name:kDidConnectInternet object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!isReload) {
        isReload = YES;
        [self firstLoad];
    } else {
        if (![nextType isEqualToString:_type]) {
            _type = [Utilities getTypeGenre];
            [self firstLoad];
        }
    }
    
    if(![[[kNSUserDefault dictionaryRepresentation] allKeys] containsObject:@"coachmark_theloai"]){
        
        UIImageView *cm = [APPDELEGATE.window viewWithTag:902];
        if (cm) {
            return;
        }
        
        cm = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
        [cm setTag:902];
        
        NSString *nameCM = @"";
        if (IS_IPHONE_4_OR_LESS) {
            nameCM = @"coachmark-theloai-ip4.png";
        } else if (IS_IPHONE_5) {
            nameCM = @"coachmark-theloai-ip5.png";
        } else if (IS_IPHONE_6){
            nameCM = @"coachmark-theloai-ip6.png";
        } else if (IS_IPHONE_6P) {
            nameCM = @"coachmark-theloai-ip6p.png";
        } else {
            nameCM = @"coachmark-theloai-ip6.png";
        }
        
        [cm setImage:[UIImage imageNamed:nameCM]];
        [APPDELEGATE.window addSubview:cm];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
        singleTap.numberOfTapsRequired = 1;
        [cm setUserInteractionEnabled:YES];
        [cm addGestureRecognizer:singleTap];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)tapDetected{
    UIImageView *cm = [APPDELEGATE.window viewWithTag:902];
    if ([cm isKindOfClass:[UIImageView class]]) {
        [cm removeFromSuperview];
        cm = nil;
        
        UIImageView *cm2 = [APPDELEGATE.window viewWithTag:903];
        if (!cm2) {
            cm2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
            [APPDELEGATE.window addSubview:cm2];
        }
        [cm2 setTag:903];
        NSString *nameCM = @"";
        if (IS_IPHONE_4_OR_LESS) {
            nameCM = @"coachmark-theloai-ip41.png";
        } else if (IS_IPHONE_5) {
            nameCM = @"coachmark-theloai-ip51.png";
        } else if (IS_IPHONE_6){
            nameCM = @"coachmark-theloai-ip61.png";
        } else if (IS_IPHONE_6P) {
            nameCM = @"coachmark-theloai-ip6p1.png";
        } else {
            nameCM = @"coachmark-theloai-ip61.png";
        }
        
        [cm2 setImage:[UIImage imageNamed:nameCM]];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected1)];
        singleTap.numberOfTapsRequired = 1;
        [cm2 setUserInteractionEnabled:YES];
        [cm2 addGestureRecognizer:singleTap];
    }
}
- (void)tapDetected1 {
    [kNSUserDefault setObject:@"YES" forKey:@"coachmark_theloai"];
    [kNSUserDefault synchronize];
    UIImageView *cm = [APPDELEGATE.window viewWithTag:903];
    if ([cm isKindOfClass:[UIImageView class]]) {
        [cm removeFromSuperview];
        cm = nil;
    }
}

- (void)receiveInternetNoti {
    self.viewNoConnection.hidden = NO;
    [self firstLoad];
}

#pragma mark - Process Data

- (void)firstLoad {
    self.pageIndex = 1;
    self.total = 0;
    self.isLoadMore = NO;
    [self.dataSources removeAllObjects];
    
    [self loaDataWithParentId:_genre.genreId type:_type pageIndex:self.pageIndex pageSize:kDefaultPageSize showLoading:!_isNotLoading isAnimation:YES];
}

- (void)loadDataIsAnimation:(BOOL)isAnimation{
    self.pageIndex = 1;
    self.total = 0;
    self.isLoadMore = NO;
    [self.dataSources removeAllObjects];
    
    [self loaDataWithParentId:_genre.genreId type:_type pageIndex:self.pageIndex pageSize:kDefaultPageSize showLoading:NO isAnimation:YES];
    
}

- (void)loaDataWithParentId:(NSString*)parentId type:(NSString*)type pageIndex:(int)pageIndex pageSize:(int)pageSize showLoading:(BOOL)isShowLoading isAnimation:(BOOL)isAnimation{
    if (APPDELEGATE.internetConnnected) {
        nextType = type;
        if (isShowLoading) {
            [self showProgressHUDWithTitle:nil];
        }
        [[APIController sharedInstance]getListChannelsWithGenreId:parentId type:[type isEqualToString:@"Mới"] ?NEW_TYPE:HOT_TYPE pageIndex:pageIndex pageSize:pageSize completed:^(int code, NSArray *results, BOOL loadmore, int total) {
            if (results) {
                NSArray *array = results;
                [self.dataSources addObjectsFromArray:array];
                self.isLoadMore = loadmore;
                if (loadmore) {
                    self.pageIndex = self.pageIndex + 1;
                }
                [self.tbMain reloadData];
                if (isAnimation) {
                    [self.tbMain scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
                }
            }
            [self dismissHUD];
            [self loadEmptyData];
        } failed:^(NSError *error) {
            [self dismissHUD];
        }];
        self.viewNoConnection.hidden = YES;
    } else {
        self.viewNoConnection.hidden = NO;
    }
}

- (void)loadMore {
    if (self.isLoadMore) {
        [self loaDataWithParentId:_genre.genreId type:_type pageIndex:self.pageIndex pageSize:kDefaultPageSize showLoading:NO isAnimation:NO];
    }
}

#pragma mark UITableView delegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 4;
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources.count%2 == 0 ? self.dataSources.count/2 : self.dataSources.count/2 + 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_SIZE.width/2 *210/372 + 65;
}

- (UITableViewCell *) tableView:(UITableView *)btableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *hotCellIdenf = @"homeCellIdef";
    HomeItemCell *homeCell = [btableView dequeueReusableCellWithIdentifier:hotCellIdenf];
    if (!homeCell) {
        homeCell = [Utilities loadView:[HomeItemCell class] FromNib:@"HomeItemCell"];
    }
    homeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    homeCell.delegate = self;
    int index = (int)indexPath.row*2;
    if (self.dataSources.count > index) {
        Channel *channel1 = [self.dataSources objectAtIndex:index];
        homeCell.channel1 = channel1;
    }
    if (self.dataSources.count > index + 1) {
        Channel *channel2 = [self.dataSources objectAtIndex:index +1];
        homeCell.channel2 = channel2;
    }
    [homeCell loadContentViewWithType:typeChannel];
    return homeCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    if ([scrollView.panGestureRecognizer translationInView:scrollView].y < 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hideGenreView" object:nil];
    }
}

#pragma mark - HomeCell Delegate
- (void)itemTapped:(id)object {
    if ([object isKindOfClass:[Channel class]]) {
        Channel *c = (Channel*)object;
        [APPDELEGATE didSelectChannelCellWith:c isPush:NO];
    }
}

#pragma mark - XLPagerTabStripViewControllerDelegate

-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return _genre.genreName;
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return [UIColor redColor];
}

@end
