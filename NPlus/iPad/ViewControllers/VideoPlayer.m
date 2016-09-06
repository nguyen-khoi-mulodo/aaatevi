//
//  VideoPlayer.m
//  NPlus
//
//  Created by Vo Chuong Thien on 11/3/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "VideoPlayer.h"
#import "APIController.h"
#import "Video.h"
#import "DBHelper.h"
#import "DownloadManager.h"
#import "ParserObject.h"
#import "ShareTask.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ArtistSuggestItemCell.h"
#import "Artist.h"
#import "QualityURL.h"
#import "ShareTask.h"
#import "ChannelVC_New_iPad.h"

@interface VideoPlayer ()

@end

@implementation VideoPlayer
@synthesize listVideos;

#define PADDING_RIGHT 12
#define PADDING_BOTTOM 72

#define SMALL_WIDTH 260
#define SMALL_HEIGHT 146

#define SWIPE_UP_THRESHOLD -1000.0f
#define SWIPE_DOWN_THRESHOLD 1000.0f
#define SWIPE_LEFT_THRESHOLD -1000.0f
#define SWIPE_RIGHT_THRESHOLD 1000.0f

#define SHOW_DETAIL 0
#define SHOW_DOWNLOAD 2
#define SHOW_LIST 1

#define SHOW_TUTORIAL @"SHOW_TUTORIAL"

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!self.player) {
        self.player = [[PlayerViewController alloc] init];
        [self.player setDelegate:self];
    }
    [videoView addSubview:self.player.view];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    tapGesture.delegate = self;
    [videoView addGestureRecognizer:tapGesture];
    
//    UITapGestureRecognizer *tap2Gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskHandleTap:)];
//    tapGesture.delegate = self;
//    [maskView addGestureRecognizer:tap2Gesture];
    
//    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
//    [panGesture setMaximumNumberOfTouches:2];
//    [videoView addGestureRecognizer:panGesture];
    
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
    [panGesture setMaximumNumberOfTouches:2];
    [videoView addGestureRecognizer:panGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:kDidLogoutNotification object:nil];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setScreenName:@"iPad.VideoDetail"];
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

- (void) doMinimized
{
    if ([self mpIsFullScreen]) {
        [videoView addGestureRecognizer:panGesture];
        [self cancelTimerHideMenu:YES];
    }
    [self.player changeVideoFullModeWithMinimizedScreen:YES];
    [self minimizeMp:YES animated:YES];
}

- (void) doXemSau{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showLoginWithTask:withVC:)]) {
        [self.delegate showLoginWithTask:kTaskViewLater withVC:self];
    }
}

- (void) doShare{
    // share
    if (!actionVC) {
        actionVC = [[ActionVC alloc] initWithNibName:@"ActionVC" bundle:nil];
    }
    [actionVC setDelegate:self];
    [actionVC loadDataWithType:share_type];
//    [actionVC.view setFrame:CGRectMake(0, 0, 165, 40 * actionVC.arrTitles.count)];
    actionPopover = [[UIPopoverController alloc] initWithContentViewController:actionVC];
    [actionPopover setPopoverContentSize:CGSizeMake(134, 40 * actionVC.arrTitles.count)];
    [actionPopover presentPopoverFromRect:btnShare.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [self cancelTimerHideMenu:YES];
}

- (void) shareFacebook{
    [self dismissPopover];
    if ([self.mVideo.link_share isEqualToString:@""]) {
        [APPDELEGATE showToastWithMessage:@"Hiện chưa có link chia sẻ cho video này." position:@"bottom" type:errorImage];
    }else{
        [[ShareTask sharedInstance] setViewController:self];
        [[ShareTask sharedInstance] shareFacebook:self.mVideo];
    }
}

- (void) copyLink{
    [self dismissPopover];
    NSString *dataText = self.mVideo.link_share;
    [[UIPasteboard generalPasteboard] setString:dataText];
   [APPDELEGATE showToastWithMessage:@"Đã copy link." position:@"bottom" type:doneImage];
}

- (void) doDownload{
    if (self.mVideo.videoStream.streamDownloads.count > 1) {
        if (!actionVC) {
            actionVC = [[ActionVC alloc] initWithNibName:@"ActionVC" bundle:nil];
        }
        [actionVC setDelegate:self];
        [actionVC loadDataWithArray:self.mVideo.videoStream.streamDownloads andType:action_download_type];
        actionPopover = [[UIPopoverController alloc] initWithContentViewController:actionVC];
        [actionPopover setPopoverContentSize:CGSizeMake(64, 40 * actionVC.arrTitles.count)];
        [actionPopover presentPopoverFromRect:btnDownload.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        [self cancelTimerHideMenu:YES];
    }else{
        QualityURL* quality = [self.mVideo.videoStream.streamDownloads firstObject];
        self.mQualityDownload = quality;
        [self downloadCurrentVideoWithQuality:quality];
    }
}

- (void) doViewQuality{
    if (self.mVideo.videoStream.streamDownloads.count > 1) {
        if (!actionVC) {
            actionVC = [[ActionVC alloc] initWithNibName:@"ActionVC" bundle:nil];
        }
        [actionVC setDelegate:self];
        [actionVC loadDataWithArray:self.mVideo.videoStream.streamUrls andType:action_quality_type];
        actionVC.mQuality = self.mQuality;
        actionPopover = [[UIPopoverController alloc] initWithContentViewController:actionVC];
        [actionPopover setPopoverContentSize:CGSizeMake(64, 40 * actionVC.arrTitles.count)];
        [actionPopover presentPopoverFromRect:btnQuality.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        [self cancelTimerHideMenu:YES];
    }
}

- (void) doChooseQuality:(QualityURL*) quality{
    if ([quality.type isEqualToString:self.mQuality.type]) {
        return;
    }
    [self dismissPopover];
    self.mVideo.stream_url = quality.link;
    self.mQuality = quality;
    [self.player setQualityWithType:quality.type withLink:quality.link];
    
}

- (void) downloadWithQuantity:(QualityURL*) quality{
    [self dismissPopover];
    self.mQualityDownload = quality;
    [self downloadCurrentVideoWithQuality:quality];
}

- (void) dismissPopover{
    [actionPopover dismissPopoverAnimated:YES];
    if (showMenu) {
        [self cancelTimerHideMenu:NO];
    }
}

-(void)loginSuccessWithTask:(NSString *)task{
    if ([task isEqualToString:kTaskViewLater]) {
        [[APIController sharedInstance] userSubcribeVideo:self.mVideo.video_id subcribe:!self.mVideo.is_like completed:^(int code, BOOL status){
            if (status) {
                self.mVideo.is_like = !self.mVideo.is_like;
                if (self.mVideo.is_like) {
                    [APPDELEGATE showToastWithMessage:@"Bạn đã thêm video vào danh sách xem sau!" position:@"bottom" type:doneImage];
                }else{
                    [APPDELEGATE showToastWithMessage:@"Bạn đã bỏ video khỏi danh sách xem sau!" position:@"bottom" type:doneImage];
                    
                }
                [self.player showXemSauStatus:self.mVideo.is_like];
            }else{
                if (!self.mVideo.is_like) {
                    [APPDELEGATE showToastWithMessage:@"Bạn thêm video vào danh sách xem sau chưa thành công!" position:@"bottom" type:errorImage];
                }else{
                    [APPDELEGATE showToastWithMessage:@"Bạn bỏ video khỏi danh sách xem sau chưa thành công!" position:@"bottom" type:errorImage];
                }
            }
        } failed:^(NSError *error) {
            NSLog(@"fail");
        }];
    }
}

- (void) logout{
    self.mVideo.is_like = NO;
    [self.player showXemSauStatus:NO];
}

- (void) actionFollow{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showLoginWithTask:andObject:)]) {
        [self.delegate showLoginWithTask:kTaskLogin andObject:nil];
    }
}

