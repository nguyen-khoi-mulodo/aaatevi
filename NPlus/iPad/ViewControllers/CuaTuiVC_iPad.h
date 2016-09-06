//
//  RankVC.h
//  NPlus
//
//  Created by Vo Chuong Thien on 10/31/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "BaseVC.h"
#import "GridViewBaseVC.h"
#import "GlobalViewController.h"
#import "LikedChannelVC_iPad.h"
#import "VideoViewLaterVC_iPad.h"
#import "NotificationVC_iPad.h"
#import "NewFeedVC_iPad.h"
#import "HistoryVC_iPad.h"



@interface CuaTuiVC_iPad : GlobalViewController <GridViewBaseDelegate, FacebookLoginTaskDelegate>{
    IBOutlet UILabel* indicateView;
    IBOutlet UIButton* btnTabViewLater;
    IBOutlet UIButton* btnTabLiked;
    
    
    UIButton* btnSubMenuCurrent;

    IBOutlet UIView* menuView;
//    IBOutlet UIButton* btnSetting;
    IBOutlet UILabel* lbNotiLoginFacebook;
    
    BOOL fromRootVC;
    
    
    // Sub View
    LikedChannelVC_iPad* channelLikedVC;
    VideoViewLaterVC_iPad* xemsauVC;
    NotificationVC_iPad* notificationVC;
    NewFeedVC_iPad* newFeedVC;
    HistoryVC_iPad* historyVC;

    IBOutlet UIView* loginView;
    
    
    IBOutlet UIButton* btnNewFeed;
    IBOutlet UIButton* btnLichSu;
    IBOutlet UIButton* btnXemSau;
    IBOutlet UIButton* btnFollow;
    IBOutlet UIButton* btnNotification;
    IBOutlet UIButton* btnCaiDat;
    
    UIButton* btnMenuCurrent;
}

@property (weak, nonatomic) IBOutlet UIButton *btnInfoUser;
@property (weak, nonatomic) IBOutlet UIButton *btnAvatar;

@property (weak, nonatomic) IBOutlet UIView* viewDiskSpace;
@property (weak, nonatomic) IBOutlet UILabel* lbInfoSpace;
@property (weak, nonatomic) IBOutlet UIProgressView *propressSpace;
@property (weak, nonatomic) IBOutlet UIImageView* bannerImage;
@property MainScreenType screenType;

- (void) showTabCuaTui:(BOOL) isShow;
- (void) setSelectedWithButtonSetting:(BOOL) selected;
@end
