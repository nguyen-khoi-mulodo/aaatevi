//
//  NPPlayerView.m
//  NPlus
//
//  Created by TEVI Team on 11/14/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "NPPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+VKFoundation.h"
#import "F3BarGauge.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAITracker.h"
#import "GAIFields.h"
#import "QualityURL.h"

#define kPlayerControlsAutoHideTime    10
#define kOverViewTag    100
#define kMainViewTag    200
#define MAKESHADOW(a) a.layer.shadowColor = [UIColor blackColor].CGColor; a.layer.shadowOpacity = 0.5f; a.layer.shadowOffset = CGSizeMake(0.0f, 1.0f); a.layer.shadowRadius = 1.0f; UIBezierPath *path = [UIBezierPath bezierPathWithRect:a.bounds]; a.layer.shadowPath = path.CGPath;
typedef NS_ENUM(NSInteger, direction) {
    Down = 0, DownRight = 1,
    Right = 2, UpRight = 3,
    Up = 4, UpLeft = 5,
    Left = 6, DownLeft = 7, Default = 8
};

@implementation BrightnessView
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return YES;
}
@end
@interface NPPlayerView()<UIGestureRecognizerDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate>{
    BOOL _isShowSetting;
    BOOL _isShowVolume;
    NSMutableArray *_lstView;
    BOOL _panningProgress;
    BOOL _slideLeftRight;
    BOOL _isChangeForward, _isChangeVolume;
    float _volume, _brightness, _currentTime;
    
    //page view contorller
    BOOL _isAnimationMore;
    NSInteger _currentTag;
}
@property (nonatomic) CGPoint startTouch;
@property (nonatomic) CGPoint lastTouch;
@property (nonatomic) CGPoint viewPoint;
@property (nonatomic, assign) CGRect minimizeFrame;
@property (nonatomic, assign) CGRect maximizeFrame;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *pages;
@end

static float height_player = 0;
static int WIDTH_MINI = 0;
static int HEIGHT_MINI = 0;
@implementation NPPlayerView
//@synthesize delegate = _delegate;
@synthesize isMinimize = _isMinimize;
@synthesize isAnimation = _isAnimation;
@synthesize isTouch = _isTouch;
-(void)awakeFromNib{
    
    float delta = 0.5625f;
    height_player = SCREEN_WIDTH * delta;
    WIDTH_MINI = SCREEN_WIDTH/2;
    HEIGHT_MINI = WIDTH_MINI * delta;
    _isTouch = NO;
    _isAnimationMore = NO;
    _isShowMore = NO;
    _currentTag = 0;
    self.minimizeFrame = CGRectMake(SCREEN_WIDTH - WIDTH_MINI - 5, SCREEN_SIZE.height - 60 - HEIGHT_MINI, WIDTH_MINI, HEIGHT_MINI);
    self.maximizeFrame = CGRectMake(0, ORIGIN_Y, SCREEN_WIDTH, height_player);
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    self.backgroundColor = [UIColor clearColor];
    self.isControlsHidden = NO;
    _isFullScreen = NO;
    _isShowSetting = NO;
    _isShowVolume = NO;
    _panningProgress = NO;
    _isAnimation = NO;
    _slideLeftRight = NO;
    _lstView = [[NSMutableArray alloc] init];
    self.isMinimize = NO;
    [self initUserInterface];
    [self initObserver];
    [self initPagesViewController];
}

- (void)initUserInterface{
    UIImage *minImage = [[UIImage imageNamed:@"playing_progressbar_playing"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *maxImage = [[UIImage imageNamed:@"playing_progressbar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [self.slDuration setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [self.slDuration setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [self.slDuration setThumbImage:[UIImage imageNamed:@"nut-v2"] forState:UIControlStateNormal];
    self.slDuration.minimumValue = 0.0f;
    self.slDuration.maximumValue = 1.0f;
    
    self.btnHD.layer.cornerRadius = 3.0;
    self.btnHD.clipsToBounds = YES;
    self.btnHD.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.btnHD.layer.borderWidth = 1.0;
    self.btnHD.backgroundColor = [UIColor clearColor];
    
    [_btnSetting addTarget:self action:@selector(toggleSetting:) forControlEvents:UIControlEventTouchUpInside];
    [_btnVolume addTarget:self action:@selector(toggleVolume:) forControlEvents:UIControlEventTouchUpInside];
    [_btnBack addTarget:self action:@selector(btnMinimize_Tapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.viewCenter.hidden = YES;
    self.viewSetting.hidden = YES;
    self.viewSetting.alpha = .0f;
    self.viewVolume.hidden = YES;
    self.viewVolume.alpha = .0f;
    self.lbTitle.hidden = YES;
    self.btnBack.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.viewMore.hidden = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:SETTING_LOCK_ROTATION]) {
        BOOL isOn = [[defaults objectForKey:SETTING_LOCK_ROTATION] boolValue];
        _btnLock.selected = isOn;
    }else{
        _btnLock.selected = NO;
    }
}

- (void)initObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideAllView) name:kToggleShowTabVideoDetailLandscape object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationShowControlPlayer:) name:kShowControlPlayerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHideControlPlayer:) name:kHideControlPlayerNotification object:nil];
}

- (void)notificationShowControlPlayer:(NSNotification *)notification{
    if (self.isControlsHidden) {
        [self setControlsHidden:NO autoHide:YES];
    }
}

- (void)notificationHideControlPlayer:(NSNotification *)notification{
    if (!self.isControlsHidden) {
        [self hideMoreView];
    }
}

