//
//  PlayerView.m
//  X4 Video Player
//
//  Created by Hemkaran Raghav on 10/4/13.
//  Copyright (c) 2013 Mahesh Gera. All rights reserved.
//

#import "KSVideoPlayerView.h"
#import "UIView+VKFoundation.h"
#import "KeepLayout.h"
#import "HorizontalViewControl.h"
#import "VerticalViewControl.h"
#define degreesToRadians(x) (M_PI * x / 180.0f)
@interface KSVideoPlayerView(){
    float mRestoreAfterScrubbingRate;
	BOOL seekToZeroBeforePlay;
	id mTimeObserver;
    
	NSURL* mURL;
    
	AVPlayer* mPlayer;
    AVPlayerItem * mPlayerItem;
}
@property (nonatomic, strong) VerticalViewControl *verticalControl;
@property (nonatomic, strong) HorizontalViewControl *horizalControl;
@end
@implementation KSVideoPlayerView
{
    id playbackObserver;
    AVPlayerLayer *playerLayer;
    BOOL viewIsShowing;
}

-(id)initWithFrame:(CGRect)frame playerItem:(AVPlayerItem*)playerItem
{
    self = [super initWithFrame:frame];
    if (self) {
        self.moviePlayer = [AVPlayer playerWithPlayerItem:playerItem];
        playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
        [playerLayer setFrame:frame];
        [self.moviePlayer seekToTime:kCMTimeZero];
        [self.layer addSublayer:playerLayer];
        self.contentURL = nil;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinishedPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        
        [self initializePlayer:frame];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame contentURL:(NSURL*)contentURL
{
    self = [super initWithFrame:frame];
    if (self) {
        
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:contentURL];
        self.moviePlayer = [AVPlayer playerWithPlayerItem:playerItem];
        playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
        [playerLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.moviePlayer seekToTime:kCMTimeZero];
        [self.layer addSublayer:playerLayer];
        self.contentURL = contentURL;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinishedPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        
        [self initializePlayer:frame];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializePlayer:frame];
    }
    return self;
}

-(void)playWithContentURL:(NSURL *)contentURL{
    
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [playerLayer setFrame:frame];
}

-(void) setupConstraints
{
    
    // bottom HUD view
    self.playerHudBottom.keepHorizontalInsets.equal = KeepRequired(0);
    self.playerHudBottom.keepBottomInset.equal = KeepRequired(0);
    
    self.playerHudBottomBGView.keepHorizontalInsets.equal = KeepRequired(0);
    self.playerHudBottomBGView.keepBottomInset.equal = KeepRequired(0);
    self.playerHudBottomBGView.keepHeight.equal = KeepRequired(15);
    
    // play/pause button
    [self.playPauseButton keepHorizontallyCentered];
    [self.playPauseButton keepVerticallyCentered];
    
    // current time label
    self.playBackTime.keepLeftInset.equal = KeepRequired(5);
    [self.playBackTime keepVerticallyCentered];

    
    // progress bar
    self.progressBar.keepLeftOffsetTo(self.playBackTime).equal = KeepRequired(5);
    self.progressBar.keepBottomInset.equal = KeepRequired(0);
    [self.progressBar keepHorizontallyCentered];
    [self.progressBar keepVerticallyCentered];
    
    // total time label
    self.playBackTotalTime.keepLeftOffsetTo(self.progressBar).equal = KeepRequired(5);
    [self.playBackTotalTime keepVerticallyCentered];

    // zoom button
    self.zoomButton.keepLeftOffsetTo(self.playBackTotalTime).equal = KeepRequired(5);
    self.zoomButton.keepRightInset.equal = KeepRequired(5);
    [self.zoomButton keepVerticallyCentered];
}

