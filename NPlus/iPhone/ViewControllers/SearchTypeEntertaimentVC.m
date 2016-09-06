//
//  SearchTypeEntertaimentVC.m
//  NPlus
//
//  Created by Anh Le Duc on 12/5/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "SearchTypeEntertaimentVC.h"
#import "CustomVideoCell.h"
@interface SearchTypeEntertaimentVC ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation SearchTypeEntertaimentVC
@synthesize keyword = _keyword;
-(NSString *)screenNameGA{
    return [self parent];
}

- (NSString*)parent{
    id parentVC = self.parentViewController.parentViewController;
    if (parentVC && [parentVC respondsToSelector:@selector(screenNameGA)]) {
        return [NSString stringWithFormat:@"%@.%@", [parentVC screenNameGA], @"GiaiTri"];
    }
    return @"NotSet";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    // Do any additional setup after loading the view from its nib.
    _tbMain.delegate  =self;
    _tbMain.dataSource = self;
    _tbMain.contentInset = UIEdgeInsetsMake(5.0f, 0, 5.0f, 0);
    _tbMain.backgroundColor = [UIColor clearColor];
    _tbMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbMain.alwaysBounceVertical = YES;
    self.dataView = _tbMain;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveDataNotFoundNoti) name:kDataNotExistNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tbMain registerNib:[UINib nibWithNibName:@"CustomVideoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"customVideoCellId"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.dataSources.count == 0) {
        [self loadData];
    }
}

- (void)loadData{
    if (self.dataSources.count == 0) {
        [self showConnectionErrorView:NO];
        [self showNoDataView:NO];
        [self showLoadingDataView:YES];
    }
    [[APIController sharedInstance] getSearchVideos:_keyword withPageIndex:[NSString stringWithFormat:@"%ld", (long)self.curPage] completed:^(NSArray *results, BOOL isMore) {
        self.isLoadMore = isMore;
         if (self.curPage == kFirstPage) {
             [self.dataSources removeAllObjects];
             [self.dataSources addObjectsFromArray:results];
         }else{
             [self.dataSources addObjectsFromArray:results];
         }
        [self finishLoadData];
//        self.dataView.hidden = YES;
        [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(loadDataView) userInfo:nil repeats:NO];
        
         } failed:^(NSError *error) {
             NSDictionary *dic = error.userInfo;
             if (self.dataSources.count == 0) {
                 [self showLoadingDataView:NO];
                 if (dic && [[[dic objectForKey:@"error"] objectForKey:@"code"] integerValue] == 224) {
                     [self showConnectionErrorView:NO];
                     [self showNoDataView:YES];
                     
                 }else{
                     [self showConnectionErrorView:YES];
                     [self showNoDataView:NO];
                     
                 }
             }
         }];
}

- (void)loadDataView{
    [self finishLoadData];
    [self showLoadingDataView:NO];
}

- (void)receiveDataNotFoundNoti {
    if (self.dataSources.count == 0) {
        [self showLoadingDataView:NO];
        [self showNoDataView:YES];
    }
    if (!APPDELEGATE.internetConnnected && self.dataSources.count == 0) {
        [self showNoDataView:NO];
        [self showConnectionErrorView:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"customVideoCellId";
    CustomVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    id obj = [self.dataSources objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[Video class]]) {
        Video *v = (Video*)obj;
        cell.lbTitle.text = v.video_title;
        cell.lbTitle.textColor = RGB(80, 80, 80);
        
        cell.lbSinger.textColor = RGB(119, 119, 119);
        
        [cell.imgItem setImageWithURL:[NSURL URLWithString:v.video_image] placeholderImage:[UIImage imageNamed:@"default_video"]];
        cell.imgBackground.image = [self cellBackgroundForRowAtIndexPath:indexPath];
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95.0f;
}
- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:_tbMain numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (self.dataSources.count == 1) {
        background = [UIImage imageNamed:@"theloai_cell_group"];
        UIEdgeInsets insets = UIEdgeInsetsMake(8, 12, 8, 12);
        UIImage *stretchableImage = [background resizableImageWithCapInsets:insets];
        return stretchableImage;
    }
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"theloai_cell_top"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"theloai_cell_bottom"];
    } else {
        background = [UIImage imageNamed:@"theloai_cell_midle"];
    }
    UIEdgeInsets insets = UIEdgeInsetsMake(8, 12, 8, 12);
    UIImage *stretchableImage = [background resizableImageWithCapInsets:insets];
    return stretchableImage;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > self.dataSources.count - 1) {
        return;
    }
    id obj = [self.dataSources objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[Video class]]){
        Video *video = (Video*)obj;
        Channel *show = [[Channel alloc] init];
        show.channelName = video.video_title;
        show.channelDes = @"";
        NowPlayerVC *nowPlayer = APPDELEGATE.nowPlayerVC;
        nowPlayer.type = @"VideoFull";
        nowPlayer.curShow = show;
        nowPlayer.curId = video.video_id;
        nowPlayer.lstVideo = @[video];
        [nowPlayer loadDataVideoIndex:0];
        [nowPlayer showPlayer:YES withAnimation:YES];
    }
}

@end