- (void)volumeChanged:(NSNotification *)notification
{
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    if (!_panningProgress) {
        [self.slVolume setValue:volume];
    }
}

- (void)handleSingleTap:(id)sender {
    if (_isLockControll) {
        return;
    }
    if (self.isMinimize) {
        [self youtubeAnimationMaximize:YES];
        return;
    }
    if (_isShowMore) {
        [self hideMoreView];
        return;
    }
//    _isShowMore = !_isShowMore;
    [self setControlsHidden:!self.isControlsHidden autoHide:NO];
    if (!self.isControlsHidden) {
//        self.controlHideCountdown = kPlayerControlsAutoHideTime;
        if ([_timerToHide isValid]) {
            [_timerToHide invalidate];
        }
        _timerToHide = nil;
        _timerToHide = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hideControll) userInfo:nil repeats:NO];
    }
    
}

- (void)hideControllWithNoAutoShow {
    _isLockControll = YES;
    [self hideControll];
}

- (void)hideControll {
    if (_isShowMore) {
        return;
    }
    [self setControlsHidden:YES autoHide:YES];
}

- (void)hideControlsIfNecessary {
    if (self.isControlsHidden) return;
    if (_isShowMore) {
        return;
    }
    if (self.controlHideCountdown == -1) {
        [self setControlsHidden:NO autoHide:YES];
    } else if (self.controlHideCountdown == 0) {
        [self setControlsHidden:YES autoHide:YES];
    } else {
        self.controlHideCountdown--;
        NSLog(@"controlHIdeCountdown: %ld", (long)self.controlHideCountdown);
    }
}

- (void)setControlsHidden:(BOOL)hidden autoHide:(BOOL)autoHide {
    if (self.isControlsHidden != hidden) {
        self.isControlsHidden = hidden;
        if (autoHide) {
            if (hidden) {
                for (int i = 0; i < 9; i++) {
                    UIView *view = [self viewWithTag:200+i];
                    [view fadeHide];
                }
            }else{
                for (int i = 0; i < 9; i++) {
                    UIView *view = [self viewWithTag:200+i];
                    [view fadeShow];
                }
            }
        } else {
            if (hidden) {
                for (int i = 0; i < 9; i++) {
                    UIView *view = [self viewWithTag:200+i];
                    [view fadeHide];
//                    if (view.tag != 205) {
//                        [view fadeHide];
//                    }
                    
                }
            }else{
                for (int i = 0; i < 9; i++) {
                    UIView *view = [self viewWithTag:200+i];
                    [view fadeShow];
                }
            }
        }
        //_isShowMore = !_isShowMore;
        [self hideAllView];
        [self showControlAutoHide:hidden];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)setFullScreen:(BOOL)full{
    _isFullScreen = full;
    [self showControlAutoHide:NO];
}


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
}

- (void)showControlAutoHide:(BOOL)autoHide{
    if (_isMinimize) {
        return;
    }
    if (_popoverView) {
        [_popoverView dismissPopoverAnimated:NO];
        _popoverView = nil;
    }
    if (!_isFullScreen) {
        [self showControlVerticalAutoHide:autoHide];
        [self.btnZoom setImage:[UIImage imageNamed:@"icon-zoom-out-press"] forState:UIControlStateHighlighted];
        [self.btnZoom setImage:[UIImage imageNamed:@"icon-zoom-out"] forState:UIControlStateNormal];
    }else{
        [self showControlHorizontal];
        [self.btnZoom setImage:[UIImage imageNamed:@"icon-zoom-in-press"] forState:UIControlStateHighlighted];
        [self.btnZoom setImage:[UIImage imageNamed:@"icon-zoom-in"] forState:UIControlStateNormal];
    }
}

- (void)showControlVerticalAutoHide:(BOOL)autoHide{
    if (APPDELEGATE.isShowingPopup && !autoHide) {
        if ([APPDELEGATE.window viewWithTag:1405]) {
            MoreOptionView *view = (MoreOptionView*)[APPDELEGATE.window viewWithTag:1405];
            [view tapGesture];
        }
    }
    self.viewCenter.hidden = YES;
    self.viewSetting.hidden = YES;
    self.viewVolume.hidden = YES;
    self.lbTitle.hidden = YES;
    self.btnBack.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.viewMore.hidden = YES;
    [self hidePanelForward];
    for (NSLayoutConstraint *constraint in _viewHeader.constraints) {
        if (constraint.constant == -5 && [constraint.firstItem isEqual:_btnShare] && [constraint.secondItem isEqual:_lbTitle]) {
            constraint.constant = -150;
            [_viewHeader setNeedsLayout];
            [_viewHeader layoutIfNeeded];
            break;
        }
    }
    _btnLike.hidden = YES;
    _btnShare.hidden = YES;
    _btnDownload.hidden = YES;
    _lbTitle.hidden = NO;
    self.lbTitle.text = APPDELEGATE.nowPlayerVC.currentVideo.video_subtitle;
}

