//
//  ListHistoryController.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/29/16.
//  Copyright © 2016 anhld. All rights reserved.
//

#import "DownloadController.h"
#import "DownloadedItemCell.h"
#import "UIViewController+AKTabBarController.h"
#import "AKTabBarController.h"
#import "DBHelper.h"

@interface DownloadController () {
    MyNavigationItem *myNavi;
    BOOL isEditMode;
    UIButton *btnDelete;
    CGRect btnDeleteFrame;
}

@end

@implementation DownloadController

- (NSString *)tabImageName
{
    return @"main-download-v2";
}

- (NSString *)activeTabImageName
{
    return @"main-download-h-v2";
}

- (NSString *)tabTitle
{
    return @"";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    myNavi = [[MyNavigationItem alloc] initWithController:self type:10];
    myNavi.delegate = self;
    self.tbMain.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tbMain.separatorColor = UIColorFromRGB(0xf0f0f0);
    [self.tbMain setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    [self.tbMain setBackgroundColor: UIColorFromRGB(0xf0f0f0)];
    [self.tbMain registerNib:[UINib nibWithNibName:@"DownloadedItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"downloadItemCellIdef"];
    isEditMode = NO;
    itemsSelected = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDiskSpace) name:kUpdateDiskSpaceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:kDidAddDownloadVideoNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Tải về";
    [self trackScreen:@"iOS.ProfileDownload"];
    self.navigationController.navigationBarHidden = NO;
    APPDELEGATE.rootNavController.navigationBarHidden = YES;
    [self.tbMain setContentOffset:CGPointZero];
    if (!isEditMode) {
        [self.akTabBarController showTabBarAnimated:YES];
    } else {
        //[self.akTabBarController hideTabBarAnimated:NO];
    }
    
    [self updateDiskSpace];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadData];
}

- (void) loadData{
    if (self.dataSources.count > 0) {
        [self.dataSources removeAllObjects];
    }
    NSArray *arrDownloaded = [[DBHelper sharedInstance] getAllVideoDownloaded];
    NSArray* reversedArray = [[arrDownloaded reverseObjectEnumerator] allObjects];
    [self.dataSources addObjectsFromArray:reversedArray];
    
    arrayDownloading = [[DownloadManager sharedInstance] getListVideoDownload];
    [DownloadManager sharedInstance].delegate = self;
    
    [self showNoDataView:(self.dataSources.count == 0)];
    [self showHeader:!isEditMode];
    [self showFooter:!isEditMode];
    [self.tbMain reloadData];
    if (!isEditMode) {
        [self.akTabBarController showTabBarAnimated:YES];
    }
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[DownloadManager sharedInstance] setDelegate:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    NSLayoutConstraint *constranitTopTable = [self.view.constraints objectAtIndex:6];
//    constranitTopTable.constant = 64;
    [self.view layoutIfNeeded];
    [self.view setNeedsLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showHeader:(BOOL) isShow{
    if (isShow) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        if (arrayDownloading.count > 0) {
            [headerView setTranslatesAutoresizingMaskIntoConstraints:YES];
            [headerView setFrame:CGRectMake(0, 0, SCREEN_SIZE.width, headerView.frame.size.height)];
            [headerView setBackgroundColor:UIColorFromRGB(0xfcfcfc)];
            int count = 0;
            for (FileDownloadInfo* info in arrayDownloading) {
                if (info.isDownloading) {
                    count ++;
                }
            }
            if (count > 0) {
                [lbSoLuong setText:[NSString stringWithFormat:@"Đang tải (%d)", (int)arrayDownloading.count]];
            }else{
                [lbSoLuong setText:@"Đang dừng"];
                FileDownloadInfo* info = [arrayDownloading lastObject];
                [lbTitle setText:info.videoDownload.video_subtitle];
                [lbSize setText:[Util getRatioWithBytesWritten:info.totalBytesWritten BytesExpectedToWrite:info.totalBytesExpectedToWrite]];
                [processView setProgress:info.downloadProgress];
            }
            
            UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height, SCREEN_SIZE.width, 11)];
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 1)];
            lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
            UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, SCREEN_SIZE.width, 10)];
            paddingView.backgroundColor = UIColorFromRGB(0xf0f0f0);
            [footer addSubview:lineView];
            [footer addSubview:paddingView];
            
            [view setFrame:CGRectMake(0, 0, SCREEN_SIZE.width, headerView.frame.size.height + footer.frame.size.height)];
            [view addSubview:headerView];
            [view addSubview:footer];
        }
