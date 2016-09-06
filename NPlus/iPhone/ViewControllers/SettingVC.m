//
//  SettingVC.m
//  NPlus
//
//  Created by Anh Le Duc on 11/11/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import "TokenManager.h"
#import "SettingVC.h"
#import "iRate.h"
#import "ReportVC.h"
#import "LoginVC.h"
#import "PowerUserVC.h"
#import "InfoVC.h"
#import "TSMiniWebBrowser.h"
#import "FacebookLoginTask.h"
#import "GooglePlusLoginTask.h"

#define ALLOW_3G        @"Cho phép dùng 3G để tải"
#define RATE            @"Đánh giá ứng dụng"
#define ERROR           @"Báo lỗi và góp ý"
#define INFO            @"Thông tin ứng dụng"
#define PU              @"Power User"
#define LOGOUT          @"Đăng xuất"
#define LOGIN           @"Đăng nhập"

#define kTaskPU         @"kTaskPU"
@interface SettingVC ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, LoginDelegate, MFMailComposeViewControllerDelegate>

@end

@implementation SettingVC
@synthesize parentDelegate;

-(NSString *)screenNameGA{
    return @"Setting";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] && !IS_IPAD) {
        UIImage *image = [UIImage imageNamed:@"personal_bg_header"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    }
    UIBarButtonItem *barBack = [[UIBarButtonItem alloc] initWithCustomView:_btnBack];
    self.navigationItem.leftBarButtonItem = barBack;
    self.view.backgroundColor = BACKGROUND_COLOR;
    [_btnBack setTitleColor:(IS_IPAD) ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
    [_btnBack setTitleColor:(IS_IPAD) ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateHighlighted];
    
    if (IS_IPAD) {
        [_btnBack setImage:nil forState:UIControlStateNormal];
        [_btnBack setImage:nil forState:UIControlStateHighlighted];
    }else{
        [_btnBack setImage:imageNameWithMaskWhiteColor(@"icon_back") forState:UIControlStateNormal];
        [_btnBack setImage:imageNameWithMaskWhiteColor(@"icon_back") forState:UIControlStateHighlighted];
    }
    
    _tbMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbMain.backgroundColor = [UIColor clearColor];
    if (IS_IPAD) {
        [_tbMain setFrame:CGRectMake(0, 0, 320, 480)];
    }
//     NSLog(@"%@", NSStringFromCGRect(_tbMain.frame));
    [self loadDataIsAnimation:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:kDidLoginNotification object:nil];;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidLoginNotification object:nil];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (IS_IPAD) {
        [self setScreenName:@"iPad.Setting"];
    }
}

- (void)loadDataIsAnimation:(BOOL)isAnimation{
    [self.dataSources removeAllObjects];
    [self.dataSources addObject:@[ALLOW_3G]];
    [self.dataSources addObject:@[RATE, INFO]];
    if (APPDELEGATE.user) {
        [self.dataSources addObject:@[LOGOUT]];
    }else{
        [self.dataSources addObject:@[LOGIN]];
    }
    [_tbMain reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (IS_IPAD) ? 320 : SCREEN_SIZE.width, cell.bounds.size.height)];
        imageView.tag = 100;
        [cell.contentView addSubview:imageView];
        
        UISwitch *switchAllow = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 28)];
        if (!IS_IPAD) {
            switchAllow.center = CGPointMake(SCREEN_SIZE.width - 40, cell.center.y);
        }else{
            switchAllow.center = CGPointMake(320 - 40, cell.center.y);
        }
        switchAllow.tag = 101;
        [switchAllow setOnTintColor:COLOR_MAIN_BLUE];
        [switchAllow addTarget:self  action:@selector(switchAllow_Changed:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.contentView addSubview:switchAllow];
        
//        UIImage* image = [UIImage imageNamed:@"btn_fb_ipad"];
//        UIImageView* loginImageView = [[UIImageView alloc] initWithFrame:CGRectMake(((IS_IPAD) ? 160 : SCREEN_SIZE.width/2) - image.size.width/2, cell.bounds.size.height/2 - image.size.height/2, image.size.width, image.size.height)];
//        [loginImageView setImage:image];
//        [loginImageView setTag:102];
//        [cell.contentView addSubview:loginImageView];
        
        _btnLogin.frame = CGRectMake(((IS_IPAD) ? 160 : SCREEN_SIZE.width/2) - _btnLogin.frame.size.width/2, cell.bounds.size.height/2 - _btnLogin.frame.size.height/2, _btnLogin.frame.size.width, _btnLogin.frame.size.height);
        [_btnLogin setTag: 102];
        [cell.contentView addSubview:_btnLogin];
        
    }
    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:100];
    UISwitch *switchAllow = (UISwitch*)[cell.contentView viewWithTag:101];