- (void)showControlHorizontal{
    
    if ([APPDELEGATE.nowPlayerVC.type isEqualToString:@"OFFLINE"]) {
        _btnLike.hidden = YES;
        _btnShare.hidden = YES;
        _btnDownload.hidden = YES;
    } else {
        _btnLike.hidden = NO;
        _btnShare.hidden = NO;
        _btnDownload.hidden = NO;
    }
    
    for (NSLayoutConstraint *constraint in _viewHeader.constraints) {
        if (constraint.constant == -150 && [constraint.firstItem isEqual:_btnShare] && [constraint.secondItem isEqual:_lbTitle]) {
            constraint.constant = -5;
            [_viewHeader setNeedsLayout];
            [_viewHeader layoutIfNeeded];
            break;
        }
    }
    self.lbTitle.hidden = NO;
    self.lbTitle.text = APPDELEGATE.nowPlayerVC.currentVideo.video_subtitle;
    self.btnBack.transform = CGAffineTransformMakeRotation(0);
    if (APPDELEGATE.nowPlayerVC.isShowViewMore) {
        self.viewMore.hidden = NO;
        if (APPDELEGATE.nowPlayerVC.season.videos && _chooseVideo) {
            _chooseVideo.dataSources = (NSMutableArray*)APPDELEGATE.nowPlayerVC.season.videos;
//            if (APPDELEGATE.nowPlayerVC.season.type == MOVIES_SERIES) {
//                _chooseVideo.tbVideo.hidden = YES;
//                _chooseVideo.collectionVideo.hidden = NO;
//                if (_chooseVideo.collectionVideo.delegate) {
//                    [_chooseVideo.collectionVideo reloadData];
//                } else {
//                    _chooseVideo.collectionVideo.delegate = _chooseVideo;
//                    _chooseVideo.collectionVideo.dataSource = _chooseVideo;
//                }
//                
//            } else {
                _chooseVideo.tbVideo.hidden = NO;
                _chooseVideo.collectionVideo.hidden = YES;
            _chooseVideo.lblTitle.text = [NSString stringWithFormat:@"%@",APPDELEGATE.nowPlayerVC.season.seasonName];
            _chooseVideo.lblIndex.text = [NSString stringWithFormat:@"%d/%d",(int)APPDELEGATE.nowPlayerVC.curIndexVideoChoose+1,(int)APPDELEGATE.nowPlayerVC.season.videos.count];
                if (_chooseVideo.tbVideo.delegate) {
                    [_chooseVideo.tbVideo reloadData];
                } else {
                    _chooseVideo.tbVideo.delegate = _chooseVideo;
                    _chooseVideo.tbVideo.dataSource = _chooseVideo;
                }
//            }
        }
    } else {
        self.viewMore.hidden = YES;
    }
    self.viewMore.frame = CGRectMake(CGRectGetWidth(self.frame) - 30, 0, self.viewMore.frame.size.width, self.viewMore.frame.size.height);
}

- (void)showViewDetail{
    if (!_isFullScreen) {
        return;
    }
//    self.viewDetail.frame = CGRectMake(CGRectGetWidth(self.frame) - 30, 0, 375, 320);
//    self.viewDetail.hidden = NO;
//    CGRect frame = CGRectMake(CGRectGetWidth(self.frame) - 375, 0, 375, 320);
//    [UIView animateWithDuration:0.5f animations:^{
//        self.viewDetail.frame = frame;
//    } completion:^(BOOL finished) {
//        
//    }];
}

- (void)hideViewDetail{
    if (!_isFullScreen) {
        return;
    }
//    CGRect frame = CGRectMake(CGRectGetWidth(self.frame) - 30, 0, 375, 320);;
//    [UIView animateWithDuration:0.5f animations:^{
//        self.viewDetail.frame = frame;
//    } completion:^(BOOL finished) {
//        
//    }];
}



-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

-(void)showPlayButton:(BOOL)isPlay{
    if (isPlay) {
        [self.btnPlayCenter setImage: _isLandcape ? [UIImage imageNamed:@"icon-play-v2"]:[UIImage imageNamed:@"icon-play-v2"] forState:UIControlStateHighlighted];
        [self.btnPlayCenter setImage:_isLandcape ? [UIImage imageNamed:@"icon-play-v2"]:[UIImage imageNamed:@"icon-play-v2"] forState:UIControlStateNormal];
    }else{

        [self.btnPlayCenter setImage: _isLandcape ? [UIImage imageNamed:@"icon-pause-v2"]:[UIImage imageNamed:@"icon-pause-v2"] forState:UIControlStateHighlighted];
        [self.btnPlayCenter setImage:_isLandcape ? [UIImage imageNamed:@"icon-pause-v2"]:[UIImage imageNamed:@"icon-pause-v2"] forState:UIControlStateNormal];
    }
}

#pragma mark - action
- (void)volumeScrubbing:(UISlider*)slider{
    //[MPMusicPlayerController iPodMusicPlayer].volume = slider.value;
}

#pragma mark - button action
- (void)hideAllView{
    _viewSetting.alpha = 0;
    _viewVolume.alpha = 0;
    _isShowVolume = NO;
    _isShowSetting = NO;
}
- (void)toggleSetting:(UIButton*)button{
    if (_isShowSetting) {
        [self.viewSetting fadeHide];
        _isShowSetting = NO;
    }else{
        [self.viewVolume fadeHide];
        _isShowVolume = NO;
        [self.viewSetting fadeShow];
        _isShowSetting = YES;
    }
}

- (void)toggleVolume:(UIButton*)button{
    if (_isShowVolume) {
        [self.viewVolume fadeHide];
        _isShowVolume = NO;
    }else{
        [self.viewSetting fadeHide];
        _isShowSetting = NO;
        [self.viewVolume fadeShow];
        _isShowVolume = YES;
    }
}

