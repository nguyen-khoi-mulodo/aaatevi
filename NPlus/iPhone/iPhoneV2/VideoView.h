//
//  VideoView.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/28/16.
//  Copyright © 2016 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDHistory.h"

@protocol VideoViewDelegate <NSObject>

- (void)didSelectItem:(id)object;

@end

@interface VideoView : UIView

@property (strong, nonatomic)  UIButton *btnItem;
@property (strong, nonatomic)  UIImageView *thumbImg;
@property (strong, nonatomic)  UILabel *lblDuration;
@property (strong, nonatomic)  UILabel *lblTitle;
@property (strong, nonatomic)  UILabel *lblSubTitle;
@property (strong, nonatomic) id<VideoViewDelegate> delegate;

@property (strong, nonatomic) Video *video;

- (id)initWithFrame:(CGRect)frame;
- (void)loadContent;
- (void) setContent:(CDHistory*) item;

@end