- (void) actionRate{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showRatingView)]) {
        [self.delegate showRatingView];
    }
}

- (IBAction) rightMenuAction:(id)sender{
//    UIButton* btn = sender;
    if ([self mpIsFullScreen]) {
        BOOL showed = [self checkInfomationShowed];
        [self showListView:!showed withAnimation:YES];
    }
}

- (void) showListView:(BOOL) isShow withAnimation:(BOOL) animation{
    if (![self.view.subviews containsObject:infoVideoContainer]) {
        [self.view addSubview:infoVideoContainer];
    }
    if (isShow) {
        [infoVideoContainer setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
    }
    [self cancelTimerHideMenu:isShow];
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            if (isShow) {
                [infoVideoContainer setFrame:CGRectMake(SCREEN_WIDTH - infoVideoContainer.frame.size.width, infoVideoContainer.frame.origin.y, infoVideoContainer.frame.size.width, infoVideoContainer.frame.size.height)];
                [rightMenuView setFrame:CGRectMake(infoVideoContainer.frame.origin.x - rightMenuView.frame.size.width, rightMenuView.frame.origin.y, rightMenuView.frame.size.width, rightMenuView.frame.size.height)];
            }else{
                [infoVideoContainer setFrame:CGRectMake(SCREEN_WIDTH, infoVideoContainer.frame.origin.y, infoVideoContainer.frame.size.width, infoVideoContainer.frame.size.height)];
                [rightMenuView setFrame:CGRectMake(infoVideoContainer.frame.origin.x - rightMenuView.frame.size.width, rightMenuView.frame.origin.y, rightMenuView.frame.size.width, rightMenuView.frame.size.height)];
                [infoVideoContainer setBackgroundColor:[UIColor clearColor]];
            }
            
        } completion:^(BOOL finished) {
            NSLog(@"%@", NSStringFromCGRect(infoVideoContainer.frame));
        }];
    }
}

- (BOOL) checkInfomationShowed{
    if (infoVideoContainer.frame.origin.x >= SCREEN_WIDTH) {
        return NO;
    }
    return YES;
}

- (void) showFullScreen{
    [self fullScreenMp:![self mpIsFullScreen] animated:YES];
}

- (void) showInfoDetailView{
    if ([self.type isEqualToString:SINGLE_TYPE] || [self.type isEqualToString:DETAIL_OFFLINE_TYPE] || [self.type isEqualToString:SEASON_TYPE]) {
        if (!infoDetailVC) {
            infoDetailVC = [[InfoDetailVC_iPad alloc] initWithNibName:@"InfoDetailVC_iPad" bundle:nil];
        }
        if ([relatedViewContainer.subviews containsObject:channelInfoDetailVC.view]) {
            [channelInfoDetailVC.view removeFromSuperview];
        }
        
        if (![relatedViewContainer.subviews containsObject:infoDetailVC.view]) {
            [relatedViewContainer addSubview:infoDetailVC.view];
        }
        [infoDetailVC setDelegate:self];
        if ([self.type isEqualToString:SINGLE_TYPE] || [self.type isEqualToString:SEASON_TYPE]) {
            [infoDetailVC loadDataWithVideo:self.mVideo];
        }else{
            [infoDetailVC loadDataWithFileInfo:self.mFileInfo];
        }
        
        // set title for player
        NSString* strTitle, *strSubTitle;
        if ([self.type isEqualToString:SINGLE_TYPE] || [self.type isEqualToString:SEASON_TYPE]) {
            strTitle = self.mVideo.video_subtitle;
            strSubTitle = self.mVideo.video_title;
        }else{
            Video* video = [self.mFileInfo videoDownload];
            strTitle = video.video_subtitle;
            strSubTitle = video.video_title;
        }
        [self setTitle:strTitle andSubTitle:strSubTitle];
    }
    
//    else if([self.type isEqualToString:SEASON_TYPE]){
//        if (!channelInfoDetailVC) {
//            channelInfoDetailVC = [[ChannelInfoDetailVC_iPad alloc] initWithNibName:@"ChannelInfoDetailVC_iPad" bundle:nil];
//        }
//        [channelInfoDetailVC setType:SEASON_TYPE];
//        if ([relatedViewContainer.subviews containsObject:infoDetailVC.view]) {
//            [infoDetailVC.view removeFromSuperview];
//        }
//        
//        if (![relatedViewContainer.subviews containsObject:channelInfoDetailVC.view]) {
//            [relatedViewContainer addSubview:channelInfoDetailVC.view];
//        }
//        [channelInfoDetailVC setDelegate:self];
//        [channelInfoDetailVC loadDataWithSeason:self.mSeason andVideo:self.mVideo];
//        
//        // set title for player
//        NSString* strTitle, *strSubTitle;
//        strTitle = self.mVideo.video_subtitle;
//        strSubTitle = self.mSeason.channel.channelName;
//        [self setTitle:strTitle andSubTitle:strSubTitle];
//    }
}


- (void) showPlaylistInfo{
    if (!seasonSuggestVC) {
        seasonSuggestVC = [[SeasonSuggestVC_iPad alloc] initWithNibName:@"SeasonSuggestVC_iPad" bundle:nil];
    }
    [seasonSuggestVC setDelegate:self];
    if (newChannelVC && [infoVideoContainer.subviews containsObject:newChannelVC.view]) {
        [newChannelVC.view removeFromSuperview];
    }
    
    if (![infoVideoContainer.subviews containsObject:seasonSuggestVC.view]) {
        [seasonSuggestVC.view setFrame:CGRectMake(0, 0, seasonSuggestVC.view.frame.size.width, seasonSuggestVC.view.frame.size.height)];
        [infoVideoContainer addSubview:seasonSuggestVC.view];
    }
    if ([self.type isEqualToString:SINGLE_TYPE] || [self.type isEqualToString:SEASON_TYPE]) {
        [seasonSuggestVC.lbTitle setText:@"Danh sách Playlist"];
        [seasonSuggestVC loadDataWithVideo:self.mVideo];
        if ([self.type isEqualToString:SEASON_TYPE]) {
            [self loadChannelDetailWithChannel:self.mSeason.channel isAnimation:NO];
        }
    }
//    else if([self.type isEqualToString:SEASON_TYPE]){
//        [seasonSuggestVC.lbTitle setText:self.mSeason.seasonName];
//        [seasonSuggestVC loadDataWithSeason:self.mSeason];
//    }
    else if([self.type isEqualToString:DETAIL_OFFLINE_TYPE]){
        [seasonSuggestVC.lbTitle setText:@"Video Đã tải"];
        [seasonSuggestVC loadDataWithFileInfo:self.mFileInfo];
    }
}

