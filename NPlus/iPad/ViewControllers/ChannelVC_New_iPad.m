//
//  ArtistVC_iPad.m
//  NPlus
//
//  Created by Vo Chuong Thien on 1/15/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "ChannelVC_New_iPad.h"

@interface ChannelVC_New_iPad ()

@end

@implementation ChannelVC_New_iPad

#define HEIGHT_SEASON_VIEW 380
#define COUNT_SEASON 3
#define HEIGHT_SEASON_ITEM 105

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // init UI
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self getChannnelDetailWithChannel:self.mChannel];
}




#pragma mark Init UI

- (void) initUI{
    [self showChannelDetail];
    [self showSeasonList];
}

- (void) showChannelDetail{
    if (!channelDetailVC) {
        channelDetailVC = [[ChannelDetail_iPad alloc] initWithNibName:@"ChannelDetail_iPad" bundle:nil];
        [channelDetailVC.view setFrame:CGRectMake(0, 0, channelDetailVC.view.frame.size.width, channelDetailVC.view.frame.size.height)];
        [channelDetailVC setDelegate:self];
        [self.view insertSubview:channelDetailVC.view belowSubview:self.btnClose];
    }
}

- (void) showSeasonList{
    if (!seasonListVC) {
        seasonListVC = [[SeasonsOfChannelVC alloc] initWithNibName:@"SeasonsOfChannelVC" bundle:nil];
        [seasonListVC.view setFrame:CGRectMake(channelDetailVC.view.frame.size.width, 0, seasonListVC.view.frame.size.width, HEIGHT_SEASON_VIEW)];
        [seasonListVC setDelegate:self];
        [self.view addSubview:seasonListVC.view];
    }
}

- (void) showChannelSuggest{
    if (!channelSuggestVC) {
        channelSuggestVC = [[ChannelSuggest_iPad alloc] initWithNibName:@"ChannelSuggest_iPad" bundle:nil];
        [self.view addSubview:channelSuggestVC.view];
    }
    if (self.mChannel.seasons.count >= COUNT_SEASON) {
        [seasonListVC.view setFrame:CGRectMake(seasonListVC.view.frame.origin.x, 0, seasonListVC.view.frame.size.width, HEIGHT_SEASON_VIEW)];
    }else{
        [seasonListVC.view setFrame:CGRectMake(seasonListVC.view.frame.origin.x, 0, seasonListVC.view.frame.size.width, HEIGHT_SEASON_VIEW - (COUNT_SEASON - self.mChannel.seasons.count) * HEIGHT_SEASON_ITEM)];
    }
    [channelSuggestVC.view setFrame:CGRectMake(channelDetailVC.view.frame.size.width, seasonListVC.view.frame.size.height, channelSuggestVC.view.frame.size.width, SCREEN_HEIGHT - seasonListVC.view.frame.size.height)];
    [channelSuggestVC setDelegate:self];
}



#pragma mark Load Data

- (void) loadDataWithChannel:(Channel*) channel{
    self.mChannel = channel;
//    [channelDetailVC loadDataWithChannel:channel];
    [self showChannelSuggest];
    [channelDetailVC loadDataWithChannel:self.mChannel];
//    [seasonListVC loadDataWithChannel:self.mChannel];
//    [channelSuggestVC loadDataWithChannel:self.mChannel];
}

- (void) getChannnelDetailWithChannel{
    [[APIController sharedInstance] getChannelDetailWithKey:self.mChannel.channelId completed:^(int code, Channel* channelFull) {
        self.mChannel = channelFull;
        [self showChannelSuggest];
        [channelDetailVC loadDataWithChannel:self.mChannel];
        [seasonListVC loadDataWithChannel:self.mChannel];
        [channelSuggestVC loadDataWithChannel:self.mChannel];
    } failed:^(NSError *error) {
        NSLog(@"fail");
    }];
}

- (void) getChannnelDetailWithChannel:(Channel*) channel{
    self.mChannel = channel;
    [self getChannnelDetailWithChannel];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction) doClose:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(animationShowView:isShow:isAnimation:)]) {
        [self.delegate animationShowView:self.view isShow:NO isAnimation:YES];
    }
}

- (void) playVideoDefaultOfChannel{
    if (self.mChannel.seasons.count > 0) {
        Season* season = [self.mChannel.seasons objectAtIndex:0];
        season.channel = self.mChannel;
        [self showVideo:season];
    }
}


@end
