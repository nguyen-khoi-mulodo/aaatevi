//
//  NPVideoPlayerView.m
//  NPlus
//
//  Created by Anh Le Duc on 9/5/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "NPVideoPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+VKFoundation.h"
#import "F3BarGauge.h"
#define kPlayerControlsAutoHideTime    5
#define kOverViewTag    100
#define kMainViewTag    200
#define MAKESHADOW(a) a.layer.shadowColor = [UIColor blackColor].CGColor; a.layer.shadowOpacity = 0.5f; a.layer.shadowOffset = CGSizeMake(0.0f, 1.0f); a.layer.shadowRadius = 1.0f; UIBezierPath *path = [UIBezierPath bezierPathWithRect:a.bounds]; a.layer.shadowPath = path.CGPath;
typedef NS_ENUM(NSInteger, direction) {
    Down = 0, DownRight = 1,
    Right = 2, UpRight = 3,
    Up = 4, UpLeft = 5,
    Left = 6, DownLeft = 7
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

@interface NPVideoPlayerView()<UIGestureRecognizerDelegate>{
    BOOL _isShowSetting;
    BOOL _isShowVolume;
    NSMutableArray *_lstView;
    BOOL _panningProgress;
    BOOL _isFullScreen;
    BOOL _slideLeftRight;
    BOOL _isChangeForward, _isChangeVolume;
    float _volume, _brightness, _currentTime;
}
@property (nonatomic) CGPoint startTouch;
@property (nonatomic) CGPoint lastTouch;
@property (nonatomic) CGPoint viewPoint;
@property (nonatomic, assign) CGRect minimizeFrame;
@property (nonatomic, assign) CGRect maximizeFrame;
@end
@implementation NPVideoPlayerView
@synthesize viewBottom, btnVerticalPlay, slDuration, lbTimeDuration, lbTotalDuration, btnZoom;
@synthesize parentController = _parentController;
@synthesize delegate = _delegate;
@synthesize isMinimize = _isMinimize;
@synthesize isAnimation = _isAnimation;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.minimizeFrame = CGRectMake(155, SCREEN_SIZE.height - 50 - 100, 160, 90);
        self.maximizeFrame = CGRectMake(0, ORIGIN_Y, 320, 180);
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
        [self initGesture];
        [self initObserver];
    }
    return self;
}

