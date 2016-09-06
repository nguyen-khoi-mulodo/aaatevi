//
//  SettingController.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/17/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "SettingController.h"
#import "MyNavigationItem.h"
#import "DeviceInfo.h"
#import "iRate.h"
#import "LoginViewController.h"
#import "RelatedVC.h"
#import "FeedbackController.h"
@interface SettingController () <LoginControllerDelegate> {
    MyNavigationItem *myNavi;
    LoginViewController *_loginVC;
}

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    myNavi = [[MyNavigationItem alloc]initWithController:self type:9];
    self.tbSetting.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tbSetting.separatorColor = UIColorFromRGB(0xf0f0f0);
    [self.tbSetting setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    [self.dataSources addObjectsFromArray: @[@"Cho phép dùng 3G để tải",@"Nhận thông báo từ Tevi",@"", @"Góp ý báo lỗi",@"Đánh giá ứng dụng",@"Ứng dụng liên quan",@"Hỗ trợ người dùng",@""]];
    self.navigationController.navigationBarHidden = NO;
    
    _lblVersion.text = [NSString stringWithFormat:@"v%@",[[DeviceInfo sharedInstance] deviceAppVersion]];
    _btnLogout.clipsToBounds = YES;
    _btnLogout.layer.cornerRadius = 5;
    [self updateLogin];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Cài đặt";
    [self trackScreen:@"iOS.ProfileConfig"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

#pragma mark - LoginController Delegate
- (void)showLoginViewWithTask:(NSString*)task {
    
    _loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    _loginVC.task = task;
    _loginVC.delegate = self;
    _loginVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:_loginVC animated:YES completion:^{
        [UIView animateWithDuration:0.5 animations:^{
            _loginVC.loginView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        }];
    }];
}

- (void)updateLogin {
    if (APPDELEGATE.isLogined) {
        [_btnLogout setTitle:@"Đăng xuất" forState:UIControlStateNormal];
        _btnLogout.backgroundColor = UIColorFromRGB(0xFF4040);
    } else {
        [_btnLogout setTitle:@"Đăng nhập" forState:UIControlStateNormal];
        _btnLogout.backgroundColor = UIColorFromRGB(0x00adef);
    }
}

- (void)didLoginSuccessWithTask:(NSString *)task {
    if (_loginVC) {
        [UIView animateWithDuration:0.5 animations:^{
            _loginVC.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [_loginVC dismissViewControllerAnimated:YES completion:^{
                [_loginVC.view removeFromSuperview];
                _loginVC = nil;
            }];
            if ([task isEqualToString:kTaskLogin]) {
                [self updateLogin];
            }
        }];
    }
}
- (void)didLoginFailedWithTask:(NSString *)task {
    if (_loginVC) {
        [UIView animateWithDuration:0.5 animations:^{
            _loginVC.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [_loginVC dismissViewControllerAnimated:YES completion:^{
                [_loginVC.view removeFromSuperview];
                _loginVC = nil;
            }];
        }];
    }
}
- (void)didCancelLogin {
    if (_loginVC) {
        [UIView animateWithDuration:0.5 animations:^{
            _loginVC.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [_loginVC dismissViewControllerAnimated:YES completion:^{
                
            }];
            [_loginVC.view removeFromSuperview];
            _loginVC = nil;
        }];
    }
}

#pragma mark - UITableView
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        return 10;
    } else if (indexPath.row == 7) {
        return 106;
    }
    return 60;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString *settingCellIdef = @"settingCellIdef";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellIdef];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:settingCellIdef];
    }
    cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
    cell.textLabel.text = [self.dataSources objectAtIndex:indexPath.row];
    cell.textLabel.textColor = UIColorFromRGB(0x212121);
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0 || indexPath.row == 1) {
        UISwitch *btnSwitch = [[UISwitch alloc]init];
        btnSwitch.tag = indexPath.row;
        btnSwitch.onTintColor = UIColorFromRGB(0x00adef);
        btnSwitch.on = YES;
        if (indexPath.row == 0) {
            if ([kNSUserDefault valueForKey:SETTING_ALLOW3G]) {
                btnSwitch.on = [[kNSUserDefault valueForKey:SETTING_ALLOW3G] boolValue];
            }
        }
        [btnSwitch addTarget:self action:@selector(btnSwitchAction:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = btnSwitch;
    } else if (indexPath.row == 2) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 10)];
        view.backgroundColor = UIColorFromRGB(0xf0f0f0);
        [cell addSubview:view];
    }
    else if (indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5){
        UIImageView *iconMore = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-view-more-ngang-v2"]];
        cell.accessoryView = iconMore;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 6) {
        UILabel *lblPhoneSupport = [[UILabel alloc]init];
        lblPhoneSupport.text = @"08 3815 4789";
        lblPhoneSupport.textColor = UIColorFromRGB(0xa4a4a4);
        [lblPhoneSupport sizeToFit];
        lblPhoneSupport.font = [UIFont fontWithName:kFontRegular size:15];
        lblPhoneSupport.textAlignment = NSTextAlignmentRight;
        cell.accessoryView = lblPhoneSupport;
    } else if (indexPath.row == 7) {
        _viewFooter.translatesAutoresizingMaskIntoConstraints = YES;
        _viewFooter.frame = CGRectMake(0, 0, SCREEN_SIZE.width, _viewFooter.frame.size.height);
        [cell addSubview:_viewFooter];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row != 7) {
        cell.contentView.backgroundColor = UIColorFromRGB(0xfcfcfc);
        cell.backgroundColor = UIColorFromRGB(0xfcfcfc);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 4) {
        [[iRate sharedInstance] openRatingsPageInAppStore];
        return;
    } else if (indexPath.row == 3){
        FeedbackController *feedbackVC = [[FeedbackController alloc]initWithNibName:@"FeedbackController" bundle:nil];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    } else if (indexPath.row == 2){

    } else if (indexPath.row == 5){
        RelatedVC *relatedVC = [[RelatedVC alloc]initWithNibName:@"HomeVC" bundle:nil];
        relatedVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:relatedVC animated:YES];

    }
    
}

- (void)btnSwitchAction: (id)sender {
    UISwitch *swt = (UISwitch*)sender;
    if (swt.tag == 0) {
        [kNSUserDefault setValue:[NSNumber numberWithBool:swt.isOn] forKey:SETTING_ALLOW3G];
        [kNSUserDefault synchronize];
    } else if (swt.tag == 1){
        
    }
}
- (IBAction)btnLogoutTapped:(id)sender {
    if (APPDELEGATE.isLogined) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"" message:@"Bạn muốn đăng xuất?" delegate:self cancelButtonTitle:@"Đóng" otherButtonTitles:@"Đăng xuất", nil];
        view.tag = 100;
        [view show];
    } else {
        [self showLoginViewWithTask:kTaskLogin];
    }
    
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100 && buttonIndex != alertView.cancelButtonIndex)
    {
        [self loginButtonClicked];
    }
}
-(void)loginButtonClicked
{
    if (APPDELEGATE.isLogined) {
        NSLog(@"Đăng xuất");
        [[APIController sharedInstance]logoutCompleted:^(BOOL logout) {
            if (logout) {
                [[FacebookLoginTask sharedInstance]logoutFacebook];
                [self updateLogin];
            }
        } failed:^(NSError *error) {
            
        }];
    }
}


@end
