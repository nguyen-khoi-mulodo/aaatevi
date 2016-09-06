//
//  LoginButtonView.m
//  NPlus
//
//  Created by Khoi Nguyen on 2/2/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "LoginButtonView.h"
#import "FacebookLoginTask.h"

@implementation LoginButtonView

- (IBAction)btnFBAction:(id)sender {
    [_delegate didFBButtonTap];
}

- (IBAction)btnGGAction:(id)sender {
    [_delegate didGGButoonTap];
}

@end
