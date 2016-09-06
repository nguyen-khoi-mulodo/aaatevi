//
//  DownloadedVC.m
//  NPlus
//
//  Created by Anh Le Duc on 10/29/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "DownloadedVC.h"
#import "ParserObject.h"
#import "DownloadManager.h"
#import "DBHelper.h"
#import "DownloadCell.h"
@interface DownloadedVC ()<UITableViewDataSource, UITableViewDelegate, DownloadManagerDelegate>{
    BOOL _isEdit, _isAnimated;
    NSMutableArray *_itemsSelected;
}


@end

@implementation DownloadedVC
-(NSString *)screenNameGA{
    return [self parent];
}

- (NSString*)parent{
    id parentVC = self.parentViewController.parentViewController;
    if (parentVC && [parentVC respondsToSelector:@selector(screenNameGA)]) {
        return [NSString stringWithFormat:@"%@.Downloaded", [parentVC screenNameGA]];
    }
    return @"NotSet";
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationController.navigationBarHidden = YES;
    _isEdit = NO;
    _itemsSelected = [[NSMutableArray alloc] init];
    _tbMain.delegate = self;
    _tbMain.dataSource = self;
    _tbMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbMain.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.dataView = _tbMain;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _tbMain.contentInset = UIEdgeInsetsMake(5, 0, 150, 0);
    _tbMain.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 50, 0);
    _isAnimated = NO;
    [DownloadManager sharedInstance].delegate = self;
    [self loadDataIsAnimation:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tbMain registerNib:[UINib nibWithNibName:@"DownloadCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"downloadCellId"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [DownloadManager sharedInstance].delegate = nil;
}

-(void)loadDataIsAnimation:(BOOL)isAnimation{
    [self.dataSources removeAllObjects];
    [_itemsSelected removeAllObjects];
    NSArray *arrUpdated = [[DBHelper sharedInstance]getAllVideoDownloaded];
    [self.dataSources addObjectsFromArray:arrUpdated];
    // reload table
    [_tbMain performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    // notify to update UI
    BOOL isHadData = YES;
    if ([self.dataSources count] <= 0) {
        isHadData = NO;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kDidLoadDownloadedVideoNotification object:nil userInfo:@{kDidLoadDownloadedVideoNotification:[NSNumber numberWithBool:isHadData]}];
}

#pragma mark UITableView delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0f;
}

- (UITableViewCell *) tableView:(UITableView *)btableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *downloadCellId =   @"downloadCellId";
    DownloadCell *cell = (DownloadCell*)[btableView dequeueReusableCellWithIdentifier:downloadCellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSources.count <= indexPath.row) {
        return cell;
    }
    FileDownloadInfo *downloadInfo = [self.dataSources objectAtIndex:indexPath.row];
    [cell setFileDownloadInfo:downloadInfo];
    [cell showInfoDowloadedWithEdit:_isEdit animated:_isAnimated];
    if ([_itemsSelected containsObject:downloadInfo]) {
        [cell checked:YES];
    }else{
        [cell checked:NO];
    }
    [cell.imgBackground setImage:[self cellBackgroundForRowAtIndexPath:indexPath]];
    return cell;
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[UIColor clearColor]];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_tbMain deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row >= self.dataSources.count) {
        return;
    }
    FileDownloadInfo *info = [self.dataSources objectAtIndex:indexPath.row];
    if (_isEdit) {
        if ([_itemsSelected containsObject:info]) {
            [_itemsSelected removeObject:info];
        }else{
            [_itemsSelected addObject:info];
        }
        [tableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:kOfflineCountItemCheckNotification object:nil userInfo:@{
                                                                                                                            @"count":[NSNumber numberWithInteger:_itemsSelected.count],
                                                                                                                            }];
        BOOL isCheckAll = (_itemsSelected.count == self.dataSources.count) ? YES : NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:kOfflineCheckAllNotification object:nil userInfo:@{
                                                                                                                      @"checkAll":[NSNumber numberWithBool:isCheckAll],
                                                                                                                      }];
        
        return;
    }
    if (info.videoDownload) {
//        Channel *show = [ParserObject getShowFromJson:info.jsonShow];
//        show.jsonShow = info.jsonShow;
//        show.jsonSeason = info.jsonSeason;
        NowPlayerVC *nowPlayer = APPDELEGATE.nowPlayerVC;
        nowPlayer.type = @"VideoFull";
        // update detailSeason
//        NSArray *array = [ParserObject getVideosFromJson:info.jsonSeason];
//        for (Video *v in array) {
//            if (v.isHadSubtitle && info.videoDownload.subTitleId) {
//                // update CDVideo.jsonSeason
//                [[DBHelper sharedInstance]updateJsonSeasonWithVideo:v subTitle:info.videoDownload.subTitleId];
//            }
//        }
        
//        if (!APPDELEGATE.internetConnnected) {
//            nowPlayer.currentOfflineVideo = info.videoDownload;
//        }
        //nowPlayer.currentVideo = info.videoDownload;
        
//        nowPlayer.curId = info.videoDownload.video_id;
//        if (info.jsonShow == nil) {
//            nowPlayer.lstVideo = @[info.videoDownload];
//            Channel *s= [[Channel alloc] init];
////            s.show_title = info.videoDownload.video_title;
//            nowPlayer.curShow = s;
//        }else{
//            nowPlayer.curShow = show;
////            NSArray *array = [ParserObject getVideosFromJson:info.jsonSeason];
//            nowPlayer.lstVideo = [ParserObject getVideosFromJson:info.jsonSeason];
//        }
        
        [nowPlayer loadDataVideoIndex:0];
        [nowPlayer showPlayer:YES withAnimation:YES];
    }
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

