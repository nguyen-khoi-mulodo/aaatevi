//
//  ArtistHotVC.m
//  NPlus
//
//  Created by Vo Chuong Thien on 1/19/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "SeasonSuggestVC_iPad.h"
#import "DBHelper.h"
#import "SeasonItemCell.h"

#define pSize 10

@interface SeasonSuggestVC_iPad ()
@end

@implementation SeasonSuggestVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataView = myTableView;
    [self.lbTitle setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [self initUIChannelInfo];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initUIChannelInfo{
    // channel info view
    [lbChannelTitle setFont:[UIFont fontWithName:kFontRegular size:16.0f]];
    [lbChannelFollow setFont:[UIFont fontWithName:kFontRegular size:13.0f]];
    
    [channelThump.layer setCornerRadius:channelThump.frame.size.width/2];
    [channelThump setClipsToBounds:YES];
    
    [btnFollow.layer setCornerRadius:5.0f];
    [btnFollow.layer setBorderWidth:1.0f];
    
    [btnFollow.titleLabel setFont:[UIFont fontWithName:kFontRegular size:16.0f]];
    [btnFollow.layer setBorderColor:[UIColorFromRGB(0x00adef) CGColor]];
    [btnFollow.titleLabel setTextColor:UIColorFromRGB(0x00adef)];
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
    [self loadDataWithVideo:self.mVideo];
}

- (void) loadDataWithVideo:(Video*) video{
    self.mChannel = [video.channels objectAtIndex:0];
    [self loadChannelInfo];
    [[APIController sharedInstance] getChannelDetailWithKey:self.mChannel.channelId completed:^(int code, Channel* channelFull) {
        self.mChannel = channelFull;
        [self loadChannelInfo];
        self.dataSources = [NSMutableArray arrayWithArray:self.mChannel.seasons];
        [myTableView reloadData];
    } failed:^(NSError *error) {
        NSLog(@"fail");
    }];
//    self.mSeason = nil;
//    self.mFileInfo = nil;
//    if (self.mVideo.video_id != video.video_id) {
//        self.mVideo = video;
//        self.curPage = kFirstPage;
//        [myTableView setContentOffset:CGPointZero animated:NO];
//    }
//    
//    if (self.dataSources.count == 0) {
//        [self showConnectionErrorView:NO];
//        [self showNoDataView:NO];
//        [self showLoadingDataView:YES];
//    }
//    
//    [[APIController sharedInstance] getVideoSuggestionWithKey:video.video_id pageIndex:self.curPage pageSize:pSize completed:^(int code ,NSArray *results, BOOL loadmore, int total) {
//        if (results) {
//            self.isLoadMore = loadmore;
//            if (self.curPage == kFirstPage) {
//                [myTableView setContentOffset:CGPointZero animated:NO];
//                [self.dataSources removeAllObjects];
//                [self.dataSources addObjectsFromArray:results];
//                if (self.dataSources.count == 0) {
//                    [self showNoDataView:YES];
//                }
//            }else{
//                [self.dataSources addObjectsFromArray:results];
//            }
//            [self finishLoadData];
//            [self showLoadingDataView:NO];
//        }else{ // data not exits
//            [self.dataSources removeAllObjects];
//            [self showLoadingDataView:NO];
//            [self finishLoadData];
//            [self showNoDataView:YES];
//        }
//    } failed:^(NSError *error) {
//        if (self.dataSources.count == 0) {
//            [self showLoadingDataView:NO];
//            [self finishLoadData];
//            if (APPDELEGATE.internetConnnected) {
//                [self showNoDataView:YES];
//                [self showConnectionErrorView:NO];
//            }else{
//                [self showNoDataView:NO];
//                [self showConnectionErrorView:YES];
//            }
//        }
//    }];
}

- (void) loadChannelInfo{
    [channelThump setImageWithURL:[NSURL URLWithString:self.mChannel.fullImg] placeholderImage:[UIImage imageNamed:@"default-video-kenh-ipad"]];
    [lbChannelTitle setText:self.mChannel.channelName];
    [lbChannelFollow setText:[NSString stringWithFormat:@"%ld lượt theo dõi", self.mChannel.totalFollow]];
    
    if (self.mChannel.isSubcribe) {
        [btnFollow.layer setBorderColor:[[UIColor redColor] CGColor]];
        [btnFollow setTitle:@"Đã theo dõi" forState:UIControlStateNormal];
        [btnFollow.titleLabel setTextColor:[UIColor redColor]];
    }else{
        [btnFollow.layer setBorderColor:[UIColorFromRGB(0x00adef) CGColor]];
        [btnFollow setTitle:@"Theo dõi" forState:UIControlStateNormal];
        [btnFollow.titleLabel setTextColor:UIColorFromRGB(0x00adef)];
    }
}

- (IBAction) showChannelDetail:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadChannelDetailWithChannel:isAnimation:)]) {
        [self.delegate loadChannelDetailWithChannel:self.mChannel isAnimation:YES];
    }
}

//- (void) loadDataWithSeason:(Season*) season{
//    if (self.mSeason && [self.mSeason.seasonId isEqualToString:season.seasonId]) {
//        return;
//    }
//    self.mVideo = nil;
//    self.mFileInfo = nil;
//    self.mSeason = season;
//    self.isLoadMore = NO;
//    [myTableView setContentOffset:CGPointZero animated:NO];
//    [self.dataSources removeAllObjects];
//    [self.dataSources addObjectsFromArray:self.mSeason.videos];
//    if (self.dataSources.count == 0) {
//        [self showNoDataView:YES];
//        [self showConnectionErrorView:NO];
//    }else{
//        [self finishLoadData];
//        [self showLoadingDataView:NO];
//    }
//}
//
//- (void) loadDataWithFileInfo:(FileDownloadInfo*) fileInfo{
//    if (self.mFileInfo && [self.mFileInfo.videoDownload.video_id isEqualToString:fileInfo.videoDownload.video_id]) {
//        return;
//    }
//    self.mVideo = nil;
//    self.mSeason = nil;
//    self.mFileInfo = fileInfo;
//    self.isLoadMore = NO;
//    [myTableView setContentOffset:CGPointZero animated:NO];
//    [self.dataSources removeAllObjects];
//    [self.dataSources addObjectsFromArray:[[DBHelper sharedInstance] getAllVideoDownloaded]];
//    if (self.dataSources.count == 0) {
//        [self showNoDataView:YES];
//        [self showConnectionErrorView:NO];
//    }else{
//        [self finishLoadData];
//        [self showLoadingDataView:NO];
//    }
//}


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
    return 120;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"seasonItemCell";
    SeasonItemCell *cell = (SeasonItemCell *)[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SeasonItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (indexPath.row < self.dataSources.count) {
        id item = [self.dataSources objectAtIndex:indexPath.row];
        if ([item isKindOfClass:[Season class]]) {
            Season* season = (Season*) item;
            [cell setContentWithSeason:season];
        }
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    if (indexPath.row < self.dataSources.count) {
        id item = [self.dataSources objectAtIndex:indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(loadVideoPlayerWithItem:withIndex:fromRootView:)]) {
            [self.delegate loadVideoPlayerWithItem:item withIndex:(int)indexPath.row fromRootView:NO];
        }
    }
}

@end
