//
//  SettingVC.m
//  NPlus
//
//  Created by TEVI Team on 11/11/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import "TokenManager.h"
#import "SettingVC_iPad.h"
#import "iRate.h"
#import "TSMiniWebBrowser.h"
#import "FacebookLoginTask.h"
#import "GooglePlusLoginTask.h"
#import "OtherApps.h"
#import "ShareTask.h"

//#import <GoogleOpenSource/GoogleOpenSource.h>

#define ALLOW_3G        @"Cho phép dùng 3G để tải"
#define RECEIVE_NOTI    @"Nhận thông báo"
#define DES_NOTI        @"Bạn sẽ nhận được thông báo cập nhật các chương trình, phim yêu thích phù hợp với sở thích của mình"
#define SHARE_APP       @"Chia sẻ ứng dụng"
#define RATE_APP        @"Đánh giá ứng dụng"
#define GOPY            @"Góp Ý"
#define APP_LIEN_QUAN   @"Ứng dụng liên quan"
#define LOGOUT          @"Đăng xuất"
#define LOGIN           @"Đăng nhập bằng facebook"


#define kTaskPU         @"kTaskPU"
@interface SettingVC_iPad ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate>

@end

@implementation SettingVC_iPad

-(NSString *)screenNameGA{
    return @"Setting";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    [[UINavigationBar appearance] setTitleTextAttributes: @{UITextAttributeFont: [UIFont fontWithName:kFontSemibold size:18.0f]}];
    self.view.backgroundColor = BACKGROUND_COLOR;
    _tbMain.backgroundColor = [UIColor whiteColor];
    [_tbMain setFrame:CGRectMake(0, 0, 320, 480)];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:kDidLoginNotification object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidLoginNotification object:nil];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setTitle:@"Cài đặt"];
    if (IS_IPAD) {
        [self setScreenName:@"iPad.Setting"];
    }
}

- (void)loadData{
    [self.dataSources removeAllObjects];
    [self.dataSources addObject:@[ALLOW_3G, SHARE_APP, RATE_APP, APP_LIEN_QUAN, APPDELEGATE.user ? LOGOUT : LOGIN]];
    [_tbMain reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.tbMain respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tbMain setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tbMain respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tbMain setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSources.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = [self.dataSources objectAtIndex:section];
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        UISwitch *switchAllow = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 51, 31)];
        switchAllow.center = CGPointMake(tableView.frame.size.width - 40, cell.center.y);
        switchAllow.tag = 101;
        [switchAllow setOnTintColor:COLOR_MAIN_BLUE];
        [switchAllow addTarget:self  action:@selector(switchAllow_Changed:) forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.textLabel setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
        [cell addSubview:switchAllow];
    }
    UISwitch *switchAllow = (UISwitch*)[cell viewWithTag:101];
    if (indexPath.section > self.dataSources.count) {
        return cell;
    }
    NSArray *arr = [self.dataSources objectAtIndex:indexPath.section];
    if (indexPath.row > arr.count) {
        return cell;
    }
    NSString *lb = [arr objectAtIndex:indexPath.row];
    cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    if ([lb isEqualToString:DES_NOTI]) {
        [cell.textLabel setNumberOfLines:3];
        [cell.textLabel setFont:[UIFont fontWithName:kFontRegular size:13.0f]];
        cell.textLabel.textColor = RGB(68, 68, 68);
    }else{
        [cell.textLabel setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
        cell.textLabel.textColor = RGB(0, 0, 0);
    }

    
    if ([lb isEqualToString:ALLOW_3G] || [lb isEqualToString:RECEIVE_NOTI]) {
        switchAllow.hidden = NO;
        [switchAllow setOn:[self allow3G]];
        cell.accessoryType= UITableViewCellAccessoryNone;
    }else{
        switchAllow.hidden = YES;
        if ([lb isEqualToString:APP_LIEN_QUAN]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType= UITableViewCellAccessoryNone;
        }
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 1) {
//        return 88.0f;
//    }
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = [self.dataSources objectAtIndex:indexPath.section];
    NSString *lb = [arr objectAtIndex:indexPath.row];
    if ([lb isEqualToString:RATE_APP]) {
        [[iRate sharedInstance] openRatingsPageInAppStore];
        return;
    }
    
    if ([lb isEqualToString:APP_LIEN_QUAN]) {
        OtherApps *relatedVC = [[OtherApps alloc]initWithNibName:@"OtherApps" bundle:nil];
//        relatedVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:relatedVC animated:YES];
        return;
    }
    
    if ([lb isEqualToString:LOGIN]) {
        [[FacebookLoginTask sharedInstance] setTheTask:kTaskLogin];
        [[FacebookLoginTask sharedInstance] setDelegate:self];
        [[FacebookLoginTask sharedInstance] loginFacebook];
        return;
    }
    
    if ([lb isEqualToString:LOGOUT]) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"" message:@"Bạn muốn đăng xuất?" delegate:self cancelButtonTitle:@"Đóng" otherButtonTitles:@"Đăng xuất", nil];
        view.tag = 100;
        [view show];
        return;
    }
    
    if ([lb isEqualToString:SHARE_APP]) {
        [[ShareTask sharedInstance] setViewController:self];
        [[ShareTask sharedInstance] shareFacebookWithURL:APP_LINK];
    }
}

