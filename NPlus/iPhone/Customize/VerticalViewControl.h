//
//  VerticalViewControl.h
//  NPlus
//
//  Created by Anh Le Duc on 8/29/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerticalViewControl : UIView
- (id)initWithFrame:(CGRect)frame withVideoPlayer:(id)videoPlayer withVideoPlayerVC:(id)videoPlayerVC;
- (void)setValueForSliderDuration:(double)value;
- (void)setTextForLabelTimeDuration:(NSString*)stringTime;
- (void)setTextForLabelTotalDuration:(NSString*)stringTime;
- (void)setStateButtonPlay:(BOOL)isPlay;
- (void)showHub:(BOOL)show withAnimation:(BOOL) animated;
@end
