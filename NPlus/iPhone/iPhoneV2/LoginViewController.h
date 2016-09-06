//
//  LoginViewController.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 2/17/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"
#import "FacebookLoginTask.h"
#import "BaseVC.h"

@protocol LoginControllerDelegate <NSObject>

- (void)didLoginSuccessWithTask:(NSString*)task;
- (void)didLoginFailedWithTask:(NSString*)task;
- (void)didCancelLogin;

@end

@interface LoginViewController : BaseVC <LoginActionDelegate,FacebookLoginTaskDelegate>

@property (weak, nonatomic) IBOutlet LoginView *loginView;
@property (strong, nonatomic) NSString *task;
@property (strong, nonatomic) id<LoginControllerDelegate> delegate;
@end
