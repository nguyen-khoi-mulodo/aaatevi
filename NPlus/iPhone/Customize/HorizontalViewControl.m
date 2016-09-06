//
//  HorizontalViewControl.m
//  NPlus
//
//  Created by Anh Le Duc on 8/29/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "HorizontalViewControl.h"
#import "KSVideoPlayerView.h"
@interface HorizontalViewControl(){
    BOOL _hubIsShow;
}
@property (nonatomic, strong) UIView *viewControl;
@property (nonatomic, strong) UIView *overView;
@property (nonatomic, strong) UIButton *btnPlay;
@property (nonatomic, strong) UISlider *sliderDuration;
@property (nonatomic, strong) UILabel *lbTimeDuration;
@property (nonatomic, strong) UILabel *lbTotalDuration;
@property (nonatomic, strong) UIButton *btnZoom;
@property (nonatomic, strong) id videoPlayer;
@property (nonatomic, strong) UIView *viewCenterControl;
@property (nonatomic, strong) UIButton *btnNext;
@property (nonatomic, strong) UIButton *btnPrevious;
@property (nonatomic, strong) UIButton *btnSetting;
@property (nonatomic, strong) UIButton *btnVolume;
@property (nonatomic, strong) UIView *viewStatus;
@property (nonatomic, strong) UIView *viewHeader;
@property (nonatomic, strong) UIView *viewHeaderControl;
@property (nonatomic, strong) UIButton *btnBack;
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UIButton *btnLike;
@property (nonatomic, strong) UIButton *btnShare;
@end
@implementation HorizontalViewControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _hubIsShow = YES;
        [self setup];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withVideoPlayer:(id)videoPlayer withVideoPlayerVC:(id)videoPlayerVC{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        self.videoPlayer = videoPlayer;
        [self setup];
    }
    return self;
}

