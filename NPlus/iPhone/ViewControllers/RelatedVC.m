//
//  RelatedVC.m
//  NPlus
//
//  Created by TEVI Team on 11/20/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "RelatedVC.h"
#import "APIController.h"
#import "AppRelatedCell.h"
#import "RelatedItem.h"
#import "TSMiniWebBrowser.h"
#import "MyNavigationItem.h"
@interface RelatedVC ()<UITableViewDataSource, UITableViewDelegate> {
    MyNavigationItem *myNaviItem;
}

@end

@implementation RelatedVC
- (NSString *)screenNameGA{
    return @"RelatedVC";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    myNaviItem = [[MyNavigationItem alloc]initWithController:self type:9];
    self.navigationController.navigationBarHidden = NO;
    tableViewController.refreshControl.hidden = YES;
    refreshControl.hidden = YES;
    refreshControl.tintColor = [UIColor clearColor];
    self.tbMain.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tbMain.separatorColor = UIColorFromRGB(0xf0f0f0);
    if (IS_IPAD) {
        [self.view setBackgroundColor:[UIColor clearColor]];
    }
    if (IS_IPAD) {
        [self.tbMain setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        self.tbMain.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        self.tbMain.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tbMain.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    self.dataView = self.tbMain;
    if (IS_IPAD) {
        [self.tbMain setBackgroundColor:[UIColor clearColor]];
        [self loadData];
    }
    
    [self loadDataIsAnimation:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    NSLayoutConstraint *constranitTopTable = [self.view.constraints objectAtIndex:6];
//    constranitTopTable.constant = 64;
    [self.view layoutIfNeeded];
    [self.view setNeedsLayout];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self trackScreen:@"iOS.ProfileRelate"];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)loadDataIsAnimation:(BOOL)isAnimation{
    if (APPDELEGATE.internetConnnected) {
        [[APIController sharedInstance] getAppRelatedCompleted:^(NSArray *results) {
            [self.dataSources removeAllObjects];
            [self.dataSources addObjectsFromArray:results];
            [self.tbMain reloadData];
            [self loadEmptyData];
        } failed:^(NSError *error) {
            
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"Ứng dụng liên quan";
    [self.tbMain registerNib:[UINib nibWithNibName:@"AppRelatedCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"appRelatedCellID"];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppRelatedCell *cell = (AppRelatedCell*)[tableView dequeueReusableCellWithIdentifier:@"appRelatedCellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RelatedItem *item = [self.dataSources objectAtIndex:indexPath.row];
    cell.lbTitle.text = item.appName;
    cell.lbDesc.text  = item.desc;
    [cell.imgItem setImageWithURL:[NSURL URLWithString:item.iconURL] placeholderImage:nil];
    if (!IS_IPAD) {
        cell.imgBackground.image = [self cellBackgroundForRowAtIndexPath:indexPath];
    }
    cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
    return cell;
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:self.tbMain numberOfRowsInSection:indexPath.section];
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
    RelatedItem *item = [self.dataSources objectAtIndex:indexPath.row];
    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:item.linkDown]];
    webBrowser.showReloadButton = YES;
    webBrowser.showActionButton = YES;
    webBrowser.mode = TSMiniWebBrowserModeModal;
    webBrowser.barStyle = UIBarStyleDefault;
    webBrowser.modalDismissButtonTitle = @"";
    [self presentViewController:webBrowser animated:YES completion:^{
        if (webBrowser) {
            [webBrowser didShow];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
