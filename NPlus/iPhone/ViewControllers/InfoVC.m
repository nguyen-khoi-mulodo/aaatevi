//
//  InfoVC.m
//  NPlus
//
//  Created by Anh Le Duc on 11/12/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import "InfoVC.h"
#import "TSMiniWebBrowser.h"
#import "DeviceInfo.h"
@interface InfoVC ()<MFMailComposeViewControllerDelegate>

@end

@implementation InfoVC

-(NSString *)screenNameGA{
    return @"ThongTin";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *barBack = [[UIBarButtonItem alloc] initWithCustomView:_btnBack];
    self.navigationItem.leftBarButtonItem = barBack;
    [_btnBack setTitleColor:(IS_IPAD) ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
    [_btnBack setTitleColor:(IS_IPAD) ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateHighlighted];
//    [_btnBack setImage:(IS_IPAD) ? imageNameWithMaskBlueColor(@"icon_back") : imageNameWithMaskWhiteColor(@"icon_back") forState:UIControlStateNormal];
//    [_btnBack setImage:(IS_IPAD) ? imageNameWithMaskBlueColor(@"icon_back") : imageNameWithMaskWhiteColor(@"icon_back") forState:UIControlStateHighlighted];
    
    // Do any additional setup after loading the view from its nib.
    NSString* stringInfo = @"";
    if (IS_IPAD) {
        stringInfo = @"TEVI dành cho iPad \nPhiên bản: v%@ \n\nTEVI Inc. \n\nBản quyền © 2015 TEVI Inc. Giữ toàn quyền. \n\n\nĐây là phần mềm cài đặt miễn phí. Những chi phí 2G/3G/wifi phát sinh trong quá trình sử dụng phần mềm này đều do nhà mạng thu phí.";
    }else{
        stringInfo = @"TEVI dành cho iPhone \nPhiên bản: v%@ \n\nTEVI Inc. \n\nBản quyền © 2015 TEVI Inc. Giữ toàn quyền. \n\n\nĐây là phần mềm cài đặt miễn phí. Những chi phí 2G/3G/wifi phát sinh trong quá trình sử dụng phần mềm này đều do nhà mạng thu phí.";
    }
    
    [_lbDesc setText:[NSString stringWithFormat:stringInfo, [DeviceInfo sharedInstance].deviceAppVersion]];
    
    [_lbDesc sizeToFit];
    [_lbDesc setNeedsDisplay];
    _lbDesc.textColor = RGB(68, 68, 68);
    if (IS_IPAD) {
        _lbDesc.translatesAutoresizingMaskIntoConstraints = YES;
        if (IOS_VERSION_LOWER_THAN_8) {
            [_lbDesc setFrame:CGRectMake(_lbDesc.frame.origin.x, 10, _lbDesc.frame.size.width, _lbDesc.frame.size.height)];
        }else{
            [_lbDesc setFrame:CGRectMake(_lbDesc.frame.origin.x, 10, 282, 300)];
        }
    }
    _lbLienHe.textColor = RGB(68, 68, 68);
    
//    NSLog(@"%@", NSStringFromCGRect(_lbLienHe.frame));
    [_btnThoaThuan addTarget:self action:@selector(btnThoaThuan_Tapped) forControlEvents:UIControlEventTouchUpInside];
    [_btnThoaThuan setTitle:@"Thoả thuận sử dụng" forState:UIControlStateNormal];
    [_btnThoaThuan setTitleColor:COLOR_MAIN_BLUE forState:UIControlStateNormal];
    _btnThoaThuan.titleLabel.font = [UIFont systemFontOfSize:14];
    _btnThoaThuan.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"Thoả thuận sử dụng"];
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
    [_btnThoaThuan setAttributedTitle: titleString forState:UIControlStateNormal];
    
    [_btnSupport setTitle:@"msupport@nct.vn" forState:UIControlStateNormal];
    [_btnSupport setTitleColor:COLOR_MAIN_BLUE forState:UIControlStateNormal];
    _btnSupport.titleLabel.font = [UIFont systemFontOfSize:14];
    _btnSupport.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    titleString = [[NSMutableAttributedString alloc] initWithString:@"msupport@nct.vn"];
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
    [_btnSupport setAttributedTitle: titleString forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)btnThoaThuan_Tapped{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [mainBundle URLForResource:@"thoathuansudung" withExtension:@"html"];
    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:url];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnSupport_Tapped:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *emailer = [[MFMailComposeViewController alloc] init];
        emailer.mailComposeDelegate = self;
        [emailer setToRecipients:[NSArray arrayWithObject:kEmail]];
        NSString *sub = @"Góp ý NhacCuaTui App - iPhone";
        if (IS_IPAD) {
            sub = @"Góp ý NhacCuaTui App - iPad";
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

- (IBAction)btnBack_Tapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
