//
//  Home_iPad.h
//  NPlus
//
//  Created by Vo Chuong Thien on 10/28/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryVC_iPad.h"
#import "SearchVC_iPad.h"
#import "VideoPlayer.h"
#import "CuaTuiVC_iPad.h"
#import "SettingVC_iPad.h"
#import "JSCustomBadge.h"
#import "GAITrackedViewController.h"
#import "FacebookLoginTask.h"
#import "GooglePlusLoginTask.h"
#import "LoginAlertVC_iPad.h"
//#import "GenreListVC.h"
#import "DownloadVC_iPad.h"
#import "ArtistVC_iPad.h"
#import "ChannelVC_iPad.h"
#import "RatingAlertVC_iPad.h"
#import "ILTranslucentView.h"


@interface RootVC_iPad : GAITrackedViewController <GlobalViewDelegate, VideoPlayerDelegate, UIPopoverControllerDelegate, SettingDelegate, UIGestureRecognizerDelegate, FacebookLoginTaskDelegate, LoginAlertDelegate, GooglePlusLoginTaskDelegate, RatingAlertDelegate>
{
    // Sub View
    
    CategoryVC_iPad* newHomeVC;
    CategoryVC_iPad* khamphaVC;
    CategoryVC_iPad* phimboVC;
    CategoryVC_iPad* phimleVC;
    CategoryVC_iPad* tvshowVC;
    CategoryVC_iPad* phimNganVC;
    CategoryVC_iPad* giaitriVC;
    CategoryVC_iPad* xemsauVC;
    ArtistVC_iPad* artistVC;
    ChannelVC_iPad* channelVC;
    CuaTuiVC_iPad* cuaTuiVC;
    CategoryVC_iPad* downloadVC;
    
    UINavigationController* tvShowNav;
    UINavigationController* giaitriNav;
    UINavigationController* phimnganNav;
    UINavigationController* khamphaNav;
    UINavigationController* searchNav;
    UINavigationController* homeNav;
    UINavigationController* cuatuiNav;
    
    SearchVC_iPad* searchVC;
    VideoPlayer* videoPlayer;
    SettingVC_iPad* settingVC;
//    GenreListVC* genreListVC;

    UINavigationController* settingNav;
    UINavigationController* categoryNav;
    

    LoginAlertVC_iPad* loginAlert;
    RatingAlertVC_iPad* ratingAlert;

    
    IBOutlet UIView* maskView;
    IBOutlet UIView* maskVideoView;
    UIPopoverController* listPopover;
    // Menu View
    IBOutlet ILTranslucentView* menuView;
    
    UIButton* btnSelectCurrent;
    IBOutlet UIButton* btnHome;
    IBOutlet UIButton* btnPhim;
    IBOutlet UIButton* btnKhamPha;
    IBOutlet UIButton* btnTVShow;
    IBOutlet UIButton* btnGiaiTri;
    IBOutlet UIButton* btnCuatui;
    IBOutlet UIButton* btnOffline;
    
    IBOutlet UIButton* btnSetting;
    
    id likeItem;
    int bagdeCount;
    JSCustomBadge *badge;
    
    id itemCurrent;
    BOOL playerDissmising;
}

- (void) stopMusicBackground:(BOOL) locked;

@end
