//
//  NPVideoPlayerLayerView.m
//  NPlus
//
//  Created by TEVI Team on 9/15/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "NPVideoPlayerLayerView.h"

@implementation NPVideoPlayerLayerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)showLoading:(BOOL)loading{
    UIView *view = [self viewWithTag:222];
    if (view) {
        UIView *viewLoading = [view viewWithTag:300];
        viewLoading.hidden = !loading;
        UIView *viewError = [view viewWithTag:301];
        viewError.hidden = loading;
        view.hidden = !loading;
    }
    
    if (loading) {
        [self startAnimation];
        APPDELEGATE.nowPlayerVC.player.view.isLockControll = YES;
    }else{
        [self stopAnimation];
        APPDELEGATE.nowPlayerVC.player.view.isLockControll = NO;
    }
}

- (void)showError:(BOOL)error withMessage:(NSString *)message{
    UIView *view = [self viewWithTag:222];
    if (view) {
        UIView *viewLoading = [view viewWithTag:300];
        viewLoading.hidden = error;
        UIView *viewError = [view viewWithTag:301];
        viewError.hidden = !error;
        UILabel *lbMessage = (UILabel*)[viewError viewWithTag:400];
        lbMessage.text = message;
        view.hidden = !error;
    }
    [self stopAnimation];
}

- (void)startAnimation{
    UIView *view = [self viewWithTag:222];
    if (!view) {
        return;
    }
    UIView *viewLoading = [view viewWithTag:300];
    UIImageView *imgLoading = (UIImageView*)[viewLoading viewWithTag:400];
//    if (![imgLoading.layer animationForKey:@"rotationAnimation"])
//    {
//        CABasicAnimation* rotationAnimation;
//        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
//        rotationAnimation.duration = 2.0f;
//        rotationAnimation.cumulative = NO;
//        rotationAnimation.repeatCount = HUGE_VALF;
//        [imgLoading.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//    }
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 1; i < 4; i++) {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"player_loading%i", i]]];
    }
    
    // Normal Animation
    imgLoading.animationImages = images;
    imgLoading.animationDuration = 0.5;
    [imgLoading startAnimating];
}

- (void)stopAnimation{
    UIView *view = [self viewWithTag:222];
    if (!view) {
        return;
    }
    UIView *viewLoading = [view viewWithTag:300];
    UIImageView *imgLoading = (UIImageView*)[viewLoading viewWithTag:400];
//    if ([imgLoading.layer animationForKey:@"rotationAnimation"])
//    {
//        [imgLoading.layer removeAllAnimations];
//    }
    if (imgLoading.isAnimating)
    {
        [imgLoading stopAnimating];
    }
    
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
    [(AVPlayerLayer *)[self layer] setVideoGravity:AVLayerVideoGravityResizeAspect];
}

@end