- (void)initUserInterface{
    self.playerLayerView = [[NPVideoPlayerLayerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.playerLayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                            UIViewAutoresizingFlexibleHeight |
                                                UIViewAutoresizingFlexibleRightMargin |
                                                    UIViewAutoresizingFlexibleLeftMargin |
                                                        UIViewAutoresizingFlexibleBottomMargin |
                                                            UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:self.playerLayerView];
//    self.playerLayerView.hidden = YES;
    
    self.viewControls = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.viewControls setAutoresizesSubviews:YES];
    self.viewControls.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                            UIViewAutoresizingFlexibleHeight |
                                            UIViewAutoresizingFlexibleRightMargin |
                                            UIViewAutoresizingFlexibleLeftMargin |
                                            UIViewAutoresizingFlexibleBottomMargin |
                                            UIViewAutoresizingFlexibleTopMargin;
    self.viewControls.backgroundColor = [UIColor clearColor];
    self.viewControls.alpha = 1.0f;
    [self addSubview:self.viewControls];
    
    self.viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 30, 320, 30)];
    self.viewBottom.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.viewBottom.backgroundColor = [UIColor clearColor];
    [self.viewControls addSubview:self.viewBottom];
    
    UIButton *overBottom = [UIButton buttonWithType:UIButtonTypeCustom];
    overBottom.frame = CGRectMake(0, 0, 320, 30);
    overBottom.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    overBottom.backgroundColor = [UIColor blackColor];
    overBottom.alpha = 0.6f;
    [self.viewBottom addSubview:overBottom];
    
    self.btnVerticalPlay = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    self.btnVerticalPlay.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.btnVerticalPlay setImage:[UIImage imageNamed:@"playing_pause_btn_dung_hover"] forState:UIControlStateHighlighted];
    [self.btnVerticalPlay setImage:[UIImage imageNamed:@"playing_pause_btn_dung"] forState:UIControlStateNormal];
    [self.btnVerticalPlay addTarget:self action:@selector(btnPlay_Tapped:) forControlEvents:UIControlEventTouchUpInside];
    self.btnVerticalPlay.backgroundColor = [UIColor clearColor];
    [self.viewBottom addSubview:self.btnVerticalPlay];
    
    self.lbTimeDuration = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width - 125, 2, 220, 30)];
    self.lbTimeDuration.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    self.lbTimeDuration.textColor = [UIColor whiteColor];
    self.lbTimeDuration.font = [UIFont systemFontOfSize:8.0f];
    self.lbTimeDuration.text = @"00:00:00 /";
    self.lbTimeDuration.textAlignment = NSTextAlignmentRight;
    self.lbTimeDuration.backgroundColor = [UIColor clearColor];
    [self.lbTimeDuration sizeToFit];
    [self.viewBottom addSubview:self.lbTimeDuration];
    
    self.lbTotalDuration = [[UILabel alloc] initWithFrame:CGRectMake(self.lbTimeDuration.frame.origin.x + self.lbTimeDuration.frame.size.width, 2, 220, 30)];
    self.lbTotalDuration.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    self.lbTotalDuration.textColor = COLOR_MAIN_BLUE;
    self.lbTotalDuration.font = [UIFont systemFontOfSize:8.0f];
    self.lbTotalDuration.text = @" 00:00:00";
    self.lbTotalDuration.textAlignment = NSTextAlignmentLeft;
    self.lbTotalDuration.backgroundColor = [UIColor clearColor];
    [self.lbTotalDuration sizeToFit];
    [self.viewBottom addSubview:self.lbTotalDuration];
    
    self.slDuration = [[UISlider alloc] initWithFrame:CGRectMake(50, 0, 220, 30)];
    self.slDuration.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIImage *minImage = [[UIImage imageNamed:@"playing_progressbar_playing"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *maxImage = [[UIImage imageNamed:@"playing_progressbar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [self.slDuration setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [self.slDuration setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [self.slDuration setThumbImage:[UIImage imageNamed:@"playing_cham_tron"] forState:UIControlStateNormal];
    self.slDuration.minimumValue = 0.0f;
    self.slDuration.maximumValue = 1.0f;
    [self.slDuration addTarget:self action:@selector(beginScrubbing:) forControlEvents:UIControlEventTouchDown];
    [self.slDuration addTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchCancel];
    [self.slDuration addTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchUpInside];
    [self.slDuration addTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchUpOutside];
    [self.slDuration addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventTouchDragInside];
    [self.viewBottom addSubview:self.slDuration];
    
    self.btnZoom = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width - 50, 0, 50, 30)];
    self.btnZoom.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.btnZoom setImage:[UIImage imageNamed:@"playing_icon_phongto_hover"] forState:UIControlStateHighlighted];
    [self.btnZoom setImage:[UIImage imageNamed:@"playing_icon_phongto"] forState:UIControlStateNormal];
    [self.btnZoom addTarget:self action:@selector(btnZoom_Tapped:) forControlEvents:UIControlEventTouchUpInside];
    self.btnZoom.backgroundColor = [UIColor clearColor];
//    self.btnZoom.hidden = YES;
    [self.viewBottom addSubview:self.btnZoom];
    
    self.viewCenter = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 35, 255, 180)];
    self.viewCenter.backgroundColor = [UIColor clearColor];
    [self.viewControls addSubview:self.viewCenter];
    self.viewCenter.hidden = YES;
    
    UIButton *imageView = [[UIButton alloc] initWithFrame:CGRectMake(0, self.viewCenter.frame.size.height - 61, 255, 61)];
    [imageView setImage:[UIImage imageNamed:@"playing_bg_now_playing"] forState:UIControlStateNormal];
    [imageView setImage:[UIImage imageNamed:@"playing_bg_now_playing"] forState:UIControlStateHighlighted];
    imageView.backgroundColor = [UIColor clearColor];
    [self.viewCenter addSubview:imageView];
    
    self.btnPlayCenter = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.btnPlayCenter setImage:[UIImage imageNamed:@"playing_pause_btn_nam_hover"] forState:UIControlStateHighlighted];
    [self.btnPlayCenter setImage:[UIImage imageNamed:@"playing_pause_btn_nam"] forState:UIControlStateNormal];
    self.btnPlayCenter.center = imageView.center;
    [self.btnPlayCenter addTarget:self action:@selector(btnPlay_Tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewCenter addSubview:self.btnPlayCenter];
    
    self.btnNext = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.btnNext setImage:[UIImage imageNamed:@"playing_next_btn_nam"] forState:UIControlStateHighlighted];
    [self.btnNext setImage:[UIImage imageNamed:@"playing_next_btn_nam"] forState:UIControlStateNormal];
    self.btnNext.center = CGPointMake(imageView.center.x + 60, imageView.center.y);
    self.btnNext.backgroundColor = [UIColor clearColor];
    [self.viewCenter addSubview:self.btnNext];
    
    self.btnPrevious = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.btnPrevious setImage:[UIImage imageNamed:@"playing_prev_btn_nam"] forState:UIControlStateHighlighted];
    [self.btnPrevious setImage:[UIImage imageNamed:@"playing_prev_btn_nam"] forState:UIControlStateNormal];
    self.btnPrevious.center = CGPointMake(imageView.center.x - 60, imageView.center.y);
    self.btnPrevious.backgroundColor = [UIColor clearColor];
    [self.viewCenter addSubview:self.btnPrevious];
    
    self.btnVolume = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.btnVolume setImage:[UIImage imageNamed:@"playing_volume_hover"] forState:UIControlStateHighlighted];
    [self.btnVolume setImage:[UIImage imageNamed:@"playing_volume"] forState:UIControlStateNormal];
    self.btnVolume.center = CGPointMake(imageView.center.x + 100, imageView.center.y);
    self.btnVolume.backgroundColor = [UIColor clearColor];
    [self.btnVolume addTarget:self action:@selector(toggleVolume:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewCenter addSubview:self.btnVolume];
    
    self.btnSetting = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.btnSetting setImage:[UIImage imageNamed:@"playing_setting_hover"] forState:UIControlStateHighlighted];
    [self.btnSetting setImage:[UIImage imageNamed:@"playing_setting"] forState:UIControlStateNormal];
    self.btnSetting.center = CGPointMake(imageView.center.x - 100, imageView.center.y);
    self.btnSetting.backgroundColor = [UIColor clearColor];
    [self.btnSetting addTarget:self action:@selector(toggleSetting:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewCenter addSubview:self.btnSetting];
    
    self.viewVolume = [[UIView alloc] initWithFrame:CGRectMake(175, 65, 100, 23)];
    self.viewVolume.alpha = .0f;
    self.viewVolume.backgroundColor = [UIColor clearColor];
    UIButton *backgroundVolume = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundVolume.frame = CGRectMake(0, 0, 100, 23);
    backgroundVolume.backgroundColor = [UIColor blackColor];
    backgroundVolume.alpha = 0.7f;
    backgroundVolume.layer.cornerRadius = 11.0f;
    self.viewVolume.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self.viewVolume addSubview:backgroundVolume];
    self.slVolume = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 80, 15)];
    self.slVolume.center = backgroundVolume.center;
    [self.slVolume setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [self.slVolume setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [self.slVolume setThumbImage:[UIImage imageNamed:@"playing_cham_tron"] forState:UIControlStateNormal];
    [self.slVolume addTarget:self action:@selector(volumeScrubbing:) forControlEvents:UIControlEventValueChanged];
    [self.viewVolume addSubview:self.slVolume];
    [_lstView addObject:self.viewVolume];
    [self.viewCenter addSubview:self.viewVolume];
    
    self.viewSetting = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 195, 70)];
    self.viewSetting.alpha = .0f;
    UIView *backgroundSetting = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 195, 70)];
    backgroundSetting.backgroundColor = [UIColor blackColor];
    backgroundSetting.alpha = 0.7f;
    backgroundSetting.layer.cornerRadius = 3.0f;
    [self.viewSetting addSubview:backgroundSetting];
    
    UIButton *btnViewSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    btnViewSetting.frame = backgroundSetting.frame;
    btnViewSetting.backgroundColor = [UIColor clearColor];
    [self.viewSetting addSubview:btnViewSetting];
    
    UILabel *lbQuality = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 100, 30)];
    lbQuality.text = @"Chất lượng:";
    lbQuality.font = [UIFont systemFontOfSize:12.0f];
    lbQuality.textColor = RGB(198, 198, 198);
    [lbQuality sizeToFit];
    CGRect frame = lbQuality.frame;
    frame.origin.x += 5;
    lbQuality.frame = frame;
    [self.viewSetting addSubview:lbQuality];
    UIButton *btn360 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn360 setTitle:@"360" forState:UIControlStateNormal];
    [btn360 setTitleColor:RGB(198, 198, 198) forState:UIControlStateNormal];
    [btn360 setTitleColor:COLOR_MAIN_BLUE forState:UIControlStateHighlighted];
    btn360.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    btn360.backgroundColor = [UIColor clearColor];
    [btn360 sizeToFit];
    frame = btn360.frame;
    frame.origin.x = lbQuality.frame.size.width + 10;
    frame.origin.y = 5;
    btn360.frame = frame;
    [self.viewSetting addSubview:btn360];
    
    UIButton *btn480 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn480 setTitle:@"480" forState:UIControlStateNormal];
    [btn480 setTitleColor:RGB(198, 198, 198) forState:UIControlStateNormal];
    [btn480 setTitleColor:COLOR_MAIN_BLUE forState:UIControlStateHighlighted];
    btn480.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    btn480.backgroundColor = [UIColor clearColor];
    [btn480 sizeToFit];
    frame = btn480.frame;
    frame.origin.x = btn360.frame.origin.x + btn360.frame.size.width;
    frame.origin.y = 5;
    btn480.frame = frame;
    [self.viewSetting addSubview:btn480];
    
    UIButton *btn720 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn720 setTitle:@"720" forState:UIControlStateNormal];
    [btn720 setTitleColor:RGB(198, 198, 198) forState:UIControlStateNormal];
    [btn720 setTitleColor:COLOR_MAIN_BLUE forState:UIControlStateHighlighted];
    btn720.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    btn720.backgroundColor = [UIColor clearColor];
    [btn720 sizeToFit];
    frame = btn720.frame;
    frame.origin.x = btn480.frame.origin.x + btn480.frame.size.width;
    frame.origin.y = 5;
    btn720.frame = frame;
    [self.viewSetting addSubview:btn720];
    
    UILabel *lbLock = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 100, 30)];
    lbLock.text = @"Khoá xoay màn hình";
    lbLock.font = [UIFont systemFontOfSize:12.0f];
    lbLock.textColor = RGB(198, 198, 198);
    [lbLock sizeToFit];
    frame = lbLock.frame;
    frame.origin.x += 5;
    lbLock.frame = frame;
    [self.viewSetting addSubview:lbLock];
    UIButton *btnLock = [[UIButton alloc] initWithFrame:CGRectMake(145, 40, 43, 18)];
    [btnLock setImage:[UIImage imageNamed:@"playing_khoamanhinh_off"] forState:UIControlStateNormal];
    [btnLock setImage:[UIImage imageNamed:@"playing_khoamanhinh_on"] forState:UIControlStateHighlighted];
    [btnLock setImage:[UIImage imageNamed:@"playing_khoamanhinh_on"] forState:UIControlStateSelected];
    btnLock.backgroundColor = [UIColor clearColor];
    [self.viewSetting addSubview:btnLock];
    [self.viewCenter addSubview:self.viewSetting];
    [_lstView addObject:self.viewSetting];
    frame = self.frame;
    self.viewHeaderLanscape = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
    self.viewHeaderLanscape.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    self.viewHeaderLanscape.backgroundColor = [UIColor clearColor];
    [self.viewControls addSubview:self.viewHeaderLanscape];
    
    
    
    UIButton *backgroundHeader = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundHeader.frame = CGRectMake(0, 0, frame.size.width, 30);
    backgroundHeader.backgroundColor = [UIColor blackColor];
    backgroundHeader.alpha = 0.6f;
    backgroundHeader.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.viewHeaderLanscape addSubview:backgroundHeader];
    
    self.btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [self.btnBack setImage:[UIImage imageNamed:@"icon_back_hover"] forState:UIControlStateHighlighted];
    [self.btnBack setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    self.btnBack.backgroundColor = [UIColor clearColor];
    [self.btnBack addTarget:self action:@selector(btnZoom_Tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewHeaderLanscape addSubview:self.btnBack];
    
    self.btnLike = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 100, 0, 50, 30)];
    self.btnLike.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.btnLike setImage:[UIImage imageNamed:@"playing_like_hover"] forState:UIControlStateHighlighted];
    [self.btnLike setImage:[UIImage imageNamed:@"playing_like"] forState:UIControlStateNormal];
    [self.viewHeaderLanscape addSubview:self.btnLike];
    
    self.btnShare = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 50, 0, 50, 30)];
    self.btnShare.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.btnShare setImage:[UIImage imageNamed:@"playing_share_hover"] forState:UIControlStateHighlighted];
    [self.btnShare setImage:[UIImage imageNamed:@"playing_share"] forState:UIControlStateNormal];
    [self.viewHeaderLanscape addSubview:self.btnShare];
    
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, frame.size.width - 100, 30)];
    self.lbTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    self.lbTitle.textColor = [UIColor whiteColor];
    self.lbTitle.font = [UIFont systemFontOfSize:14.0f];
    self.lbTitle.text = @"Thiên long bát bộ 2014 Thiên long bát bộ 2014 Thiên long bát bộ 2014 Thiên long bát bộ 2014";
    self.lbTitle.alpha = 0.8f;
    self.lbTitle.backgroundColor = [UIColor clearColor];
    self.lbTitle.textAlignment = NSTextAlignmentLeft;
    [self.viewHeaderLanscape addSubview:self.lbTitle];
    self.viewHeaderLanscape.hidden = YES;
    
    self.viewHeaderPortrait = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
    self.viewHeaderPortrait.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    self.viewHeaderPortrait.backgroundColor = [UIColor clearColor];
    [self.viewControls addSubview:self.viewHeaderPortrait];
    
    backgroundHeader = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundHeader.frame = CGRectMake(0, 0, frame.size.width, 30);
    backgroundHeader.backgroundColor = [UIColor blackColor];
    backgroundHeader.alpha = 0.6f;
    backgroundHeader.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.viewHeaderPortrait addSubview:backgroundHeader];
    
    self.btnMinimize = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
    self.btnMinimize.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self.btnMinimize addTarget:self action:@selector(btnMinimize_Tapped) forControlEvents:UIControlEventTouchUpInside];
    [self.btnMinimize setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    [self.btnMinimize setImage:[UIImage imageNamed:@"icon_back_hover"] forState:UIControlStateHighlighted];
    [self.viewHeaderPortrait addSubview:self.btnMinimize];
    
    self.btnShareP = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width - 40, 0, 30, 30)];
    [self.btnShareP setImage:[UIImage imageNamed:@"playing_share"] forState:UIControlStateNormal];
    [self.btnShareP setImage:[UIImage imageNamed:@"playing_share_hover"] forState:UIControlStateHighlighted];
    [self.viewHeaderPortrait addSubview:self.btnShareP];
    
    self.btnLikeP = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width - 90, 0, 30, 30)];
    [self.btnLikeP setImage:[UIImage imageNamed:@"playing_like"] forState:UIControlStateNormal];
    [self.btnLikeP setImage:[UIImage imageNamed:@"playing_like_hover"] forState:UIControlStateHighlighted];
    [self.viewHeaderPortrait addSubview:self.btnLikeP];
    
    self.btnDownload = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width - 150, 0, 30, 30)];
    [self.btnDownload setImage:[UIImage imageNamed:@"playing_download"] forState:UIControlStateNormal];
    [self.btnDownload setImage:[UIImage imageNamed:@"playing_download_hover"] forState:UIControlStateHighlighted];
    [self.btnDownload addTarget:self action:@selector(btnDownload_Tapped) forControlEvents:UIControlEventTouchUpInside];
    [self.viewHeaderPortrait addSubview:self.btnDownload];
    
    self.viewDetail = [[NPVideoPlayerDetailView alloc] initWithFrame:CGRectMake(0, 0, 375, 320)];