- (void) showVideoSuggest:(BOOL) isSuggest andList:(NSMutableArray*) list{
    if (!isSuggest) {
        if (!videoofSeasonVC) {
            videoofSeasonVC = [[VideoSuggestVC_iPad alloc] initWithNibName:@"VideoSuggestVC_iPad" bundle:nil];
        }
        if (![infoVideoContainer.subviews containsObject:videoofSeasonVC.view]) {
            [videoofSeasonVC.view setFrame:CGRectMake(videoofSeasonVC.view.frame.size.width, 0, videoofSeasonVC.view.frame.size.width, videoofSeasonVC.view.frame.size.height)];
            [infoVideoContainer addSubview:videoofSeasonVC.view];
        }
        [videoofSeasonVC setDelegate:self];
        [videoofSeasonVC.lbTitle setText:@"Video"];
        [videoofSeasonVC loadVideosOfSeason:list];
        float X = videoofSeasonVC.view.frame.origin.x;
        if (X == infoVideoContainer.frame.size.width) {
            [self animationShowView:videoofSeasonVC.view isShow:YES];
        }
    }else{
        if (!videoSuggestVC) {
            videoSuggestVC = [[VideoSuggestVC_iPad alloc] initWithNibName:@"VideoSuggestVC_iPad" bundle:nil];
        }
        if (![infoVideoContainer.subviews containsObject:videoSuggestVC.view]) {
            [videoSuggestVC.view setFrame:CGRectMake(videoSuggestVC.view.frame.size.width, 0, videoSuggestVC.view.frame.size.width, videoSuggestVC.view.frame.size.height)];
            [infoVideoContainer addSubview:videoSuggestVC.view];
        }
        [videoSuggestVC setDelegate:self];
        [videoSuggestVC.lbTitle setText:@"Video gợi ý"];
        [videoSuggestVC loadDataWithVideo:self.mVideo];
        float X = videoSuggestVC.view.frame.origin.x;
        if (X == infoVideoContainer.frame.size.width) {
            [self animationShowView:videoSuggestVC.view isShow:YES];
        }
    }
    
}

- (void) loadChannelDetailWithChannel:(Channel*) channel isAnimation:(BOOL) animation{
    if (!newChannelVC) {
        newChannelVC = [[ChannelVC_New_iPad alloc] initWithNibName:@"ChannelVC_New_iPad" bundle:nil];
    }
    [newChannelVC setDelegate:self];
    [newChannelVC loadDataWithChannel:channel];
    if (![infoVideoContainer.subviews containsObject:newChannelVC.view]) {
        [newChannelVC.view setFrame:CGRectMake(infoVideoContainer.frame.size.width, 0, newChannelVC.view.frame.size.width , newChannelVC.view.frame.size.height)];
        [infoVideoContainer addSubview:newChannelVC.view];
    }
    
    float X = newChannelVC.view.frame.origin.x;
    if (X == infoVideoContainer.frame.size.width) {
        [self animationShowView:newChannelVC.view isShow:YES isAnimation:animation];
    }
}

- (void) animationShowView:(UIView*) view isShow:(BOOL) isShow isAnimation:(BOOL) isAnimation{
    if (isAnimation) {
        [UIView animateWithDuration:0.5 animations:^{
            if (isShow) {
                [view setFrame:CGRectMake(view.frame.origin.x - view.frame.size.width, 0, view.frame.size.width, view.frame.size.height)];
            }else{
                [view setFrame:CGRectMake(view.frame.origin.x + view.frame.size.width, 0, view.frame.size.width, view.frame.size.height)];
            }
        } completion:^(BOOL finished) {
            if (!isShow) {
                [view removeFromSuperview];
            }
        }];
    }else{
        if (isShow) {
            [view setFrame:CGRectMake(view.frame.origin.x - view.frame.size.width, 0, view.frame.size.width, view.frame.size.height)];
        }else{
            [view setFrame:CGRectMake(view.frame.origin.x + view.frame.size.width, 0, view.frame.size.width, view.frame.size.height)];
            [view removeFromSuperview];
        }
    }
}

- (void) setTitle:(NSString*) title andSubTitle:(NSString*) subTitle{
    [self.player setTitle:title andSubTitle:subTitle];
}

- (void) createListEpisode:(int) numList{
    
    if (!self.listButtons) {
        self.listButtons = [[NSMutableArray alloc] init];
    }else{
        if (self.listButtons.count > 0) {
            [self.listButtons removeAllObjects];
        }
    }
    
    if (episodeScrollView.subviews.count > 0) {
        for (UIButton* btn in episodeScrollView.subviews) {
            
            [btn removeFromSuperview];
        }
    }
    
    int padding = 15;
    int dX = 15;
    int dY = 15;
    int col = 5;
    int width = 51,height = 40;
    int row = (int)numList / col;
    if (row * col < numList) {
        row ++;
    }
    
    int index = 1;
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < col; j++) {
            if (index <= numList) {
                UIButton* btn = [[UIButton alloc] init];
                [btn setFrame:CGRectMake(padding + (dX + width) * j, dY * (i + 1) + height * i, width, height)];
                [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
                [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
                
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                if (index == 1) {
                    [btn setSelected:YES];
                    [btn setBackgroundColor:[UIColor colorWithRed:19/255.0 green:155/255.0 blue:234/255.0 alpha:1.0f]];
                }else{
                    [btn setSelected:NO];
                    [btn setBackgroundColor:[UIColor colorWithRed:167/255.0 green:169/255.0 blue:171/255.0 alpha:1.0f]];
                }
                [btn setTitle:[NSString stringWithFormat:@"%d", index] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(doTouch:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTag:index - 1];
                [btn.layer setCornerRadius:4.0];
                [self.listButtons addObject:btn];
                index ++;
                [episodeScrollView addSubview:btn];
            }
            
        }
    }
//    [episodeScrollView setContentSize:CGSizeMake(episodeScrollView.frame.size.width, dY * (row + 1) + width * row)];
    [episodeScrollView setContentOffset:CGPointZero];
}

- (void) doTouch:(id) sender{
    UIButton* btnTouched = (UIButton*)sender;

    for (UIButton* btn in self.listButtons) {
        if (btn.tag != btnTouched.tag) {
            [btn setSelected:NO];
            [btn setBackgroundColor:[UIColor colorWithRed:167/255.0 green:169/255.0 blue:171/255.0 alpha:1.0f]];
        }else{
            [btn setSelected:YES];
            [btn setBackgroundColor:[UIColor colorWithRed:19/255.0 green:155/255.0 blue:234/255.0 alpha:1.0f]];
        }
    }
}

- (NSString*) getTitle{
//    if ([self.typeCurrent isEqualToString:SINGLE_TYPE]) {
//        return self.showCurrent.show_title;
//    }else if([self.typeCurrent isEqualToString:SEASON_TYPE]){
//        return self.seasonCurrent.season_title;
//    }else if([self.typeCurrent isEqualToString:DETAIL_TYPE]){
//        return self.videoCurrent.video_title;
//    }else if([self.typeCurrent isEqualToString:DETAIL_OFFLINE_TYPE]){
//        return self.showCurrent.show_title;
//    }
    return @"";
}

- (NSString*) getID{
//    if ([self.typeCurrent isEqualToString:SINGLE_TYPE]) {
//        return self.showCurrent.show_id;
//    }else if([self.typeCurrent isEqualToString:SEASON_TYPE]){
//        return self.seasonCurrent.season_id;
//    }else if([self.typeCurrent isEqualToString:DETAIL_TYPE]){
//        return self.videoCurrent.video_id;
//    }else if([self.typeCurrent isEqualToString:DETAIL_OFFLINE_TYPE])
//        return self.showCurrent.show_id;
    return @"";
}

- (id) getObject{
//    if ([self.typeCurrent isEqualToString:SINGLE_TYPE]) {
//        return self.showCurrent;
//    }else if([self.typeCurrent isEqualToString:DETAIL_TYPE]){
//        return self.videoCurrent;
//    }else if([self.typeCurrent isEqualToString:DETAIL_OFFLINE_TYPE]){
//        if (!self.showCurrent.jsonShow) {
//            return self.videoCurrent;
//        }else{
//            return self.showCurrent;
//        }
//    }else if([self.typeCurrent isEqualToString:SEASON_TYPE]){
//        if (self.showCurrent) {
//            return self.showCurrent;
//        }else{
//            return self.seasonCurrent;
//        }
//    }
    return nil;
}

- (void) tutorialHandleTap:(UITapGestureRecognizer*)recognizer{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    if (![userDef objectForKey:SHOW_TUTORIAL]) {
        [userDef setObject:@"NO" forKey:SHOW_TUTORIAL];
        [userDef synchronize];
    }
//    [self.tutorialImageView setHidden:YES];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    tapGesture.delegate = self;
    [videoView addGestureRecognizer:tapGesture];
    
//    UITapGestureRecognizer *tap2Gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskHandleTap:)];
//    tapGesture.delegate = self;
//    [maskView addGestureRecognizer:tap2Gesture];
    
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
    [panGesture setMaximumNumberOfTouches:2];
    [videoView addGestureRecognizer:panGesture];
}

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    if (![self mpIsMinimized]) {
        if (showMenu) {
            
            [self hideVideoMenu];
            [self cancelTimerHideMenu:YES];

        }else{
            [self showVideoMenu];
            [self cancelTimerHideMenu:NO];
        }
    }else{
        [self minimizeMp:NO animated:YES];
    }
}

