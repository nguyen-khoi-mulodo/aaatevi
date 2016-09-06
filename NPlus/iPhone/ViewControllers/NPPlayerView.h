//
//  NPPlayerView.h
//  NPlus
//
//  Created by TEVI Team on 11/14/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPVideoPlayerLayerView.h"
#import "MoreOptionView.h"
#import "FWTPopoverView.h"
#import "ListVideoFullScreenController.h"

//@protocol NPVideoPlayerViewDelegate;
@interface BrightnessView : UIView
@end

@interface NPPlayerView : UIView <MoreOptionViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnDownload;
- (IBAction)btnDownload_Tapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *iconHD;
@property (weak, nonatomic) IBOutlet UIProgressView *bufferProgress;

@property (weak, nonatomic) IBOutlet UIView *viewFooter;
@property (weak, nonatomic) IBOutlet UISlider *slDuration;
@property (weak, nonatomic) IBOutlet UIButton *btnZoom;
@property (weak, nonatomic) IBOutlet UILabel *lbTimeDuration;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalDuration;
@property (weak, nonatomic) IBOutlet UIButton *btnHD;
@property (weak, nonatomic) IBOutlet UIView *viewSubFooter;
@property (strong, nonatomic) FWTPopoverView *popoverView;

@property (weak, nonatomic) IBOutlet UIView *viewCenter;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayCenter;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnVolume;
@property (weak, nonatomic) IBOutlet UIButton *btnSetting;
@property (weak, nonatomic) IBOutlet UIButton *btnPrevious;


@property (weak, nonatomic) IBOutlet UIView *viewSetting;
@property (weak, nonatomic) IBOutlet UIButton *btnLock;
- (IBAction)btnLock_Tapped:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *viewVolume;
@property (weak, nonatomic) IBOutlet UISlider *slVolume;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIView *viewMore;
@property (weak, nonatomic) IBOutlet UIView *viewMoreContainer;
@property (weak, nonatomic) IBOutlet UIView *viewMoreButtons;
@property (weak, nonatomic) IBOutlet UIButton *btnTabChooseVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnTabDescVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnTabDownloadVideo;
- (IBAction)changeTab:(UIButton*)button;


@property (nonatomic, strong) IBOutlet NPVideoPlayerLayerView* playerLayerView;
@property (nonatomic, strong) ListVideoFullScreenController* chooseVideo;
@property (nonatomic, assign) BOOL isControlsHidden;
@property (nonatomic, assign) NSInteger controlHideCountdown;
@property (nonatomic, assign) BOOL isMinimize;
@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, assign) BOOL isTouch;
@property (nonatomic, assign) BOOL isLandcape;
@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, assign) BOOL isHadHD;
@property (nonatomic, assign) BOOL isShowMore;
@property (nonatomic, assign) BOOL isLockControll;
@property (nonatomic, assign) BOOL isShowPanelForward;
@property (nonatomic, strong) NSString *curTypeQualityDown;

// timer to hide control
@property (nonatomic, strong) NSTimer *timerToHide;


- (void)youtubeAnimationMaximize:(BOOL)animated;
- (void)youtubeAnimationMinimize:(BOOL)animated;
- (void)performOrientationChange:(UIInterfaceOrientation)deviceOrientation;
- (void)showPlayButton:(BOOL)isPlay;
- (void)hideControlsIfNecessary;
- (void)setControlsHidden:(BOOL)hidden autoHide:(BOOL)autoHide;
- (void)setDelegateForViewDetail:(id)delegate;
- (void)setAlphaViewControls:(float)alpha;
- (void)setFullScreen:(BOOL)full;
- (IBAction)handleSingleTap:(id)sender;
- (void)hideControll;
- (void)hideControllWithNoAutoShow;
- (void)refresh;

@end