#pragma mark - download manager delegate

-(void)downloadManager:(DownloadManager *)downloadManager finishedDownload:(FileDownloadInfo *)downloadInfo{
    _isAnimated = NO;
    [self loadData];
}

-(void)onEdit:(BOOL)edit{
    [_itemsSelected removeAllObjects];
    _isAnimated = YES;
    _isEdit = edit;
    [self loadData];
//    _tbMain.contentInset = UIEdgeInsetsMake(5, 0, 55, 0);
}

-(void)onCheckAll:(BOOL)checkAll{
    if (checkAll) {
        [_itemsSelected removeAllObjects];
        [_itemsSelected addObjectsFromArray:self.dataSources];
    }else{
        [_itemsSelected removeAllObjects];
    }
    [_tbMain reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:kOfflineCheckAllNotification object:nil userInfo:@{
                                                                                                                 @"checkAll":[NSNumber numberWithBool:checkAll],
                                                                                                                 }];
    [[NSNotificationCenter defaultCenter] postNotificationName:kOfflineCountItemCheckNotification object:nil userInfo:@{
                                                                                                                  @"count":[NSNumber numberWithInteger:_itemsSelected.count],
                                                                                                                  }];
}

-(void)onDelete{
    if (_itemsSelected.count > 0) {
        NSMutableArray *discardedItems = [NSMutableArray array];
        
        for (FileDownloadInfo *info in _itemsSelected) {
            Video *vd = info.videoDownload;
            BOOL success = [[DBHelper sharedInstance] deleteFileDownloaded:vd.video_id withQuality:vd.type_quality];
            if (success) {
                [discardedItems addObject:info];
            }
        }
        [[DBHelper sharedInstance] refresh];
        [_itemsSelected removeObjectsInArray:discardedItems];
        [self loadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:kOfflineCountItemCheckNotification object:nil userInfo:@{
                                                                                                                            @"count":[NSNumber numberWithInteger:0],
                                                                                                                            }];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDiskSpaceNotification object:nil userInfo:nil];
    }
}
@end
