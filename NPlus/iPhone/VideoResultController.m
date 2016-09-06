//
//  VideoResultController.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/16/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "VideoResultController.h"

@interface VideoResultController () {
    NSString *_keyword;
}

@end

@implementation VideoResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tbMain.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tbMain.separatorColor = UIColorFromRGB(0xf0f0f0);
    [self.tbMain registerNib:[UINib nibWithNibName:@"HomeItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"homeCellIdef"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self trackScreen:@"iOS.Searchvideo"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)loadDataIsAnimation:(BOOL)isAnimation {
    self.pageIndex = 1;
    self.total = 0;
    self.isLoadMore = NO;
    [self.dataSources removeAllObjects];
    [self searchVideoByKeyWord:_keyword isNewSearch:NO];
}

- (void)searchVideoByKeyWord:(NSString*)keyword isNewSearch:(BOOL)isNewSearch{
    _keyword = keyword;
    if (isNewSearch) {
        self.total = 0;
        self.pageIndex = 1;
    }
    if (APPDELEGATE.internetConnnected) {
        //[Utilities showGlobalProgressHUDWithTitle:nil];
        [[APIController sharedInstance]searchVideoByKeyword:keyword pageIndex:self.pageIndex pageSize:kDefaultPageSize completed:^(int code, NSArray *results, BOOL loadmore, int total) {
            if (results) {
                NSArray *array = results;
                if (isNewSearch) {
                    self.dataSources = (NSMutableArray*)array;
                } else {
                    [self.dataSources addObjectsFromArray:array];
                }
                self.isLoadMore = loadmore;
                if (loadmore) {
                    self.pageIndex = self.pageIndex + 1;
                }
                [self.tbMain reloadData];
            }
            [self dismissHUD];
            //[self loadEmptyData];
        } failed:^(NSError *error) {
            [self dismissHUD];
        }];
    } else {
        //[self showConnectionErrorView:YES offsetY:88];
    }
}
- (void)loadMore {
    if (self.isLoadMore) {
        [self searchVideoByKeyWord:_keyword isNewSearch:NO];
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
    return SCREEN_SIZE.width/2 *210/372 + 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count%2 == 0 ? self.dataSources.count/2 : self.dataSources.count/2 + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *hotCellIdenf = @"homeCellIdef";
    HomeItemCell *homeCell = [tableView dequeueReusableCellWithIdentifier:hotCellIdenf];
    if (!homeCell) {
        homeCell = [Utilities loadView:[HomeItemCell class] FromNib:@"HomeItemCell"];
    }
    homeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    homeCell.delegate = self;
    int index = (int)indexPath.row*2;
    if (self.dataSources.count > index) {
        Video *video1 = [self.dataSources objectAtIndex:index];
        homeCell.video1 = video1;
    }
    if (self.dataSources.count > index + 1) {
        Video *video2 = [self.dataSources objectAtIndex:index +1];
        homeCell.video2 = video2;
    }
    [homeCell loadContentViewWithType:typeVideo];
    homeCell.delegate = self;
    return homeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSources.count > indexPath.row) {
        
    }
}
#pragma mark - HomeCell Delegate
- (void)itemTapped:(id)object {
    if ([object isKindOfClass:[Video class]]) {
        Video *v = (Video*)object;
        [APPDELEGATE didSelectVideoCellWith:v];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if(scrollView.contentOffset.y + scrollView.frame.size.height  > (scrollView.contentSize.height - CELL_HEIGHT_MORE))
    {
        if(self.isLoadMore)
        {
            [self loadMore];
            self.isLoadMore = NO;
        }
    }
}

- (void) showNoDataView: (BOOL) show{
    //[myNavi.rightBtn setHidden:show];
    [super showNoDataView:show];
}
#pragma mark - XLPagerTabStripViewControllerDelegate

-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"Video";
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return [UIColor redColor];
}

@end