-(void)initializePlayer:(CGRect)frame
{
//    int frameWidth =  frame.size.width;
//    int frameHeight = frame.size.height;
//    
//    self.backgroundColor = [UIColor blackColor];
//    viewIsShowing =  NO;
//    
//    [self.layer setMasksToBounds:YES];
//
//    self.playerHudBottom = [[UIView alloc] init];
//    self.playerHudBottom.frame = CGRectMake(0, 0, frameWidth, 25);
//    [self.playerHudBottom setBackgroundColor:[UIColor clearColor]];
//    [self addSubview:self.playerHudBottom];
//    
//    self.playerHudBottomBGView = [[UIView alloc] init];
//    self.playerHudBottomBGView.frame = CGRectMake(0, 0, frameWidth, 48*frameHeight/160);
//    self.playerHudBottomBGView.backgroundColor = [UIColor blackColor];
//
//    // Create the colors for our gradient.
//    UIColor *transparent = [UIColor colorWithWhite:1.0f alpha:0.f];
//    UIColor *opaque = [UIColor colorWithWhite:1.0f alpha:1.0f];
//    
//    // Create a masklayer.
//    CALayer *maskLayer = [[CALayer alloc]init];
//    maskLayer.frame = self.playerHudBottomBGView.bounds;
//    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc]init];
//    gradientLayer.frame = CGRectMake(0,0,self.playerHudBottomBGView.bounds.size.width, self.playerHudBottomBGView.bounds.size.height);
//    gradientLayer.colors = @[(id)transparent.CGColor, (id)transparent.CGColor, (id)opaque.CGColor, (id)opaque.CGColor];
//    gradientLayer.locations = @[@0.0f, @0.09f, @0.8f, @1.0f];
//
//    // Add the mask.
//    [maskLayer addSublayer:gradientLayer];
//    self.playerHudBottomBGView.layer.mask = maskLayer;
//    
//    [self.playerHudBottom addSubview:self.playerHudBottomBGView];
//    
//    //Play Pause Button
//    self.playPauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    self.playPauseButton.frame = CGRectMake(5*frameWidth/240, 6*frameHeight/160, 16*frameWidth/240, 16*frameHeight/160);
//    [self.playPauseButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.playPauseButton setSelected:NO];
//    [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"avplayer.bundle/playback_pause"] forState:UIControlStateSelected];
//    [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"avplayer.bundle/playback_play"] forState:UIControlStateNormal];
//    [self.playPauseButton setTintColor:[UIColor clearColor]];
//    self.playPauseButton.layer.opacity = 0;
//    [self addSubview:self.playPauseButton];
//
//    //Seek Time Progress Bar
//    self.progressBar = [[UISlider alloc] init];
//    self.progressBar.frame = CGRectMake(0, 0, frameWidth, 15);
//    [self.progressBar addTarget:self action:@selector(progressBarChanged:) forControlEvents:UIControlEventValueChanged];
//    [self.progressBar addTarget:self action:@selector(proressBarChangeEnded:) forControlEvents:UIControlEventTouchUpInside];
////    [self.progressBar setThumbImage:[UIImage imageNamed:@"Slider_button"] forState:UIControlStateNormal];
//    [self.playerHudBottom addSubview:self.progressBar];
//
//    //Current Time Label
//    self.playBackTime = [[UILabel alloc] init];
//    [self.playBackTime sizeToFit];
//    self.playBackTime.text = [self getStringFromCMTime:self.moviePlayer.currentTime];
//    [self.playBackTime setTextAlignment:NSTextAlignmentLeft];
//    [self.playBackTime setTextColor:[UIColor whiteColor]];
//    self.playBackTime.font = [UIFont systemFontOfSize:12*frameWidth/240];
//    [self.playerHudBottom addSubview:self.playBackTime];
//    
//    //Total Time label
//    self.playBackTotalTime = [[UILabel alloc] init];
//    [self.playBackTotalTime sizeToFit];
//    
//    self.playBackTotalTime.text = @"00:00";
////    self.playBackTotalTime.text = [self getStringFromCMTime:self.moviePlayer.currentItem.asset.duration];
//    
//    [self.playBackTotalTime setTextAlignment:NSTextAlignmentRight];
//    [self.playBackTotalTime setTextColor:[UIColor whiteColor]];
//    self.playBackTotalTime.font = [UIFont systemFontOfSize:12*frameWidth/240];
//    [self.playerHudBottom addSubview:self.playBackTotalTime];
//
//    //zoom button
//    UIImage *image = [UIImage imageNamed:@"avplayer.bundle/zoomin"];
//    self.zoomButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    self.zoomButton.frame = CGRectMake(0,0,image.size.width, image.size.height);
//    [self.zoomButton addTarget:self action:@selector(zoomButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.zoomButton setBackgroundImage:image forState:UIControlStateNormal];
//    [self.playerHudBottom addSubview:self.zoomButton];
//    
//    for (UIView *view in [self subviews]) {
//        view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    }
//
    viewIsShowing =  YES;
    self.verticalControl = [[VerticalViewControl alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) withVideoPlayer:self withVideoPlayerVC:nil];
    [self addSubview:self.verticalControl];
    
    self.horizalControl = [[HorizontalViewControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.height, SCREEN_SIZE.width) withVideoPlayer:self withVideoPlayerVC:nil];
    [self addSubview:self.horizalControl];
    [self.horizalControl setHidden:YES];
    
    CMTime interval = CMTimeMake(33, 1000);
    __weak __typeof(self) weakself = self;
    playbackObserver = [self.moviePlayer addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock: ^(CMTime time) {
        CMTime endTime = CMTimeConvertScale (weakself.moviePlayer.currentItem.asset.duration, weakself.moviePlayer.currentTime.timescale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
        if (CMTimeCompare(endTime, kCMTimeZero) != 0) {
            double normalizedTime = (double) weakself.moviePlayer.currentTime.value / (double) endTime.value;
            [weakself.verticalControl setValueForSliderDuration:normalizedTime];
            [weakself.horizalControl setValueForSliderDuration:normalizedTime];
        }
        [weakself.verticalControl setTextForLabelTimeDuration:[weakself getStringFromCMTime:weakself.moviePlayer.currentTime]];
        [weakself.verticalControl setTextForLabelTotalDuration:[weakself getStringFromCMTime:weakself.moviePlayer.currentItem.asset.duration]];
        [weakself.horizalControl setTextForLabelTimeDuration:[weakself getStringFromCMTime:weakself.moviePlayer.currentTime]];
        [weakself.horizalControl setTextForLabelTotalDuration:[weakself getStringFromCMTime:weakself.moviePlayer.currentItem.asset.duration]];
    }];
    
    [self.verticalControl showHub:YES withAnimation:NO];
}

-(void)zoomButtonPressed:(UIButton*)sender
{
//    [UIView animateWithDuration:0.5 animations:^{
//        [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)];
//    }];
//    [self.delegate playerViewZoomButtonClicked:self];
//    [self setIsFullScreenMode:!_isFullScreenMode];
    self.isFullScreenMode = sender.selected;
    
    if (self.isFullScreenMode) {
        [self performOrientationChange:UIInterfaceOrientationLandscapeRight];
    } else {
        [self performOrientationChange:UIInterfaceOrientationPortrait];
    }
    

}

- (void)performOrientationChange:(UIInterfaceOrientation)deviceOrientation {
    if (!self.forceRotate) {
        return;
    }
//    if ([self.delegate respondsToSelector:@selector(videoPlayer:willChangeOrientationTo:)]) {
//        [self.delegate videoPlayer:self willChangeOrientationTo:deviceOrientation];
//    }
    
    CGFloat degrees = [self degreesForOrientation:deviceOrientation];
    __weak __typeof__(self) weakSelf = self;
    UIInterfaceOrientation lastOrientation = self.visibleInterfaceOrientation;
    self.visibleInterfaceOrientation = deviceOrientation;
    [UIView animateWithDuration:0.3f animations:^{
        CGRect bounds = [[UIScreen mainScreen] bounds];
        CGRect parentBounds;
        CGRect viewBoutnds;
        if (UIInterfaceOrientationIsLandscape(deviceOrientation)) {
            viewBoutnds = CGRectMake(0, 0, CGRectGetWidth(self.landscapeFrame), CGRectGetHeight(self.landscapeFrame));
            parentBounds = CGRectMake(0, 0, CGRectGetHeight(bounds), CGRectGetWidth(bounds));
        } else {
            viewBoutnds = CGRectMake(0, 0, CGRectGetWidth(self.portraitFrame), CGRectGetHeight(self.portraitFrame));
            parentBounds = CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        }
        
        weakSelf.superview.transform = CGAffineTransformMakeRotation(degreesToRadians(degrees));
        weakSelf.superview.bounds = parentBounds;
        [weakSelf.superview setFrameOriginX:0.0f];
        [weakSelf.superview setFrameOriginY:0.0f];
        
        CGRect wvFrame = weakSelf.superview.superview.frame;
        if (wvFrame.origin.y > 0) {
            wvFrame.size.height = CGRectGetHeight(bounds) ;
            wvFrame.origin.y = 0;
            weakSelf.superview.superview.frame = wvFrame;
        }
        
        weakSelf.bounds = viewBoutnds;
        [weakSelf setFrameOriginX:0.0f];
        [weakSelf setFrameOriginY:0.0f];
//        [weakSelf layoutForOrientation:deviceOrientation];
        
    } completion:^(BOOL finished) {
//        if ([self.delegate respondsToSelector:@selector(videoPlayer:didChangeOrientationFrom:)]) {
//            [self.delegate videoPlayer:self didChangeOrientationFrom:lastOrientation];
//        }
    }];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:self.visibleInterfaceOrientation animated:YES];
//    [self updateCaptionView:self.view.captionBottomView caption:self.captionBottom playerView:self.view];
//    [self updateCaptionView:self.view.captionTopView caption:self.captionTop playerView:self.view];
//    self.view.fullscreenButton.selected = self.isFullScreenMode = UIInterfaceOrientationIsLandscape(deviceOrientation);
}