//- (void) maskHandleTap: (UITapGestureRecognizer*) recognizer{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(hideLoginView)]) {
//        [maskView setHidden:YES];
//        [self.delegate hideLoginView];
//    }
//}

- (void)panHandle:(UIPanGestureRecognizer *)recognizer
{
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
    static CGPoint startPoint;
    CGPoint endPoint;
    static CGPoint viewPoint;
    CGPoint newOrigin;
    CGSize newSize;
    UIViewController* topview = [((UINavigationController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController]) topViewController];
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            startPoint = [recognizer locationInView:topview.view];
            BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
            direct_type = normal_direct;
            if (isVerticalGesture) {
                if (velocity.y > 0) {
                    if (![self mpIsMinimized]) {
                        direct_type = down_direct;
                    }
                } else {
                    if ([self mpIsMinimized]) {
                        direct_type = up_direct;
                    }
                }
            }
            
            else {
                if (velocity.x > 0) {
                    if ([self mpIsMinimized]) {
                        direct_type = right_direct;
                    }else{
                        direct_type = right_top_direct;
                    }
                } else {
                    if ([self mpIsMinimized]) {
                        direct_type = left_direct;
                    }
                }
            }
            
            if ([self mpIsMinimized]) {
                newOrigin = CGPointMake(SCREEN_WIDTH - SMALL_WIDTH - PADDING_RIGHT, SCREEN_HEIGHT - SMALL_HEIGHT - PADDING_BOTTOM);
                viewPoint = CGPointMake(SCREEN_WIDTH - SMALL_WIDTH - PADDING_RIGHT, SCREEN_HEIGHT - SMALL_HEIGHT - PADDING_BOTTOM);
            }else{
                newOrigin = CGPointZero;
                viewPoint = CGPointZero;
            }
            if (direct_type != normal_direct) {
                [rightMenuView setHidden:YES];
                [self.player.bottomPlayer setHidden:YES];
                [self.player.headerPlayer setHidden:YES];
                [self.player.centerPlayer setHidden:YES];
                [relatedViewContainer setUserInteractionEnabled:NO];
                if (direct_type == up_direct) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(showMaskVideoView:)]) {
                        [self.delegate showMaskVideoView:NO];
                    }
                }
            }
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (direct_type == down_direct || direct_type == up_direct || direct_type == right_top_direct) {
                endPoint   = [recognizer locationInView:topview.view];
                float gPointY = endPoint.y - startPoint.y;
                if (gPointY + viewPoint.y > 0 && gPointY + viewPoint.y < SCREEN_HEIGHT - SMALL_HEIGHT - PADDING_BOTTOM) {
                    newOrigin.y = gPointY + viewPoint.y;
                }else if(gPointY + viewPoint.y <= 0){
                    newOrigin.y = 0;
                }else{
                    newOrigin.y = SCREEN_HEIGHT - SMALL_HEIGHT - PADDING_BOTTOM;
                }
                
                float ratio = newOrigin.y * 1.0 / (SCREEN_HEIGHT - PADDING_BOTTOM);
                newOrigin.x = (SCREEN_WIDTH - PADDING_RIGHT) * ratio;
                if (newOrigin.x <= 0) {
                    newOrigin.x = 0;
                }else if(newOrigin.x >= SCREEN_WIDTH - SMALL_WIDTH - PADDING_RIGHT){
                    newOrigin.x = SCREEN_WIDTH - SMALL_WIDTH - PADDING_RIGHT;
                }
                newSize.width = (VIDEO_WIDTH * (1.0f - ratio) > SMALL_WIDTH) ? (VIDEO_WIDTH * (1.0f - ratio)) : SMALL_WIDTH;
                newSize.height = (VIDEO_HEIGHT * (1.0f - ratio) > SMALL_HEIGHT) ? (VIDEO_HEIGHT * (1.0f - ratio)) : SMALL_HEIGHT;
                
                [recognizer setTranslation:CGPointZero inView:topview.view];
                [self.view setFrame:CGRectMake(newOrigin.x, newOrigin.y, SCREEN_WIDTH, SCREEN_HEIGHT)];
                if (direct_type == up_direct) {
                    [videoView setFrame:CGRectMake(0, 0,  newSize.width , newSize.height)];
                }else{
                    [videoView setFrame:CGRectMake(0, 0,  newSize.width , newSize.height)];
                }
                [infoVideoContainer setFrame:CGRectMake(videoView.frame.origin.x + newSize.width, videoView.frame.origin.y, infoVideoContainer.frame.size.width, infoVideoContainer.frame.size.height)];
                [relatedViewContainer setFrame:CGRectMake(videoView.frame.origin.x, videoView.frame.origin.y + newSize.height, relatedViewContainer.frame.size.width, relatedViewContainer.frame.size.height)];
                [infoVideoContainer setAlpha:(1.0 - ratio) * 0.8];
                [relatedViewContainer setAlpha:(1.0 - ratio) * 0.8];
                [backgroundImage setAlpha:(1.0 - ratio) * 0.8];
                if (self.delegate && [self.delegate respondsToSelector:@selector(setAlphaMaskVideoView:)]) {
                    [self.delegate setAlphaMaskVideoView:(1.0 - ratio)];
                }
                [self.view setBackgroundColor:[UIColor clearColor]];
            }
            else if(direct_type == left_direct || direct_type == right_direct){
                endPoint   = [recognizer locationInView:topview.view];
                float gPointX = endPoint.x - startPoint.x;
                newOrigin.y = SCREEN_HEIGHT - SMALL_HEIGHT - PADDING_BOTTOM;
                
                if (gPointX + viewPoint.x < SCREEN_WIDTH - PADDING_RIGHT && gPointX + viewPoint.x > 0) {
                    newOrigin.x = gPointX + viewPoint.x;
                }else if(gPointX + viewPoint.x < 0){
                    newOrigin.x = 0;
                }else{
                    newOrigin.x = SCREEN_WIDTH - PADDING_RIGHT;
                }
                float ratio = newOrigin.x * 1.0 / (SCREEN_WIDTH - PADDING_RIGHT);
                newSize.width = SMALL_WIDTH;
                newSize.height = SMALL_HEIGHT;
                [recognizer setTranslation:CGPointZero inView:topview.view];
                [self.view setFrame:CGRectMake(newOrigin.x, newOrigin.y, SCREEN_WIDTH, SCREEN_HEIGHT)];
                [videoView setFrame:CGRectMake(0, 0,  newSize.width , newSize.height)];
                [infoVideoContainer setFrame:CGRectMake(videoView.frame.origin.x + videoView.frame.size.width, videoView.frame.origin.y, infoVideoContainer.frame.size.width, infoVideoContainer.frame.size.height)];
                [relatedViewContainer setFrame:CGRectMake(videoView.frame.origin.x, videoView.frame.origin.y + videoView.frame.size.height, relatedViewContainer.frame.size.width, relatedViewContainer.frame.size.height)];
                [infoVideoContainer setAlpha:0.0f];
                [relatedViewContainer setAlpha:0.0f];
                [backgroundImage setAlpha:0.0f];
                if (direct_type == left_direct) {
                    [videoView setAlpha:(ratio*1.5)];
                }else{
                    [videoView setAlpha:(1.0 - ratio*0.75)];
                }
                [self.view setBackgroundColor:[UIColor clearColor]];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint vel = [recognizer velocityInView:recognizer.view];
            
            if (vel.x < SWIPE_LEFT_THRESHOLD)
            {
                // TODO: Detected a swipe to the left
                //                NSLog(@"swipe left");
                if (direct_type == left_direct) {
                    //                    direct_type = left_direct;
                    [self dissmissVideoView:0.5];
                }
                else if(direct_type == up_direct || direct_type == down_direct){
                    [self minimizeMp:NO animated:YES];
                }
            }
            else if (vel.x > SWIPE_RIGHT_THRESHOLD)
            {
                //                NSLog(@"swipe right");
                if (![self mpIsMinimized]) {
                    [self minimizeMp:YES animated:YES];
                }else{
                    
                    //                    NSLog(@"close right: %d", direct_type);
                    //                    direct_type = right_direct;
                    //                    [self dissmissVideoView:0.5];
                }
                // TODO: Detected a swipe to the right
            }
            else if (vel.y < SWIPE_UP_THRESHOLD)
            {
                //                NSLog(@"swipe up");
                if (self.view.frame.origin.y != 0) {
                    //                    NSLog(@"swipe up");
                    [self minimizeMp:NO animated:YES];
                }
                // TODO: Detected a swipe up
            }
            else if (vel.y > SWIPE_DOWN_THRESHOLD)
            {
                //                NSLog(@"swipe down");
                if (![self mpIsMinimized]) {
                    //                    NSLog(@"swipe down");
                    [self minimizeMp:YES animated:YES];
                }
                // TODO: Detected a swipe down
            }
            else
            {
                endPoint   = [recognizer locationInView:topview.view];
                if (direct_type == up_direct || direct_type == down_direct || direct_type == right_top_direct) {
                    if (videoView.frame.size.width > VIDEO_HEIGHT) {
                        [self minimizeMp:NO animated:YES];
                    }else{
                        [self minimizeMp:YES animated:YES];
                    }
                }else{
                    [self prepareDismissVideoView:0.5];
                }
            }
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            endPoint   = [recognizer locationInView:topview.view];
            if (direct_type == up_direct || direct_type == down_direct) {
                if (videoView.frame.size.width > VIDEO_HEIGHT) {
                    [self minimizeMp:NO animated:YES];
                }else{
                    [self minimizeMp:YES animated:YES];
                }
            }else{
                [self prepareDismissVideoView:0.5];
            }
        }
            break;
        default:
            break;
    }
}