-(void)setup{
    self.backgroundColor = [UIColor clearColor];
    CGRect frame = self.frame;
    float dY = IOS_OLDER_THAN_7 ? 20 : 0;
    self.viewControl  = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 30 - dY, frame.size.width, 30)];
    self.viewControl.backgroundColor = [UIColor clearColor];
    [self addSubview:self.viewControl];
    
    self.overView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
    self.overView.backgroundColor = [UIColor blackColor];
    self.overView.alpha = 0.6f;
    [self.viewControl addSubview:self.overView];
    
    self.lbTimeDuration = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 134, 0, 40, 13)];
    self.lbTimeDuration.textColor = [UIColor whiteColor];
    self.lbTimeDuration.font = [UIFont systemFontOfSize:8.0f];
    self.lbTimeDuration.text = @"00:00:00 /";
    self.lbTimeDuration.textAlignment = NSTextAlignmentRight;
    self.lbTimeDuration.backgroundColor = [UIColor clearColor];
    [self.viewControl addSubview:self.lbTimeDuration];
    
    self.lbTotalDuration = [[UILabel alloc] initWithFrame:CGRectMake(self.lbTimeDuration.frame.origin.x + self.lbTimeDuration.frame.size.width, 0, 40, 13)];
    self.lbTotalDuration.textColor = COLOR_MAIN_BLUE;
    self.lbTotalDuration.font = [UIFont systemFontOfSize:8.0f];
    self.lbTotalDuration.text = @" 00:00:00";
    self.lbTotalDuration.textAlignment = NSTextAlignmentLeft;
    self.lbTotalDuration.backgroundColor = [UIColor clearColor];
    [self.viewControl addSubview:self.lbTotalDuration];
    
    float slDY = IOS_OLDER_THAN_7 ? 5 : 0;
    self.sliderDuration = [[UISlider alloc] initWithFrame:CGRectMake(15, 10 - slDY, frame.size.width - 70, 10)];
    UIImage *minImage = [[UIImage imageNamed:@"playing_progressbar_playing"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *maxImage = [[UIImage imageNamed:@"playing_progressbar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [self.sliderDuration setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [self.sliderDuration setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [self.sliderDuration setThumbImage:[UIImage imageNamed:@"playing_cham_tron"] forState:UIControlStateNormal];
    self.sliderDuration.minimumValue = 0.0f;
    self.sliderDuration.maximumValue = 1.0f;
    [self.sliderDuration addTarget:self action:@selector(progressBarChanged:) forControlEvents:UIControlEventValueChanged];
    [self.sliderDuration addTarget:self action:@selector(proressBarChangeEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewControl addSubview:self.sliderDuration];
    
    self.btnZoom = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 50, 0, 50, 30)];
    [self.btnZoom setImage:[UIImage imageNamed:@"playing_icon_thunho_hover"] forState:UIControlStateHighlighted];
    [self.btnZoom setImage:[UIImage imageNamed:@"playing_icon_thunho"] forState:UIControlStateNormal];
    [self.viewControl addSubview:self.btnZoom];
    
    self.viewCenterControl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 255, 61)];
    self.viewCenterControl.backgroundColor = [UIColor clearColor];
    self.viewCenterControl.center = CGPointMake(self.center.x, self.center.y + 85 - dY);
    [self addSubview:self.viewCenterControl];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewCenterControl.frame.size.width, self.viewCenterControl.frame.size.height)];
    [imageView setImage:[UIImage imageNamed:@"playing_bg_now_playing"]];
    [self.viewCenterControl addSubview:imageView];
    
    self.btnPlay = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.btnPlay setImage:[UIImage imageNamed:@"playing_pause_btn_nam_hover"] forState:UIControlStateHighlighted];
    [self.btnPlay setImage:[UIImage imageNamed:@"playing_pause_btn_nam"] forState:UIControlStateNormal];
    [self.btnPlay addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.btnPlay.center = CGPointMake(self.viewCenterControl.frame.size.width/2, self.viewCenterControl.frame.size.height/2);
    [self.viewCenterControl addSubview:self.btnPlay];
    
    self.btnNext = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.btnNext setImage:[UIImage imageNamed:@"playing_next_btn_nam"] forState:UIControlStateHighlighted];
    [self.btnNext setImage:[UIImage imageNamed:@"playing_next_btn_nam"] forState:UIControlStateNormal];
    self.btnNext.center = CGPointMake(self.viewCenterControl.frame.size.width/2 + 60, self.viewCenterControl.frame.size.height/2);
    [self.viewCenterControl addSubview:self.btnNext];
    
    self.btnPrevious = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.btnPrevious setImage:[UIImage imageNamed:@"playing_prev_btn_nam"] forState:UIControlStateHighlighted];
    [self.btnPrevious setImage:[UIImage imageNamed:@"playing_prev_btn_nam"] forState:UIControlStateNormal];
    self.btnPrevious.center = CGPointMake(self.viewCenterControl.frame.size.width/2 - 60, self.viewCenterControl.frame.size.height/2);
    [self.viewCenterControl addSubview:self.btnPrevious];
    
    self.btnVolume = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.btnVolume setImage:[UIImage imageNamed:@"playing_volume_hover"] forState:UIControlStateHighlighted];
    [self.btnVolume setImage:[UIImage imageNamed:@"playing_volume"] forState:UIControlStateNormal];
    self.btnVolume.center = CGPointMake(self.viewCenterControl.frame.size.width/2 + 100, self.viewCenterControl.frame.size.height/2);
    [self.viewCenterControl addSubview:self.btnVolume];
    
    self.btnSetting = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.btnSetting setImage:[UIImage imageNamed:@"playing_setting_hover"] forState:UIControlStateHighlighted];
    [self.btnSetting setImage:[UIImage imageNamed:@"playing_setting"] forState:UIControlStateNormal];
    self.btnSetting.center = CGPointMake(self.viewCenterControl.frame.size.width/2 - 100, self.viewCenterControl.frame.size.height/2);
    [self.viewCenterControl addSubview:self.btnSetting];
    
    self.viewHeaderControl = [[UIView alloc] initWithFrame:CGRectMake(0, ORIGIN_Y, frame.size.width, 30)];
    self.viewHeaderControl.backgroundColor = [UIColor clearColor];
    [self addSubview:self.viewHeaderControl];
    
    if (IOS_NEWER_OR_EQUAL_TO_7) {
        self.viewStatus = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
        self.viewStatus.backgroundColor = [UIColor blackColor];
        [self addSubview:self.viewStatus];
    }
    
    self.viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
    self.viewHeader.backgroundColor = [UIColor blackColor];
    self.viewHeader.alpha = 0.6f;
    [self.viewHeaderControl addSubview:self.viewHeader];
    
    self.btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [self.btnBack setImage:[UIImage imageNamed:@"icon_back_hover"] forState:UIControlStateHighlighted];
    [self.btnBack setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [self.viewHeaderControl addSubview:self.btnBack];
    
    self.btnLike = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 100, 0, 50, 30)];
    [self.btnLike setImage:[UIImage imageNamed:@"playing_like_hover"] forState:UIControlStateHighlighted];
    [self.btnLike setImage:[UIImage imageNamed:@"playing_like"] forState:UIControlStateNormal];
    [self.viewHeaderControl addSubview:self.btnLike];
    
    self.btnShare = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 50, 0, 50, 30)];
    [self.btnShare setImage:[UIImage imageNamed:@"playing_share_hover"] forState:UIControlStateHighlighted];
    [self.btnShare setImage:[UIImage imageNamed:@"playing_share"] forState:UIControlStateNormal];
    [self.viewHeaderControl addSubview:self.btnShare];
    
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, frame.size.width - 150, 30)];
    self.lbTitle.textColor = [UIColor whiteColor];
    self.lbTitle.font = [UIFont systemFontOfSize:14.0f];
    self.lbTitle.text = @"Thiên long bát bộ 2014";
    self.lbTitle.alpha = 0.8f;
    self.lbTitle.backgroundColor = [UIColor clearColor];
    [self.viewHeaderControl addSubview:self.lbTitle];
}

