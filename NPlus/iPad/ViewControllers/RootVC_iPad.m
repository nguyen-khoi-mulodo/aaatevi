//
//  Home_iPad.m
//  NPlus
//
//  Created by Vo Chuong Thien on 10/28/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "RootVC_iPad.h"
#import "TSMiniWebBrowser.h"
#import "FileDownloadInfo.h"
#import "ParserObject.h"
#import "DBHelper.h"
#import "CDHistory.h"

@interface RootVC_iPad ()

@end

@implementation RootVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLoginView) name:kLoginSuccess object:nil];
    [btnHome sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    tapGesture.delegate = self;
    [maskView addGestureRecognizer:tapGesture];

    [self initUI];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initUI{
    [btnHome.titleLabel setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
    [btnPhim.titleLabel setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
    [btnKhamPha.titleLabel setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
    [btnTVShow.titleLabel setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
    [btnGiaiTri.titleLabel setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
    [btnCuatui.titleLabel setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
    [btnOffline.titleLabel setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
    
    [menuView setTranslucent:YES];
    [menuView setTranslucentTintColor:[UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:0.85f]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Action Switch Screen

- (void) backToHome{
    [btnHome sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void) showVideo:(id) item{
    if (playerDissmising) {
        return;
    }
    
    if (itemCurrent == item && itemCurrent) {
        if ([videoPlayer mpIsMinimized]) {
            [videoPlayer minimizeMp:NO animated:YES];
        }
        return;
    }
    if (!videoPlayer) {
        videoPlayer = [[VideoPlayer alloc] initWithNibName:@"VideoPlayer" bundle:nil];
        [videoPlayer setDelegate:self];
    }
    
    if ([item isKindOfClass:[Video class]]) {
        [videoPlayer setType:SINGLE_TYPE];
    }else if([item isKindOfClass:[Season class]]){
        [videoPlayer setType:SEASON_TYPE];
    }else if([item isKindOfClass:[FileDownloadInfo class]]){
        [videoPlayer setType:DETAIL_OFFLINE_TYPE];
    }

    BOOL openPlayer = YES;
    if (APPDELEGATE.connectionType == kConnectionTypeNone) {
        if (![item isKindOfClass:[FileDownloadInfo class]]) {
            if ([item isKindOfClass:[Video class]]) {
                Video* video = (Video*)item;
                Video *videoOffline = [[DBHelper sharedInstance] videoIsDownloaded:video.video_id withQuality:video.type_quality];
                if (!videoOffline) {
                    openPlayer = NO;
                }
            }else{
                openPlayer = NO;
            }
        }
    }
    
    if (openPlayer) {
        itemCurrent = item;
        [videoPlayer showLoading:YES];
        if (![self.view.subviews containsObject:videoPlayer.view]) {
            
            [videoPlayer.view setFrame:CGRectMake(videoPlayer.view.frame.size.width, videoPlayer.view.frame.size.height, videoPlayer.view.frame.size.width, videoPlayer.view.frame.size.height)];
            [self.view insertSubview:videoPlayer.view aboveSubview:menuView];
            [UIView animateWithDuration:0.4f
                             animations:^{
                                 [videoPlayer.view setFrame:CGRectMake(0, 0, videoPlayer.view.frame.size.width, videoPlayer.view.frame.size.height)];
                             }
                             completion:^(BOOL finished)
             {
                 [videoPlayer loadVideoPlayerWithItem:item withIndex:-1 fromRootView:YES];
                 [maskVideoView setHidden:NO];
             }
             ];
        }else{
            [videoPlayer loadVideoPlayerWithItem:item withIndex:-1 fromRootView:YES];
        }
    }else{
        [APPDELEGATE showToastMessage:@"Vui lòng kết nối mạng để play video này!"];
    }
}

- (void) showChannel:(id)item{
    Channel* channel = (Channel*)item;
    [[APIController sharedInstance] getChannelDetailWithKey:channel.channelId completed:^(int code, Channel* channelFull) {
//        self.mChannel = channelFull;
        Season* firstSeason = [channelFull.seasons objectAtIndex:0];
        firstSeason.channel = channelFull;
        [self showVideo:firstSeason];
    } failed:^(NSError *error) {
        NSLog(@"fail");
    }];
    
//    Channel* channel = (Channel*)item;
//    if (!channelVC) {
//        channelVC = [[ChannelVC_iPad alloc] initWithNibName:@"ChannelVC_iPad" bundle:nil];
//    }
//    [channelVC setDelegate:self];
//    channelVC.mChannel = channel;
//    [channelVC getChannnelDetailWithChannel];
//    if (searchNav && [self.view.subviews containsObject:searchNav.view]) {
//        if ([[searchNav viewControllers] containsObject:channelVC])
//        {
//            [searchNav popToViewController:channelVC animated:YES];
//        } else {
//            [searchNav pushViewController:channelVC animated:YES];
//        }
//    }else{
//        switch (btnSelectCurrent.tag) {
//            case home_type:
//                if ([[homeNav viewControllers] containsObject:channelVC])
//                {
//                    [homeNav popToViewController:channelVC animated:YES];
//                } else {
//                    [homeNav pushViewController:channelVC animated:YES];
//                }
//                break;
//            case khampha_type:
//                if ([[khamphaNav viewControllers] containsObject:channelVC])
//                {
//                    [khamphaNav popToViewController:channelVC animated:YES];
//                } else {
//                    [khamphaNav pushViewController:channelVC animated:YES];
//                }
//                break;
//            case tvshow_type:
//                if ([[tvShowNav viewControllers] containsObject:channelVC])
//                {
//                    [tvShowNav popToViewController:channelVC animated:YES];
//                } else {
//                    [tvShowNav pushViewController:channelVC animated:YES];
//                }
//                break;
//            case phimngan_type:
//                if ([[phimnganNav viewControllers] containsObject:channelVC])
//                {
//                    [phimnganNav popToViewController:channelVC animated:YES];
//                } else {
//                    [phimnganNav pushViewController:channelVC animated:YES];
//                }
//                break;
//            case giaitri_type:
//                if ([[giaitriNav viewControllers] containsObject:channelVC])
//                {
//                    [giaitriNav popToViewController:channelVC animated:YES];
//                } else {
//                    [giaitriNav pushViewController:channelVC animated:YES];
//                }
//                break;
//            case canhan_type:
//                if ([[cuatuiNav viewControllers] containsObject:channelVC])
//                {
//                    [cuatuiNav popToViewController:channelVC animated:YES];
//                } else {
//                    [cuatuiNav pushViewController:channelVC animated:YES];
//                }
//                break;
//            default:
//                break;
//        }
//    }
//    [self showMenuAnimation:NO];
}

- (void) showArtist:(id) item{
    Artist* artist = (Artist*)item;
    if (!artistVC) {
        artistVC = [[ArtistVC_iPad alloc] initWithNibName:@"ArtistVC_iPad" bundle:nil];
    }
    [artistVC setDelegate:self];
//    artistVC.mArtist = artist;
    [artistVC getArtistDetailWithArtist:artist];
    
    if (searchNav && [self.view.subviews containsObject:searchNav.view]) {
        if ([[searchNav viewControllers] containsObject:artistVC])
        {
            [searchNav popToViewController:artistVC animated:YES];
        } else {
            [searchNav pushViewController:artistVC animated:YES];
        }
    }else{
        switch (btnSelectCurrent.tag) {
            case home_type:
                if ([[homeNav viewControllers] containsObject:artistVC])
                {
                    [homeNav popToViewController:artistVC animated:YES];
                } else {
                    [homeNav pushViewController:artistVC animated:YES];
                }
                break;
            case khampha_type:
                if ([[khamphaNav viewControllers] containsObject:artistVC])
                {
                    [khamphaNav popToViewController:artistVC animated:YES];
                } else {
                    [khamphaNav pushViewController:artistVC animated:YES];
                }
                break;
            case tvshow_type:
                if ([[tvShowNav viewControllers] containsObject:artistVC])
                {
                    [tvShowNav popToViewController:artistVC animated:YES];
                } else {
                    [tvShowNav pushViewController:artistVC animated:YES];
                }
                break;
            case phimngan_type:
                if ([[phimnganNav viewControllers] containsObject:artistVC])
                {
                    [phimnganNav popToViewController:artistVC animated:YES];
                } else {
                    [phimnganNav pushViewController:artistVC animated:YES];
                }
                break;
            case giaitri_type:
                if ([[giaitriNav viewControllers] containsObject:artistVC])
                {
                    [giaitriNav popToViewController:artistVC animated:YES];
                } else {
                    [giaitriNav pushViewController:artistVC animated:YES];
                }
                break;
            case canhan_type:
                if ([[cuatuiNav viewControllers] containsObject:artistVC]) {
                    [cuatuiNav popToViewController:artistVC animated:YES];
                }else{
                    [cuatuiNav pushViewController:artistVC animated:YES];
                }
                break;
            default:
                break;
        }
    }
    [self showMenuAnimation:NO];
}

- (void) showSearchVC{
    [self showMenu:NO];
    if (!searchVC) {
        searchVC = [[SearchVC_iPad alloc] initWithNibName:@"SearchVC_iPad" bundle:nil];
        [searchVC setDelegate:self];
    }
    if (!searchNav) {
        searchNav = [[UINavigationController alloc] initWithRootViewController:searchVC];
        searchNav.navigationBarHidden = YES;
    }
    [self.view insertSubview:searchNav.view belowSubview:maskView];
}

- (void) closeSearchView{
    [searchNav.view removeFromSuperview];
    [self showMenuAnimation:YES];
}

- (void) showMenuAnimation:(BOOL) isShow{
    if (!isShow) {
        [menuView setFrame:CGRectMake(0, SCREEN_HEIGHT - menuView.frame.size.height, menuView.frame.size.width, menuView.frame.size.height)];
        [UIView animateWithDuration:0.4f
                         animations:^{
                             [menuView setFrame:CGRectMake(0, menuView.frame.origin.y + menuView.frame.size.height, menuView.frame.size.width, menuView.frame.size.height)];
                         }
                         completion:^(BOOL finished)
                         {
                             // TO DO
//                             NSLog(@"Đã đóng Menu");
                             [menuView setHidden:YES];
                         }
         ];
    }else{
        if (searchNav && [self.view.subviews containsObject:searchNav.view]) {
            return;
        }else{
            switch (btnSelectCurrent.tag) {
                case home_type:{
                    UIViewController* topVC = [homeNav topViewController];
                    if ([topVC isKindOfClass:[ChannelVC_iPad class]] || [topVC isKindOfClass:[ArtistVC_iPad class]]) {
                        return;
                    }
                }
                
                    break;
                case khampha_type:
                {
                    UIViewController* topVC = [khamphaNav topViewController];
                    if ([topVC isKindOfClass:[ChannelVC_iPad class]] || [topVC isKindOfClass:[ArtistVC_iPad class]]) {
                        return;
                    }
                }
                    break;
                case tvshow_type:
                {
                    UIViewController* topVC = [tvShowNav topViewController];
                    if ([topVC isKindOfClass:[ChannelVC_iPad class]] || [topVC isKindOfClass:[ArtistVC_iPad class]]) {
                        return;
                    }
                }
                    break;
                case phimngan_type:
                {
                    UIViewController* topVC = [phimnganNav topViewController];
                    if ([topVC isKindOfClass:[ChannelVC_iPad class]] || [topVC isKindOfClass:[ArtistVC_iPad class]]) {
                        return;
                    }
                }
                    break;
                case giaitri_type:
                {
                    UIViewController* topVC = [giaitriNav topViewController];
                    if ([topVC isKindOfClass:[ChannelVC_iPad class]] || [topVC isKindOfClass:[ArtistVC_iPad class]]) {
                        return;
                    }
                }
                    break;
                case canhan_type:
                {
                    UIViewController* topVC = [cuatuiNav topViewController];
                    if ([topVC isKindOfClass:[ChannelVC_iPad class]] || [topVC isKindOfClass:[ArtistVC_iPad class]]) {
                        return;
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
        [menuView setFrame:CGRectMake(0, SCREEN_HEIGHT, menuView.frame.size.width, menuView.frame.size.height)];
        [menuView setHidden:NO];
        [UIView animateWithDuration:0.4f
                         animations:^{
                             [menuView setFrame:CGRectMake(0, menuView.frame.origin.y - menuView.frame.size.height, menuView.frame.size.width, menuView.frame.size.height)];
                         }
                         completion:^(BOOL finished)
                         {
                             // TO DO
//                             NSLog(@"Đã mở Menu");
                         }
         ];
    }
    
}

- (void) showMenu:(BOOL) isShow{
    [menuView setHidden:!isShow];
}

- (void) showMaskVideoView:(BOOL) isShow{
    [maskVideoView setHidden:isShow];
}

- (void) setAlphaMaskVideoView:(float) alpha{
    [maskVideoView setAlpha:alpha];
}

- (int) getIndexOfVideo:(Video*) video fromList:(NSMutableArray*) list{
    for (int i = 0; i < list.count; i++) {
        Video* v = [list objectAtIndex:i];
        if ([video.video_id isEqualToString:v.video_id]) {
            return i+1;
        }
    }
    return 0;
}

- (int) getIndexOfVideoId:(NSString*) videoId fromList:(NSMutableArray*) list{
    for (int i = 0; i < list.count; i++) {
        Video* v = [list objectAtIndex:i];
        if ([videoId isEqualToString:v.video_id]) {
            return i+1;
        }
    }
    return 0;
}

- (void) minimizedVideoPlayer:(BOOL) isMinimized{
    if (isMinimized) {
        [self.view insertSubview:videoPlayer.view belowSubview:menuView];
    }else{
        [self.view insertSubview:videoPlayer.view aboveSubview:menuView];
    }
}


#pragma mark Show Popover

- (void) showSettingView:(BOOL) isShow{
    if (isShow) {
        if (!settingVC) {
            settingVC = [[SettingVC_iPad alloc] initWithNibName:@"SettingVC_iPad" bundle:nil];
            [settingVC setDelegate:self];
        }else{
            [settingVC loadData];
        }
        [settingVC.view setFrame:CGRectMake(0, 0, 320, 480)];
        if (!settingNav) {
            settingNav = [[UINavigationController alloc] initWithRootViewController:settingVC];
        }else{
            [settingNav popToRootViewControllerAnimated:NO];
        }
        settingNav.edgesForExtendedLayout = UIRectEdgeNone;
        if (IOS_VERSION_LOWER_THAN_8) {
            if (!listPopover) {
                listPopover = [[UIPopoverController alloc] initWithContentViewController:settingNav];
                [listPopover setDelegate:self];
            }else{
                [listPopover setContentViewController:settingNav];
            }
        }else{
            listPopover = [[UIPopoverController alloc] initWithContentViewController:settingNav];
            [listPopover setDelegate:self];
        }
        [listPopover setPopoverContentSize:CGSizeMake(320, 480)];
        [listPopover presentPopoverFromRect:CGRectMake(0, 0, 50, 20) inView:btnSetting permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }else{
        if (listPopover != nil) {
            [listPopover dismissPopoverAnimated:YES];
        }
    }
}

- (void) showLoginWithTask:(NSString*) task withVC:(id) vc{
    if (APPDELEGATE.user == nil) {
        if (!loginAlert) {
            loginAlert = [[LoginAlertVC_iPad alloc] initWithNibName:@"LoginAlertVC_iPad" bundle:nil];
        }
        [loginAlert setDelegate:self];
        [loginAlert setTask:task];
        [loginAlert setViewcontroller:vc];
//        NSLog(@"show login view");
        [self.view addSubview:loginAlert.view];
    }else{
        if ([vc respondsToSelector:@selector(loginSuccessWithTask:)]) {
            [vc loginSuccessWithTask:task];
        }
    }
}

- (void) loginWithTask:(NSString*) task{
    [[FacebookLoginTask sharedInstance] setTheTask:task];
    [[FacebookLoginTask sharedInstance] setDelegate:self];
    [[FacebookLoginTask sharedInstance] loginFacebook];
}

- (void) loginSuccessWithTask:(NSString*) task{
//    NSLog(@"login successs");
    id vc = loginAlert.viewcontroller;
    [self hideLoginView];
    if ([vc respondsToSelector:@selector(loginSuccessWithTask:)]) {
        [vc loginSuccessWithTask:task];
    }
}

- (void) hideLoginView{
//    NSLog(@"hide login view");
    if ([self.view.subviews containsObject:loginAlert.view]) {
        [loginAlert.view removeFromSuperview];
    }
}



- (void) showRatingView:(id) vc{
    if (!ratingAlert) {
        ratingAlert = [[RatingAlertVC_iPad alloc] initWithNibName:@"RatingAlertVC_iPad" bundle:nil];
    }
    [ratingAlert setDelegate:vc];
    [self.view addSubview:ratingAlert.view];
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    // do something now that it's been dismissed
//    NSLog(@"aaaa");
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(historyViewClose) name:@"ShowOffHistoryView" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowOffHistoryView" object:nil];
}

//- (void)incrementBagde:(NSNotification*)notification{
//    bagdeCount++;
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:[NSNumber numberWithInteger:bagdeCount] forKey:SETTING_BAGDE];
//    [defaults synchronize];
//    [self addBadge];
//}
//
//- (void)updateBagde{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    bagdeCount = 0;
//    if ([defaults objectForKey:SETTING_BAGDE]) {
//        bagdeCount = (int)[[defaults objectForKey:SETTING_BAGDE] integerValue];
//    }
//    [self addBadge];
//}
//
//- (void) addBadge{
//    if (badge && [btnOffline.subviews containsObject:badge]) {
//        [badge removeFromSuperview];
//    }
//    
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([defaults objectForKey:SETTING_BAGDE]) {
//        bagdeCount = (int)[[defaults objectForKey:SETTING_BAGDE] integerValue];
//    }
//    if (bagdeCount > 0) {
//        badge = [JSCustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", bagdeCount]];
//        [badge setFrame:CGRectMake(46, 3, badge.frame.size.width, badge.frame.size.height)];
//        [btnOffline addSubview:badge];
//    }
//}
- (BOOL) checkOpenningVideo{
    return [self.view.subviews containsObject:videoPlayer.view];
}

//- (void) showRegisterView{
//    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:@"https://id.nct.vn/dang-ky"]];
//    webBrowser.showReloadButton = YES;
//    webBrowser.showActionButton = YES;
//    webBrowser.mode = TSMiniWebBrowserModeModal;
//    webBrowser.barStyle = UIBarStyleDefault;
//    webBrowser.modalDismissButtonTitle = @"";
//    [self presentViewController:webBrowser animated:YES completion:^{
//        if (webBrowser) {
//            [webBrowser didShow];
//        }
//    }];
//}
//
//- (void) showForgetPassword{
//    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:@"https://id.nct.vn/quen-mat-khau"]];
//    webBrowser.showReloadButton = YES;
//    webBrowser.showActionButton = YES;
//    webBrowser.mode = TSMiniWebBrowserModeModal;
//    webBrowser.barStyle = UIBarStyleDefault;
//    webBrowser.modalDismissButtonTitle = @"";
//    [self presentViewController:webBrowser animated:YES completion:^{
//        if (webBrowser) {
//            [webBrowser didShow];
//        }
//    }];
//}

- (void) videoPlayerDismissing{
    playerDissmising = YES;
}

- (void) videoPlayerDismissed{
    playerDissmising = NO;
    itemCurrent = nil;
}

- (void) stopMusicBackground:(BOOL) locked{
    if ([self.view.subviews containsObject:videoPlayer.view]) {
        [videoPlayer stopVideoBackground:locked];
    }
}

#pragma Action
- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
//    [self hideLoginView];
}

- (IBAction) menuSelected:(id)sender{
//    [self hideLoginView];
    UIButton* btn = sender;
    if (searchNav && [self.view.subviews containsObject:searchNav.view]) {
        [searchNav.view removeFromSuperview];
    }

    if (btnSelectCurrent) {
        if (btnSelectCurrent.tag == btn.tag) {
            return;
        }
        [btnSelectCurrent setSelected:NO];
        [btnSelectCurrent setBackgroundColor:[UIColor clearColor]];
        switch (btnSelectCurrent.tag) {
            case home_type: // home view
                [homeNav.view removeFromSuperview];
                break;
            case khampha_type:
                [khamphaNav.view removeFromSuperview];
                break;
            case tvshow_type:
                [tvShowNav.view removeFromSuperview];
                break;
            case phimngan_type:
                [phimnganNav.view removeFromSuperview];
                break;
            case giaitri_type:
                [giaitriNav.view removeFromSuperview];
                break;
            case canhan_type: // Cua Tui
                [cuatuiNav.view removeFromSuperview];
                break;
            case download_type:
                [downloadVC.view removeFromSuperview];
                break;
            default:
                break;
        }
    }
    
    switch (btn.tag) {
        case home_type:
            if (!newHomeVC) {
                newHomeVC = [[CategoryVC_iPad alloc] initWithNibName:@"CategoryVC_iPad" bundle:nil];
            }
            [newHomeVC setDelegate:self];
            [newHomeVC setScreenType:home_type];
            
            if (!homeNav) {
                homeNav = [[UINavigationController alloc] initWithRootViewController:newHomeVC];
                homeNav.navigationBarHidden = YES;
            }
            [self.view insertSubview:homeNav.view belowSubview:maskView];
            break;
            
        case khampha_type:
            if (!khamphaVC) {
                khamphaVC = [[CategoryVC_iPad alloc] initWithNibName:@"CategoryVC_iPad" bundle:nil];
            }
            [khamphaVC setDelegate:self];
            [khamphaVC setScreenType:khampha_type];
            
            if (!khamphaNav) {
                khamphaNav = [[UINavigationController alloc] initWithRootViewController:khamphaVC];
                khamphaNav.navigationBarHidden = YES;
            }
            
            [self.view insertSubview:khamphaNav.view belowSubview:maskView];
            break;
        case tvshow_type:
        {
            if (!tvshowVC) {
                tvshowVC = [[CategoryVC_iPad alloc] initWithNibName:@"CategoryVC_iPad" bundle:nil];
            }
            [tvshowVC setDelegate:self];
            [tvshowVC setScreenType:tvshow_type];
            if (!tvShowNav) {
                tvShowNav = [[UINavigationController alloc] initWithRootViewController:tvshowVC];
                tvShowNav.navigationBarHidden = YES;
            }
            [self.view insertSubview:tvShowNav.view belowSubview:maskView];
            break;
        }
        case phimngan_type:
            if (!phimNganVC) {
                phimNganVC = [[CategoryVC_iPad alloc] initWithNibName:@"CategoryVC_iPad" bundle:nil];
            }
            [phimNganVC setDelegate:self];
            [phimNganVC setScreenType:phimngan_type];
            
            if (!phimnganNav) {
                phimnganNav = [[UINavigationController alloc] initWithRootViewController:phimNganVC];
                phimnganNav.navigationBarHidden = YES;
            }
            
            [self.view insertSubview:phimnganNav.view belowSubview:maskView];
            break;
        case giaitri_type:
            if (!giaitriVC) {
                giaitriVC = [[CategoryVC_iPad alloc] initWithNibName:@"CategoryVC_iPad" bundle:nil];
            }
            [giaitriVC setDelegate:self];
            [giaitriVC setScreenType:giaitri_type];
            
            if (!giaitriNav) {
                giaitriNav = [[UINavigationController alloc] initWithRootViewController:giaitriVC];
                giaitriNav.navigationBarHidden = YES;
            }
            [self.view insertSubview:giaitriNav.view belowSubview:maskView];
            break;
        case canhan_type:
            if (!cuaTuiVC) {
                cuaTuiVC = [[CuaTuiVC_iPad alloc] initWithNibName:@"CuaTuiVC_iPad" bundle:nil];
            }
            [cuaTuiVC setDelegate:self];
            if (!cuatuiNav) {
                cuatuiNav = [[UINavigationController alloc] initWithRootViewController:cuaTuiVC];
                cuatuiNav.navigationBarHidden = YES;
            }
            [self.view insertSubview:cuatuiNav.view belowSubview:maskView];
            break;
        case download_type:
            if (!downloadVC) {
                downloadVC = [[CategoryVC_iPad alloc] initWithNibName:@"CategoryVC_iPad" bundle:nil];
            }
            [downloadVC setDelegate:self];
            [downloadVC setScreenType:download_type];
            [self.view insertSubview:downloadVC.view belowSubview:maskView];
            break;
        default:
            break;
    }
    [btn setSelected:YES];
//    [btn setBackgroundColor:[UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1.0f]];
//    [btn setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.2f]];
//    btn setBackgroundColor:[UIColor ]
//    [btn setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.2f]];
//    [btn setBackgroundColor:UIColorFromRGB(0xffffff)];
    [btn setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.08]];
//    [btn setAlpha:0.8f];
    btnSelectCurrent = btn;
}

@end