- (void) prepareDismissVideoView:(float) time{
    Direct_Type d_type = direct_type;
    if (d_type == left_direct) {
        if (self.view.frame.origin.x > SCREEN_WIDTH - SMALL_WIDTH) {
            d_type = right_direct;
        }
    }else if(d_type == right_direct){
        if (self.view.frame.origin.x < SCREEN_WIDTH - SMALL_WIDTH) {
            d_type = left_direct;
        }
    }
    if(d_type == left_direct){
        if (self.view.frame.origin.x + videoView.frame.size.width/2 > SCREEN_WIDTH/2) {
            [self minimizeMp:YES animated:YES];
        }else{
            [self dissmissVideoView:time];
            
        }
    }else if(d_type == right_direct){
        if (self.view.frame.origin.x < SCREEN_WIDTH - videoView.frame.size.width/2 - 20) {
            [self minimizeMp:YES animated:YES];
        }else{
            [self dissmissVideoView:time];
        }
    }
}

- (void) dissmissVideoView:(float) time{
//    [self myDealloc];
    Direct_Type d_type = direct_type;
    if (d_type == left_direct) {
        if (self.view.frame.origin.x > SCREEN_WIDTH - SMALL_WIDTH) {
            d_type = right_direct;
        }
    }else if(d_type == right_direct){
        if (self.view.frame.origin.x < SCREEN_WIDTH - SMALL_WIDTH) {
            d_type = left_direct;
        }
    }
    [self stopVideo];
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayerDismissing)]) {
        [self.delegate videoPlayerDismissing];
    }
    [UIView animateWithDuration:time
                     animations:^{
                         if (d_type == left_direct) {
                             [self.view setFrame:CGRectMake(-self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
                         }else if(d_type == right_direct){
                             [self.view setFrame:CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
                         }
                     }
                     completion:^(BOOL finished)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayerDismissed)]) {
             [self.delegate videoPlayerDismissed];
         }
         [videoView setAlpha:1.0];
         [videoView.layer setBorderColor:[UIColor clearColor].CGColor];
         [videoView.layer setBorderWidth:0.0f];
         [videoView setFrame:CGRectMake(0, 0, VIDEO_WIDTH, VIDEO_HEIGHT)];
         [infoVideoContainer setFrame:CGRectMake(videoView.frame.origin.x + videoView.frame.size.width, 0, infoVideoContainer.frame.size.width, infoVideoContainer.frame.size.height)];
         [infoVideoContainer setAlpha:1.0];
         [infoBG setAlpha:1.0f];
         [relatedViewContainer setFrame:CGRectMake(videoView.frame.origin.x, videoView.frame.origin.y + videoView.frame.size.height, relatedViewContainer.frame.size.width, relatedViewContainer.frame.size.height)];
         [relatedViewContainer setAlpha:1.0];
         [relatedViewContainer setUserInteractionEnabled:YES];
         [backgroundImage setAlpha:1.0f];
         [self.player changeVideoFullModeWithMinimizedScreen:[self mpIsMinimized]];
//         [self.view setBackgroundColor:[UIColor colorWithRed:21/255.0 green:30/255.0 blue:34/255.0 alpha:1.0f]];
         [self.view setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
         [self.view setFrame:CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT , SCREEN_WIDTH, SCREEN_HEIGHT)];
         [self.view removeFromSuperview];
     }
     ];
}

