//
//  DownloadingVC.m
//  NPlus
//
//  Created by Anh Le Duc on 10/29/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "DownloadingVC.h"
#import "DownloadManager.h"
#import "DownloadCell.h"
#import "SubTitle.h"
#import "ParserObject.h"
@interface DownloadingVC ()<UITableViewDataSource, UITableViewDelegate, DownloadManagerDelegate>{
    BOOL _isEdit, _isAnimated;
    NSMutableArray *_itemsSelected;
}

@end

@implementation DownloadingVC
-(NSString *)screenNameGA{
    return [self parent];
}

- (NSString*)parent{
    id parentVC = self.parentViewController.parentViewController;
    if (parentVC && [parentVC respondsToSelector:@selector(screenNameGA)]) {
        return [NSString stringWithFormat:@"%@.Downloading", [parentVC screenNameGA]];
    }
    return @"NotSet";
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isEdit = NO;
    _itemsSelected = [[NSMutableArray alloc] init];
//    self.navigationController.navigationBarHidden = YES;
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
    [self loadData];
    [DownloadManager sharedInstance].delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tbMain registerNib:[UINib nibWithNibName:@"DownloadCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"downloadCellId"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [DownloadManager sharedInstance].delegate = nil;
}

-(void)loadData{
    [_itemsSelected removeAllObjects];
    DownloadManager *manager = [DownloadManager sharedInstance];
    [self.dataSources removeAllObjects];
    NSArray *arr = [manager getListVideoDownload];
    if ( arr && arr.count > 0) {
        [self.dataSources addObjectsFromArray:arr];
    }
    
//    [_tbMain reloadData];
    [_tbMain performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    // notify to update UI
    BOOL isHadData = YES;
    if ([self.dataSources count] <= 0) {
        isHadData = NO;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kDidLoadDownloadingVideoNotification object:nil userInfo:@{kDidLoadDownloadingVideoNotification:[NSNumber numberWithBool:isHadData]}];
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
    DownloadCell *cell = [btableView dequeueReusableCellWithIdentifier:downloadCellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row > self.dataSources.count - 1) {
        return cell;
    }
    FileDownloadInfo *downloadInfo = [self.dataSources objectAtIndex:indexPath.row];
    [cell setFileDownloadInfo:downloadInfo];
    [cell showInfoDownloadingWithEdit:_isEdit animated:_isAnimated];
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
-(void)downloadManager:(DownloadManager *)downloadManager startedDownload:(FileDownloadInfo *)downloadInfo{
    [self loadData];
}

-(void)downloadManager:(DownloadManager *)downloadManager updateDownload:(FileDownloadInfo *)downloadInfo{
    NSArray* cellArr = [self.tbMain visibleCells];
    for(id obj in cellArr)
    {
        if([obj isKindOfClass:[DownloadCell class]])
        {
            DownloadCell *cell=(DownloadCell *)obj;
            [cell updateCell:downloadInfo.taskIdentifier];
        }
    }
}

-(void)downloadManager:(DownloadManager *)downloadManager finishedDownload:(FileDownloadInfo *)downloadInfo{
    [self loadData];
}

-(void)downloadManager:(DownloadManager *)downloadManager cancelDownload:(FileDownloadInfo *)downloadInfo{
    [self loadData];
}

-(void)downloadManager:(DownloadManager *)downloadManager failedDownload:(FileDownloadInfo *)downloadInfo{
    NSArray* cellArr = [self.tbMain visibleCells];
    for(id obj in cellArr)
    {
        if([obj isKindOfClass:[DownloadCell class]])
        {
            DownloadCell *cell=(DownloadCell *)obj;
            [cell updateCell:downloadInfo.taskIdentifier];
        }
    }
}

-(void)onEdit:(BOOL)edit{
    [_itemsSelected removeAllObjects];
    _isAnimated = YES;
    _isEdit = edit;
    [self loadData];
//    _tbMain.contentInset = UIEdgeInsetsMake(5, 0, 150, 0);
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
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:_itemsSelected];
        NSMutableArray *discardedItems = [NSMutableArray array];
        
        for (FileDownloadInfo *info in arr) {
            [[DownloadManager sharedInstance] stop:info];
            [discardedItems addObject:info];
        }
        
        [_itemsSelected removeObjectsInArray:discardedItems];
        [self loadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:kOfflineCountItemCheckNotification object:nil userInfo:@{
                                                                                                                            @"count":[NSNumber numberWithInteger:0],
                                                                                                                            }];
    }
}
@end
