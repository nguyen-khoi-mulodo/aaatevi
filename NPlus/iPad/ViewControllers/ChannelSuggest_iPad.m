//
//  ArtistHotVC.m
//  NPlus
//
//  Created by Vo Chuong Thien on 1/19/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "ChannelSuggest_iPad.h"
#import "ChannelSuggestItemCell.h"

#define pSize 10

@interface ChannelSuggest_iPad ()
@end

@implementation ChannelSuggest_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataView = myTableView;
    [lbTitleChannel setFont:[UIFont fontWithName:kFontSemibold size:17.0f]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Load Data

- (void) loadData{
    [self loadDataWithChannel:self.mChannel];
}

- (void) loadDataWithChannel:(Channel*) channel{
    if (self.mChannel.channelId != channel.channelId) {
        self.mChannel = channel;
        self.curPage = kFirstPage;
        [myTableView setContentOffset:CGPointZero animated:NO];
    }
    
    if (self.dataSources.count == 0) {
        [self showConnectionErrorView:NO];
        [self showNoDataView:NO];
        [self showLoadingDataView:YES];
    }
    
    [[APIController sharedInstance] getChannelSuggestionWithKey:channel.channelId pageIndex:(int)self.curPage pageSize:pSize completed:^(int code ,NSArray *results, BOOL loadmore, int total) {
        if (results) {
            self.isLoadMore = loadmore;
            if (self.curPage == kFirstPage) {
                [self.dataSources removeAllObjects];
                [self.dataSources addObjectsFromArray:results];
                if (self.dataSources.count == 0) {
                    [self showNoDataView:YES];
                }
            }else{
                [self.dataSources addObjectsFromArray:results];
            }
            [self finishLoadData];
            [self showLoadingDataView:NO];
        }else{ // data not exits
            [self.dataSources removeAllObjects];
            [self showLoadingDataView:NO];
            [self finishLoadData];
            [self showNoDataView:YES];
        }
    } failed:^(NSError *error) {
        if (self.dataSources.count == 0) {
            [self showLoadingDataView:NO];
            [self finishLoadData];
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

#pragma mark TableView Delegate

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
    return self.dataSources.count;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 218;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"channelSuggestItemCell";
    ChannelSuggestItemCell *cell = (ChannelSuggestItemCell *)[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChannelSuggestItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if (indexPath.row < self.dataSources.count) {
        Channel* channel = [self.dataSources objectAtIndex:indexPath.row];
        [cell setContentWithChannel:channel];
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    if (indexPath.row < self.dataSources.count) {
        Channel* channel = [self.dataSources objectAtIndex:indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(getChannnelDetailWithChannel:)]) {
            [self.delegate getChannnelDetailWithChannel:channel];
        }
    }
}

@end
