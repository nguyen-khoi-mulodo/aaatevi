//
//  LoginFormVC.h
//  NPlus
//
//  Created by Anh Le Duc on 10/29/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginFormDelegate;
@interface LoginFormVC : UIViewController
@property (nonatomic, weak) id<LoginFormDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

- (IBAction)btnLogin_Tapped:(id)sender;
@end



@protocol LoginFormDelegate <NSObject>

@optional
- (void)loginFormVC:(LoginFormVC*)loginVC buttonLoginTapped:(UIButton*)button;

@end