//    UIButton *btnViewDetail = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnViewDetail.frame = CGRectMake(30, 0, 345, 320);
//    btnViewDetail.backgroundColor = [UIColor yellowColor];
//    [self.viewDetail insertSubview:btnViewDetail atIndex:0];
    [self.viewControls addSubview:self.viewDetail];
    self.viewDetail.hidden = YES;
    
}

- (void)initObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideAllView) name:kToggleShowTabVideoDetailLandscape object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}
- (void)volumeChanged:(NSNotification *)notification
{
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    if (!_panningProgress) {
        [self.slVolume setValue:volume];
    }
}

- (void)initGesture{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapGesture.cancelsTouchesInView = YES;
    [self addGestureRecognizer:tapGesture];
}

- (void)handleSingleTap:(id)sender {
    if (self.isMinimize) {
        [self youtubeAnimationMaximize:YES];
        return;
    }
    if (self.viewDetail.isShow) {
        [self.viewDetail hideDetail];
        return;
    }
    [self setControlsHidden:!self.isControlsHidden];
    if (!self.isControlsHidden) {
        self.controlHideCountdown = kPlayerControlsAutoHideTime;
    }
}



- (void)hideControlsIfNecessary {
    if (self.isControlsHidden) return;
    if (self.controlHideCountdown == -1) {
        [self setControlsHidden:NO];
    } else if (self.controlHideCountdown == 0) {
        [self setControlsHidden:YES];
    } else {
        self.controlHideCountdown--;
    }
}

