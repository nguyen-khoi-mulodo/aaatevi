//
//  LoginVC.m
//  NPlus
//
//  Created by Anh Le Duc on 9/8/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "LoginVC.h"
#import <MessageUI/MessageUI.h>
#import "TSMiniWebBrowser.h"
#import "APIController.h"
#import "GooglePlusLoginTask.h"

@interface LoginVC ()<UIAlertViewDelegate, FacebookLoginTaskDelegate>{
    BOOL isLoaded;
}

@end

@implementation LoginVC
@synthesize theTask = _theTask;
@synthesize delegate = _delegate;

- (NSString *)screenNameGA{
    return @"Login";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    isLoaded = YES;
    if (APPDELEGATE.nowPlayerVC) {
//        [APPDELEGATE.nowPlayerVC.view layoutIfNeeded];
    }
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (APPDELEGATE.user) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!IS_IPAD) {
        if (IOS_NEWER_OR_EQUAL_TO_7) {
            self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        }
        self.navigationController.navigationBarHidden = NO;
        if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
            UIImage *image = [UIImage imageNamed:@"personal_bg_header"];
            [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        }
        UIBarButtonItem *barBack = [[UIBarButtonItem alloc] initWithCustomView:_btnBack];
        self.navigationItem.leftBarButtonItem = barBack;
    }
    isLoaded = NO;
    // Do any additional setup after loading the view from its nib.
    [_btnBack setImage:imageNameWithMaskWhiteColor(@"icon_back") forState:UIControlStateNormal];
    [_btnBack setImage:imageNameWithMaskWhiteColor(@"icon_back") forState:UIControlStateHighlighted];
    _txtUsername.backgroundColor = RGB(242, 244, 245);
    _txtUsername.layer.borderWidth = 1.0f;
    _txtUsername.layer.borderColor = RGB(226, 226, 226).CGColor;
    _txtUsername.layer.cornerRadius = 0.0f;
    
    _txtPassword.backgroundColor = RGB(242, 244, 245);
    _txtPassword.layer.borderWidth = 1.0f;
    _txtPassword.layer.borderColor = RGB(226, 226, 226).CGColor;
    _txtPassword.layer.cornerRadius = 0.0f;
    
    CGRect frame = _viewContainer.frame;
    if (IOS_NEWER_OR_EQUAL_TO_7) {
        frame.origin.y = 5;
    }else{
        frame.origin.y = 49;
    }
    _viewContainer.frame = frame;
    _viewContainer.backgroundColor = [UIColor whiteColor];
    _viewContainer.layer.cornerRadius = 1.0f;
    _viewContainer.layer.borderWidth = 1.0f;
    _viewContainer.layer.borderColor = RGB(206, 206, 206).CGColor;
    
    _scrollMain.backgroundColor = RGB(235, 235, 235);
    
    UIImage *normalImage = [UIImage imageNamed:@"bg_btn"];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 20, 0, 20);
    UIImage *stretchableNormalImage = [normalImage resizableImageWithCapInsets:insets];
    [_btnLogin setBackgroundImage:stretchableNormalImage forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tapHideKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapHideKeyboard];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveLoginNotification) name:kDidLoginNotification object:nil];
}

- (void)receiveLoginNotification {
    if (!IS_IPAD) {
        if (self.presentingViewController != nil) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)hideKeyboard{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLogin_Tapped:(id)sender {
    if (_txtUsername.text.length == 0)
    {
        [_txtUsername becomeFirstResponder];
        return;
    }
    if (_txtPassword.text.length == 0)
    {
        [_txtPassword becomeFirstResponder];
        return;
    }
    [_txtUsername resignFirstResponder];
    [_txtPassword resignFirstResponder];
    
    [[APIController sharedInstance] loginWithUserName:_txtUsername.text withPassword:_txtPassword.text completed:^(User *result) {
        if (result) {
            [APPDELEGATE setUser:result];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginNotification object:nil];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(loginVC:withTask:)]) {
            [_delegate loginVC:self withTask:_theTask];
        }
        
        if (!IS_IPAD) {
            if (self.presentingViewController != nil) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(hideLoginView)]) {
                [_delegate hideLoginView];
            }
        }
    } failed:^(NSError *error) {
        [APPDELEGATE setUser:nil];
        if (_delegate && [_delegate respondsToSelector:@selector(loginVC:withTask:)]) {
            [_delegate loginVC:self withTask:_theTask];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Đăng nhập không thành công!" delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles:nil];
        [alert show];
        
        if (self.presentingViewController != nil) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)btnRegister_Tapped:(id)sender {
    if (IS_IPAD) {
        if (_delegate && [_delegate respondsToSelector:@selector(showRegisterView)]) {
            [_delegate showRegisterView];
        }
    }else{
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"NhacCuaTui"
                                                            message:SEND_SMS_NOTE
                                                           delegate:self
                                                  cancelButtonTitle:OK_TITLE
                                                  otherButtonTitles:ALERT_CANCEL_BUTTON,nil];
        
        [alertView show];
    }
}