-(void)setValueForSliderDuration:(double)value{
    if (self.sliderDuration) {
        self.sliderDuration.value = value;
    }
}

-(void)setTextForLabelTimeDuration:(NSString *)stringTime{
    if (self.lbTimeDuration) {
        self.lbTimeDuration.text = [NSString stringWithFormat:@"%@ /", stringTime];
    }
}

-(void)setTextForLabelTotalDuration:(NSString *)stringTime{
    if (self.lbTotalDuration) {
        self.lbTotalDuration.text = [NSString stringWithFormat:@" %@", stringTime];
    }
}

-(void)showHub:(BOOL)show withAnimation:(BOOL)animated{
    __weak __typeof(self) weakself = self;
    if(show) {
        CGRect frame = self.viewControl.frame;
        frame.origin.y = self.bounds.size.height - self.viewControl.frame.size.height;
        float anima = animated ? 0.3f : 0.0f;
        [UIView animateWithDuration:anima animations:^{
            weakself.viewControl.frame = frame;
            weakself.overView.frame = frame;
            _hubIsShow = show;
        }];
    } else {
        CGRect frame = self.viewControl.frame;
        frame.origin.y = self.bounds.size.height ;
        float anima = animated ? 0.3f : 0.0f;
        [UIView animateWithDuration:anima animations:^{
            weakself.viewControl.frame = frame;
            weakself.overView.frame = frame;
            _hubIsShow = show;
        }];
    }
}


-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

-(void)playButtonAction:(UIButton*)sender
{
    if (self.videoPlayer && [self.videoPlayer isKindOfClass:[KSVideoPlayerView class]] && [self.videoPlayer respondsToSelector:@selector(playButtonAction:)]) {
        [self.videoPlayer playButtonAction:sender];
    }
}

-(void)progressBarChanged:(UISlider*)sender
{
    if (self.videoPlayer && [self.videoPlayer isKindOfClass:[KSVideoPlayerView class]] && [self.videoPlayer respondsToSelector:@selector(progressBarChanged:)]) {
        [self.videoPlayer progressBarChanged:sender];
    }
}

-(void)proressBarChangeEnded:(UISlider*)sender
{
    if (self.videoPlayer && [self.videoPlayer isKindOfClass:[KSVideoPlayerView class]] && [self.videoPlayer respondsToSelector:@selector(proressBarChangeEnded:)]) {
        [self.videoPlayer proressBarChangeEnded:sender];
    }
}

-(void)setStateButtonPlay:(BOOL)isPlay{
    if (isPlay) {
        [self.btnPlay setImage:[UIImage imageNamed:@"playing_pause_btn_nam_hover"] forState:UIControlStateHighlighted];
        [self.btnPlay setImage:[UIImage imageNamed:@"playing_pause_btn_nam"] forState:UIControlStateNormal];
    }else{
        [self.btnPlay setImage:[UIImage imageNamed:@"playing_play_btn_nam_hover"] forState:UIControlStateHighlighted];
        [self.btnPlay setImage:[UIImage imageNamed:@"playing_play_btn_nam"] forState:UIControlStateNormal];
    }
}

@end