//        if (self.dataSources.count > 0) {
//            HomeHeaderSection* headerViewOfSection = [Utilities loadView:[HomeHeaderSection class] FromNib:@"HomeHeaderSection"];
//            headerViewOfSection.backgroundColor = UIColorFromRGB(0xfcfcfc);
//            headerViewOfSection.lblHeader.text = [NSString stringWithFormat:@"Đã tải (%d)", (int)self.dataSources.count];
//            [headerViewOfSection.iconHeader setHidden:YES];
//            [headerViewOfSection.lblHeader setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
//            [headerViewOfSection setFrame:CGRectMake(0, view.frame.size.height, SCREEN_SIZE.width, headerViewOfSection.frame.size.height)];
//            [view setFrame:CGRectMake(0, 0, SCREEN_SIZE.width, view.frame.size.height + headerViewOfSection.frame.size.height)];
//            [view addSubview:headerViewOfSection];
//        }
        HomeHeaderSection* headerViewOfSection = [Utilities loadView:[HomeHeaderSection class] FromNib:@"HomeHeaderSection"];
//        headerViewOfSection.backgroundColor = UIColorFromRGB(0xfcfcfc);
        [headerViewOfSection setBackgroundColor:[UIColor whiteColor]];
        headerViewOfSection.lblHeader.text = [NSString stringWithFormat:@"Đã tải (%d)", (int)self.dataSources.count];
        [headerViewOfSection.iconHeader setHidden:YES];
        [headerViewOfSection.lblHeader setFont:[UIFont fontWithName:kFontRegular size:20.0f]];
        [headerViewOfSection setFrame:CGRectMake(0, view.frame.size.height, SCREEN_SIZE.width, headerViewOfSection.frame.size.height)];
        [view setFrame:CGRectMake(0, 0, SCREEN_SIZE.width, view.frame.size.height + headerViewOfSection.frame.size.height)];
        [view addSubview:headerViewOfSection];
        [view setBackgroundColor:[UIColor blueColor]];
        [self.tbMain setTableHeaderView:view];
    }else{
        [self.tbMain setTableHeaderView:nil];
    }
    
}

