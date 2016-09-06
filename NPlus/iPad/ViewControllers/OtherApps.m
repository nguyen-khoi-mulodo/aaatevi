//
//  IntroVC.m
//  XoSo
//
//  Created by Vo Chuong Thien on 5/6/15.
//  Copyright (c) 2015 Khoi Nguyen Nguyen. All rights reserved.
//

#import "OtherApps.h"
#import "AppItemCell.h"
#import "RelatedItem.h"
#import "TSMiniWebBrowser.h"
#import "APIController.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "AppRelatedCell.h"

@interface OtherApps ()

@end

@implementation OtherApps

- (void)viewDidLoad {
    [super viewDidLoad];
    myTableView.tableFooterView = [[UIView alloc] init];
    self.dataView = myTableView;
    [self loadData];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setTitle:@"Ứng dụng khác"];
//    [self getAppsList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    if (self.dataSources.count == 0) {
        [self showConnectionErrorView:NO];
        [self showLoadingDataView:YES];
    }
    [[APIController sharedInstance] getAppRelatedCompleted:^(NSArray *results) {
        [self.dataSources removeAllObjects];
        [self.dataSources addObjectsFromArray:results];
        [self finishLoadData];
        [self showLoadingDataView:NO];
        
        if (self.dataSources.count == 0) {
            [self showNoDataView:YES];
        }
        
    } failed:^(NSError *error) {
        if (self.dataSources.count == 0) {
            [self showLoadingDataView:NO];
            if (APPDELEGATE.internetConnnected) {
                [self showNoDataView:YES];
                [self showConnectionErrorView:NO];
            }else{
                [self showNoDataView:NO];
                [self showConnectionErrorView:YES];
                
            }
        }
    }];
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

-(void)viewDidLayoutSubviews
{
    if ([myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    NSLog(@"%d", self.dataSources.count);
    return [self.dataSources count];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (IS_IPAD) {
//        return 70;
//    }
    return 105;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"appRelatedCellID";
    AppRelatedCell *cell = (AppRelatedCell *)[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AppRelatedCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if (indexPath.row < self.dataSources.count) {
        RelatedItem *item = [self.dataSources objectAtIndex:indexPath.row];
        [cell setContentWithAppItem:item];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSources.count > indexPath.row) {
        RelatedItem* item = [self.dataSources objectAtIndex:indexPath.row];
        [self showWebViewWithURL:item.linkDown];
    }
}

- (void) showWebViewWithURL:(NSString*) url{
    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:url]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
