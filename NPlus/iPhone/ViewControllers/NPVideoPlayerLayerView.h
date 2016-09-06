//
//  NPVideoPlayerLayerView.h
//  NPlus
//
//  Created by TEVI Team on 9/15/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface NPVideoPlayerLayerView : UIView
- (void)showLoading:(BOOL)loading;
- (void)showError:(BOOL)error withMessage:(NSString*)message;
- (void)setPlayer:(AVPlayer *)player;
@end