- (void)setControlsHidden:(BOOL)hidden {
    if (self.isControlsHidden != hidden) {
        self.isControlsHidden = hidden;
        if (hidden) {
            [self.viewControls fadeHide];
        }else{
            [self.viewControls fadeShow];
        }
//        self.viewControls.hidden  = hidden;
        [self hideAllView];
        [self showControl];
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
    [self showControl];
}


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
}

- (void)showControl{
//    self.playerLayerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    if (!_isFullScreen) {
        [self showControlVertical];
        [self.btnZoom setImage:[UIImage imageNamed:@"playing_icon_phongto_hover"] forState:UIControlStateHighlighted];
        [self.btnZoom setImage:[UIImage imageNamed:@"playing_icon_phongto"] forState:UIControlStateNormal];
    }else{
        [self showControlHorizontal];
        [self.btnZoom setImage:[UIImage imageNamed:@"playing_icon_thunho_hover"] forState:UIControlStateHighlighted];
        [self.btnZoom setImage:[UIImage imageNamed:@"playing_icon_thunho"] forState:UIControlStateNormal];
    }
}

- (void)showControlVertical{
    if (!self.isControlsHidden) {
        self.btnVerticalPlay.hidden = NO;
        self.viewCenter.hidden = YES;
        self.viewHeaderLanscape.hidden = YES;
        self.viewHeaderPortrait.hidden = NO;
        self.viewDetail.hidden = YES;
    }
}