- (void)setAlphaViewControls:(float)alpha{
//    self.viewControls.alpha = alpha;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kToggleShowTabVideoDetailLandscape object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShowControlPlayerNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHideControlPlayerNotification object:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.startTouch = [[touches allObjects][0] locationInView:self.window];
    self.viewPoint = self.frame.origin;
    _volume = [MPMusicPlayerController iPodMusicPlayer].volume;
    _brightness = [UIScreen mainScreen].brightness;
    _currentTime = self.slDuration.value;
    _isChangeForward = _isChangeVolume = NO;
    _isTouch = YES;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    _isChangeForward = _isChangeVolume = NO;
    _isTouch = NO;
    if (_isFullScreen) {
        [self hidePanelForward];
        if (_isChangeForward) {
            NowPlayerVC *nowVC = APPDELEGATE.nowPlayerVC;
            [nowVC.player beginScrubbing];
            [nowVC.player scrub];
            [nowVC.player endScrubbing];
        }
        
        _isChangeForward = _isChangeVolume = NO;
        return;
    }
    _isAnimation = NO;
    CGRect rect = self.frame;
    
    if ((rect.origin.x <= 50 || rect.origin.x > SCREEN_SIZE.width - 50) && rect.origin.y == SCREEN_SIZE.height - 60 - HEIGHT_MINI) {
        [self hiddenPlayer];
        
        return;
    }
    
    if (rect.origin.y >= SCREEN_SIZE.height/2)
    {
        rect.origin.y = SCREEN_SIZE.height;
        [self youtubeAnimationMinimize:YES];
    }
    else
    {
        rect.origin.y = 0;
        [self youtubeAnimationMaximize:YES];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    _isTouch = NO;
    if (_isFullScreen) {
        [self hidePanelForward];
        if (_isChangeForward) {
            NowPlayerVC *nowVC = APPDELEGATE.nowPlayerVC;
            [nowVC.player beginScrubbing];
            [nowVC.player scrub];
            [nowVC.player endScrubbing];
        }
        
        _isChangeForward = _isChangeVolume = NO;
        return;
    }
    _isAnimation = NO;
    CGRect rect = self.frame;
    
    if ((rect.origin.x <= 50 || rect.origin.x > SCREEN_SIZE.width - 50) && rect.origin.y == SCREEN_SIZE.height - 60 - HEIGHT_MINI) {
        [self hiddenPlayer];
        
        return;
    }
    
    if (rect.origin.y >= 50)
        {
            rect.origin.y = SCREEN_SIZE.height;
            [self youtubeAnimationMinimize:YES];
        
    } else {
        rect.origin.y = 0;
        [self youtubeAnimationMaximize:YES];
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    _isTouch = YES;
    if (!_isFullScreen) {
        [self touchesMovedOnPlayerView:touches withEvent:event];
    }else{
        [self touchesMovedOnPlayerViewLandscape:touches withEvent:event];
    }
}
-(direction)calculateDirectionFromTouches {
    NSInteger xDisplacement = self.lastTouch.x-self.startTouch.x;
    NSInteger yDisplacement = self.lastTouch.y-self.startTouch.y;
    
//    double x = fabs((double)xDisplacement);
//    double y = fabs((double)yDisplacement);
//    if (x <= 10 || y <= 10 ) {
//        return Default;
//    }
    
    float angle = atan2(xDisplacement, yDisplacement);
    int octant = (int)(round(8 * angle / (2 * M_PI) + 8)) % 8;
    
    return ((direction) octant);
}
-(void)touchesMovedOnPlayerView:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint lastTouchCoordinates = [[[touches allObjects] lastObject] locationInView:self.window];
    self.lastTouch = lastTouchCoordinates;
    float alpha = 0;
    UIView *mainView = [self.superview viewWithTag:kMainViewTag];
    UIView *overView = [self.superview viewWithTag:kOverViewTag];
    
    direction dir = [self calculateDirectionFromTouches];
    if (dir == Default) {
        return;
    }
    if (dir != Left && dir != Right && !_slideLeftRight) {
        float gPoint = self.viewPoint.y + (self.lastTouch.y - self.startTouch.y);
        if (gPoint < ORIGIN_Y || gPoint > SCREEN_SIZE.height - 60 - HEIGHT_MINI) {
            return;
        }
        alpha = 1 - (MIN(1, gPoint / (SCREEN_SIZE.height - 60 - HEIGHT_MINI)));
        CGRect frame = self.frame;
        frame.origin.y = gPoint;
        frame.origin.x = (SCREEN_WIDTH - 5 - WIDTH_MINI) * (1 - alpha);
        frame.size.width = SCREEN_WIDTH - (1 - alpha) * WIDTH_MINI;
        frame.size.height = height_player - (1 - alpha) * HEIGHT_MINI;
        self.frame = frame;
        
        frame = mainView.frame;
        frame.origin.x = self.frame.origin.x;
        frame.origin.y = self.frame.origin.y + self.frame.size.height;
        mainView.frame = frame;
        if (alpha < 0) {
            alpha = 0;
        }
        mainView.alpha = alpha;
        overView.alpha = alpha;
        if (!self.isControlsHidden) {
            [self setControlsHidden:YES autoHide:YES];
        }
    }else if (self.frame.origin.y == SCREEN_SIZE.height - 60 - HEIGHT_MINI){
        _slideLeftRight = YES;
        float gPoint = self.viewPoint.x - fabs(self.startTouch.x - self.lastTouch.x);
        CGRect frame = self.frame;
        frame.origin.x = self.viewPoint.x - (self.startTouch.x - self.lastTouch.x);;
        frame.origin.y = SCREEN_SIZE.height - 60 - HEIGHT_MINI;
        self.frame = frame;
        alpha = (MIN(1, gPoint / self.viewPoint.x));
        if (alpha < 0.2f) {
            alpha = 0.2f;
        }
        self.alpha = alpha;
    }
}

-(void)touchesMovedOnPlayerViewLandscape:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint lastTouchCoordinates = [touch locationInView:self.window];
    self.lastTouch = lastTouchCoordinates;
    direction dir = [self calculateDirectionFromTouches];
    if (dir == Up || dir == Down) {
        float alpha = 0;
        float gPoint = self.startTouch.y - self.lastTouch.y;
        if (ABS(gPoint) < 20 || _isChangeForward) {
            return;
        }
        _isChangeVolume  = YES;
        alpha = gPoint / SCREEN_SIZE.height;
        if (lastTouchCoordinates.x > SCREEN_SIZE.width/2) {
            float delta = _volume + alpha;
            if (delta > 1) {
                delta = 1;
            }else if(delta < 0){
                delta = 0;
            }
            [MPMusicPlayerController iPodMusicPlayer].volume = delta;
        }else{
            float delta = _brightness + alpha;
            if (delta > 1) {
                delta = 1;
            }else if(delta < 0){
                delta = 0;
            }
            [[UIScreen mainScreen] setBrightness:delta];
            [self showBrightnessView:delta];
        }
        
    }else if (dir == Left || dir == Right){
         NowPlayerVC *nowVC  = APPDELEGATE.nowPlayerVC;
        //_isShowPanelForward = YES;
        static float temp = 0;
        float alpha = 0;
        float gPoint = self.lastTouch.x - self.startTouch.x;
        if (ABS(gPoint) < 20 || _isChangeVolume) {
            return;
        }
        _isChangeForward = YES;
        alpha = (gPoint / SCREEN_SIZE.width)* SCREEN_WIDTH/CMTimeGetSeconds(nowVC.player.timeDuration);
        float delta = _currentTime + alpha;
        if (delta > 1) {
            delta = 1;
        }else if(delta < 0){
            delta = 0;
        }
        
        self.slDuration.value = delta;
       
        if (nowVC && [nowVC.player isPlaying]) {
            [nowVC.player pause];
        }
        [self showPanelForward:delta isForward:((temp < delta) ? YES : NO)];
        temp = delta;
    }
    
}