- (void) deleteVideoItemCurrent{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayerDismissed)]) {
        [self.delegate videoPlayerDismissed];
    }
}


- (BOOL) mpIsMinimized {
    return self.view.frame.origin.y == SCREEN_HEIGHT - SMALL_HEIGHT - PADDING_BOTTOM && self.view.frame.origin.x == SCREEN_WIDTH - SMALL_WIDTH - PADDING_RIGHT;
}

- (BOOL) mpIsFullScreen {
    return videoView.frame.size.width == SCREEN_WIDTH;
}

- (void)minimizeMp:(BOOL)minimized animated:(BOOL)animated {
    CGRect videoContainerFrame;
    CGFloat alpha;
    if (minimized) {
        CGFloat mpWidth = SMALL_WIDTH;
        CGFloat mpHeight = SMALL_HEIGHT; // 160:90 == 16:9
        CGFloat x = SCREEN_WIDTH - mpWidth - PADDING_RIGHT;
        CGFloat y = SCREEN_HEIGHT - mpHeight - PADDING_BOTTOM;
        videoContainerFrame = CGRectMake(x, y, mpWidth, mpHeight);
        alpha = 0.0;
    } else {
        videoContainerFrame = CGRectMake(0, 0, VIDEO_WIDTH, VIDEO_HEIGHT);
        alpha = 1.0;
    }
    if (minimized) {
        [self.player changeVideoFullModeWithMinimizedScreen:minimized];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(showMaskVideoView:)]) {
        [self.delegate showMaskVideoView:minimized];
    }
    NSTimeInterval duration = (animated)? 0.5 : 0.0;
    [UIView animateWithDuration:duration animations:^{
        if (minimized) {
            self.view.frame = CGRectMake(videoContainerFrame.origin.x, videoContainerFrame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT);
            videoView.frame = CGRectMake(0, 0, videoContainerFrame.size.width, videoContainerFrame.size.height);
        }else{
            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            videoView.frame = CGRectMake(videoContainerFrame.origin.x, videoContainerFrame.origin.y, videoContainerFrame.size.width, videoContainerFrame.size.height);
        }
        [videoView setAlpha:1.0f];
        [infoVideoContainer setFrame:CGRectMake(videoView.frame.origin.x + videoView.frame.size.width, videoView.frame.origin.y, infoVideoContainer.frame.size.width, infoVideoContainer.frame.size.height)];
        [relatedViewContainer setFrame:CGRectMake(videoView.frame.origin.x, videoView.frame.origin.y + videoView.frame.size.height, relatedViewContainer.frame.size.width, relatedViewContainer.frame.size.height)];
        [relatedViewContainer setAlpha:alpha];
        [infoVideoContainer setAlpha:alpha];
        [backgroundImage setAlpha:alpha];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(setAlphaMaskVideoView:)]) {
            [self.delegate setAlphaMaskVideoView:alpha];
        }
        if (!minimized) {
//            [self.view setBackgroundColor:[UIColor colorWithRed:21/255.0 green:30/255.0 blue:34/255.0 alpha:1.0f]];
            [self.view setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
            [videoView.layer setBorderColor:[UIColor clearColor].CGColor];
            [videoView.layer setBorderWidth:0.0f];
        }else{
            [self.view setBackgroundColor:[UIColor clearColor]];
//            [videoView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
//            [videoView.layer setBorderColor:[[UIColor clearColor] CGColor]];
            [videoView.layer setBorderColor:[[UIColor colorWithWhite:1.0 alpha:0.2] CGColor]];
            [videoView.layer setBorderWidth:1.0f];
        }
    } completion:^(BOOL finished) {
//        [btnRightCurrent setSelected:!minimized];
        [relatedViewContainer setUserInteractionEnabled:YES];
        if (self.delegate && [self.delegate respondsToSelector:@selector(showMaskVideoView:)]) {
            [self.delegate showMaskVideoView:minimized];
        }
        if (!minimized) {
            [self.player changeVideoFullModeWithMinimizedScreen:minimized];
        }
        [rightMenuView setFrame:CGRectMake(videoView.frame.origin.x + videoView.frame.size.width - rightMenuView.frame.size.width, (videoView.frame.origin.y + (videoView.frame.size.height - 60) / 2 - rightMenuView.frame.size.height/2), rightMenuView.frame.size.width, rightMenuView.frame.size.height)];
        [rightMenuView setHidden:YES];
        if (self.delegate && [self.delegate respondsToSelector:@selector(minimizedVideoPlayer:)]) {
            [self.delegate minimizedVideoPlayer:minimized];
        }
        
    }];
}

- (void)fullScreenMp:(BOOL) isFull animated:(BOOL)animated {
    
    if ([self mpIsFullScreen] == isFull) return;
    
    CGRect videoContainerFrame;
    CGRect relatedVideoContainerFrame;
    CGRect relatedVideoByArtistContainerFrame;
    float alpha;
    if (isFull) {
        CGFloat mpWidth = SCREEN_WIDTH;
        CGFloat mpHeight = SCREEN_HEIGHT; // 160:90 == 16:9
        videoContainerFrame = CGRectMake(0, 0, mpWidth, mpHeight);
        alpha = 0.0f;
    } else {
        videoContainerFrame = CGRectMake(0, 0, VIDEO_WIDTH, VIDEO_HEIGHT);
        alpha = 1.0f;
    }
    relatedVideoContainerFrame = CGRectMake(videoContainerFrame.origin.x
                                            + videoContainerFrame.size.width, videoContainerFrame.origin.y, infoVideoContainer.frame.size.width, infoVideoContainer.frame.size.height);
    relatedVideoByArtistContainerFrame = CGRectMake(videoContainerFrame.origin.x, videoContainerFrame.origin.y + videoContainerFrame.size.height, relatedViewContainer.frame.size.width, relatedViewContainer.frame.size.height);
    
    if (!isFull) {
        [rightMenuView setHidden:YES];
    }
    
    NSTimeInterval duration = (animated)? 0.5 : 0.0;
    [UIView animateWithDuration:duration animations:^{
        videoView.frame = videoContainerFrame;
        [self.player showPlayerMenuFull:isFull];
        [rightMenuView setFrame:CGRectMake(videoView.frame.origin.x + videoView.frame.size.width - rightMenuView.frame.size.width, (isFull) ? (videoView.frame.origin.y + videoView.frame.size.height/2 - rightMenuView.frame.size.height/2) : (videoView.frame.origin.y + (videoView.frame.size.height - 60) / 2 - rightMenuView.frame.size.height/2), rightMenuView.frame.size.width, rightMenuView.frame.size.height)];
        [infoVideoContainer setFrame:CGRectMake(videoView.frame.origin.x + videoView.frame.size.width, 0, infoVideoContainer.frame.size.width, infoVideoContainer.frame.size.height)];
        [relatedViewContainer setFrame:CGRectMake(videoView.frame.origin.x, videoView.frame.origin.y + videoView.frame.size.height, relatedViewContainer.frame.size.width, relatedViewContainer.frame.size.height)];
        [infoVideoContainer setAlpha:alpha];
        [relatedViewContainer setAlpha:alpha];
        [backgroundImage setAlpha:alpha];
    } completion:^(BOOL finished) {
        if (isFull) {
            [videoView removeGestureRecognizer:panGesture];
            [infoVideoContainer setAlpha:1.0f];
            [self.player showControlFull:isFull];
            [rightMenuView setHidden:NO];
        }else{
            [videoView addGestureRecognizer:panGesture];
        }
    }];
}

