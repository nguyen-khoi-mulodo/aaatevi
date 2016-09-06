//
//  LoginViewController.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 2/17/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () {
    LoginView *lgView;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
    [self.view addGestureRecognizer:tapGesture];
     lgView = [Utilities loadView:[LoginView class] FromNib:@"LoginView"];
    lgView.delegate = self;
    [lgView loadViewIsPopup:YES];
    [_loginView addSubview:lgView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _loginView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
}

- (void)tapGesture {
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self didCancelTapped];
        }];
    }];
}

- (void)didLoginFBTapped {
    [FacebookLoginTask sharedInstance].delegate = self;
    [[FacebookLoginTask sharedInstance]loginFacebook];
    [self trackEvent:@"iOS_Login"];
}

- (void)didLoginGGTapped {
    
}

- (void)didCancelTapped {
    [_delegate didCancelLogin];
}

- (void)loginSuccessWithTask:(NSString *)task {
    [[NSNotificationCenter defaultCenter]postNotificationName:kDidLoginNotification object:nil];
    APPDELEGATE.isLogined = YES;
    [_delegate didLoginSuccessWithTask:_task];
}

- (void)loginFailWithTask:(NSString *)task {
    [_delegate didLoginFailedWithTask:_task];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}



@end
