//
//  AppDelegate.m
//  NPlus
//
//  Created by TEVI Team on 7/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "AppDelegate.h"
#import "AKTabBarController.h"
#import "JSCustomBadge.h"
#import "iRate.h"
#import "HomeVC.h"
#import "AKNavigationController.h"
#import "APIController.h"
#import "RootVC_iPad.h"
#import "TokenInfo.h"
#import "DBHelper.h"
#import "UIView+Toast.h"

#import "GAI.h"
#import "FacebookLoginTask.h"
#import "TSMiniWebBrowser.h"

#import "HomeController.h"
#import "CanhanController.h"
#import "MenuGenreViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "DiscoveryVC.h"
#import "DownloadController.h"
#import "GenreController.h"
#import "ActorController.h"
#import "NewFeedVCViewController.h"
#import "PageViewController.h"


//#import <Fabric/Fabric.h>
//#import <Crashlytics/Crashlytics.h>

@interface AppDelegate () <UISplitViewControllerDelegate> {
    NSString *_url;
    NSString *notifyId;
}
@end

@implementation AppDelegate
@synthesize sideMenuViewController = _sideMenuViewController;
@synthesize rootNavController = _rootNavController;
@synthesize tabBarController = _tabBarController;
@synthesize nowPlayerVC = _nowPlayerVC;
@synthesize internetReachability = _internetReachability;
@synthesize internetConnnected = _internetConnnected;
@synthesize connectionType = _connectionType;
@synthesize user = _user;
@synthesize versionEntity = _versionEntity;

static bool lockedScreen = NO;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
//        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
//    }
    _connectionType = kConnectionTypeNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];
	[self updateInterfaceWithReachability:self.internetReachability];
    [self isLoggined];
    [self initGA];
    [self getAccessToken];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
    // If the device is an iPad, we make it taller.
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    if (!IS_IPAD) {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        _tabBarController = [[AKTabBarController alloc] initWithTabBarHeight:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 70 : 50];
        
        // Comment out the line above and uncomment the line below to show the tab bar at the top of the UI.
        /*
         _tabBarController = [[AKTabBarController alloc] initWithTabBarHeight:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 70 : 50 position:AKTabBarPositionBottom];
         */
        
        [_tabBarController setMinimumHeightToDisplayTitle:40.0];
        
        // If needed, disable the resizing when switching display orientations.
        /*
         [_tabBarController setTabBarHasFixedHeight:YES];
         */
        
        [self setupTabbarControllerIsInit:YES];
        
        
        //    [_tabBarController setBackgroundImageName:@"tabbar_bg"];
        //    [_tabBarController setSelectedBackgroundImageName:@"tabbar_bg"];
        [_tabBarController setTabStrokeColor:[UIColor clearColor]];
        [_tabBarController setIconShadowColor:[UIColor clearColor]];
        [_tabBarController setIconShadowOffset:CGSizeMake(0, 0)];
//        [_tabBarController setIconColors:@[RGB(136, 137, 137), RGB(136, 137, 137)]]; // MAX 2 Colors
        [_tabBarController setSelectedIconColors:@[RGB(0, 173, 239), RGB(0, 173, 239)]]; // MAX 2 Colors
        [_tabBarController setSelectedIconOuterGlowColor:[UIColor clearColor]];
        [_tabBarController setTextColor:RGB(136, 137, 137)];
        [_tabBarController setSelectedTextColor:RGB(0, 173, 239)];
        [_tabBarController setTabEdgeColor:[UIColor clearColor]];
        [_tabBarController setTabInnerStrokeColor:[UIColor clearColor]];
        [_tabBarController setTabStrokeColor:[UIColor clearColor]];
        [_tabBarController setTopEdgeColor:[UIColor clearColor]];
        [_tabBarController setIsGradient:NO];
        [_tabBarController setIsFillBackgroundNoisePattern:NO];
        [_tabBarController setTabIconPreRendered:YES];
        [_tabBarController setTabTitleIsHidden:YES];
        
        _tabBarController.defaultBadge = [JSCustomBadge customBadgeWithString:@""
                                                              withStringColor:[UIColor whiteColor]
                                                               withInsetColor:[UIColor redColor]
                                                               withBadgeFrame:YES
                                                          withBadgeFrameColor:[UIColor redColor]
                                                                    withScale:0.8f
                                                                  withShining:NO];
        
        _rootNavController = [[UINavigationController alloc] initWithRootViewController:_tabBarController];
        _rootNavController.navigationBarHidden = YES;
        [_rootNavController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        _rootNavController.navigationBar.translucent = YES;
        [_rootNavController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:kFontSemibold size:18.0f],NSForegroundColorAttributeName: [UIColor whiteColor]}];
        [_rootNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg-header-top-v2"]
                                                    forBarMetrics:UIBarMetricsDefault];
