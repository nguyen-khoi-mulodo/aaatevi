//
//  AppDelegate.h
//  NPlus
//
//  Created by TEVI Team on 7/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "NowPlayerVC.h"
#import "User.h"
#import "Channel.h"
#import "VersionEntity.h"
#import "RootVC_iPad.h"
#import "RESideMenu.h"
#import "MenuGenreViewController.h"
#import "NewFeedVCViewController.h"

@class AKTabBarController;

typedef enum{
    kConnectionTypeNone,
    kConnectionTypeWifi,
    kConnectionTypeWAN
}kConnectionType;

@interface AppDelegate : UIResponder <UIApplicationDelegate,RESideMenuDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RESideMenu *sideMenuViewController;
@property (strong, nonatomic) MenuGenreViewController *rightMenu;
@property (strong, nonatomic) UINavigationController *rootNavController;
@property (nonatomic, strong) AKTabBarController *tabBarController;
@property (nonatomic, strong) NowPlayerVC *nowPlayerVC;
@property (nonatomic, strong) RootVC_iPad* rootVC;
@property (nonatomic, strong) NewFeedVCViewController *newfeedVC;

@property (nonatomic, strong) Reachability *internetReachability;
@property (nonatomic, assign) BOOL internetConnnected;
@property (nonatomic, assign) kConnectionType connectionType;
@property (nonatomic, copy) void(^backgroundTransferCompletionHandler)();
@property (nonatomic, strong) VersionEntity *versionEntity;
@property (nonatomic, strong, setter = setUser:) User *user;
@property (nonatomic, strong) NSString* tutorialName;
@property BOOL retictPushActorVC;
@property BOOL isLogined;
@property BOOL isShowingPopup;
@property BOOL isShowingNotif;

- (void)addNowPlayingViewController;
- (void)removeNowPlayingViewController;
- (void)openListVideo:(Channel*)item withType:(kItemCollectionType)type;
- (NSString *)getUserID;
- (void)showToastMessage:(NSString*)message;
- (void)showToastWithMessage:(NSString*)mesage position:(NSString*)position type:(int)type; // type 0-normal 1-done 2-error
- (void)showTutorial:(NSString*)name;
- (BOOL)allowDownload;
- (void)start;
- (void)checkVersion;
- (void)setupTabbarControllerIsInit:(BOOL)isInit;

- (void)registerPushNotification;

- (void)didSelectArtistCellWith:(Artist *)artist;
- (void)didSelectVideoOffline:(Video*)video;
- (void)didSelectVideoCellWith:(Video*)video;
- (void)didSelectChannelCellWith:(Channel*)channel isPush:(BOOL)isPush;
- (void)didSelectGenre:(Genre*)parentGenre listGenres:(NSArray*)listGenres index:(NSInteger)index;

- (void)initPlayerWithHidden:(BOOL)hidden;
- (void)playerLoadDataWithType:(NSString*)type video:(Video*)video channel:(Channel*)channel index:(int)index;
-(void) showToastMessage:(NSString *)message withImageName:(NSString*) imageName;
- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController;
@end
