//
//  HistoryVC.m
//  NPlus
//
//  Created by Anh Le Duc on 11/11/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "HistoryVC.h"
#import "UIViewController+AKTabBarController.h"
#import "AKTabBarController.h"
#import "ParserObject.h"
#import "DBHelper.h"
#import "CDHistory.h"
@interface HistoryVC ()<UIAlertViewDelegate>

@end

@implementation HistoryVC

-(NSString *)screenNameGA{
    return @"History";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!IS_IPAD) {
        UIBarButtonItem *barDelete = [[UIBarButtonItem alloc] initWithCustomView:_btnDelete];
        UIBarButtonItem *barBack = [[UIBarButtonItem alloc] initWithCustomView:_btnBack];
        self.navigationItem.rightBarButtonItem = barDelete;
        self.navigationItem.leftBarButtonItem = barBack;
        [_btnBack setTitleColor:COLOR_MAIN_GRAY forState:UIControlStateNormal];
        [_btnBack setTitleColor:COLOR_MAIN_BLUE forState:UIControlStateHighlighted];
        self.view.backgroundColor = BACKGROUND_COLOR;
        _tbMain.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbMain.contentInset  = UIEdgeInsetsMake(5.0f, 0, 5, 0);
    }else{
        _tbMain.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.view.backgroundColor = [UIColor whiteColor];
        [_tbMain setBackgroundColor:BACKGROUND_COLOR];
        [_tbMain setTableHeaderView:self.viewHeader];
        
    }
    // Do any additional setup after loading the view from its nib.
    _tbMain.dataSource = self;
    _tbMain.delegate = self;
    
    _tbMain.backgroundColor = [UIColor clearColor];
    self.dataView = _tbMain;
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:kReloadHistoryNotification object:nil];
}

-(void)myDealloc{
    [super myDealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReloadHistoryNotification object:nil];
}

-(void)loadData{
    NSArray *lstHistory = [[DBHelper sharedInstance] getVideoHistory];
    if (lstHistory == nil) {
        _btnDelete.enabled = NO;
    }else{
        _btnDelete.enabled = YES;
    }
    [self.dataSources removeAllObjects];
    [self.dataSources addObjectsFromArray:lstHistory];
    [self.btnDeleteHeader setHidden:(IS_IPAD && self.dataSources.count == 0)];
    [_tbMain reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([_tbMain respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tbMain setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tbMain respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tbMain setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.akTabBarController hideTabBarAnimated:NO];
    if (IS_IPAD) {
        [self setScreenName:@"iPad.History"];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.akTabBarController showTabBarAnimated:NO];
    
}

- (IBAction)btnDelete_Tapped:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Bạn muốn xoá tất cả lịch sử đã xem không?" delegate:self cancelButtonTitle:@"Không" otherButtonTitles:@"Xoá", nil];
    alert.tag = 111;
    [alert show];
}

- (IBAction)btnBack_Tapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        background.tag = 100;
        background.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:background];
    }
    CDHistory *his = [self.dataSources objectAtIndex:indexPath.row];
    cell.textLabel.text = his.videoTitle;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.textColor = RGB(80, 80, 80);
    double seconds = [his.lastTime doubleValue];
    if (seconds == -1) {
        cell.detailTextLabel.text = @"Bạn đã xem hết!";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.detailTextLabel.textColor = RGB(161, 161, 161);
    }else{
        NSString *time = [self getStringFromSeconds:seconds];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Bạn đã xem đến %@", time];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.detailTextLabel.textColor = RGB(161, 161, 161);
    }
    
    if (!IS_IPAD) {
        UIImageView *background = (UIImageView*)[cell.contentView viewWithTag:100];
        [background setImage:[self cellBackgroundForRowAtIndexPath:indexPath]];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
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
    if (indexPath.row > self.dataSources.count) {
        return;
    }
    CDHistory *his = [self.dataSources objectAtIndex:indexPath.row];
    if (IS_IPAD) {
        if (self.parentDelegate && [self.parentDelegate respondsToSelector:@selector(showVideo:andOtherItem:)]) {
            [self.parentDelegate showVideo:his andOtherItem:nil];
        }
        
        if (self.parentDelegate && [self.parentDelegate respondsToSelector:@selector(showHistoryView:)]) {
            [self.parentDelegate showHistoryView:NO];
        }
        
    }else{
        if (his.videoId != nil) {
//            Channel *show = [ParserObject getShowFromJson:his.showDetail];
//            show.jsonShow = his.showDetail;
//            show.jsonSeason = his.seasonDetail;
            NowPlayerVC *nowPlayer = APPDELEGATE.nowPlayerVC;
            nowPlayer.type = @"VideoFull";
            //nowPlayer.curShow = show;
            nowPlayer.curId = his.videoId;
            //nowPlayer.lstVideo = [ParserObject getVideosFromJson:his.seasonDetail];
            [nowPlayer loadDataVideoIndex:0];
            [nowPlayer showPlayer:YES withAnimation:YES];
        }else{
            Channel *show = [[Channel alloc] init];
            show.channelName = his.videoTitle;
            show.channelDes = @"";
            show.fullImg = his.videoImage;
            
            NowPlayerVC *nowPlayer = APPDELEGATE.nowPlayerVC;
            nowPlayer.type = @"VideoDetail";
            nowPlayer.curId = his.videoId;
            nowPlayer.curShow = show;
            //        nowPlayer.itemCollectionType = collectionType;
            [nowPlayer loadDataVideoIndex:0];
            [nowPlayer showPlayer:YES withAnimation:YES];
        }
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 111 && buttonIndex == 1) {
        [[DBHelper sharedInstance] clearAllHistory];
        [self loadData];
    }
}

-(NSString*)getStringFromSeconds:(double)currentSeconds
{
    int mins = currentSeconds/60.0;
    int hour = mins/60.0;
    if (hour > 0) {
        mins = mins % 60;
    }
    int secs = fmodf(currentSeconds, 60.0);
    NSString *hourString = hour < 10 ? [NSString stringWithFormat:@"0%d", hour] : [NSString stringWithFormat:@"%d", hour];
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    return [NSString stringWithFormat:@"%@:%@:%@", hourString, minsString, secsString];
}
@end
