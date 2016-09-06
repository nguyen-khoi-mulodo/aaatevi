//
//  LoginView.h
//  NPlus
//
//  Created by Khoi Nguyen on 2/2/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginButtonView.h"

@protocol LoginActionDelegate <NSObject>

- (void)didLoginFBTapped;
- (void)didLoginGGTapped;
- (void)didCancelTapped;

@end

@interface LoginView : UIView <LoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgHeaderView;
@property (weak, nonatomic) IBOutlet LoginButtonView *loginButtonView;
@property (weak, nonatomic) IBOutlet UIView *loginSubView;
@property (weak, nonatomic) IBOutlet UILabel *lblLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UILabel *lblLoginDes;

@property (nonatomic, strong) id<LoginActionDelegate> delegate;
@property BOOL isPopup;

- (void)loadViewIsPopup:(BOOL)popup;

@end