//        _rootNavController.navigationBar.shadowImage = [UIImage new];
        //_rootNavController.view.backgroundColor = [UIColor lightTextColor];
        _rootNavController.navigationBar.backgroundColor = [UIColor clearColor];

        
        _tabBarController.tabBar.hidden = YES;
        
        _rightMenu = [[MenuGenreViewController alloc]init];
        _sideMenuViewController = [[RESideMenu alloc]initWithContentViewController:_rootNavController leftMenuViewController:nil rightMenuViewController:_rightMenu];
        _sideMenuViewController.panGestureEnabled = NO;
        
        _sideMenuViewController.backgroundImage = [UIImage imageNamed:@"bg-app-tevi"];
        _sideMenuViewController.menuPreferredStatusBarStyle = 0; // UIStatusBarStyleLightContent
        _sideMenuViewController.delegate = self;
        _sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
        _sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
        _sideMenuViewController.contentViewShadowOpacity = 0.6;
        _sideMenuViewController.contentViewShadowRadius = 12;
        _sideMenuViewController.contentViewShadowEnabled = YES;
        self.window.rootViewController = _sideMenuViewController;
        
        _nowPlayerVC = [[NowPlayerVC alloc] initWithNibName:@"NowPlayerVC" bundle:nil];
        [_sideMenuViewController.contentViewController.view addSubview:_nowPlayerVC.view];
        _nowPlayerVC.view.hidden = NO;
        //[_window addSubview:_nowPlayerVC.view];
        [_nowPlayerVC showPlayer:NO withAnimation:NO];
        [self start];
        
        [_window makeKeyAndVisible];
    }
    else{
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), //center
                                        NULL, // observer
                                        lockStateChanged, // callback
                                        CFSTR("com.apple.springboard.lockcomplete"), // event name
                                        NULL, // object
                                        CFNotificationSuspensionBehaviorDeliverImmediately);

        [self start];
        [_window makeKeyAndVisible];
    }
    [self checkVersion];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotifiyMiniPlayer:) name:kDidMinimizePlayerForActor object:nil];
//    [Fabric with:@[[Crashlytics class]]];
    if (launchOptions) {
        NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (notification) {
            NSLog(@"app recieved notification from remote%@",notification);
            [self application:application didReceiveRemoteNotification:notification];
        }else{
            NSLog(@"app did not recieve notification");
        }
    }
    return YES;
}

- (void)receiveNotifiyMiniPlayer:(NSNotification*)notif {
    if (!APPDELEGATE.retictPushActorVC ) {
        NSDictionary *userInfo = [notif userInfo];
        if (userInfo) {
            
        }
    }
}

- (void)getAccessToken {
    [[APIController sharedInstance]getAccessTokenCompleted:^(id results) {
        
    } failed:^(NSError *error) {
        
    }] ;
}

- (void)setupTabbarControllerIsInit:(BOOL)isInit {
    HomeController *homeVC = [[HomeController alloc]initWithNibName:@"HomeController" bundle:nil];
    DiscoveryVC* discoveryVC = [[DiscoveryVC alloc] initWithNibName:@"DiscoveryVC" bundle:nil];
    _newfeedVC = [[NewFeedVCViewController alloc]initWithNibName:@"NewFeedVCViewController" bundle:nil];
    CanhanController *canhanVC = [[CanhanController alloc]initWithNibName:@"CanhanController" bundle:nil];
    DownloadController* myDownloadVC = [[DownloadController alloc] initWithNibName:@"DownloadController" bundle:nil];
    [_tabBarController setViewControllers:[NSMutableArray arrayWithObjects:
                                               [[AKNavigationController alloc] initWithRootViewController:homeVC],
                                               [[AKNavigationController alloc] initWithRootViewController:discoveryVC],
                                                [[AKNavigationController alloc] initWithRootViewController:_newfeedVC],
                                                [[AKNavigationController alloc] initWithRootViewController:canhanVC],
                                               [[AKNavigationController alloc] initWithRootViewController:myDownloadVC],
                                               nil]];
    
}

static void lockStateChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    NSString *lockState = (__bridge NSString *)((CFStringRef)name);
//    NSLog(@"event received!:%@",name);
    if ([lockState isEqualToString:@"com.apple.springboard.lockcomplete"]) {
        lockedScreen = YES;
    }
//    else{
//        if (lockedScreen) {
//            lockedScreen = NO;
//         }
//    }
}

