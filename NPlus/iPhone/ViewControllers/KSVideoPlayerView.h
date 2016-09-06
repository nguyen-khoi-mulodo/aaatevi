//
//  PlayerView.h
//  X4 Video Player
//
//  Created by Hemkaran Raghav on 10/4/13.
//  Copyright (c) 2013 Mahesh Gera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@class KSVideoPlayerView;

@protocol playerViewDelegate <NSObject>
@optional
-(void)playerViewZoomButtonClicked:(KSVideoPlayerView*)view;
-(void)playerFinishedPlayback:(KSVideoPlayerView*)view;

@end

@interface KSVideoPlayerView : UIView

@property (assign, nonatomic) id <playerViewDelegate> delegate;
@property (assign, nonatomic) BOOL isFullScreenMode;
@property (assign, nonatomic) BOOL forceRotate;

@property (nonatomic, assign) UIInterfaceOrientation visibleInterfaceOrientation;
@property (nonatomic, assign) UIInterfaceOrientationMask supportedOrientations;
@property (nonatomic, assign) CGRect portraitFrame;
@property (nonatomic, assign) CGRect landscapeFrame;

@property (retain, nonatomic) NSURL *contentURL;
@property (retain, nonatomic) AVPlayer *moviePlayer;
@property (assign, nonatomic) BOOL isPlaying;

@property (retain, nonatomic) UIButton *playPauseButton;
@property (retain, nonatomic) UIButton *volumeButton;
@property (retain, nonatomic) UIButton *zoomButton;

@property (retain, nonatomic) UISlider *progressBar;
@property (retain, nonatomic) UISlider *volumeBar;

@property (retain, nonatomic) UILabel *playBackTime;
@property (retain, nonatomic) UILabel *playBackTotalTime;

@property (retain,nonatomic) UIView *playerHudCenter;
@property (retain,nonatomic) UIView *playerHudBottom;
@property (retain,nonatomic) UIView *playerHudBottomBGView;

- (id)initWithFrame:(CGRect)frame contentURL:(NSURL*)contentURL;
- (id)initWithFrame:(CGRect)frame playerItem:(AVPlayerItem*)playerItem;
- (void)playWithContentURL:(NSURL*)contentURL;
-(void)play;
-(void)pause;
-(void) setupConstraints;

-(void)zoomButtonPressed:(UIButton*)sender;
-(void)playButtonAction:(UIButton*)sender;
-(void)progressBarChanged:(UISlider*)sender;

- (void)setURL:(NSURL*)URL;
- (NSURL*)URL;

@end
