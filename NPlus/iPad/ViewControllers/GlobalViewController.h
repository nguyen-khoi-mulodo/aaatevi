//
//  GlobalViewController.h
//  NPlus
//
//  Created by Vo Chuong Thien on 11/14/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@protocol GlobalViewDelegate <NSObject>
- (void) showVideo:(id) item;
- (void) showChannel:(id) item;
- (void) showArtist:(id) item;
- (void) showMenuAnimation:(BOOL) isShow;
- (void) closeSearchView;
- (void) showRatingView:(id) vc;
- (void) showLoginWithTask:(NSString*) task withVC:(id) vc;
- (void) hideLoginView;
- (void) animationShowView:(UIView*) view isShow:(BOOL) isShow isAnimation:(BOOL) isAnimation;



- (void) showSerialViewWithData:(id) item;
- (void) showSearchVC;
- (void) showHistoryView:(BOOL) isShow;
- (void) showSettingView:(BOOL) isShow;
- (void) showShopView:(BOOL) isShow;
- (void) showLoginWithTask:(NSString*) task andObject:(id) item;
- (void) choseTabCuatui:(BOOL) isChose;
- (void) backToHome;
- (void) addBadge;
- (void) showRegisterView;
- (void) showForgetPassword;
- (void) showArtistView;
- (void) showChannelView;

@end

@interface GlobalViewController : GAITrackedViewController{
    IBOutlet UIButton* btnHistory;
}
@property (nonatomic, strong) id <GlobalViewDelegate> delegate;

- (void) showMenuAnimation:(BOOL) isShow;
- (void) closeSearchView;

- (void) showVideo:(id) item andOtherItem:(id) otherItem;
- (void) showSerialViewWithData:(id) item;
- (IBAction) doBackHome:(id) sender;
@end