- (CGFloat)degreesForOrientation:(UIInterfaceOrientation)deviceOrientation {
    switch (deviceOrientation) {
        case UIInterfaceOrientationPortrait:
            return 0;
            break;
        case UIInterfaceOrientationLandscapeRight:
            return 90;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            return -90;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            return 180;
            break;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [playerLayer setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

-(void)setIsFullScreenMode:(BOOL)isFullScreenMode
{
    _isFullScreenMode = isFullScreenMode;
    if (isFullScreenMode) {
        [self setFrame:CGRectMake(0, 0, SCREEN_SIZE.height, SCREEN_SIZE.width)];
        self.backgroundColor = [UIColor blackColor];
        [self.verticalControl setHidden:YES];
        [self.horizalControl setHidden:NO];
    } else {
        [self setFrame:CGRectMake(0, ORIGIN_Y, 320, 180)];
        self.backgroundColor = [UIColor blackColor];
        [self.verticalControl setHidden:NO];
        [self.horizalControl setHidden:YES];
    }
}

-(void)playerFinishedPlaying
{
    [self.moviePlayer pause];
    [self.moviePlayer seekToTime:kCMTimeZero];
    [self.playPauseButton setSelected:NO];
    self.isPlaying = NO;
    if ([self.delegate respondsToSelector:@selector(playerFinishedPlayback:)]) {
        [self.delegate playerFinishedPlayback:self];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [(UITouch*)[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(playerLayer.frame, point)) {
        if (!self.isFullScreenMode) {
            [self.verticalControl showHub:!viewIsShowing withAnimation:YES];
        }
        viewIsShowing = !viewIsShowing;
    }
}


-(NSString*)getStringFromCMTime:(CMTime)time
{
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
    int hour = mins/60.0;
    int secs = fmodf(currentSeconds, 60.0);
    NSString *hourString = hour < 10 ? [NSString stringWithFormat:@"0%d", hour] : [NSString stringWithFormat:@"%d", hour];
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    return [NSString stringWithFormat:@"%@:%@:%@", hourString, minsString, secsString];
}

//-(void)volumeButtonPressed:(UIButton*)sender
//{
//    if (sender.isSelected) {
//        [self.moviePlayer setMuted:YES];
//        [sender setSelected:NO];
//    } else {
//        [self.moviePlayer setMuted:NO];
//        [sender setSelected:YES];
//    }
//}

-(void)playButtonAction:(UIButton*)sender
{
    if (self.isPlaying) {
        [self pause];
    } else {
        [self play];
    }
}

-(void)progressBarChanged:(UISlider*)sender
{
    if (self.isPlaying) {
        [self.moviePlayer pause];
    }
    CMTime seekTime = CMTimeMakeWithSeconds(sender.value * (double)self.moviePlayer.currentItem.asset.duration.value/(double)self.moviePlayer.currentItem.asset.duration.timescale, self.moviePlayer.currentTime.timescale);
    [self.moviePlayer seekToTime:seekTime];
}

-(void)proressBarChangeEnded:(UISlider*)sender
{
    if (self.isPlaying) {
        [self.moviePlayer play];
    }
}

-(void)volumeBarChanged:(UISlider*)sender
{
    [self.moviePlayer setVolume:sender.value];
}

-(void)play
{
    [self.moviePlayer play];
    self.isPlaying = YES;
    [self.verticalControl setStateButtonPlay:YES];
    [self.horizalControl setStateButtonPlay:YES];
}

-(void)pause
{
    [self.moviePlayer pause];
    self.isPlaying = NO;
    [self.verticalControl setStateButtonPlay:NO];
    [self.horizalControl setStateButtonPlay:NO];
}

-(void)dealloc
{
    [self.moviePlayer removeTimeObserver:playbackObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
