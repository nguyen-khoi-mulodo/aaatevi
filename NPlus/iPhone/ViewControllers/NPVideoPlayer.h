//
//  NPVideoPlayer.h
//  NPlus
//
//  Created by TEVI Team on 9/15/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "NPPlayerView.h"
#import "LoginViewController.h"
#import "MoreOptionView.h"
@protocol NPVideoPlayerDelegate;
@interface NPVideoPlayer : NSObject <LoginControllerDelegate,MoreOptionViewDelegate> {
    float mRestoreAfterScrubbingRate;
	BOOL seekToZeroBeforePlay;
	id mTimeObserver;
	NSURL* mURL;
    BOOL FORE_STOP;
    BOOL LOADING_ASSET;
}
@property (nonatomic, strong) NPPlayerView *view;
@property (nonatomic, copy) NSURL* URL;
@property (readwrite, strong, setter=setPlayer:, getter=player) AVPlayer* mPlayer;
@property (strong, nonatomic) AVPlayerItem* mPlayerItem;
@property (assign, nonatomic) BOOL isFullScreen;
@property (assign, nonatomic) BOOL forceRotate;
@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, assign) UIInterfaceOrientation visibleInterfaceOrientation;
@property (nonatomic, assign) UIInterfaceOrientationMask supportedOrientations;
@property (nonatomic, assign) CGRect portraitFrame;
@property (nonatomic, assign) CGRect landscapeFrame;
@property (nonatomic, weak) id<NPVideoPlayerDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *str_Subtitle;
@property (nonatomic, assign) BOOL isZoomTap;
@property (nonatomic, strong) LoginViewController *loginVC;
@property (nonatomic, strong) NSString *curTypeQuality;

- (void)setVideoTitle:(NSString*)video_title;
- (BOOL)isPlaying;
- (CMTime) timeCurrent;
- (CMTime) timeDuration;
- (void)play;
- (void)pause;
- (void)stop;
- (void)myDealloc;
- (void)performOrientationChange:(UIInterfaceOrientation)deviceOrientation completion:(void(^)(BOOL finished))_completed;
- (void)beginScrubbing;
- (void)scrub;
- (void)endScrubbing;
- (void)setLikeForCurrentVideo:(BOOL)isLiked;
- (BOOL)canRotation;
- (void)showLoginViewWithTask:(NSString*)task;
- (void)btnLike_Tapped;
- (void)btnShare_Tapped;
- (void)btnHD_Tapped;
-(void)btnZoom_Tapped;
@end

@protocol NPVideoPlayerDelegate <NSObject>

@required
- (BOOL)canPlayNextItem;
- (void)playNextItem;
- (BOOL)canPlayPreItem;
- (void)playPreItem;
- (void)btnZoom_Tapped;
@end