- (void)showControlHorizontal{
    if (!self.isControlsHidden) {
        self.btnVerticalPlay.hidden = YES;
        self.viewCenter.hidden = NO;
        self.viewCenter.frame = CGRectMake(self.frame.size.width / 2 - 127, self.frame.size.height - 180 - 35, 255, 180);
        self.viewDetail.frame = CGRectMake(CGRectGetWidth(self.frame) - 30, 0, 375, 320);
        self.viewHeaderLanscape.hidden = NO;
        self.viewHeaderPortrait.hidden = YES;
        self.viewDetail.hidden = NO;
    }
}

- (void)showViewDetail{
    if (!_isFullScreen) {
        return;
    }
    self.viewDetail.frame = CGRectMake(CGRectGetWidth(self.frame) - 30, 0, 375, 320);
    self.viewDetail.hidden = NO;
    CGRect frame = CGRectMake(CGRectGetWidth(self.frame) - 375, 0, 375, 320);
    [UIView animateWithDuration:0.5f animations:^{
        self.viewDetail.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideViewDetail{
    if (!_isFullScreen) {
        return;
    }
    CGRect frame = CGRectMake(CGRectGetWidth(self.frame) - 30, 0, 375, 320);;
    [UIView animateWithDuration:0.5f animations:^{
        self.viewDetail.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
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
        [self.btnVerticalPlay setImage:[UIImage imageNamed:@"playing_play_btn_dung_hover"] forState:UIControlStateHighlighted];
        [self.btnVerticalPlay setImage:[UIImage imageNamed:@"playing_play_btn_dung"] forState:UIControlStateNormal];
        [self.btnPlayCenter setImage:[UIImage imageNamed:@"playing_play_btn_nam_hover"] forState:UIControlStateHighlighted];
        [self.btnPlayCenter setImage:[UIImage imageNamed:@"playing_play_btn_nam"] forState:UIControlStateNormal];
    }else{
        [self.btnVerticalPlay setImage:[UIImage imageNamed:@"playing_pause_btn_dung_hover"] forState:UIControlStateHighlighted];
        [self.btnVerticalPlay setImage:[UIImage imageNamed:@"playing_pause_btn_dung"] forState:UIControlStateNormal];
        [self.btnPlayCenter setImage:[UIImage imageNamed:@"playing_pause_btn_nam_hover"] forState:UIControlStateHighlighted];
        [self.btnPlayCenter setImage:[UIImage imageNamed:@"playing_pause_btn_nam"] forState:UIControlStateNormal];
    }
}

#pragma mark - action
- (void)btnPlay_Tapped:(UIButton*)button{
    if (_delegate && [_delegate respondsToSelector:@selector(btnPlay_Tapped)]) {
        [_delegate btnPlay_Tapped];
    }
}
- (void)btnZoom_Tapped:(UIButton*)button{
//    self.fullscreenButton.selected = !self.fullscreenButton.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(btnZoom_Tapped)]) {
        [_delegate btnZoom_Tapped];
    }
}

- (void)beginScrubbing:(UISlider*)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(beginScrubbing)]) {
        [_delegate beginScrubbing];
    }
}
- (void)scrub:(UISlider*)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(scrub)]) {
        [_delegate scrub];
    }
}
- (void)endScrubbing:(UISlider*)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(endScrubbing)]) {
        [_delegate endScrubbing];
    }
}
- (void)volumeScrubbing:(UISlider*)slider{
    [MPMusicPlayerController iPodMusicPlayer].volume = slider.value;
}