- (void) showFooter:(BOOL) isShow{
    if (isShow) {
//        if (self.dataSources.count > 0) {
//            [self.tbMain setTableFooterView:footerView];
//        }
        [self.tbMain setTableFooterView:footerView];
    }else{
        [self.tbMain setTableFooterView:nil];
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

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return  60;
//}
//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    HomeHeaderSection *headerViewOfSection = [Utilities loadView:[HomeHeaderSection class] FromNib:@"HomeHeaderSection"];
//    headerViewOfSection.backgroundColor = UIColorFromRGB(0xfcfcfc);
//    headerViewOfSection.lblHeader.text = [NSString stringWithFormat:@"Đã tải (%d)", (int)self.dataSources.count];
//    [headerViewOfSection.iconHeader setHidden:YES];
//    return headerViewOfSection;
//}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *itemCellIdef = @"downloadItemCellIdef";
    DownloadedItemCell *cell = (DownloadedItemCell*)[self.tbMain dequeueReusableCellWithIdentifier:itemCellIdef];
    if (!cell) {
        cell = [Utilities loadView:[DownloadedItemCell class] FromNib:@"DownloadedItemCell"];
    }
    
    if (indexPath.row < self.dataSources.count) {
        FileDownloadInfo* item = [self.dataSources objectAtIndex:indexPath.row];
        [cell setContent:item];
    }
    if (tableView.editing) {
        if (myNavi.leftBtn.selected) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
        }else{
//            [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
        }
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        NSLog(@"selected editing");
        if (self.dataSources.count > indexPath.row) {
            FileDownloadInfo* item = [self.dataSources objectAtIndex:indexPath.row];
            if (![itemsSelected containsObject:item]) {
                [itemsSelected addObject:item];
            }
            [self updateNumsOfItems];
        }
    } else {
        NSLog(@"selected");
        if (self.dataSources.count > indexPath.row) {
            FileDownloadInfo* item = [self.dataSources objectAtIndex:indexPath.row];
            APPDELEGATE.nowPlayerVC.curIndexVideoChoose = indexPath.row;
            [APPDELEGATE didSelectVideoOffline:item.videoDownload];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        NSLog(@"deselected editing");
        if (self.dataSources.count > indexPath.row) {
            FileDownloadInfo* item = [self.dataSources objectAtIndex:indexPath.row];
            [self removeItem:item];
            [self updateNumsOfItems];
        }
    } else {
        NSLog(@"deselected");
    }
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"commit editing");
}
#pragma mark - MyNavigationItem Delegate
- (void)didRightButtonTapWithType:(int)type {
    if (type == 10) {
        isEditMode = !isEditMode;
        [self.tbMain setEditing:isEditMode animated:YES];
        [self showHeader:!isEditMode];
        [self showFooter:!isEditMode];
        [myNavi.rightBtn setImage: isEditMode ? [UIImage imageNamed:@""]:[UIImage imageNamed:@"icon-xoa-v2"] forState:UIControlStateNormal];
//        [myNavi.leftBtn setImage: isEditMode ? [UIImage imageNamed:@""]:[UIImage imageNamed:@"icon-back-v2"] forState:UIControlStateNormal];
        [myNavi.leftBtn setImage:nil forState:UIControlStateNormal];
        [myNavi.rightBtn setSelected:isEditMode];
        [myNavi.leftBtn setSelected:NO];
        
        if (isEditMode) {
            [self.akTabBarController hideTabBarAnimated:YES];
            
        } else {
            [self.akTabBarController showTabBarAnimated:YES];
            self.tbMain.allowsMultipleSelection = NO;
        }
        if (!btnDelete) {
            btnDelete = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_SIZE.height - 64, SCREEN_SIZE.width, 50)];
            btnDelete.backgroundColor = [UIColor redColor];
            [self updateNumsOfItems];
            [self.view addSubview:btnDelete];
            btnDeleteFrame = btnDelete.frame;
            [btnDelete addTarget:self action:@selector(removeItems) forControlEvents:UIControlEventTouchUpInside];
        }
        myNavi.rightBtn.enabled = NO;
        [UIView animateWithDuration:0.5 animations:^{
            btnDelete.frame = isEditMode ? CGRectMake(0, SCREEN_SIZE.height - 50 - 64, SCREEN_SIZE.width, 50):btnDeleteFrame;
        } completion:^(BOOL finished) {
            if (!isEditMode) {
                btnDelete = nil;
                [itemsSelected removeAllObjects];
            }
            myNavi.rightBtn.enabled = YES;
        }];
    }
    
    
}

- (void)didLeftButtonTap{
    myNavi.leftBtn.selected = !myNavi.leftBtn.selected;
    if (myNavi.leftBtn.selected) {
        [myNavi.leftBtn setTitle:@"Bỏ chọn" forState:UIControlStateNormal];
        myNavi.leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -32, 0, 0);
        for (FileDownloadInfo* info in self.dataSources) {
            if (![itemsSelected containsObject:info]) {
                [itemsSelected addObject:info];
            }
        }
    }else{
        [itemsSelected removeAllObjects];
        myNavi.leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
        [myNavi.leftBtn setTitle:@"Chọn tất cả" forState:UIControlStateNormal];
    }
    [self updateNumsOfItems];
    [self.tbMain reloadData];
}

- (void) updateNumsOfItems{
    [btnDelete setTitle:[NSString stringWithFormat:@"Xoá (%d)", (int)itemsSelected.count] forState:UIControlStateNormal];
    if (itemsSelected.count == self.dataSources.count) { // self.datasources.cout
        [myNavi.leftBtn setTitle:@"Bỏ chọn" forState:UIControlStateNormal];
        myNavi.leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -32, 0, 0);
        [myNavi.leftBtn setSelected:YES];
    }
}