- (void)showBrightnessView:(float)progress{
    BrightnessView *view = (BrightnessView*)[self viewWithTag:666];
    if (!view) {
        view = [[BrightnessView alloc] initWithFrame:CGRectMake(0, 0, 155, 155)];
        view.backgroundColor = [UIColor clearColor];
        view.tag = 666;
        view.userInteractionEnabled = YES;
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)];
        [img setImage:[UIImage imageNamed:@"brightness_bg"]];
        img.userInteractionEnabled = YES;
        [view addSubview:img];
        
        F3BarGauge *progressView = [[F3BarGauge alloc] initWithFrame:CGRectMake(13, 132, 135, 7)];
        progressView.tag = 10;
        progressView.numBars = 16;
        progressView.litEffect = NO;
        UIColor *clrBar = RGB(255, 255, 255);
        progressView.normalBarColor = clrBar;
        progressView.warningBarColor = clrBar;
        progressView.dangerBarColor = clrBar;
        progressView.backgroundColor = [UIColor blackColor];
        progressView.outerBorderColor = [UIColor clearColor];
        progressView.innerBorderColor = [UIColor clearColor];
        [view addSubview:progressView];
        
        [self addSubview:view];
    }
    F3BarGauge *progressView = (F3BarGauge*)[view viewWithTag:10];
    progressView.value = progress;
    
    view.hidden = NO;
    view.alpha = 1.0f;
    view.center = self.center;
    [view.layer removeAllAnimations];
    [UIView animateWithDuration:2.0f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            view.hidden = YES;
        }
    }];
}

- (void)hidePanelForward{
    UIView *view = (UIView*)[self viewWithTag:777];
    if (view) {
        NowPlayerVC *nowVC  = APPDELEGATE.nowPlayerVC;
        if (nowVC) {
            [nowVC.player play];
        }
        [UIView animateWithDuration:1.0f delay:0 options:0 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                view.hidden = YES;
                _isShowPanelForward = NO;
            }
        }];
    }
}
- (void)showPanelForward:(float)progress isForward:(BOOL)isForward{
    //_isShowPanelForward = YES;
    UIView *view = (UIView*)[self viewWithTag:777];
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
        view.backgroundColor = [UIColor clearColor];
        view.tag = 777;
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)];
        img.backgroundColor = [UIColor blackColor];
        img.alpha = 0.7f;
        img.layer.cornerRadius = 3.0f;
        [view addSubview:img];
        
        UIImageView *imgWard = [[UIImageView alloc] initWithFrame:CGRectMake(56, 8, 19, 15)];
        imgWard.tag = 10;
        [view addSubview:imgWard];
        
        UILabel *lbCur = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 65, 10)];
        lbCur.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        lbCur.textColor = [UIColor whiteColor];
        lbCur.font = [UIFont systemFontOfSize:8.0f];
        lbCur.text = @"00:00:00";
        lbCur.textAlignment = NSTextAlignmentRight;
        lbCur.backgroundColor = [UIColor clearColor];
        //[lbCur sizeToFit];
        lbCur.tag = 11;
        [view addSubview:lbCur];
        
        UILabel *lbDur = [[UILabel alloc] initWithFrame:CGRectMake(lbCur.frame.origin.x + lbCur.frame.size.width, 30, 65, 10)];
        lbDur.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        lbDur.textColor = COLOR_MAIN_BLUE;
        lbDur.font = [UIFont systemFontOfSize:8.0f];
        lbDur.text = @"00:00:00";
        lbDur.textAlignment = NSTextAlignmentLeft;
        lbDur.backgroundColor = [UIColor clearColor];
        //[lbDur sizeToFit];
        lbDur.tag = 12;
        [view addSubview:lbDur];
        
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 50, 110, 2)];
        progressView.progress = 0.0f;
        progressView.tag = 13;
        [view addSubview:progressView];
        [self addSubview:view];
    }
    UIImageView *ward = (UIImageView*)[view viewWithTag:10];
    [ward setImage:[UIImage imageNamed:(isForward ? @"icon_forward" : @"icon_backward")]];
    UIProgressView *pView = (UIProgressView*)[view viewWithTag:13];
    pView.progress = progress;
    
    UILabel *lbCur = (UILabel*)[view viewWithTag:11];
    UILabel *lbDur = (UILabel*)[view viewWithTag:12];
    NowPlayerVC *nowVC  = APPDELEGATE.nowPlayerVC;
    if (nowVC) {
        CMTime duration = nowVC.player.timeDuration;
        NSString *total = [NSString stringWithFormat:@" %@", [self getStringFromCMTime:duration]];
        lbDur.text = total;
        CMTime current = CMTimeMake(duration.value*progress, duration.timescale);
        NSString *time = [NSString stringWithFormat:@"%@ /", [self getStringFromCMTime:current]];
        lbCur.text = time;
    }
    view.hidden = NO;
    view.alpha = 1.0f;
    view.center = CGPointMake(self.center.x, self.center.y - 90);
    [view.layer removeAllAnimations];
}