#pragma mark - button action
- (void)hideAllView{
    for (UIView *view in _lstView) {
        [view fadeHide];
    }
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
    self.viewControls.alpha = alpha;
}

#pragma mark - view detail 
-(void)setDelegateForViewDetail:(id)delegate{
    [self.viewDetail setDelegate:delegate];
}
-(void)setDataForTabChooseVideo:(NSArray *)data{
    [self.viewDetail.chooseVideo setListVideo:data];
}
-(void)setDataForTabDetailVideo:(NSString *)title withDescription:(NSString *)des{
    self.lbTitle.text = title;
    [self.viewDetail.detailVideo setDataTitle:title withDescription:des];
}
-(void)setDataForTabDownloadVideo:(NSArray *)data{
    [self.viewDetail.downloadVideo setListVideo:data];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kToggleShowTabVideoDetailLandscape object:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.startTouch = [[touches allObjects][0] locationInView:self.window];
    self.viewPoint = self.frame.origin;
    _volume = [MPMusicPlayerController iPodMusicPlayer].volume;
    _brightness = [UIScreen mainScreen].brightness;
    _currentTime = self.slDuration.value;
    _isChangeForward = _isChangeVolume = NO;
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    _isChangeForward = _isChangeVolume = NO;
    if (_isFullScreen) {
        return;
    }
    _isAnimation = NO;
    CGRect rect = self.frame;
    
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
    if (_isFullScreen) {
        if (_isChangeForward) {
            [self beginScrubbing:nil];
            [self scrub:nil];
            [self endScrubbing:nil];
        }
        [self hidePanelForward];
        _isChangeForward = _isChangeVolume = NO;
        return;
    }
    _isAnimation = NO;
    CGRect rect = self.frame;
    
    if (rect.origin.x <= 50 && rect.origin.y == SCREEN_SIZE.height - 150) {
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
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_isFullScreen) {
        [self touchesMovedOnPlayerView:touches withEvent:event];
    }else{
        [self touchesMovedOnPlayerViewLandscape:touches withEvent:event];
    }
}
-(direction)calculateDirectionFromTouches {
    NSInteger xDisplacement = self.lastTouch.x-self.startTouch.x;
    NSInteger yDisplacement = self.lastTouch.y-self.startTouch.y;
    
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
    if (dir != Left && dir != Right && !_slideLeftRight) {
        float gPoint = self.viewPoint.y + (self.lastTouch.y - self.startTouch.y);
        if (gPoint < ORIGIN_Y || gPoint > SCREEN_SIZE.height - 150) {
            return;
        }
        alpha = 1 - (MIN(1, gPoint / (SCREEN_SIZE.height - 150)));
        NSLog(@"%f", alpha);
        CGRect frame = self.frame;
        frame.origin.y = gPoint;
        frame.origin.x = 155 * (1 - alpha);
        frame.size.width = 320 - (1 - alpha)*160;
        frame.size.height = 180 - (1 - alpha)*90;
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
    }else if (self.frame.origin.y == SCREEN_SIZE.height-150){
        _slideLeftRight = YES;
        float gPoint = self.viewPoint.x - (self.startTouch.x - self.lastTouch.x);
        CGRect frame = self.frame;
        frame.origin.x = gPoint;
        frame.origin.y = SCREEN_SIZE.height - 150;
        self.frame = frame;
        alpha = (MIN(1, gPoint / self.viewPoint.x));
        if (alpha < 0.2f) {
            alpha = 0.2f;
        }
        self.alpha = alpha;
    }
}

