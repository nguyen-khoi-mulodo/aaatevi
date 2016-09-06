//
//  NPVideoPlayerDetailView.h
//  NPlus
//
//  Created by Le Duc Anh on 9/15/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseVideoLandscapeVC.h"
#import "VideoDetailLandscapeVC.h"
#import "VideoDownloadLandscapeVC.h"
@protocol NPVideoPlayerViewDelegate;
@interface NPVideoPlayerDetailView : UIView<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (nonatomic, strong) UIButton *btnTabChoose;
@property (nonatomic, strong) UIButton *btnTabDetail;
@property (nonatomic, strong) UIButton *btnTabDownload;
@property (nonatomic, strong) UIView *viewContainer;
@property (nonatomic, weak) id<NPVideoPlayerViewDelegate> delegate;
@property (nonatomic, strong) ChooseVideoLandscapeVC* chooseVideo;
@property (nonatomic, strong) VideoDetailLandscapeVC *detailVideo;
@property (nonatomic, strong) VideoDownloadLandscapeVC *downloadVideo;
@property (nonatomic, assign) BOOL isShow;
- (void)showDetail;
- (void)hideDetail;
@end

@protocol NPVideoPlayerDetailViewDelegate <NSObject>

@optional
- (void)npVideoPlayerDetailView:(NPVideoPlayerDetailView*)viewDetail tabChooseVideoSelectedAtIndex:(NSInteger)index;
@end