-(NSString*)getStringFromCMTime:(CMTime)time
{
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
    int hour = mins/60.0;
    if (hour > 0) {
        mins = mins % 60;
    }
    int secs = fmodf(currentSeconds, 60.0);
    NSString *hourString = hour < 10 ? [NSString stringWithFormat:@"0%d", hour] : [NSString stringWithFormat:@"%d", hour];
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    return [NSString stringWithFormat:@"%@:%@:%@", hourString, minsString, secsString];
}

#pragma mark - Orientation
- (void)performOrientationChange:(UIInterfaceOrientation)deviceOrientation {
    if (_isAnimation) {
        return;
    }
    if (UIInterfaceOrientationIsPortrait(deviceOrientation) && !self.isMinimize) {
        UIView *mainView = [self.superview viewWithTag:kMainViewTag];
        mainView.alpha = 1.0f;
        mainView.frame = CGRectMake(0, ORIGIN_Y + height_player, SCREEN_WIDTH, SCREEN_SIZE.height - ORIGIN_Y - height_player);
    }else if (UIInterfaceOrientationIsLandscape(deviceOrientation)){
        self.isMinimize = NO;
    }
    //[self refresh];
}

- (void)refresh{
    _isAnimationMore = NO;
    _isShowMore = NO;
    
    
    NowPlayerVC *nowVC = APPDELEGATE.nowPlayerVC;
    NSArray *lstVideo = nowVC.lstVideo;
    if (lstVideo.count == 1) {
        _btnTabChooseVideo.hidden = YES;
        _btnTabDescVideo.translatesAutoresizingMaskIntoConstraints = YES;
        CGRect frame = _btnTabDescVideo.frame;
        frame.origin.y = 15;
        _btnTabDescVideo.frame = frame;
        _btnTabDownloadVideo.translatesAutoresizingMaskIntoConstraints = YES;
        frame = _btnTabDownloadVideo.frame;
        frame.origin.y = 60;
        _btnTabDownloadVideo.frame = frame;
    }else{
        _btnTabChooseVideo.hidden = NO;
        _btnTabDescVideo.translatesAutoresizingMaskIntoConstraints = YES;
        CGRect frame = _btnTabDescVideo.frame;
        frame.origin.y = 40;
        _btnTabDescVideo.frame = frame;
        _btnTabDownloadVideo.translatesAutoresizingMaskIntoConstraints = YES;
        frame = _btnTabDownloadVideo.frame;
        frame.origin.y = 78;
        _btnTabDownloadVideo.frame = frame;
    }

    if (_chooseVideo) {
        [_chooseVideo viewDidAppear:NO];
    }
//    if (_downloadVideo) {
//        [_downloadVideo viewDidAppear:NO];
//    }
//    if (_detailVideo) {
//        [_detailVideo viewDidAppear:NO];
//    }
    
}

