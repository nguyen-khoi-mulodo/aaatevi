//
//  LoginView.m
//  NPlus
//
//  Created by Khoi Nguyen on 2/2/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (void)loadViewIsPopup:(BOOL)popup {
    _isPopup = popup;
    self.translatesAutoresizingMaskIntoConstraints = YES;
    [self setFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    LoginButtonView *buttonView = [Utilities loadView:[LoginButtonView class] FromNib:@"LoginButtonView"];
    buttonView.delegate = self;
    [_loginButtonView addSubview:buttonView];
    if (!popup) {
        _btnCancel.hidden = YES;
        _lblLogin.center = _loginSubView.center;
        _lblLogin.textAlignment = NSTextAlignmentCenter;
        _loginSubView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    } else {
        //self.backgroundColor = [UIColor clearColor];
        _btnCancel.hidden = NO;
        _lblLogin.textAlignment = NSTextAlignmentLeft;
        _lblLogin.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        _lblLoginDes.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        _loginSubView.clipsToBounds = YES;
        _loginSubView.layer.cornerRadius = 8;
        _loginSubView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _bgHeaderView.clipsToBounds = YES;
        _bgHeaderView.layer.cornerRadius = 8;
        
    }
}


- (IBAction)btnCancelAction:(id)sender {
    [_delegate didCancelTapped];
}

- (void)didFBButtonTap {
    NSLog(@"FBLogin Tap");
    [_delegate didLoginFBTapped];
}

- (void)didGGButoonTap {
     NSLog(@"GGLogin Tap");
    [_delegate didLoginGGTapped];
}
@end
