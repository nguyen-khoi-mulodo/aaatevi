//
//  NPViewControl.m
//  NPlus
//
//  Created by Le Duc Anh on 9/7/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "NPViewControl.h"

@interface NPViewControl()

           
@end

@implementation NPViewControl
@synthesize viewBottom, btnVerticalPlay, slDuration, lbTimeDuration, lbTotalDuration, btnZoom;
@synthesize parentController = _parentController;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];

        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface{
    self.viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 30, 320, 30)];
    [self addSubview:self.viewBottom];
    
    UIView *overBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    overBottom.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    overBottom.backgroundColor = [UIColor blackColor];
    overBottom.alpha = 0.6f;
    [self.viewBottom addSubview:overBottom];
    
    self.btnVerticalPlay = [[UIButton alloc] init];
    [self.btnVerticalPlay setImage:[UIImage imageNamed:@"playing_pause_btn_dung_hover"] forState:UIControlStateHighlighted];
    [self.btnVerticalPlay setImage:[UIImage imageNamed:@"playing_pause_btn_dung"] forState:UIControlStateNormal];
//    [self.btnVerticalPlay addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.btnVerticalPlay.backgroundColor = [UIColor clearColor];
    [self.viewBottom addSubview:self.btnVerticalPlay];
    
    self.lbTimeDuration = [[UILabel alloc] init];
    self.lbTimeDuration.textColor = [UIColor whiteColor];
    self.lbTimeDuration.font = [UIFont systemFontOfSize:8.0f];
    self.lbTimeDuration.text = @"00:00:00 /";
    self.lbTimeDuration.textAlignment = NSTextAlignmentRight;
    self.lbTimeDuration.backgroundColor = [UIColor clearColor];
    [self.lbTimeDuration sizeToFit];
    [self.viewBottom addSubview:self.lbTimeDuration];
    
    self.lbTotalDuration = [[UILabel alloc] init];
    self.lbTotalDuration.textColor = COLOR_MAIN_BLUE;
    self.lbTotalDuration.font = [UIFont systemFontOfSize:8.0f];
    self.lbTotalDuration.text = @" 00:00:00";
    self.lbTotalDuration.textAlignment = NSTextAlignmentLeft;
    self.lbTotalDuration.backgroundColor = [UIColor clearColor];
    [self.lbTotalDuration sizeToFit];
    [self.viewBottom addSubview:self.lbTotalDuration];
    
    self.slDuration = [[UISlider alloc] init];
    UIImage *minImage = [[UIImage imageNamed:@"playing_progressbar_playing"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *maxImage = [[UIImage imageNamed:@"playing_progressbar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [self.slDuration setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [self.slDuration setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [self.slDuration setThumbImage:[UIImage imageNamed:@"playing_cham_tron"] forState:UIControlStateNormal];
    self.slDuration.minimumValue = 0.0f;
    self.slDuration.maximumValue = 1.0f;
//    [self.slDuration addTarget:self action:@selector(progressBarChanged:) forControlEvents:UIControlEventValueChanged];
//    [self.slDuration addTarget:self action:@selector(proressBarChangeEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewBottom addSubview:self.slDuration];
    
    self.btnZoom = [[UIButton alloc] init];
    [self.btnZoom setImage:[UIImage imageNamed:@"playing_icon_phongto_hover"] forState:UIControlStateHighlighted];
    [self.btnZoom setImage:[UIImage imageNamed:@"playing_icon_phongto"] forState:UIControlStateNormal];
    [self.btnZoom addTarget:_parentController action:@selector(zoomButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.btnZoom.backgroundColor = [UIColor clearColor];
    [self.viewBottom addSubview:self.btnZoom];
    
    self.viewCenter = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 35, 255, 180)];
    self.viewCenter.backgroundColor = [UIColor clearColor];
    [self addSubview:self.viewCenter];
    self.viewCenter.hidden = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.viewCenter.frame.size.height - 61, 255, 61)];
    [imageView setImage:[UIImage imageNamed:@"playing_bg_now_playing"]];
    [self.viewCenter addSubview:imageView];
    
    self.btnPlayCenter = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.btnPlayCenter setImage:[UIImage imageNamed:@"playing_pause_btn_nam_hover"] forState:UIControlStateHighlighted];
    [self.btnPlayCenter setImage:[UIImage imageNamed:@"playing_pause_btn_nam"] forState:UIControlStateNormal];
    self.btnPlayCenter.center = imageView.center;
//    [self.btnPlayCenter addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewCenter addSubview:self.btnPlayCenter];
    
    self.btnNext = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.btnNext setImage:[UIImage imageNamed:@"playing_next_btn_nam"] forState:UIControlStateHighlighted];
    [self.btnNext setImage:[UIImage imageNamed:@"playing_next_btn_nam"] forState:UIControlStateNormal];
    self.btnNext.center = CGPointMake(imageView.center.x + 60, imageView.center.y);
    [self.viewCenter addSubview:self.btnNext];

    self.btnPrevious = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.btnPrevious setImage:[UIImage imageNamed:@"playing_prev_btn_nam"] forState:UIControlStateHighlighted];
    [self.btnPrevious setImage:[UIImage imageNamed:@"playing_prev_btn_nam"] forState:UIControlStateNormal];
    self.btnPrevious.center = CGPointMake(imageView.center.x - 60, imageView.center.y);
    [self.viewCenter addSubview:self.btnPrevious];

    self.btnVolume = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.btnVolume setImage:[UIImage imageNamed:@"playing_volume_hover"] forState:UIControlStateHighlighted];
    [self.btnVolume setImage:[UIImage imageNamed:@"playing_volume"] forState:UIControlStateNormal];
    self.btnVolume.center = CGPointMake(imageView.center.x + 100, imageView.center.y);
    [self.viewCenter addSubview:self.btnVolume];

    self.btnSetting = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.btnSetting setImage:[UIImage imageNamed:@"playing_setting_hover"] forState:UIControlStateHighlighted];
    [self.btnSetting setImage:[UIImage imageNamed:@"playing_setting"] forState:UIControlStateNormal];
    self.btnSetting.center = CGPointMake(imageView.center.x - 100, imageView.center.y);
    [self.viewCenter addSubview:self.btnSetting];

    self.viewVolume = [[UIView alloc] initWithFrame:CGRectMake(175, 65, 100, 23)];
    self.viewVolume.backgroundColor = [UIColor clearColor];
    UIView *backgroundVolume = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 23)];
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
    [self.viewVolume addSubview:self.slVolume];
    [self.viewCenter addSubview:self.viewVolume];
    
    self.viewSetting = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 195, 70)];
    UIView *backgroundSetting = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 195, 70)];
    backgroundSetting.backgroundColor = [UIColor blackColor];
    backgroundSetting.alpha = 0.7f;
    backgroundSetting.layer.cornerRadius = 3.0f;
    [self.viewSetting addSubview:backgroundSetting];
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
    UIButton *btnLock = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLock setFrame:CGRectMake(145, 40, 43, 18)];
    [btnLock setBackgroundImage:[UIImage imageNamed:@"playing_khoamanhinh_off"] forState:UIControlStateNormal];
    [btnLock setBackgroundImage:[UIImage imageNamed:@"playing_khoamanhinh_on"] forState:UIControlStateHighlighted];
    [btnLock setBackgroundImage:[UIImage imageNamed:@"playing_khoamanhinh_on"] forState:UIControlStateSelected];
    [self.viewSetting addSubview:btnLock];
    [self.viewCenter addSubview:self.viewSetting];
    
    frame = self.frame;
    self.viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, ORIGIN_Y, frame.size.width, 30)];
    self.viewHeader.backgroundColor = [UIColor clearColor];
    [self addSubview:self.viewHeader];
    
    if (IOS_NEWER_OR_EQUAL_TO_7) {
        self.viewStatus = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
        self.viewStatus.backgroundColor = [UIColor blackColor];
        self.viewStatus.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.viewStatus.hidden = YES;
        [self addSubview:self.viewStatus];
    }
    
    UIView *backgroundHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
    backgroundHeader.backgroundColor = [UIColor blackColor];
    backgroundHeader.alpha = 0.6f;
    backgroundHeader.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.viewHeader addSubview:backgroundHeader];
    
    self.btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [self.btnBack setImage:[UIImage imageNamed:@"icon_back_hover"] forState:UIControlStateHighlighted];
    [self.btnBack setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    self.btnBack.backgroundColor = [UIColor clearColor];
    [self.viewHeader addSubview:self.btnBack];
    
    self.btnLike = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 100, 0, 50, 30)];
    [self.btnLike setImage:[UIImage imageNamed:@"playing_like_hover"] forState:UIControlStateHighlighted];
    [self.btnLike setImage:[UIImage imageNamed:@"playing_like"] forState:UIControlStateNormal];
    self.btnLike.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [self.viewHeader addSubview:self.btnLike];
    
    self.btnShare = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 50, 0, 50, 30)];
    [self.btnShare setImage:[UIImage imageNamed:@"playing_share_hover"] forState:UIControlStateHighlighted];
    [self.btnShare setImage:[UIImage imageNamed:@"playing_share"] forState:UIControlStateNormal];
    self.btnShare.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [self.viewHeader addSubview:self.btnShare];
    
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, frame.size.width - 150, 30)];
    self.lbTitle.textColor = [UIColor whiteColor];
    self.lbTitle.font = [UIFont systemFontOfSize:14.0f];
    self.lbTitle.text = @"Thiên long bát bộ 2014 Thiên long bát bộ 2014 Thiên long bát bộ 2014 Thiên long bát bộ 2014";
    self.lbTitle.alpha = 0.8f;
    self.lbTitle.backgroundColor = [UIColor clearColor];
    self.lbTitle.textAlignment = NSTextAlignmentLeft;
    self.lbTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [self.viewHeader addSubview:self.lbTitle];
    self.viewHeader.hidden = YES;
    
    self.viewDetail = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 320)];
    UIImageView *backgroundViewDetail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 320)];
    [backgroundViewDetail setImage:[UIImage imageNamed:@"bg_popup_video_ngang"]];
    [self.viewDetail addSubview:backgroundViewDetail];
    [self addSubview:self.viewDetail];
    self.viewDetail.hidden = YES;
    
    [self setupConstraints];
}