#pragma mark - animation
- (void)youtubeAnimationMaximize:(BOOL)animated{
    if (_isAnimation) {
        return;
    }
    
    _isAnimation = YES;
    _lblTitle.hidden = NO;
    UIView *overView = [self.superview viewWithTag:kOverViewTag];
    UIView *mainView = [self.superview viewWithTag:kMainViewTag];
    CGRect frame = mainView.frame;
    frame.origin.x = self.maximizeFrame.origin.x;
    frame.origin.y = self.maximizeFrame.origin.y + height_player;
    float duration = animated ? 0.3f : 0.0f;
    [UIView animateWithDuration:duration animations:^{
        self.frame = self.maximizeFrame;
        self.alpha = 1.0f;
        overView.alpha = 1.0f;
        mainView.frame = frame;
        mainView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            _isAnimation = NO;
            self.isMinimize = NO;
            _slideLeftRight = NO;
            [APPDELEGATE addNowPlayingViewController];
        }
    }];
}
- (void)youtubeAnimationMinimize:(BOOL)animated{
    if (_isAnimation) {
        return;
    }
    _isAnimation = YES;
    _lblTitle.hidden = YES;
    UIView *overView = [self.superview viewWithTag:kOverViewTag];
    UIView *mainView = [self.superview viewWithTag:kMainViewTag];
    CGRect frame = mainView.frame;
    frame.origin.x = self.minimizeFrame.origin.x;
    frame.origin.y = self.minimizeFrame.origin.y + HEIGHT_MINI;
    float duration = animated ? 0.3f : 0.0f;
    [UIView animateWithDuration:duration animations:^{
        self.frame = self.minimizeFrame;
        MAKESHADOW(self);
//        self.viewControls.alpha = 0.0f;
        self.alpha = 1.0f;
        overView.alpha = 0.0f;
        mainView.frame = frame;
        mainView.alpha = .0f;
    } completion:^(BOOL finished) {
        if (finished) {
            _isAnimation = NO;
            self.isMinimize = YES;
            _slideLeftRight = NO;
            [APPDELEGATE addNowPlayingViewController];
        }
    }];
}

- (void)hiddenPlayer{
    CGRect frame = self.frame;
    if (frame.origin.x > SCREEN_SIZE.width - 50) {
        frame.origin.x = SCREEN_SIZE.width;
    }else{
        frame.origin.x = - self.frame.size.width;
    }
    [UIView animateWithDuration:0.2f animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            self.isMinimize = NO;
            APPDELEGATE.nowPlayerVC.isShowNowPlaying = NO;
            [APPDELEGATE.nowPlayerVC stopPlayer];
            [APPDELEGATE.nowPlayerVC showPlayer:NO withAnimation:NO];
            [self youtubeAnimationMaximize:NO];
        }
    }];
}
- (IBAction)btnZomTapped:(id)sender {
    [APPDELEGATE.nowPlayerVC.player btnZoom_Tapped];
}

- (void)btnMinimize_Tapped{
    if (_isFullScreen) {
        return;
    }
    if (!self.isControlsHidden) {
        [self setControlsHidden:YES autoHide:YES];
    }
    [self youtubeAnimationMinimize:YES];
}
//- (IBAction)btnWatchLaterAction:(id)sender {
//    [self showLoginView];
//}

- (IBAction)btnDownload_Tapped:(id)sender {
    [APPDELEGATE.nowPlayerVC trackEvent:@"iOS_video_download"];
    if ([[DownloadManager sharedInstance] videoIsDownloaded:APPDELEGATE.nowPlayerVC.currentVideo withQuality:nil]) {
        NSString *mess = @"Đã được tải về.";
        [APPDELEGATE showToastWithMessage:mess position:@"top" type:errorImage];
        return;
    }
    if ([[DownloadManager sharedInstance] videoIsInListDownloading:APPDELEGATE.nowPlayerVC.currentVideo]) {
        NSString *mess = @"Đang được tải về.";
        [APPDELEGATE showToastWithMessage:mess position:@"top" type:errorImage];
        return;
    }
    if (!self.popoverView) {
        NSArray *arrayQuality = APPDELEGATE.nowPlayerVC.currentVideo.videoStream.streamDownloads;
        if (arrayQuality.count > 1) {
            self.popoverView = [[FWTPopoverView alloc] init];
            for (int i = 0; i < arrayQuality.count; i++) {
                QualityURL *qlt = [arrayQuality objectAtIndex:i];
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*40, 70, 40)];
                btn.backgroundColor = [UIColor clearColor];
                [btn setTitle:qlt.type forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont fontWithName:kFontRegular size:15];
                [self.popoverView.contentView addSubview:btn];
                btn.clipsToBounds = YES;
                btn.layer.cornerRadius = 5.0;
                [btn addTarget:self action:@selector(btnQualityDownAction:) forControlEvents:UIControlEventTouchUpInside];
                if (i < arrayQuality.count -1) {
                    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, btn.frame.size.height-0.5, btn.frame.size.width, 0.5)];
                    line.backgroundColor = RGBA(240, 240, 240, 0.1);
                    [btn addSubview:line];
                }
            }
            
            self.popoverView.contentSize = CGSizeMake(70, arrayQuality.count *40);
            [self.popoverView presentFromRect:CGRectMake(self.btnDownload.frame.origin.x, self.btnDownload.frame.origin.y, self.btnDownload.frame.size.width, self.btnDownload.frame.size.height)
                                            inView:self
                           permittedArrowDirection:FWTPopoverArrowDirectionUp
                                          animated:YES];
        } else if (arrayQuality.count == 1){
            QualityURL *qlt = [arrayQuality firstObject];
            NSString *linkDownload = qlt.link;
            if (linkDownload) {
//                APPDELEGATE.nowPlayerVC.currentVideo.type_quality = qlt.type;
//                APPDELEGATE.nowPlayerVC.currentVideo.link_down = linkDownload;
                NSDictionary *dict = @{@"qualityDownload":qlt};
                [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadVideoCurrentNotification object:nil userInfo:dict];
            }
        }
    }
}

- (void)btnQualityDownAction:(id)sender {
    UIButton *btn = (UIButton*)sender;
    NSArray *arrayQuality = APPDELEGATE.nowPlayerVC.currentVideo.videoStream.streamDownloads;
    for (QualityURL *qlt in arrayQuality) {
        if ([btn.titleLabel.text isEqualToString:qlt.type]) {
            NSString *linkDownload = qlt.link;
            if (linkDownload) {
                NSDictionary *dict = @{@"qualityDownload":qlt};
                [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadVideoCurrentNotification object:nil userInfo:dict];
            }
            break;
        }
    }
    [self.popoverView dismissPopoverAnimated:YES];
}