- (void)finishedWelcomeScreen{
    [self start];
}

-(void)start{
    if (IS_IPAD) {
        _rootVC = [[RootVC_iPad alloc] initWithNibName:@"RootVC_iPad" bundle:nil];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.rootVC];
        nav.navigationBarHidden = YES;
        [_window setRootViewController:nav];
    }else{
        if ([[[kNSUserDefault dictionaryRepresentation] allKeys] containsObject:SETTING_INTRO ]) {
            [_window setRootViewController:_sideMenuViewController];
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            _nowPlayerVC.view.hidden = NO;
            [_window bringSubviewToFront:_nowPlayerVC.view];
        } else {
            PageViewController *pageWelcome = [[PageViewController alloc]initWithNibName:@"PageViewController" bundle:nil];
            [_window setRootViewController:pageWelcome];
        }
    }
    
    [kNSUserDefault setObject:[NSNumber numberWithBool:YES] forKey:SETTING_INTRO];
    [kNSUserDefault synchronize];
}

- (void)initPlayerWithHidden:(BOOL)hidden {
    if (_nowPlayerVC) {
        [_nowPlayerVC stopPlayer];
        [_nowPlayerVC myDealloc];
        [_nowPlayerVC.view removeFromSuperview];
        _nowPlayerVC = nil;
    }
    _nowPlayerVC = [[NowPlayerVC alloc] initWithNibName:@"NowPlayerVC" bundle:nil];
    [_sideMenuViewController.contentViewController.view addSubview:_nowPlayerVC.view];
    //[_window addSubview:_nowPlayerVC.view];
    [_nowPlayerVC showPlayer:NO withAnimation:NO];
    if (hidden) {
        _nowPlayerVC.view.hidden = YES;
    } else {
        _nowPlayerVC.view.hidden = NO;
        [_window bringSubviewToFront:_nowPlayerVC.view];
    }
}
- (void)playerLoadDataWithType:(NSString*)type video:(Video*)video channel:(Channel *)channel index:(int)index{
    _nowPlayerVC.type = type;
    if (APPDELEGATE.nowPlayerVC.typePlayer != typePlayerOffline) {
        _nowPlayerVC.tbInfo.hidden = NO;
        _nowPlayerVC.prepairedVideo = video;
        [_nowPlayerVC loadDataVideoIndex:index];
        if ([type isEqualToString:@"NEW_VIDEO"]) {
            [_nowPlayerVC loadDataNewVideo];
            [_nowPlayerVC showPlayer:YES withAnimation:YES];
        } else if ([type isEqualToString:@"NEW_VIDEO_IN_SEASON"]){
            [_nowPlayerVC loadNewDataForVideoInSeason];
        } else if ([type isEqualToString:@"NEW_VIDEO_SUGGESTION"]) {
            [_nowPlayerVC loadDataNewVideoSuggestion];
        } else if ([type isEqualToString:@"NEW_SEASON"]){
            [_nowPlayerVC loadNewSeason];
        } else if ([type isEqualToString:@"SHOWCASE_CHANNEL"]) {
            [_nowPlayerVC loadDataWithChannel:channel];
            [_nowPlayerVC loadVideoDetailWithLoadChannel:NO];
            [_nowPlayerVC showPlayer:YES withAnimation:YES];
        }
    } else {
        //update player for offline
        _nowPlayerVC.tbInfo.hidden = YES;
        [_nowPlayerVC loadDataOffile];
        [_nowPlayerVC showPlayer:YES withAnimation:YES];
        
    }
}

- (void) initGA{
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
//    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:kAnalyticsID];
}

- (void)addNowPlayingViewController{
    //[_rootNavController addChildViewController:_nowPlayerVC];
    [_window bringSubviewToFront:_nowPlayerVC.view];
    [_sideMenuViewController.contentViewController.navigationController.topViewController.view bringSubviewToFront:_nowPlayerVC.view];
    [APPDELEGATE.rootNavController.view bringSubviewToFront:_nowPlayerVC.view];
}
- (void)removeNowPlayingViewController{
//    _nowPlayerVC.lstVideo = nil;
//    _nowPlayerVC.season = nil;
//    _nowPlayerVC.currentVideo = nil;
//    _nowPlayerVC.currentOfflineVideo = nil;
    [_nowPlayerVC removeFromParentViewController];
}

- (void)checkVersion{
    [[APIController sharedInstance] checkVersionCompleted:^(VersionEntity *result) {
        if (result) {
            _versionEntity = (VersionEntity*)result;
            if (_versionEntity.isUpdate) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:_versionEntity.msg delegate:self cancelButtonTitle:(_versionEntity.foreUpdate ? nil : @"Đóng") otherButtonTitles:@"Cập nhật", nil];
                alert.tag = 111;
                [alert show];
            }
        }
    } failed:^(NSError *error) {
        _versionEntity = [[VersionEntity alloc] init];
    }];
}

