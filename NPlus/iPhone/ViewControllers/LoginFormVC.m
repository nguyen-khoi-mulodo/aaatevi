//
//  LoginFormVC.m
//  NPlus
//
//  Created by Anh Le Duc on 10/29/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "LoginFormVC.h"
#import "APIController.h"
#import "GooglePlusLoginTask.h"

@interface LoginFormVC ()

@end

@implementation LoginFormVC
@synthesize delegate = _delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *normalImage = [UIImage imageNamed:@"bg_btn"];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 20, 0, 20);
    UIImage *stretchableNormalImage = [normalImage resizableImageWithCapInsets:insets];
    [_btnLogin setBackgroundImage:stretchableNormalImage forState:UIControlStateNormal];
    self.view.backgroundColor = BACKGROUND_COLOR;
    
//    [[GooglePlusLoginTask shareInstance]trySilentSignIn:self];
}

//- (void)listenNotification {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kGooglePlusLoginedNotification object:nil];
//}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)hideKeyboard{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnLogin_Tapped:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(loginFormVC:buttonLoginTapped:)]) {
        [_delegate loginFormVC:self buttonLoginTapped:_btnLogin];
    }
}

//#pragma mark - GPPSignIn
//- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
//    if (error) {
//        // handle error
//    } else {
//        [[GooglePlusLoginTask shareInstance]didFinishedWithAuth:auth];
//    }
//}

@end