- (IBAction)btnBack_Tapped:(id)sender {
    if (self.presentingViewController != nil) {
        if (APPDELEGATE.nowPlayerVC) {
            [APPDELEGATE.nowPlayerVC didRotateTo];
        }

        [self dismissViewControllerAnimated:YES completion:^{
            [APPDELEGATE.nowPlayerVC presentViewFromPlayer:NO];
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)btnForget_Tapped:(id)sender {
    if (IS_IPAD) {
        if (_delegate && [_delegate respondsToSelector:@selector(showForgetPassword)]) {
            [_delegate showForgetPassword];
        }
    }else{
        NSString *urlStr  = @"https://mid.nct.vn/quen-mat-khau";
        TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:urlStr]];
        webBrowser.showReloadButton = YES;
        webBrowser.showActionButton = YES;
        webBrowser.mode = TSMiniWebBrowserModeModal;
        webBrowser.barStyle = UIBarStyleDefault;
        webBrowser.modalDismissButtonTitle = @"";
        
        [self.navigationController presentViewController:webBrowser animated:YES completion:^{
            if (webBrowser) {
                [webBrowser didShow];
            }
        }];
    }
}

- (IBAction)btnFBLogin_Tapped:(id)sender {
    [[FacebookLoginTask sharedInstance] setTheTask:kTaskLogin];
    [[FacebookLoginTask sharedInstance] setDelegate:self];
    [[FacebookLoginTask sharedInstance] loginFacebook];
}

- (IBAction)btnGGSignIn_Tapped:(id)sender {
    [[GooglePlusLoginTask shareInstance] setTheTask:kTaskLogin];
    [[GooglePlusLoginTask shareInstance] setDelegate:self];
    [[GooglePlusLoginTask shareInstance] loginGooglePlus];
}

-(void)loginSuccessWithTask:(NSString *)task{
    if (_delegate && [_delegate respondsToSelector:@selector(loginVC:withTask:)]) {
        [_delegate loginVC:self withTask:_theTask];
    }
    if (!IS_IPAD) {
        if (self.presentingViewController != nil) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)loginFailWithTask:(NSString *)task {

}


//#pragma mark - SignInGooglePlus Delegate
//- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
//    if (error) {
//        // handle error login
//    } else {
//        [[GooglePlusLoginTask shareInstance]didFinishedWithAuth:auth];
//    }
//}

#pragma mark - Orientation

- (BOOL) shouldAutorotate
{
    return APPDELEGATE.nowPlayerVC.isShowNowPlaying;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[UIApplication sharedApplication] statusBarOrientation];
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (APPDELEGATE.nowPlayerVC) {
        [APPDELEGATE.nowPlayerVC willRotateTo:toInterfaceOrientation];
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if (APPDELEGATE.nowPlayerVC) {
        [APPDELEGATE.nowPlayerVC didRotateTo];
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    if (!APPDELEGATE.nowPlayerVC.isShowNowPlaying) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:OK_TITLE])
    {
        
        [self sendSMS];
    }
}
-(void)sendSMS
{
    [self.txtUsername resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass != nil)
    {
        if ([messageClass canSendText])
        {
            [self displaySMSComposerSheet];
            return;
        }
    }
    NSString *message = @"Thiết bị không hỗ trợ chức năng gửi tin nhắn SMS.";
    UIAlertView* view = [[UIAlertView alloc]
                         initWithTitle:nil
                         message:message
                         delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
    [view show];    
}

#pragma mark Compose SMS
-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.recipients = [NSArray arrayWithObjects:@"8536", nil] ;
    picker.body = @"NCT DK";
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark Dismiss SMS view controller
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultSent:{
            UIAlertView* view = [[UIAlertView alloc]
                                 initWithTitle:nil
                                 message:SEND_SMS_SUCESSED
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
            [view show];
        }
            break;
        case MessageComposeResultFailed:{
            UIAlertView* view = [[UIAlertView alloc]
                                 initWithTitle:nil
                                 message:SEND_SMS_FAILED
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
            [view show];
        }
            
            break;
        default:
            
            break;
    }
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated: completion:)])
    {
        [self performSelector:@selector(dismissViewControllerAnimated: completion:) withObject:[NSNumber numberWithBool:YES] withObject:nil];
    }
    else
    {
        [self performSelector:@selector(dismissModalViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES]];
    }
}
@end

@implementation LoginNavigationController

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if (self.topViewController != nil)
        return [self.topViewController preferredInterfaceOrientationForPresentation];
    else
        return [super  preferredInterfaceOrientationForPresentation];
}

@end