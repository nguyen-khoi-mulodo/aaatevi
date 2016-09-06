//
//  LoginButtonView.h
//  NPlus
//
//  Created by Khoi Nguyen on 2/2/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginButtonDelegate <NSObject>

@optional
- (void)didFBButtonTap;
- (void)didGGButoonTap;

@end

@interface LoginButtonView : UIView

@property (weak, nonatomic) IBOutlet UIButton *btnFBLogin;

@property (weak, nonatomic) IBOutlet UIButton *btnGGLogin;

@property (strong, nonatomic) id<LoginButtonDelegate> delegate;
@end