-(void)touchesMovedOnPlayerViewLandscape:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint lastTouchCoordinates = [[[touches allObjects] lastObject] locationInView:self.window];
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
        static float temp = 0;
        float alpha = 0;
        float gPoint = self.lastTouch.x - self.startTouch.x;
        if (ABS(gPoint) < 20 || _isChangeVolume) {
            return;
        }
        _isChangeForward = YES;
        alpha = gPoint / SCREEN_SIZE.width;
        float delta = _currentTime + alpha;
        if (delta > 1) {
            delta = 1;
        }else if(delta < 0){
            delta = 0;
        }
        
        NSLog(@"alpha: %f", delta);
        self.slDuration.value = delta;
        NowPlayerVC *nowVC  = APPDELEGATE.nowPlayerVC;
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
            }
        }];
    }
}
- (void)showPanelForward:(float)progress isForward:(BOOL)isForward{
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
        
        UILabel *lbCur = [[UILabel alloc] initWithFrame:CGRectMake(26, 30, 40, 10)];
        lbCur.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        lbCur.textColor = [UIColor whiteColor];
        lbCur.font = [UIFont systemFontOfSize:8.0f];
        lbCur.text = @"00:00:00 /";
        lbCur.textAlignment = NSTextAlignmentRight;
        lbCur.backgroundColor = [UIColor clearColor];
        [lbCur sizeToFit];
        lbCur.tag = 11;
        [view addSubview:lbCur];
        
        UILabel *lbDur = [[UILabel alloc] initWithFrame:CGRectMake(lbCur.frame.origin.x + lbCur.frame.size.width, 30, 40, 10)];
        lbDur.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        lbDur.textColor = COLOR_MAIN_BLUE;
        lbDur.font = [UIFont systemFontOfSize:8.0f];
        lbDur.text = @" 00:00:00";
        lbDur.textAlignment = NSTextAlignmentLeft;
        lbDur.backgroundColor = [UIColor clearColor];
        [lbDur sizeToFit];
        lbDur.tag = 12;
        [view addSubview:lbDur];
        
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 50, 110, 2)];
        progressView.progress = 0.0f;
        progressView.tag = 13;
        [view addSubview:progressView];
        [self insertSubview:view aboveSubview:self.viewControls];
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
        mainView.frame = CGRectMake(0, ORIGIN_Y + 180, 320, SCREEN_SIZE.height - ORIGIN_Y - 180);
    }else if (UIInterfaceOrientationIsLandscape(deviceOrientation)){
        self.isMinimize = NO;
    }
}