#pragma mark Show Video Detail

- (void) loadVideoPlayerWithItem:(id) item withIndex:(int) index fromRootView:(BOOL) fromRoot
{
    [rightMenuView setHidden:YES];
    if (!fromRoot) {
        [self showLoading:YES];
    }
    if ([item isKindOfClass:[Video class]]) {
        indexCurrent = index;
        Video* video = (Video*)item;
        Video *videoOffline = [[DBHelper sharedInstance] videoIsDownloaded:video.video_id withQuality:video.type_quality];
        if (videoOffline && APPDELEGATE.connectionType == kConnectionTypeNone) {
            self.mVideo = videoOffline;
            self.mVideo.stream_url = videoOffline.stream_url;
            [self playVideoWithURL];
        }else{
            [[APIController sharedInstance] getVideoDetailWithKey:video.video_id completed:^(int code, Video* videoFull) {
                if (videoOffline) {
                    self.mVideo = videoOffline;
                    self.mVideo.channels = videoFull.channels;
                    self.mVideo.viewCount = videoFull.viewCount;
                }else{
                    self.mVideo = videoFull;
                }
                [self.player showXemSauStatus:self.mVideo.is_like];
                [self getStreamAndPlay];
                [self showInfoDetailView];
                [self showPlaylistInfo];
            } failed:^(NSError *error) {
                NSLog(@"fail");
            }];
        }
        
        if ([self mpIsMinimized]) {
            [self minimizeMp:NO animated:YES];
        }
    }else if([item isKindOfClass:[Season class]]){
        Season* season = (Season*)item;
        Channel* channel = season.channel;
        [[APIController sharedInstance] getSeasonDetailWithKey:season.seasonId completed:^(int code, Season* seasonFull) {
            self.mSeason = seasonFull;
            self.mSeason.channel = channel;
            if (self.mSeason.videos.count > 0) {
                Video* video = [self.mSeason.videos objectAtIndex:0];
                playSeason = YES;
                [self loadVideoPlayerWithItem:video withIndex:0 fromRootView:NO];
            }
        } failed:^(NSError *error) {
            NSLog(@"fail");
        }];
    }else if([item isKindOfClass:[FileDownloadInfo class]]){
        indexCurrent = index;
        Video* videoOffline = [(FileDownloadInfo*)item videoDownload];
        self.mVideo = videoOffline;
        self.mFileInfo = (FileDownloadInfo*)item;
        self.mVideo.stream_url = videoOffline.stream_url;
        [self playVideoWithURL];
        [self showPlaylistInfo];
        [self showInfoDetailView];
        if ([self mpIsMinimized]) {
            [self minimizeMp:NO animated:YES];
        }
    }
    
}

-(void) getStreamAndPlay{
//    [self showLoading:YES];
    [[APIController sharedInstance] getVideoStreamWithKey:self.mVideo.video_id completed:^(int code, VideoStream* videostream) {
        self.mVideo.videoStream = videostream;
        [self playVideoWithURL];
    } failed:^(NSError *error) {
        NSLog(@"fail");
    }];
}

- (void) playVideoWithURL{
    if (self.mVideo.videoStream.streamUrls.count > 1 && self.mVideo.videoStream) {
        [self.player enableButtonQuality:YES];
    }else{
        [self.player enableButtonQuality:NO];
    }
    
    QualityURL* quality;
    if (self.mVideo.type_quality) {
        for (QualityURL* ql in self.mVideo.videoStream.streamUrls) {
            if ([ql.type isEqualToString:self.mVideo.type_quality]) {
                ql.link = self.mVideo.stream_url;
                quality = ql;
                break;
            }
        }
    }else{
        quality = [self.mVideo.videoStream.streamUrls firstObject];
    }

    self.mVideo.stream_url = quality.link;
    self.mQuality = quality;
    if ([self.type isEqualToString:SEASON_TYPE]) {
        [self.player setIndexCurrent:indexCurrent];
        [self.player setListVideos:[NSMutableArray arrayWithArray:self.mSeason.videos]];
    }else{
        [self.player setIndexCurrent:-1];
        [self.player setListVideos:[NSMutableArray arrayWithArray:@[]]];
    }
    
    if (self.mVideo.stream_url) {
        [self.player setURL:[NSURL URLWithString:self.mVideo.stream_url]];
    }
    [self.player setQualityWithType:quality.type withLink:@""];
    [self.player showActionView:(![self.type isEqualToString:DETAIL_OFFLINE_TYPE])];
    showMenu = YES;
    [self cancelTimerHideMenu:NO];
    [self showVideoMenu];
}

- (void) getSubtitleWithVideo:(Video *)v _completed:(void(^)(NSString *str, NSError *error))completed {
    if (v.isHadSubtitle) {
        [[APIController sharedInstance] getSubtitleWithWideoKey:v.video_id completed:^(NSArray *array){
            SubTitle *sub = [array lastObject];
            if ([ParserObject checkExistSub:sub.subtitle_id]) {
                [ParserObject getExistContentSubTitle:sub ofVideo:v _completed:^(NSString *str, NSError *error){
                    completed(str, error);
                }];
            }else {
                [ParserObject saveSubTitleAndLoadFile:sub _completed:^(NSString *str, NSError *error){
                    completed(str, error);
                }];
            }
        }failed:^(NSError *error){
            // handle error
            if (v.subTitleId) {
                [ParserObject getExistContentSubTitleOffline:v _completed:^(NSString *str, NSError *error){
                    completed(str, error);
                }];
            }else{
                completed (nil, error);
            }
        }];
        
    } else {
        completed(nil, nil);
    }
}


- (void) cannotPlayNext{
    if ([self mpIsFullScreen] || [self mpIsMinimized]) {
        if ([self mpIsFullScreen]) {
            [videoView addGestureRecognizer:panGesture];
            [self fullScreenMp:NO animated:YES];
        }else if([self mpIsMinimized]){
            [self minimizeMp:NO animated:YES];
        }
    }
}

- (BOOL) isAllow3G{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:SETTING_ALLOW3G] && [[defaults valueForKey:SETTING_ALLOW3G] boolValue]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)setAllow3G:(BOOL)isOn{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:isOn] forKey:SETTING_ALLOW3G];
    [defaults synchronize];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 111 && buttonIndex == 1) {
        [self setAllow3G:YES];
        [self downloadCurrentVideoWithQuality:self.mQualityDownload];
    }
}


- (void) downloadVideo:(Video*) video atIndex:(int) index{
    self.videoDownloadCurrent = video;
    self.indexDownloadCurrent = index;
    if (APPDELEGATE.connectionType == kConnectionTypeNone) {
        [APPDELEGATE showToastMessage:@"Vui lòng kết nối mạng để tải video"];
        return;
    }else{
        if (APPDELEGATE.connectionType == kConnectionTypeWAN) {
            if (![self isAllow3G]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Bạn đang sử dụng 2G/3G. Bạn có muốn tiếp tục tải video?" delegate:self cancelButtonTitle:@"Huỷ" otherButtonTitles:@"Tiếp tục", nil];
                [alert setTag:111];
                [alert show];
                return;
            }
        }
    }
    
    if (video.link_down == nil || video.link_down.length < 10) {
        [[APIController sharedInstance] getVideoDetailWithId:video.video_id completed:^(NSArray *results) {
            Video* _video = [results lastObject];
            [self downloadVideo:_video atIndex:index];
        } failed:^(NSError *error) {
            
        }];
        return;
    }
}