- (IBAction)btnLogin_Tapped:(id)sender {
    if (APPDELEGATE.user) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showSettingView:)]) {
        [self.delegate showSettingView:NO];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showLoginWithTask:andObject:)]) {
        [self.delegate showLoginWithTask:kTaskLogin andObject:nil];
    }
    
}
         
- (void) loginSuccessWithTask:(NSString*) task{
    [self loadData];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Email", nil)
                                                        message:NSLocalizedString(@"Email failed to send. Please try again.", nil)
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil];
        [alert show];
    }
    else if (result == MFMailComposeResultSent)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Email", nil)
                                                        message:NSLocalizedString(@"The mail has been sent successfully.", nil)
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil];
        [alert show];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:_tbMain numberOfRowsInSection:indexPath.section];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (self.dataSources.count == 1) {
        background = [UIImage imageNamed:@"theloai_cell_group"];
        UIEdgeInsets insets = UIEdgeInsetsMake(8, 12, 8, 12);
        UIImage *stretchableImage = [background resizableImageWithCapInsets:insets];
        return stretchableImage;
    }
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"theloai_cell_top"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"theloai_cell_bottom"];
    } else {
        background = [UIImage imageNamed:@"theloai_cell_midle"];
    }
    UIEdgeInsets insets = UIEdgeInsetsMake(8, 12, 8, 12);
    UIImage *stretchableImage = [background resizableImageWithCapInsets:insets];
    return stretchableImage;
}

- (IBAction)btnStore_Tapped:(id)sender {
}

- (IBAction)btnBack_Tapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)allow3G{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:SETTING_ALLOW3G]) {
        BOOL isOn = [[defaults objectForKey:SETTING_ALLOW3G] boolValue];
        return isOn;
    }
    return NO;
}

- (void)setAllow3G:(BOOL)isOn{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:isOn] forKey:SETTING_ALLOW3G];
    [defaults synchronize];
    if (!IS_IPAD) {
        NowPlayerVC *nowVC = APPDELEGATE.nowPlayerVC;
        [nowVC cellcularChange];
    }
}

- (void)switchAllow_Changed:(UISwitch*)switchAllow{
    [self setAllow3G:switchAllow.isOn];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100 && buttonIndex == 1) {
        [[APIController sharedInstance] logoutCompleted:^(BOOL logout) {
            if (logout) {
                [[FacebookLoginTask sharedInstance] logoutFacebook];
                APPDELEGATE.user = nil;
                [[APIController sharedInstance] getAccessTokenCompleted:^(id results) {
                    [[TokenManager sharedInstance] setToken:results];
                } failed:^(NSError *error) {
                }];
                [self loadData];
            }
        } failed:^(NSError *error) {
            
        }];
        
        
    }
}

- (void) showRegisterView{
//    if (self.parentDelegate && [self.parentDelegate respondsToSelector:@selector(showRegisterView)]) {
//        [self.parentDelegate showRegisterView];
//    }
    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:@"https://id.nct.vn/dang-ky"]];
    webBrowser.showReloadButton = YES;
    webBrowser.showActionButton = YES;
    webBrowser.mode = TSMiniWebBrowserModeModal;
    webBrowser.barStyle = UIBarStyleDefault;
    webBrowser.modalDismissButtonTitle = @"";
    [self presentViewController:webBrowser animated:YES completion:^{
        if (webBrowser) {
            [webBrowser didShow];
        }
    }];
}

- (void) showForgetPassword{
//    if (self.parentDelegate && [self.parentDelegate respondsToSelector:@selector(showForgetPassword)]) {
//        [self.parentDelegate showForgetPassword];
//    }
    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:@"https://id.nct.vn/quen-mat-khau"]];
    webBrowser.showReloadButton = YES;
    webBrowser.showActionButton = YES;
    webBrowser.mode = TSMiniWebBrowserModeModal;
    webBrowser.barStyle = UIBarStyleDefault;
    webBrowser.modalDismissButtonTitle = @"";
    [self presentViewController:webBrowser animated:YES completion:^{
        if (webBrowser) {
            [webBrowser didShow];
        }
    }];
}


@end