#pragma mark - Register Notification
- (void)registerPushNotification {
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    NSString *token = [[NSString alloc] initWithFormat:@"%@", devToken];
    token = [token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (token) {
        [[APIController sharedInstance]keyNotify:token completed:^(BOOL result) {} failed:^(NSError *error) {}];
    }
}
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0;
    if (userInfo) {
        [self receiveRemoteNotiWithInfo:userInfo application:application];
    }
}

- (void)receiveRemoteNotiWithInfo:(NSDictionary*)info application:(UIApplication*)application {
    if (info) {
        if ([info objectForKey:@"TYPE"]) {
            NSString *key = [info objectForKey:@"TYPE"];
            UIApplicationState state = [application applicationState];
            notifyId = [[info objectForKey:@"NOTIFID"]description];
            if ([key isEqualToString:@"LINK"] || [key isEqualToString:@"APP"]) {
                if ([info objectForKey:@"ID"]) {
                    NSString *stringURL = [info objectForKey:@"ID"];
                    _url = stringURL;
                    if (state == UIApplicationStateActive) {
                        if ([info objectForKey:@"aps"]) {
                            NSDictionary *dict = [info objectForKey:@"aps"];
                            NSString *stringMessage = @"";
                            if ([dict objectForKey:@"alert"]) {
                                stringMessage = [dict objectForKey:@"alert"];
                            }
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                            message:stringMessage
                                                                           delegate:self cancelButtonTitle:@"Hủy"
                                                                  otherButtonTitles:@"Xem", nil];
                            alert.tag = 444;
                            [alert show];
                        }
                    }else{
                        [self showWebViewWithURL:stringURL];
                    }
                }
            } else if ([key isEqualToString:@"VIDEO"]) {
                if ([info objectForKey:@"ID"]) {
                    NSString *videoKey = [[info objectForKey:@"ID"]description];
                    Video *video = [[Video alloc]init];
                    video.video_id = videoKey;
                    
                    if (state == UIApplicationStateActive) {
                        NSDictionary *aps = [info objectForKey:@"aps"];
                        NSString *message = [aps objectForKey:@"alert"];
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Thôi" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [alert dismissViewControllerAnimated:YES completion:^{
                                
                            }];
                        }];
                        UIAlertAction *viewAction = [UIAlertAction actionWithTitle:@"Xem" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                             [self didSelectVideoCellWith:video];
                            [[APIController sharedInstance]logNotifyViewd:notifyId completed:^(BOOL result) {} failed:^(NSError *error) {}];
                        }];
                        [alert addAction:cancelAction];
                        [alert addAction:viewAction];
                        [self.rootNavController.topViewController presentViewController:alert animated:YES completion:nil];
                    } else {
                        [self didSelectVideoCellWith:video];
                        [[APIController sharedInstance]logNotifyViewd:notifyId completed:^(BOOL result) {} failed:^(NSError *error) {}];
                    }
                }
            } else if ([key isEqualToString:@"CHANNEL"]) {
                if ([info objectForKey:@"ID"]) {
                    NSString *channelKey = [[info objectForKey:@"ID"]description];
                    Channel *channel = [[Channel alloc]init];
                    channel.channelId = channelKey;
                    if (state != UIApplicationStateActive) {
                        [self didSelectChannelCellWith:channel isPush:YES];
                        [[APIController sharedInstance]logNotifyViewd:notifyId completed:^(BOOL result) {} failed:^(NSError *error) {}];
                    } else {
                        NSDictionary *aps = [info objectForKey:@"aps"];
                        NSString *message = [aps objectForKey:@"alert"];
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Thôi" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [alert dismissViewControllerAnimated:YES completion:^{
                                
                            }];
                        }];
                        UIAlertAction *viewAction = [UIAlertAction actionWithTitle:@"Xem" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [self didSelectChannelCellWith:channel isPush:YES];
                            [[APIController sharedInstance]logNotifyViewd:notifyId completed:^(BOOL result) {} failed:^(NSError *error) {}];
                        }];
                        [alert addAction:cancelAction];
                        [alert addAction:viewAction];
                        [self.rootNavController.topViewController presentViewController:alert animated:YES completion:nil];
                    }
                }
            }
        }
    }
}
- (void) showWebViewWithURL:(NSString*) url{
    [[APIController sharedInstance]logNotifyViewd:notifyId completed:^(BOOL result) {} failed:^(NSError *error) {}];
    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:url]];
    webBrowser.showReloadButton = YES;
    webBrowser.showActionButton = YES;
    webBrowser.mode = TSMiniWebBrowserModeModal;
    webBrowser.barStyle = UIBarStyleDefault;
    webBrowser.modalDismissButtonTitle = @"";
    
    [self.window.rootViewController presentViewController:webBrowser animated:YES completion:^{
        if (webBrowser) {
            [webBrowser didShow];
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (notification.userInfo) {
        //NSDictionary *dict = notification.userInfo;
    }
}


- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 111 && buttonIndex != alertView.cancelButtonIndex && _versionEntity.url && _versionEntity.url.length)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_versionEntity.url]];
    } else if (alertView.tag == 444){
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self showWebViewWithURL:_url];
        }
    }
}