- (void)didTappedButtonIndex:(int)index object:(id)object linkShare:(NSString *)linkShare title:(NSString *)title{
    if (index == 1 || index == 2) {
        if (APPDELEGATE.nowPlayerVC.currentVideo.link_down) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadVideoCurrentNotification object:nil];
        }
    }
}


#pragma mark - page view controller
- (void)initPagesViewController{
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.viewMoreContainer.frame.size.width, self.viewMoreContainer.frame.size.height);
    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    [self.pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [APPDELEGATE.nowPlayerVC addChildViewController:self.pageViewController];
    [self.viewMoreContainer addSubview:self.pageViewController.view];
    [self addPageControl];
    [self updateSegmentControl];
    for (UIScrollView *view in self.pageViewController.view.subviews) {
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            
            view.scrollEnabled = NO;
        }
    }
}

- (void)addPageControl{
    NSMutableArray *pages = [NSMutableArray new];
    _chooseVideo = [[ListVideoFullScreenController alloc]initWithNibName:@"ListVideoFullScreenController" bundle:nil];
    _chooseVideo.curIndexVideoChoose = (int)APPDELEGATE.nowPlayerVC.curIndexVideoChoose;
    [pages addObject:_chooseVideo];
//    _detailVideo = [[VideoDetailLandscapeVC alloc] initWithNibName:@"VideoDetailLandscapeVC" bundle:nil];
//    [_detailVideo.view setBackgroundColor:[UIColor clearColor]];
//    [pages addObject:_detailVideo];
//    _downloadVideo = [[VideoDownloadLandscapeVC alloc] initWithNibName:@"VideoDownloadLandscapeVC" bundle:nil];
//    [_downloadVideo.view setBackgroundColor:[UIColor clearColor]];
//    [pages addObject:_downloadVideo];
    [self setPages:pages];
}


- (void)updateSegmentControl{
    if ([self.pages count]>0) {
        [self.pageViewController setViewControllers:@[self.pages[0]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:NULL];
    }
}



- (NSMutableArray *)pages
{
    if (!_pages)_pages = [NSMutableArray new];
    return _pages;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    return self.pages[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound)||(index+1 >= [self.pages count])) {
        return nil;
    }
    
    return self.pages[++index];
}


- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed){
        return;
    }
    
    //    [self.pageControl setSelectedSegmentIndex:[self.pages indexOfObject:[viewController.viewControllers lastObject]] animated:YES];
}


- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index < [self.pages count]) {
        [self.pageViewController setViewControllers:@[self.pages[index]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:animated
                                         completion:NULL];
    }
}

- (IBAction)changeTab:(UIButton*)button{
    NSInteger tag = button.tag;
    if (_isShowMore && tag == _currentTag) {
        [self hideMoreView];
        [self hilightButtonWithTag:-1];
        return;
    }
    [self.pageViewController setViewControllers:@[self.pages[0]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:NULL];
    _currentTag = tag;
    [self hilightButtonWithTag:tag];
    [self showMoreView];
    
    NSString *screenName = nil;
    if (tag == 100) {
        screenName = @"iOS.VideoFullScreen.ChooseVideo";
        [_chooseVideo loadDataIsAnimation:NO];
    }
//    else if (tag == 101) {
//        screenName = @"iOS.VideoFullScreen.VideoDescription";
//        [_detailVideo loadData];
//    } else{
//        screenName = @"iOS.VideoFullScreen.ChooseVideoDownload";
//        [_downloadVideo loadData];
//    }
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:screenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kToggleShowTabVideoDetailLandscape object:nil];
}
- (void)hilightButtonWithTag:(NSInteger)tag{
    for (UIView *view in [self.viewMoreButtons subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)view;
            if (tag == button.tag) {
                button.selected = YES;
            }else{
                button.selected = NO;
            }
        }
    }
}

- (void)showMoreView{
    if (_isAnimationMore || _isShowMore) {
        return;
    }
    _isAnimationMore = YES;
    _isShowMore = YES;
    self.viewMore.frame = CGRectMake(CGRectGetWidth(self.superview.frame) - 30, 0, self.viewMore.frame.size.width, self.viewMore.frame.size.height);
    self.hidden = NO;
    CGRect frame = CGRectMake(CGRectGetWidth(self.frame) - 375, 0, self.viewMore.frame.size.width, self.viewMore.frame.size.height);
    [UIView animateWithDuration:0.5f animations:^{
        self.viewMore.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            _isShowMore = YES;
            _isAnimationMore = NO;
        }
    }];
}

- (void)hideMoreView{
    if (_isAnimationMore || !_isShowMore) {
        return;
    }
    _isAnimationMore = YES;
    _isShowMore = NO;

    CGRect frame = CGRectMake(CGRectGetWidth(self.frame) - 30, 0, self.viewMore.frame.size.width, self.viewMore.frame.size.height);
    [UIView animateWithDuration:0.5f animations:^{
        self.viewMore.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            _isShowMore = NO;
            _isAnimationMore = NO;
            [self setControlsHidden:YES autoHide:YES];
            [self hilightButtonWithTag:-1];
        }
    }];
}

- (IBAction)btnLock_Tapped:(id)sender {
    BOOL isOn = !_btnLock.isSelected;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:isOn] forKey:SETTING_LOCK_ROTATION];
    [defaults synchronize];
    _btnLock.selected = isOn;
}
@end
