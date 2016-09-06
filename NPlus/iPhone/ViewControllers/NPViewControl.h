//
//  NPViewControl.h
//  NPlus
//
//  Created by Le Duc Anh on 9/7/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NPViewControl : UIView
@property (nonatomic, weak) id parentController;
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

@property (nonatomic, strong) UIView *viewHeader;
@property (nonatomic, strong) UIView *viewStatus;
@property (nonatomic, strong) UIButton *btnBack;
@property (nonatomic, strong) UIButton *btnLike;
@property (nonatomic, strong) UIButton *btnShare;
@property (nonatomic, strong) UILabel *lbTitle;

@property (nonatomic, strong) UIView *viewDetail;
@end