-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler{
    
    self.backgroundTransferCompletionHandler = completionHandler;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    [self performSelector:@selector(screenLockActivated)
//               withObject:nil
//               afterDelay:0];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (IS_IPAD) {
        if(self.rootVC){
            [self.rootVC stopMusicBackground:lockedScreen];
            if (lockedScreen) {
                lockedScreen = !lockedScreen;
            }
        }
    }else{
        if (self.nowPlayerVC) {
//            double seconds = CMTimeGetSeconds([APPDELEGATE.nowPlayerVC.player timeCurrent]);
//            double duration = CMTimeGetSeconds([APPDELEGATE.nowPlayerVC.player timeDuration]);
//            if (seconds == duration) {
//                seconds = -1;
//            }
//            [[DBHelper sharedInstance] addVideoToHistory:APPDELEGATE.nowPlayerVC.currentVideo withStopTime:seconds];
            [self.nowPlayerVC.player pause];
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    [self checkVersion];
    application.applicationIconBadgeNumber = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:kWillEnterForeground object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //[[DBHelper sharedInstance] saveContext];
    
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];

    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBSDKAppEvents activateApp];
}


- (BOOL)isLoggined {
    APPDELEGATE.isLogined = [Utilities checkLogined];
    if (APPDELEGATE.isLogined) {
        if ([kNSUserDefault objectForKey:kUserDefaultUser]) {
            NSDictionary *info = [kNSUserDefault objectForKey:kUserDefaultUser];
            User *user = [[User alloc]init];
            user.userName = [info objectForKey:kUserName];
            user.displayName = [info objectForKey:kUserDisplayName];
            user.avatar = [info objectForKey:kUserAvatar];
            user.email = [info objectForKey:kUserEmail];
            APPDELEGATE.user = user;
        }
        return YES;
    }
    return NO;
}

-(NSString *)getUserID{
    if (self.user == nil)
        return @"0";
    return self.user.userID;
}

- (void)didSelectArtistCellWith:(Artist *)artist{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    ActorController *actorVC = [[ActorController alloc]initWithNibName:@"ActorController" bundle:nil];
    actorVC.artist = artist;
    [APPDELEGATE.rootNavController pushViewController:actorVC animated:YES];
    
}

- (void)didSelectVideoOffline:(Video*)video {
    [APPDELEGATE.nowPlayerVC.player.view.btnHD setTitle:video.type_quality forState:UIControlStateNormal];
    if ([video.type_quality  containsString:@"720"] || [video.type_quality  containsString:@"1080"]) {
        APPDELEGATE.nowPlayerVC.player.view.iconHD.hidden = NO;
    } else {
        APPDELEGATE.nowPlayerVC.player.view.iconHD.hidden = YES;
    }
    APPDELEGATE.nowPlayerVC.type = @"OFFLINE";
    APPDELEGATE.nowPlayerVC.typePlayer = typePlayerOffline;
    [APPDELEGATE.nowPlayerVC playWithVideo:video] ;
    APPDELEGATE.nowPlayerVC.isShowViewMore = NO;
    APPDELEGATE.nowPlayerVC.player.view.btnNext.hidden = YES;
    APPDELEGATE.nowPlayerVC.player.view.btnPrevious.hidden = YES;
    [self.nowPlayerVC trackScreen:@"iOS.OfflinePlayer"];
    if (!APPDELEGATE.nowPlayerVC.isShowNowPlaying || APPDELEGATE.nowPlayerVC.player.view.isMinimize) {
        [APPDELEGATE playerLoadDataWithType:@"OFFLINE" video:video channel:nil index:0];
    } else {
        [APPDELEGATE.nowPlayerVC.tbVideo reloadData];
        for (NSLayoutConstraint *topContraint in _nowPlayerVC.contentContainer.constraints) {
            if ( [topContraint.firstItem isEqual:_nowPlayerVC.tbVideo] && [topContraint.secondItem isEqual:_nowPlayerVC.headeView] && topContraint.firstAttribute == NSLayoutAttributeTop && topContraint.secondAttribute == NSLayoutAttributeBottom) {
                topContraint.constant = - _nowPlayerVC.headeView.frame.size.height - _nowPlayerVC.header.frame.size.height;
                [_nowPlayerVC.contentContainer setNeedsLayout];
                [_nowPlayerVC.contentContainer layoutIfNeeded];
                break;
            }
        }
    }
    APPDELEGATE.nowPlayerVC.player.view.lbTitle.text = APPDELEGATE.nowPlayerVC.currentVideo.video_title;
    //[APPDELEGATE.nowPlayerVC.tbVideo reloadData];
    
}

