//
//  ListVideoVC.m
//  NPlus
//
//  Created by Anh Le Duc on 8/20/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "ListVideoVC.h"
#import "UIViewController+AKTabBarController.h"
#import "AKTabBarController.h"
#import "ListVideoCell.h"
#import "Channel.h"
#import "Season.h"
#import "SearchVC.h"
#import "NowPlayerVC.h"
@interface ListVideoVC ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ListVideoVC
@synthesize currentItem = _currentItem;
@synthesize itemCollectionType = _itemCollectionType;

- (NSString *)screenNameGA{
    return @"Channel";
}

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
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView.hidden = YES;
    UIBarButtonItem *barSearch = [[UIBarButtonItem alloc] initWithCustomView:_btnSearch];
    UIBarButtonItem *barBack = [[UIBarButtonItem alloc] initWithCustomView:_btnBack];
    self.navigationItem.rightBarButtonItem = barSearch;
    self.navigationItem.leftBarButtonItem = barBack;
    [_btnBack setTitleColor:COLOR_MAIN_GRAY forState:UIControlStateNormal];
    [_btnBack setTitleColor:COLOR_MAIN_BLUE forState:UIControlStateHighlighted];
    
    if (_currentItem) {
//        [_btnBack setTitle:_currentItem.show_title forState:UIControlStateNormal];
//        [_btnBack setTitle:_currentItem.show_title forState:UIControlStateHighlighted];
    }
    
    _tbMain.dataSource = self;
    _tbMain.delegate = self;
    _tbMain.clipsToBounds = NO;
    _tbMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbMain.backgroundColor = BACKGROUND_COLOR;
    
    if (!self.akTabBarController.isTabBarHidden) {
        _tbMain.contentInset = UIEdgeInsetsMake(0, 0, 55, 0);
        _tbMain.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0);
    }
    float delta = 0.344f;
    float width = SCREEN_WIDTH;
    float height = width * delta;
    UIView *headerTable = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    headerTable.backgroundColor = BACKGROUND_COLOR;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height - 5)];
    imageView.tag = 100;
    [imageView setImage:[UIImage imageNamed:@"default_showcase"]];
    [headerTable addSubview:imageView];
    _tbMain.tableHeaderView = headerTable;
    self.dataView = _tbMain;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.dataSources.count == 0) {
        [self loadData];
    }
}

- (void)loadData{
    [[APIController sharedInstance] getShowDetailWithId:_currentItem.channelId completed:^(Channel *result, NSString *jsonShow) {
        _currentItem = result;
//        _currentItem.jsonShow = jsonShow;
        [self.dataSources removeAllObjects];
        [self.dataSources addObjectsFromArray:result.seasons];
        [self doneLoadingTableViewData];
    } failed:^(NSError *error) {
        
    }];
}

-(void)doneLoadingTableViewData{
    [super doneLoadingTableViewData];
    UIView *header = _tbMain.tableHeaderView;
    if (header) {
        UIImageView *imageView = (UIImageView*)[header viewWithTag:100];
        [imageView setImageWithURL:[NSURL URLWithString:_currentItem.fullImg] placeholderImage:[UIImage imageNamed:@"default_showcase_channel"]];
    }
    [_tbMain reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack_Tapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - uitableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 89.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *listVideoCellId = @"listVideoCellId";
    
    ListVideoCell *cell = (ListVideoCell *)[tableView dequeueReusableCellWithIdentifier:listVideoCellId];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListVideoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    id obj = [self.dataSources objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[Season class]]) {
//        Season *item = (Season*)obj;
//        cell.lbTitle.text = item.season_title;
//        cell.lbSubTitle.text = item.season_show;
//        cell.lbCountVideo.text = item.number_video;
//        [cell.imgItem setImageWithURL:[NSURL URLWithString:item.season_image] placeholderImage:[UIImage imageNamed:@"default_video"]];
    }
    cell.imgOver.backgroundColor = [UIColor blackColor];
    cell.imgOver.alpha = 0.5f;
    [cell.imgBg setImage:[self cellBackgroundForRowAtIndexPath:indexPath]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:_tbMain numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"list_video_cell_top"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"list_video_cell_bottom"];
    } else {
        background = [UIImage imageNamed:@"list_video_cell_midle"];
    }
    
    return background;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= self.dataSources.count) {
        return;
    }
//    Season *season = [self.dataSources objectAtIndex:indexPath.row];
//    NowPlayerVC *nowPlayer = APPDELEGATE.nowPlayerVC;
//    nowPlayer.type = @"Serial";
//    nowPlayer.curId = season.season_id;
//    nowPlayer.curShow = _currentItem;
//    nowPlayer.itemCollectionType = _itemCollectionType;
//    [nowPlayer loadData];
//    [nowPlayer showPlayer:YES withAnimation:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