- (void) showNoDataView: (BOOL) show{
    [myNavi.rightBtn setHidden:show];
//    [super showNoDataView:show];
}

- (void) removeItem:(FileDownloadInfo*) item{
    for (FileDownloadInfo* info in itemsSelected) {
        if ([info.videoDownload.video_id isEqualToString:item.videoDownload.video_id] && [info.videoDownload.type_quality isEqualToString:item.videoDownload.type_quality]) {
            if (itemsSelected.count == self.dataSources.count) {
                [myNavi.leftBtn setTitle:@"Chọn tất cả" forState:UIControlStateNormal];
                myNavi.leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
                [myNavi.leftBtn setSelected:NO];
            }
            [itemsSelected removeObject:info];
            break;
        }
    }
}

- (void) removeItems{
    if (itemsSelected.count == 0) {
        
    }else{
        if (!confirmView) {
            confirmView = [[ConfirmAlertView alloc] initWithNibName:@"ConfirmAlertView" bundle:nil];
        }
        [confirmView setDelegate:self];
        [confirmView.view setFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
        [self.navigationController.view addSubview:confirmView.view];
    }
}

- (void) cancel{
    if ([self.navigationController.view.subviews containsObject:confirmView.view]) {
        [confirmView.view removeFromSuperview];
    }
}

- (void) remove{
    [self cancel];
    [self.dataSources removeObjectsInArray:itemsSelected];
    for (FileDownloadInfo* info in itemsSelected) {
        [[DBHelper sharedInstance] deleteFileDownloaded:info.videoDownload.video_id withQuality:info.quality];
    }
    [itemsSelected removeAllObjects];
    [self.tbMain reloadData];
    [self updateNumsOfItems];
    
    if (self.dataSources.count == 0) {
        [myNavi.rightBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        [self showNoDataView:YES];
    }
    [self updateDiskSpace];
    [[NSNotificationCenter defaultCenter]postNotificationName:kDidDeleteVideoDownloaded object:nil];

}

- (IBAction) doShowDownloading:(id)sender{
    if (!downloadingVC) {
        downloadingVC = [[DownloadingController alloc] initWithNibName:@"DownloadingController" bundle:nil];
    }
//    [downloadingVC setDataSources:[NSMutableArray arrayWithArray:arrayDownloading]];
    [self.navigationController pushViewController:downloadingVC animated:YES];
}

- (void)updateDiskSpace{
    lbDiskSpace.text = [Util getDiskSpaceInfo];
}

#pragma mark - download manager delegate

-(void)downloadManager:(DownloadManager *)downloadManager finishedDownload:(FileDownloadInfo *)downloadInfo{
    [lbSize setText:[Util getRatioWithBytesWritten:downloadInfo.totalBytesWritten BytesExpectedToWrite:downloadInfo.totalBytesExpectedToWrite]];
    [self loadData];
}

-(void)downloadManager:(DownloadManager *)downloadManager startedDownload:(FileDownloadInfo *)downloadInfo{
    [self loadData];
}

-(void)downloadManager:(DownloadManager *)downloadManager updateDownload:(FileDownloadInfo *)downloadInfo{
    NSLog(@"update at downloadcontroller");
    if (!downloadInfoCurrent || (downloadInfoCurrent && downloadInfoCurrent.taskIdentifier != downloadInfo.taskIdentifier)) {
        downloadInfoCurrent = downloadInfo;
        [lbTitle setText:downloadInfo.videoDownload.video_subtitle];
        [downloadInfo setDownloadProgress:downloadInfo.downloadProgress];
    }
    [lbSize setText:[Util getRatioWithBytesWritten:downloadInfo.totalBytesWritten BytesExpectedToWrite:downloadInfo.totalBytesExpectedToWrite]];
    [processView setProgress:downloadInfo.downloadProgress];
}
-(void)downloadManager:(DownloadManager *)downloadManager cancelDownload:(FileDownloadInfo *)downloadInfo{
    NSLog(@"cancel download");
}

-(void)downloadManager:(DownloadManager *)downloadManager failedDownload:(FileDownloadInfo *)downloadInfo{
    NSLog(@"download fail :%ld", downloadInfo.taskIdentifier);
}


@end
