//
//  GooglePlusLoginTask.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/2/15.
//  Copyright (c) 2015 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@protocol GooglePlusLoginTaskDelegate <NSObject>
- (void) loginSuccessWithTask:(NSString*) task;
@optional
- (void) loginFailWithTask:(NSString*) task;
@end

@interface GooglePlusLoginTask : NSObject {
    
}

@property (nonatomic, strong) id <GooglePlusLoginTaskDelegate> delegate;
@property (strong, nonatomic) NSString *theTask;

+ (GooglePlusLoginTask *) shareInstance;

- (BOOL) checkLoginedGooglePlus;
- (void) loginGooglePlus;
- (void) logoutGooglePlus;
- (void) trySilentAuthentication;

//- (void)signinWithVC:(UIViewController<GPPSignInDelegate> *)vc;
//- (void)trySilentSignIn:(UIViewController<GPPSignInDelegate> *)vc;
//- (void)signout;
//- (void)disconnect;
//- (void)didFinishedWithAuth:(GTMOAuth2Authentication*)auth;
@end