- (void)didSelectVideoCellWith:(Video*)video {
    [self.nowPlayerVC trackScreen:@"iOS.Player"];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [[APIController sharedInstance]getVideoStreamWithKey:video.video_id completed:^(int code, VideoStream *results) {
        if (results) {
            video.videoStream = results;
            APPDELEGATE.nowPlayerVC.typePlayer = typePlayerVideoOfSeason;
            APPDELEGATE.nowPlayerVC.isShowViewMore = YES;
            [APPDELEGATE playerLoadDataWithType:@"NEW_VIDEO" video:video channel:nil index:0];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kDidPlayVideo object:nil];
    } failed:^(NSError *error) {
        //[self dismissHUD];
        APPDELEGATE.nowPlayerVC.player.view.isLockControll = NO;
    }];
}

- (void)didSelectChannelCellWith:(Channel*)channel isPush:(BOOL)isPush{
    [self.nowPlayerVC trackScreen:@"iOS.Player"];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (APPDELEGATE.internetConnnected) {
        if (channel.videoKey) {
            [[APIController sharedInstance]getVideoStreamWithKey:channel.videoKey completed:^(int code, VideoStream *results) {
                Video *video = [[Video alloc]init];
                video.video_id = channel.videoKey;
                video.videoStream = results;
                APPDELEGATE.nowPlayerVC.typePlayer = typePlayerVideoOfSeason;
                APPDELEGATE.nowPlayerVC.isShowViewMore = YES;
                [APPDELEGATE playerLoadDataWithType:@"NEW_VIDEO" video:video channel:nil index:0];
                [[NSNotificationCenter defaultCenter]postNotificationName:kDidPlayVideo object:nil];
            } failed:^(NSError *error) {
                
            }];
        } else {
            [[APIController sharedInstance]getChannelDetailWithKey:channel.channelId completed:^(int code, Channel *results) {
                if (results) {
                    //APPDELEGATE.nowPlayerVC.curChannel = results;
                    [[APIController sharedInstance]getVideoStreamWithKey:results.videoKey completed:^(int code, VideoStream *stream) {
                        Video *video = [[Video alloc]init];
                        video.video_id = results.videoKey;
                        video.videoStream = stream;
                        APPDELEGATE.nowPlayerVC.typePlayer = typePlayerVideoOfSeason;
                        APPDELEGATE.nowPlayerVC.isShowViewMore = YES;
                        if (isPush) {
                            [APPDELEGATE playerLoadDataWithType:@"NEW_VIDEO" video:video channel:results index:0];
                        } else {
                            [APPDELEGATE playerLoadDataWithType:@"SHOWCASE_CHANNEL" video:video channel:results index:0];
                        }
                        
                    } failed:^(NSError *error) {
                        
                    }];
                }
            } failed:^(NSError *error) {
                
            }];
        }
    }
}
- (void)didSelectGenre:(Genre*)parentGenre listGenres:(NSArray*)listGenres index:(NSInteger)index {
    if (listGenres) {
        NSMutableArray* list = [[NSMutableArray alloc] initWithObjects:parentGenre, nil];
        [list addObjectsFromArray:listGenres];
        index ++;
        GenreController *genreVC = [[GenreController alloc]initWithNibName:@"GenreController" bundle:nil listGenres:list indexTab:index];
        genreVC.type = [Utilities getTypeGenre];
        genreVC.genre = parentGenre;
        genreVC.hidesBottomBarWhenPushed = YES;
        [APPDELEGATE.rootNavController.topViewController.navigationController pushViewController:genreVC animated:YES];
    } else if (parentGenre) {
//        NSLog(@"vao day");
        [[APIController sharedInstance]getListGenresWithParentId:parentGenre.genreId completed:^(int code, NSArray *results) {
            if (results) {
//                NSLog(@"tra ket qua ve day");
                GenreController *genreVC = [[GenreController alloc]initWithNibName:@"GenreController" bundle:nil];
                genreVC.type = [Utilities getTypeGenre];
                genreVC.genre = parentGenre;
                genreVC.listGenres = (NSMutableArray*)results;
                genreVC.hidesBottomBarWhenPushed = YES;
                [APPDELEGATE.rootNavController.topViewController.navigationController pushViewController:genreVC animated:YES];
            } else {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"enableButton" object:nil];
            }
        } failed:^(NSError *error) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"enableButton" object:nil];
        }];
    }
}