#pragma mark - animation
- (void)youtubeAnimationMaximize:(BOOL)animated{
    if (_isAnimation) {
        return;
    }
    _isAnimation = YES;
    UIView *overView = [self.superview viewWithTag:kOverViewTag];
    UIView *mainView = [self.superview viewWithTag:kMainViewTag];
    CGRect frame = mainView.frame;
    frame.origin.x = self.maximizeFrame.origin.x;
    frame.origin.y = self.maximizeFrame.origin.y + 180;
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
    UIView *overView = [self.superview viewWithTag:kOverViewTag];
    UIView *mainView = [self.superview viewWithTag:kMainViewTag];
    CGRect frame = mainView.frame;
    frame.origin.x = self.minimizeFrame.origin.x;
    frame.origin.y = self.minimizeFrame.origin.y + 90;
    float duration = animated ? 0.3f : 0.0f;
    [UIView animateWithDuration:duration animations:^{
        self.frame = self.minimizeFrame;
        MAKESHADOW(self);
        self.viewControls.alpha = 0.0f;
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
    frame.origin.x = - self.frame.size.width;
    [UIView animateWithDuration:0.2f animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            self.isMinimize = NO;
            [APPDELEGATE.nowPlayerVC stopPlayer];
            [self youtubeAnimationMaximize:NO];
        }
    }];
    
}

- (void)btnMinimize_Tapped{
    [self youtubeAnimationMinimize:YES];
}

- (void)btnDownload_Tapped{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadVideoCurrentNotification object:nil];
}

@end