-(void) setupConstraints
{
    self.viewBottom.keepHorizontalInsets.equal = KeepRequired(0);
    self.viewBottom.keepBottomInset.equal = KeepRequired(0);
    self.viewBottom.keepHeight.equal = KeepRequired(30);
    
    self.btnVerticalPlay.keepLeftInset.equal = KeepRequired(0);
    self.btnVerticalPlay.keepRightOffsetTo(self.slDuration).equal = KeepRequired(0);
    [self.btnVerticalPlay keepVerticallyCentered];
    
    self.lbTimeDuration.keepTopInset.equal = KeepRequired(0);
    self.lbTimeDuration.keepRightInset.equal = KeepRequired(85);
    self.lbTotalDuration.keepLeftOffsetTo(self.lbTimeDuration).equal = KeepRequired(0);
    
    self.slDuration.keepLeftInset.equal = KeepRequired(50);
    self.slDuration.keepBottomInset.equal = KeepRequired(0);
    [self.slDuration keepHorizontallyCentered];
    [self.slDuration keepVerticallyCentered];
    
    self.btnZoom.keepLeftOffsetTo(self.slDuration).equal = KeepRequired(0);
    self.btnZoom.keepRightInset.equal = KeepRequired(0);
    [self.btnZoom keepVerticallyCentered];
    
    self.btnBack.keepLeftInset.equal = KeepRequired(0);
    self.btnBack.keepRightOffsetTo(self.lbTitle).equal = KeepRequired(0);
    [self.btnBack keepVerticallyCentered];
    
    self.lbTitle.keepTopInset.equal = KeepRequired(0);
    self.lbTitle.keepLeftInset.equal = KeepRequired(50);
    self.lbTitle.keepRightInset.equal = KeepRequired(100);
    self.lbTitle.keepLeftOffsetTo(self.btnBack).equal = KeepRequired(0);
//    self.lbTitle.keepRightOffsetTo(self.btnLike).equal = KeepRequired(0);
    [self.lbTitle keepVerticallyCentered];
    
    self.btnLike.keepRightInset.equal = KeepRequired(50);
    self.btnLike.keepRightOffsetTo(self.btnShare).equal = KeepRequired(0);
//    self.btnLike.keepLeftOffsetTo(self.lbTitle).equal = KeepRequired(0);
    [self.btnLike keepVerticallyCentered];
    
    self.btnShare.keepRightInset.equal = KeepRequired(0);
    self.btnShare.keepLeftOffsetTo(self.btnLike).equal = KeepRequired(0);
    [self.btnShare keepVerticallyCentered];
    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectGetWidth(frame) == 320) {
        [self showControlVertical];
    }else{
        [self showControlHorizontal];
    }
}

- (void)showControlVertical{
    self.btnVerticalPlay.hidden = NO;
    self.viewCenter.hidden = YES;
    self.viewStatus.hidden = YES;
    self.viewHeader.hidden = YES;
    if (self.viewStatus) {
        self.viewStatus.hidden = YES;
    }
    self.viewDetail.hidden = YES;
}

- (void)showControlHorizontal{
    self.btnVerticalPlay.hidden = YES;
    self.viewCenter.hidden = NO;
    self.viewCenter.frame = CGRectMake(self.frame.size.width / 2 - 127, self.frame.size.height - 180 - 35, 255, 180);
    self.viewHeader.frame = CGRectMake(0, ORIGIN_Y, self.frame.size.width, 30);
    self.viewStatus.hidden = NO;
    self.viewHeader.hidden = NO;
    if (self.viewStatus) {
        self.viewStatus.hidden = NO;
    }
    self.viewDetail.hidden = NO;
}


-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}
@end