#pragma mark - reachability network
- (void) reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self updateInterfaceWithReachability:curReach];
}
- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.internetReachability)
	{
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        BOOL connectionRequired = [reachability connectionRequired];
        NSString* statusString = @"";
        
        switch (netStatus)
        {
            case NotReachable:        {
                statusString = @"Mất kết nối mạng, vui lòng kiểm tra lại";
                _internetConnnected = NO;
                _connectionType = kConnectionTypeNone;
                connectionRequired = NO;
                break;
            }
                
            case ReachableViaWWAN:        {
                statusString = @"Đã chuyển qua mạng 2G/3G";
                _internetConnnected = YES;
                _connectionType = kConnectionTypeWAN;
                break;
            }
            case ReachableViaWiFi:        {
                statusString= @"Đã bật Wifi";
                _internetConnnected = YES;
                _connectionType = kConnectionTypeWifi;
                break;
            }
        }
        
        if (connectionRequired)
        {
            statusString= @"Mất kết nối mạng, vui lòng kiểm tra lại";
            _internetConnnected = NO;
            _connectionType = kConnectionTypeNone;
        }
        if (_internetConnnected) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kDidConnectInternet object:nil];
        }
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state == UIApplicationStateActive && statusString.length > 0)
        {
            [self showToastWithMessage:statusString position:@"top" type:0];
        }
        if (self.nowPlayerVC) {
            [self.nowPlayerVC cellcularChange];
        }
    }
}

//- (void) setUser:(User *)user
//{
//    if (_user && user && [_user.userName isEqualToString:user.userName]
//        && [_user.passWord isEqualToString:user.passWord]
//        && [_user.userID isEqualToString:user.userID]
//        && [_user.avatar isEqualToString: user.avatar])
//    {
//        return;
//    }
//    
//    _user = user;
//    if (user == nil)
//    {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:@"" forKey:SETTING_USERNAME];
//        [defaults setObject:@"" forKey:SETTING_PWD];
//        [defaults setObject:@"" forKey:SETTING_USERID];
//        [defaults setObject:@"" forKey:SETTING_AVATAR];
//        [defaults synchronize];
//    }
//    else
//    {
//    	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:user.userName forKey:SETTING_USERNAME];
//        [defaults setObject:user.passWord forKey:SETTING_PWD];
//        [defaults setObject:user.userID forKey:SETTING_USERID];
//        [defaults setObject:user.avatar forKey:SETTING_AVATAR];
//        [defaults synchronize];
//    }
//}

- (void) setUser:(User *)user
{
    if (_user && user && [_user.userName isEqualToString:user.userName])
    {
        return;
    }
    _user = user;
}

+ (void)initialize
{
    [iRate sharedInstance].appStoreID = kAPPID;
    [iRate sharedInstance].daysUntilPrompt = 10;
    
}

-(void)showToastMessage:(NSString *)message{
    if (IS_IPAD) {
        [self.rootVC.view makeToast:message duration:2.0 position:@"bottom"];
    }else{
        [self.rootNavController.view makeToast:message duration:2.0f position:@"top"];
    }
}

-(void) showToastMessage:(NSString *)message withImageName:(NSString*) imageName{
    if (IS_IPAD) {
        [self.rootVC.view makeToast:message duration:2.0 position:@"center" image:[UIImage imageNamed:imageName]];
    }else{
        [self.rootNavController.view makeToast:message duration:2.0f position:@"top"];
    }
}

- (void)showToastWithMessage:(NSString *)mesage position:(NSString *)position type:(int)type {
    _isShowingNotif = YES;
    if (type==noneImage) {
        //[self.window makeToast:mesage duration:2.0 position:position image:nil];
        [self.window makeToast:mesage duration:2.0 position:@"top" title:@"Success" image:nil];
    } else if (type == doneImage){
        [self.window makeToast:mesage duration:2.0 position:@"top" title:@"Success" image:[UIImage imageNamed:@"icon-thongbao-success-v2"]];
    } else if (type == errorImage) {
        [self.window makeToast:mesage duration:2.0 position:@"top" title:@"Warning" image:[UIImage imageNamed:@"icon-thongbao-fail-v2"]];
    }
    
}

