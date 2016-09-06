//
//  ListHistoryController.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/29/16.
//  Copyright © 2016 anhld. All rights reserved.
//

#import "ListHistoryController.h"
#import "ItemCell.h"
#import "UIViewController+AKTabBarController.h"
#import "AKTabBarController.h"
#import "DBHelper.h"

@interface ListHistoryController () {
    MyNavigationItem *myNavi;
    BOOL isEditMode;
    UIButton *btnDelete;
    CGRect btnDeleteFrame;
    NSMutableArray *arrayVideoHistory;
}

@end

@implementation ListHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    myNavi = [[MyNavigationItem alloc] initWithController:self type:8];
    myNavi.delegate = self;
    self.tbMain.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tbMain.separatorColor = UIColorFromRGB(0xf0f0f0);
    [self.tbMain setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    [self.tbMain registerNib:[UINib nibWithNibName:@"ItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"itemCellIdef"];
    isEditMode = NO;
    itemsSelected = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateHistories) name:kReloadHistoryNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Lịch sử";
    [self trackScreen:@"iOS.ProfileHistory"];
    self.navigationController.navigationBarHidden = NO;
    APPDELEGATE.rootNavController.navigationBarHidden = YES;
    [self showNoDataView:(self.dataSources.count == 0)];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateHistories];
}

- (void)updateHistories {
    self.dataSources = (NSMutableArray*)[[DBHelper sharedInstance]getVideoHistory];
    NSMutableArray *arrHisTemp = [self.dataSources mutableCopy];
    for (CDHistory *item in arrHisTemp) {
        if (!item.videoTitle || [item.videoTitle isEqualToString:@""] ) {
            [self.dataSources removeObject:item];
        }
    }
    [self.tbMain reloadData];
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
    if (indexPath.row < self.dataSources.count) {
        CDHistory* item = [self.dataSources objectAtIndex:indexPath.row];
        if (item.videoId) {
            return 92;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *itemCellIdef = @"itemCellIdef";
    ItemCell *cell = (ItemCell*)[self.tbMain dequeueReusableCellWithIdentifier:itemCellIdef];
    if (!cell) {
        cell = [Utilities loadView:[ItemCell class] FromNib:@"ItemCell"];
    }
    
    if (indexPath.row < self.dataSources.count) {
        CDHistory* item = [self.dataSources objectAtIndex:indexPath.row];
        if (item.videoId) {
            [cell setContent:item];
        }
    }
    cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
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
//        NSLog(@"selected editing");
        if (self.dataSources.count > indexPath.row) {
            CDHistory* item = [self.dataSources objectAtIndex:indexPath.row];
            if (![itemsSelected containsObject:item]) {
                [itemsSelected addObject:item];
            }
            [self updateNumsOfItems];
        }
    } else {
        if (self.dataSources.count > indexPath.row) {
            CDHistory* item = [self.dataSources objectAtIndex:indexPath.row];
            Video *_video = [[Video alloc]init];
            _video.video_id = item.videoId;
            _video.video_title = item.videoTitle;
            _video.video_subtitle = item.videoSubTitle;
            _video.video_image = item.videoImage;
            _video.time = item.time;
            _video.stream_url = item.quality;
            [APPDELEGATE didSelectVideoCellWith:_video];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
//        NSLog(@"deselected editing");
        if (self.dataSources.count > indexPath.row) {
            CDHistory* item = [self.dataSources objectAtIndex:indexPath.row];
            [self removeItem:item];
            [self updateNumsOfItems];
        }
    } else {
        
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
    if (type == 8) {
        isEditMode = !isEditMode;
        [self.tbMain setEditing:isEditMode animated:YES];
        [myNavi.rightBtn setImage: isEditMode ? [UIImage imageNamed:@""]:[UIImage imageNamed:@"icon-xoa-v2"] forState:UIControlStateNormal];
        [myNavi.leftBtn setImage: isEditMode ? [UIImage imageNamed:@""]:[UIImage imageNamed:@"icon-back-v2"] forState:UIControlStateNormal];
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
        [UIView animateWithDuration:0.3 animations:^{
            btnDelete.frame = isEditMode ? CGRectMake(0, SCREEN_SIZE.height - 50 - 64, SCREEN_SIZE.width, 50):btnDeleteFrame;
        } completion:^(BOOL finished) {
            if (!isEditMode) {
                btnDelete = nil;
                [itemsSelected removeAllObjects];
            }
        }];
    }
    
    
}

- (void)didLeftButtonTap{
    myNavi.leftBtn.selected = !myNavi.leftBtn.selected;
    if (myNavi.leftBtn.selected) {
        [myNavi.leftBtn setTitle:@"Bỏ chọn" forState:UIControlStateNormal];
        myNavi.leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -32, 0, 0);
        for (CDHistory* his in self.dataSources) {
            if (![itemsSelected containsObject:his]) {
                [itemsSelected addObject:his];
            }
            
        }
    }else{
        [itemsSelected removeAllObjects];
        [myNavi.leftBtn setTitle:@"Chọn tất cả" forState:UIControlStateNormal];
        myNavi.leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
    }
    [self updateNumsOfItems];
    [self.tbMain reloadData];
}

- (void) updateNumsOfItems{
    [btnDelete setTitle:[NSString stringWithFormat:@"Xoá (%d)", (int)itemsSelected.count] forState:UIControlStateNormal];
    if (itemsSelected.count == self.dataSources.count) {
        [myNavi.leftBtn setTitle:@"Bỏ chọn" forState:UIControlStateNormal];
        myNavi.leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -32, 0, 0);
        [myNavi.leftBtn setSelected:YES];
    }
    
}

- (void) showNoDataView: (BOOL) show{
    [myNavi.rightBtn setHidden:show];
    [super showNoDataView:show];
}

- (void) removeItem:(CDHistory*) item{
    for (CDHistory* his in itemsSelected) {
        if ([his.videoId isEqualToString:item.videoId]) {
            if (itemsSelected.count == self.dataSources.count) {
                [myNavi.leftBtn setTitle:@"Chọn tất cả" forState:UIControlStateNormal];
                myNavi.leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
                [myNavi.leftBtn setSelected:NO];
            }
            [itemsSelected removeObject:his];
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
    if (self.dataSources.count == 0) {
        [[DBHelper sharedInstance] clearAllHistory];
    }else{
        for (CDHistory* his in itemsSelected) {
            [[DBHelper sharedInstance] removeHistory:his.videoId];
        }
    }
    [itemsSelected removeAllObjects];
    [self.tbMain reloadData];
    [self updateNumsOfItems];
    if (self.dataSources.count == 0) {
        [self autoBack];
    }
}

- (void) autoBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
