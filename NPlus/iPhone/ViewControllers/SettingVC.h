//
//  SettingVC.h
//  NPlus
//
//  Created by Anh Le Duc on 11/11/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "BaseVC.h"


@protocol SettingDelegate <NSObject>
- (void) showLoginWithTask:(NSString*) task andObject:(id) item;
- (void) showRegisterView;
- (void) showForgetPassword;
- (void) showSettingView:(BOOL) isShow;
@end

@interface SettingVC : BaseVC
@property (nonatomic, strong) id <SettingDelegate> parentDelegate;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UITableView *tbMain;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
- (IBAction)btnStore_Tapped:(id)sender;
- (IBAction)btnBack_Tapped:(id)sender;
- (IBAction)btnLogin_Tapped:(id)sender;

@end