-(BOOL)allowDownload{
    return YES;
}

-(void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application
{
//    NSLog(@"bbb");
}

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application
{
//    NSLog(@"aaa");
}


- (void)showTutorial:(NSString*)name{
    UIImageView *img = (UIImageView*)[self.window viewWithTag:333];
    _tutorialName = nil;
    if (img) {
        [img removeFromSuperview];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UIImageView *imageView = nil;
    if ([[defaults objectForKey:name] boolValue] || ![defaults objectForKey:name]) {
        NSString *iName;
        if ([name isEqualToString:TUTORIAL_2]) {
            iName = [self nameForHardware:@"tut_2"];
        }else if([name isEqualToString:TUTORIAL_4]){
            iName = [self nameForHardware:@"tut_4"];
        }
        
        imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [imageView setImage:[UIImage imageNamed:iName]];
        
        if (imageView) {
            _tutorialName = name;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissImageView:)];
            [imageView addGestureRecognizer:tap];
            imageView.userInteractionEnabled = YES;
            imageView.tag = 333;
            [self.window addSubview:imageView];
            [self.nowPlayerVC.player performSelector:@selector(pause) withObject:nil afterDelay:0.5f];
            if (![defaults objectForKey:name]) {
                [defaults setObject:[NSNumber numberWithBool:YES] forKey:name];
                [defaults synchronize];
            }
        }
    }
}

- (void)dismissImageView:(UITapGestureRecognizer*)gesture{
    UIView *view = [gesture view];
    NSUserDefaults* userDefaut = [NSUserDefaults standardUserDefaults];
    [UIView animateWithDuration:0.5f animations:^{
        view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (_tutorialName) {
            [userDefaut setObject:[NSNumber numberWithBool:NO] forKey:_tutorialName];
        }
        view.userInteractionEnabled = NO;
        [view removeFromSuperview];
    }];
}

- (NSString*)nameForHardware:(NSString*)fileName{
    if(IS_IPHONE_5){
        return [fileName stringByAppendingString:@"_ip5"];
    }else if(IS_IPHONE_6){
        return [fileName stringByAppendingString:@"_ip6"];
    }else if(IS_IPHONE_6P){
        return [fileName stringByAppendingString:@"_ip6"];
    }
    return fileName;
}

#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

#pragma mark - Rotation

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if (!IS_IPAD) {
        UIImageView *cm = [APPDELEGATE.nowPlayerVC.view viewWithTag:901];
        if (_nowPlayerVC.isShowNowPlaying && !_nowPlayerVC.player.view.isMinimize && !_nowPlayerVC.player.loginVC && !_nowPlayerVC.player.view.isAnimation && !_nowPlayerVC.player.view.isTouch && !APPDELEGATE.isShowingPopup && !APPDELEGATE.isShowingNotif && !cm) {
            return UIInterfaceOrientationMaskAll;
        } else if (APPDELEGATE.isShowingPopup || APPDELEGATE.isShowingNotif || _nowPlayerVC.player.view.isShowPanelForward) {
            if (_nowPlayerVC.player.view.isFullScreen) {
                //return UIInterfaceOrientationMaskLandscape;
            } else {
                //return UIInterfaceOrientationMaskPortrait;
            }
        }
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskLandscape;
}

- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration {
    if (!IS_IPAD) {
        if (newStatusBarOrientation == UIInterfaceOrientationPortrait) {
            _nowPlayerVC.orientation = UIInterfaceOrientationPortrait;
        } else {
            _nowPlayerVC.orientation = UIInterfaceOrientationMaskLandscapeRight;
        }
    }
}

- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
    if (!IS_IPAD) {
        if (_nowPlayerVC.orientation == (UIInterfaceOrientation) UIInterfaceOrientationMaskLandscapeRight) {
            [_nowPlayerVC.player performOrientationChange:UIInterfaceOrientationLandscapeRight completion:^(BOOL finished) {
                _nowPlayerVC.player.view.isLandcape = YES;
                [_nowPlayerVC.player.view showPlayButton:!_nowPlayerVC.player.isPlaying];
            }];
        } else {
            [_nowPlayerVC.player performOrientationChange:UIInterfaceOrientationPortrait completion:^(BOOL finished) {
                _nowPlayerVC.player.view.isLandcape = NO;
                [_nowPlayerVC.player.view showPlayButton:!_nowPlayerVC.player.isPlaying];
            }];
        }
    }
}

- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}
@end
