//
//  VerticalViewControl.m
//  NPlus
//
//  Created by Anh Le Duc on 8/29/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "VerticalViewControl.h"
#import "KSVideoPlayerView.h"
@interface VerticalViewControl(){
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
@end
@implementation VerticalViewControl

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
    self.overView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 30, SCREEN_SIZE.width, 30)];
    self.overView.backgroundColor = [UIColor blackColor];
    self.overView.alpha = 0.5f;
    [self addSubview:self.overView];
    
    self.viewControl  = [[UIView alloc] initWithFrame:self.overView.frame];
    self.viewControl.backgroundColor = [UIColor clearColor];
    [self addSubview:self.viewControl];
    
    self.btnPlay = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [self.btnPlay setImage:[UIImage imageNamed:@"playing_pause_btn_dung_hover"] forState:UIControlStateHighlighted];
    [self.btnPlay setImage:[UIImage imageNamed:@"playing_pause_btn_dung"] forState:UIControlStateNormal];
    [self.btnPlay addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewControl addSubview:self.btnPlay];
    
    self.lbTimeDuration = [[UILabel alloc] initWithFrame:CGRectMake(186, 0, 40, 13)];
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
    
    self.sliderDuration = [[UISlider alloc] initWithFrame:CGRectMake(63, 10, 200, 10)];
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
    
    self.btnZoom = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width - 50, 0, 50, 30)];
    [self.btnZoom setImage:[UIImage imageNamed:@"playing_icon_phongto_hover"] forState:UIControlStateHighlighted];
    [self.btnZoom setImage:[UIImage imageNamed:@"playing_icon_phongto"] forState:UIControlStateNormal];
    [self.btnZoom addTarget:self action:@selector(zoomButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewControl addSubview:self.btnZoom];
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

-(void)zoomButtonPressed:(UIButton*)sender{
    if (self.videoPlayer && [self.videoPlayer isKindOfClass:[KSVideoPlayerView class]] && [self.videoPlayer respondsToSelector:@selector(zoomButtonPressed:)]) {
        [self.videoPlayer zoomButtonPressed:sender];
    }
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
        [self.btnPlay setImage:[UIImage imageNamed:@"playing_pause_btn_dung_hover"] forState:UIControlStateHighlighted];
        [self.btnPlay setImage:[UIImage imageNamed:@"playing_pause_btn_dung"] forState:UIControlStateNormal];
    }else{
        [self.btnPlay setImage:[UIImage imageNamed:@"playing_play_btn_dung_hover"] forState:UIControlStateHighlighted];
        [self.btnPlay setImage:[UIImage imageNamed:@"playing_play_btn_dung"] forState:UIControlStateNormal];
    }
}

@end