- (void) stopVideo{
    [self.player stop];
    [self addToHistory];
}

- (void) addToHistory{
    double seconds = CMTimeGetSeconds([self.player.mPlayer currentTime]);
    [[DBHelper sharedInstance] addVideoToHistory:self.mVideo withStopTime:seconds];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadHistoryNotification object:nil];
}

- (void) stopVideoBackground:(BOOL) locked{
    if (locked) {
        [self.player pause:nil];
    }
    [self addToHistory];
}



- (void) showLoading:(BOOL) isShow{
    [self.player showLoading:isShow];
    if (isShow) {
        [self stopVideo];
    }
}

//- (void)playVideoWithURL:(NSString*)link{
//    if (self.player) {
//        [self.player setURL:[NSURL URLWithString:link]];
//    }
//}

- (void) showVideo:(id) item andOtherItem:(id) otherItem{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showVideo:andOtherItem:)]) {
        [self.delegate showVideo:item andOtherItem:otherItem];
    }
}

//- (void) showSerialViewWithData:(id) item{
//    showSerialVC = YES;
//    serialItem = item;
//    [self minimizeMp:YES animated:YES];
//}

//- (IBAction) doLike:(id)sender{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(showLoginWithTask:andObject:)]) {
//        [self.delegate showLoginWithTask:kTaskLike andObject:self.mVideo];
//    }
//}

- (BOOL) checkOpenningVideo{
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkOpenningVideo)]) {
        return [self.delegate checkOpenningVideo];
    }
    return NO;
}

- (void) showLoginOnPlayerView:(BOOL) isShow{
    [maskView setHidden:!isShow];
}

- (IBAction) btnShare_Tapped:(id) sender{
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"Chia sẻ" delegate:self cancelButtonTitle:@"Đóng" destructiveButtonTitle:nil otherButtonTitles:MENU_FB, MENU_COPY, nil];
    [menu showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self doTask:[actionSheet buttonTitleAtIndex:buttonIndex]];
}

- (void) doTask:(NSString *) task
{
    if ([task isEqualToString:MENU_FB])
    {
        Video *video = self.mVideo;
        if (!video) {
            return;
        }
        [[ShareTask sharedInstance] setViewController:self];
        [[ShareTask sharedInstance] shareFacebook:video];
    }
    else if ([task isEqualToString:MENU_COPY])
    {
//        Video *video = self.videoCurrent;
        
//        NSString *dataText = video.link_share;
//        [[UIPasteboard generalPasteboard] setString:dataText];
//        [APPDELEGATE showToastMessage:@"Đã copy link"];
    }
}

- (void) showMsg:(BOOL) isshow{
    [relatedMsgView setHidden:!isshow];
}

- (void) cancelTimerHideMenu:(BOOL) isCancel{
    if (isCancel) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideVideoMenu) object:nil];
    }else{
        [self performSelector:@selector(hideVideoMenu) withObject:nil afterDelay:10.0f];
    }
}

- (void) cancelPanGeature:(BOOL) isCancel{
    if (![self mpIsMinimized] && ![self mpIsFullScreen]) {
        if (isCancel) {
            [videoView removeGestureRecognizer:panGesture];
        }else{
            [videoView addGestureRecognizer:panGesture];
        }
    }
}

- (void) hideVideoMenu
{
    showMenu = NO;
    if ([self mpIsFullScreen]) {
        BOOL showed = [self checkInfomationShowed];
        if (showed) {
            [self showListView:NO withAnimation:YES];
        }
        [rightMenuView setHidden:YES];
    }
    [self.player hideMenuPlayer:YES];
    [self cancelTimerHideMenu:YES];
}

- (void) showVideoMenu{
    showMenu = YES;
    if ([self mpIsFullScreen]) {
        [rightMenuView setHidden:NO];
    }
    [self.player hideMenuPlayer:NO];
}

- (Video*) getCurrentVideo{
    return self.mVideo;
}

- (void) showChannel:(id) item{
    [self doMinimized];
    if (self.delegate && [self.delegate respondsToSelector:@selector(showChannel:)]) {
        [self.delegate showChannel:item];
    }
}

- (void) showArtist:(id)item{
    [self doMinimized];
    if (self.delegate && [self.delegate respondsToSelector:@selector(showArtist:)]) {
        [self.delegate showArtist:item];
    }
}

- (void) showLoginWithTask:(NSString*) task withVC:(id) vc{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showLoginWithTask:withVC:)]) {
        [self.delegate showLoginWithTask:task withVC:vc];
    }
}

- (void) showRatingView:(id) vc{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showRatingView:)]) {
        [self.delegate showRatingView:vc];
    }
}

- (NSString*) getDownloadLinkWithType:(NSString*) type {
    if (self.mVideo.videoStream.streamDownloads.count > 0) {
        NSArray *arrayQualities = self.mVideo.videoStream.streamDownloads;
        for (QualityURL* quality in arrayQualities) {
            if ([quality.type isEqualToString:type]) {
                return quality.link;
            }
        }
        return nil;
    } else {
        return nil;
    }
}

- (BOOL)allow3G{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:SETTING_ALLOW3G]) {
        BOOL isOn = [[defaults objectForKey:SETTING_ALLOW3G] boolValue];
        return isOn;
    }
    return NO;
}

- (void)downloadCurrentVideoWithQuality:(QualityURL*) quality{
    if (!APPDELEGATE.internetConnnected) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Vui lòng kết nối mạng để sử dụng tính năng này" delegate:self cancelButtonTitle:@"Huỷ" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (![self allow3G] && APPDELEGATE.connectionType != kConnectionTypeWifi) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Bạn đã chuyển qua chế độ 2G/3G, có tiếp tục tải không?" delegate:self cancelButtonTitle:@"Huỷ" otherButtonTitles:@"Tiếp tục", nil];
        alert.tag = 111;
        [alert show];
        return;
    }
    [[DownloadManager sharedInstance] downloadVideo:self.mVideo withQuality:quality completion:^(DownloadManagerCode code) {
        if (code == DownloadManagerCodeFileIsNull) {
            NSString *mess = @"Không tìm thấy link tải về.";
            [APPDELEGATE showToastMessage:mess];
            return;
        }
        if (code == DownloadManagerCodeFileExists) {
            NSString *mess = @"Đang được tải về.";
            [APPDELEGATE showToastMessage:mess];
            return;
        }
        if(code == DownloadManagerCodeFileDownloaded){
            NSString *mess = @"Đã được tải về.";
            [APPDELEGATE showToastMessage:mess];
            return;
        }
        if(code == DownloadManagerCodeAddFinished){
            NSString *mess = @"Đã thêm vào danh sách tải về.";
             [[NSNotificationCenter defaultCenter] postNotificationName:kDidAddDownloadVideoNotification object:nil];
            [APPDELEGATE showToastMessage:mess];
            return;
        }
        if(code == DownloadManagerCodeDoNotAllowDownload){
            NSString *mess = @"Do yêu cầu của đơn vị sở hữu bản quyền, hiện không cho phép tải video này!";
            [APPDELEGATE showToastMessage:mess];
            return;
        }
    }];
    return;
}

@end
