//
//  VideoPlayer.h
//  NPlus
//
//  Created by Vo Chuong Thien on 11/3/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Channel.h"
#import "Season.h"
#import "PlayerViewController.h"
#import "GAITrackedViewController.h"
#import "SeasonSuggestVC_iPad.h"
#import "InfoDetailVC_iPad.h"
#import "ChannelInfoDetailVC_iPad.h"
#import "ActionVC.h"
#import "ChannelVC_New_iPad.h"
#import "VideoSuggestVC_iPad.h"


@protocol VideoPlayerDelegate <NSObject>
- (void) showChannel:(id) item;
- (void) showArtist:(id) item;
- (void) showLoginWithTask:(NSString*) task withVC:(id) vc;
- (void) showRatingView:(id) vc;
- (void) hideLoginView;

- (void) showVideo:(id) item andOtherItem:(id) otherItem;
- (void) showSerialViewWithData:(id) item;
- (void) showLoginWithTask:(NSString*) task andObject:(id) item;
- (void) showRatingView;
- (void) minimizedVideoPlayer:(BOOL) isMinimized;
- (BOOL) checkOpenningVideo;
- (void) hideLoginView;
- (void) videoPlayerDismissed;
- (void) showMaskVideoView:(BOOL) isShow;
- (void) setAlphaMaskVideoView:(float) alpha;
- (void) videoPlayerDismissing;

@end

@interface VideoPlayer : GAITrackedViewController <UIGestureRecognizerDelegate, PlayerViewControllerDelegate, UIActionSheetDelegate,UIGridViewDelegate, InfoDetailDelegate, SeasonSuggestVCDelegate, ChannelInfoDetailDelegate, ActionDelegate, GlobalViewDelegate, VideoSuggestDelegate>{
    IBOutlet UIView* videoView;
    IBOutlet UIView* infoVideoContainer;
    IBOutlet UIImageView* infoBG;
    IBOutlet UIView* relatedViewContainer;
    IBOutlet UIView* headerView;
    IBOutlet UIView* rightMenuView;
    IBOutlet UIView* maskView;
    
    UIPanGestureRecognizer *panGesture;
    int direct_type;
    UIButton* btnRightCurrent;
    
    IBOutlet UILabel* lbName;
    IBOutlet UILabel* lbCountry;
    
    NSMutableArray* listVideos;
    
    BOOL showSerialVC;
    id serialItem;
    
    Video* videoCurrent;
    Video* videoDownloadCurrent;
    int indexDownloadCurrent;
    
    IBOutlet UILabel* relatedMsgView;
    
    IBOutlet UIView* episodeView;
    IBOutlet UIScrollView* episodeScrollView;
    IBOutlet UIView* infoView;
    IBOutlet UIScrollView* infoScrollView;
    IBOutlet UIGridView* gridView;
    IBOutlet UIImageView* backgroundImage;
    
    
    InfoDetailVC_iPad* infoDetailVC;
    ChannelInfoDetailVC_iPad* channelInfoDetailVC;
    SeasonSuggestVC_iPad* seasonSuggestVC;
    ActionVC* actionVC;
    ChannelVC_New_iPad* newChannelVC;
    VideoSuggestVC_iPad* videoofSeasonVC;
    VideoSuggestVC_iPad* videoSuggestVC;
    
    UIPopoverController* actionPopover;
    BOOL showMenu;
    IBOutlet UIButton* btnDownload;
    IBOutlet UIButton* btnShare;
    IBOutlet UIButton* btnQuality;
    
    BOOL playSeason;
    int indexCurrent;
}

@property (nonatomic, strong) Video* mVideo;
@property (nonatomic, strong) Season* mSeason;
@property (nonatomic, strong) FileDownloadInfo* mFileInfo;
@property (nonatomic, strong) QualityURL* mQuality;
@property (nonatomic, strong) QualityURL* mQualityDownload;
@property (nonatomic, strong) NSString* type;



@property (nonatomic, strong) Channel* showCurrent;
@property (nonatomic, strong) Video* videoDownloadCurrent;
@property (nonatomic, strong) Season* seasonCurrent;
@property (nonatomic, strong) PlayerViewController* player;
@property (nonatomic, strong) NSString* typeCurrent;
@property (nonatomic, strong) id <VideoPlayerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIButton* btnLike;
@property (nonatomic, strong) NSMutableArray* listVideos;
@property int indexCurrent;
@property int indexDownloadCurrent;
@property (nonatomic, strong) IBOutlet UIImageView* tutorialImageView;

@property (nonatomic, strong) NSMutableArray* listArtists;

@property (nonatomic, strong) NSMutableArray* listButtons;

- (void) loadVideoPlayerWithItem:(id) item withIndex:(int) index fromRootView:(BOOL) fromRoot;


- (void) showLoginOnPlayerView:(BOOL) isShow;
- (BOOL) mpIsMinimized;
- (void) minimizeMp:(BOOL)minimized animated:(BOOL)animated;
- (void) stopVideo;
- (void) stopVideoBackground:(BOOL) locked;

@end
