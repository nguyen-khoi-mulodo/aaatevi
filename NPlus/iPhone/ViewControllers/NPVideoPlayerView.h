//
//  NPVideoPlayerView.h
//  NPlus
//
//  Created by Anh Le Duc on 9/5/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NPVideoPlayerLayerView.h"
#import "NPVideoPlayerDetailView.h"

@protocol NPVideoPlayerViewDelegate;
@interface BrightnessView : UIView
@end
@interface NPVideoPlayerView : UIView{
}
@property (nonatomic, weak) id<NPVideoPlayerViewDelegate> delegate;
@property (nonatomic, strong) NPVideoPlayerLayerView* playerLayerView;
@property (nonatomic, weak) id parentController;
@property (nonatomic, strong) UIView *viewControls;
@property (nonatomic, strong) UIView *viewBottom;
@property (nonatomic, strong) UIButton *btnVerticalPlay;
@property (nonatomic, strong) UISlider *slDuration;
@property (nonatomic, strong) UILabel *lbTimeDuration;
@property (nonatomic, strong) UILabel *lbTotalDuration;
@property (nonatomic, strong) UIButton *btnZoom;

@property (nonatomic, strong) UIView *viewCenter;
@property (nonatomic, strong) UIButton *btnPlayCenter;
@property (nonatomic, strong) UIButton *btnNext;
@property (nonatomic, strong) UIButton *btnPrevious;
@property (nonatomic, strong) UIButton *btnVolume;
@property (nonatomic, strong) UIButton *btnSetting;

@property (nonatomic, strong) UIView *viewVolume;
@property (nonatomic, strong) UISlider *slVolume;
@property (nonatomic, strong) UIView *viewSetting;

@property (nonatomic, strong) UIView *viewHeaderLanscape;
@property (nonatomic, strong) UIButton *btnBack;
@property (nonatomic, strong) UIButton *btnLike;
@property (nonatomic, strong) UIButton *btnShare;
@property (nonatomic, strong) UILabel *lbTitle;

@property (nonatomic, strong) UIView *viewHeaderPortrait;
@property (nonatomic, strong) UIButton *btnMinimize;
@property (nonatomic, strong) UIButton *btnLikeP;
@property (nonatomic, strong) UIButton *btnShareP;
@property (nonatomic, strong) UIButton *btnDownload;


@property (nonatomic, strong) NPVideoPlayerDetailView *viewDetail;
@property (nonatomic, assign) BOOL isControlsHidden;
@property (nonatomic, assign) NSInteger controlHideCountdown;
@property (nonatomic, assign) BOOL isMinimize;
@property (nonatomic, assign) BOOL isAnimation;
- (void)youtubeAnimationMaximize:(BOOL)animated;
- (void)youtubeAnimationMinimize:(BOOL)animated;
- (void)performOrientationChange:(UIInterfaceOrientation)deviceOrientation;
- (void)showPlayButton:(BOOL)isPlay;
- (void)hideControlsIfNecessary;
- (void)setDelegateForViewDetail:(id)delegate;
- (void)setAlphaViewControls:(float)alpha;
- (void)setFullScreen:(BOOL)full;
- (void)setDataForTabChooseVideo:(NSArray*)data;
- (void)setDataForTabDetailVideo:(NSString*)title withDescription:(NSString*)des;
- (void)setDataForTabDownloadVideo:(NSArray*)data;
@end

@protocol NPVideoPlayerViewDelegate <NSObject>

@optional
- (void)btnPlay_Tapped;
- (void)btnZoom_Tapped;
- (void)beginScrubbing;
- (void)scrub;
- (void)endScrubbing;

@end

