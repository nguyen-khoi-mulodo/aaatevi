//
//  LoginVC.h
//  NPlus
//
//  Created by Anh Le Duc on 9/8/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

#import "GooglePlusLoginTask.h"


@protocol LoginDelegate;
@interface LoginVC : BaseVC <GooglePlusLoginTaskDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollMain;
@property (strong, nonatomic) IBOutlet UIButton *btnShop;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (weak, nonatomic) IBOutlet UIButton *btnGGSignIn;

@property (copy, nonatomic) NSString *theTask;
@property (nonatomic, weak) id<LoginDelegate> delegate;


- (IBAction)btnLogin_Tapped:(id)sender;
- (IBAction)btnRegister_Tapped:(id)sender;
- (IBAction)btnBack_Tapped:(id)sender;
- (IBAction)btnForget_Tapped:(id)sender;
- (IBAction)btnFBLogin_Tapped:(id)sender;
- (IBAction)btnGGSignIn_Tapped:(id)sender;

@end

@protocol LoginDelegate <NSObject>

@optional
- (void)loginVC:(LoginVC*)loginVC withTask:(NSString*)task;
- (void) hideLoginView;
- (void) showRegisterView;
- (void) showForgetPassword;

@end

@interface LoginNavigationController : UINavigationController

@end