//    UIImageView* loginImage = (UIImageView*)[cell.contentView viewWithTag:102];
    UIButton *loginGG = (UIButton*)[cell.contentView viewWithTag:102];
    if (indexPath.section > self.dataSources.count) {
        return cell;
    }
    NSArray *arr = [self.dataSources objectAtIndex:indexPath.section];
    if (indexPath.row > arr.count) {
        return cell;
    }
    cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.textColor = RGB(68, 68, 68);
    [imageView setImage:[self cellBackgroundForRowAtIndexPath:indexPath]];
    
    NSString *lb = [arr objectAtIndex:indexPath.row];
    if ([lb isEqualToString:ALLOW_3G]) {
        switchAllow.hidden = NO;
        [switchAllow setOn:[self allow3G]];
        cell.accessoryType= UITableViewCellAccessoryNone;
    }else{
        switchAllow.hidden = YES;
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if ([lb isEqualToString:LOGIN]) {
        [cell.textLabel setHidden:YES];
        [_btnLogin setHidden:NO];
        cell.accessoryType= UITableViewCellAccessoryNone;
    }else{
        [cell.textLabel setHidden:NO];
        [_btnLogin setHidden:YES];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    
//    if ([lb isEqualToString:LOGIN] || [lb isEqualToString:LOGOUT]) {
//        cell.accessoryType= UITableViewCellAccessoryNone;
//    }
    
    return cell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section > self.dataSources.count) {
        return;
    }
    NSArray *arr = [self.dataSources objectAtIndex:indexPath.section];
    if (indexPath.row > arr.count) {
        return;
    }
    NSString *lb = [arr objectAtIndex:indexPath.row];
    if ([lb isEqualToString:RATE]) {
        [[iRate sharedInstance] openRatingsPageInAppStore];
        return;
    }
    if ([lb isEqualToString:ERROR]) {
//        ReportVC *reportVC = [[ReportVC alloc] initWithNibName:@"ReportVC" bundle:nil];
//        [self.navigationController pushViewController:reportVC animated:YES];
        
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *emailer = [[MFMailComposeViewController alloc] init];
            emailer.mailComposeDelegate = self;
            [emailer setToRecipients:[NSArray arrayWithObject:kEmail]];
            NSString *sub = @"Góp ý NhacCuaTui Video - iPhone";
            if (IS_IPAD) {
                sub = @"Góp ý NhacCuaTui Video - iPad";
            }
            [emailer setSubject:NSLocalizedString(sub, nil)];
            NSString *osVer = [[UIDevice currentDevice] systemVersion];
            NSString *appVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            NSString *body = [NSString stringWithFormat:@"\n\n\n----------------------------------------\nVersion App: %@\nVersion OS: %@\nDevice: %@\nHardware: %@\n----------------------------------------\n", appVer, osVer, [[UIDevice currentDevice] hardwareDescription], [UIDevice platform]];
            
            [emailer setMessageBody:body isHTML:NO];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                emailer.modalPresentationStyle = UIModalPresentationPageSheet;
            }
            //            APPDELEGATE.tabView.hidden = YES;
            [self presentViewController:emailer animated:YES completion: nil];
        }
        else
        {
            UIAlertView* view = [[UIAlertView alloc]
                                 initWithTitle:nil
                                 message:@"No mail account setup on device"
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
            [view show];
        }
        
        return;
    }
    if ([lb isEqualToString:INFO]) {
        InfoVC *infoVC = [[InfoVC alloc] initWithNibName:@"InfoVC" bundle:nil];
        [self.navigationController pushViewController:infoVC animated:YES];
        return;
    }
    if ([lb isEqualToString:PU]) {
        if (!APPDELEGATE.user) {
            LoginVC *loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
            loginVC.theTask = kTaskPU;
            loginVC.delegate = self;
            [self.navigationController pushViewController:loginVC animated:YES];
        }else{
            PowerUserVC *powerUserVC = [[PowerUserVC alloc] initWithNibName:@"PowerUserVC" bundle:nil];
            [self.navigationController pushViewController:powerUserVC animated:YES];
        }
        
        return;
    }
    if ([lb isEqualToString:LOGIN]) {
//        LoginVC *loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
//        loginVC.delegate = self;
//        [self.navigationController pushViewController:loginVC animated:YES];
//        [[FacebookLoginTask sharedInstance] setTheTask:kTaskLogin];
//        [[FacebookLoginTask sharedInstance] setDelegate:self];
//        [[FacebookLoginTask sharedInstance] loginFacebook];
        return;
    }
    
    if ([lb isEqualToString:LOGOUT]) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"" message:@"Bạn muốn đăng xuất?" delegate:self cancelButtonTitle:@"Đóng" otherButtonTitles:@"Đăng xuất", nil];
        view.tag = 100;
        [view show];
        return;
    }
}

- (IBAction)btnLogin_Tapped:(id)sender {
    if (APPDELEGATE.user) {
        return;
    }
    if (!IS_IPAD) {
        LoginVC *loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
        loginVC.delegate = self;
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        if (self.parentDelegate && [self.parentDelegate respondsToSelector:@selector(showSettingView:)]) {
            [self.parentDelegate showSettingView:NO];
        }
        
        if (self.parentDelegate && [self.parentDelegate respondsToSelector:@selector(showLoginWithTask:andObject:)]) {
            [self.parentDelegate showLoginWithTask:kTaskLogin andObject:nil];
        }
        
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
        
        
        if(APPDELEGATE.user.loginType == loginfacebook){
            [[FacebookLoginTask sharedInstance] logoutFacebook];
        }else if(APPDELEGATE.user.loginType == logingoogleplus){
            [[GooglePlusLoginTask shareInstance] logoutGooglePlus];
        }
        APPDELEGATE.user = nil;
        [[APIController sharedInstance] getAccessTokenCompleted:^(id results) {
            [[TokenManager sharedInstance] setToken:results];
        } failed:^(NSError *error) {
        }];
        [self loadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginNotification object:nil];
    }
}

#pragma mark - LoginVC delegate
-(void)loginVC:(LoginVC *)loginVC withTask:(NSString *)task{
    if (IS_IPAD && !task) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [self loadData];
    if (task!=nil) {
        NSDictionary *userInfo = @{@"task":task};
        [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(delayFuntionWithTask:) userInfo:userInfo repeats:NO];
    }
}

- (void)delayFuntionWithTask:(NSTimer*)timer{
    NSDictionary *userInfo = timer.userInfo;
    if (![userInfo objectForKey:@"task"]) {
        return;
    }
    NSString *task = [userInfo objectForKey:@"task"];
    if ([task isEqualToString:kTaskPU]) {
        PowerUserVC *powerUserVC = [[PowerUserVC alloc] initWithNibName:@"PowerUserVC" bundle:nil];
        [self.navigationController pushViewController:powerUserVC animated:YES];
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
