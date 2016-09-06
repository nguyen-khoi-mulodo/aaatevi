//
//  PowerUserVC.m
//  NPlus
//
//  Created by Anh Le Duc on 11/12/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "PowerUserVC.h"
#import <MessageUI/MessageUI.h>
#define OFF_ADS     @"Tắt quảng cáo"
#define RES_PU      @"Bạn chưa phải Power User"
#define SEC_RES     @"Đăng kí Power User"
#define SEC_DATE    @"Ngày hết hạn Power User"
@interface PowerUserVC ()<UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate>

@end

@implementation PowerUserVC

-(NSString *)screenNameGA{
    return @"PU";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (!IS_IPAD) {
        self.navigationController.navigationBarHidden = NO;
        if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
            UIImage *image = [UIImage imageNamed:@"personal_bg_header"];
            [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
            self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
        }
    }
    UIBarButtonItem *barBack = [[UIBarButtonItem alloc] initWithCustomView:_btnBack];
    self.navigationItem.leftBarButtonItem = barBack;
    self.view.backgroundColor = BACKGROUND_COLOR;
    [_btnBack setTitleColor:(IS_IPAD) ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
    [_btnBack setTitleColor:(IS_IPAD) ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateHighlighted];
    [_btnBack setImage:(IS_IPAD) ? imageNameWithMaskBlueColor(@"icon_back") : imageNameWithMaskWhiteColor(@"icon_back") forState:UIControlStateNormal];
    [_btnBack setImage:(IS_IPAD) ? imageNameWithMaskBlueColor(@"icon_back") : imageNameWithMaskWhiteColor(@"icon_back") forState:UIControlStateHighlighted];
    _tbMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbMain.backgroundColor = [UIColor clearColor];
    [self loadData];
}

- (void)loadData{
    [self.dataSources removeAllObjects];
    [self.dataSources addObject:@[OFF_ADS]];
    
    if (APPDELEGATE.user) {
        [self.dataSources addObject:@[RES_PU]];
    }else{
        [self.dataSources addObject:@[RES_PU]];
    }
    [_tbMain reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cell.bounds.size.height)];
        imageView.tag = 100;
        [cell.contentView addSubview:imageView];
        
        UISwitch *switchAllow = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 28)];
        switchAllow.center = CGPointMake((IS_IPAD) ? (320 - 40) : SCREEN_SIZE.width - 40, cell.center.y);
        switchAllow.tag = 101;
        switchAllow.onTintColor = COLOR_MAIN_BLUE;
        [switchAllow addTarget:self  action:@selector(switchAllow_Changed:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:switchAllow];
        
        UIButton *btnRes  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 29)];
        btnRes.center = CGPointMake((IS_IPAD) ? (320 - 55) : SCREEN_SIZE.width - 55, cell.center.y);
        UIImage *normalImage = [UIImage imageNamed:@"bg_btn"];
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 20, 0, 20);
        UIImage *stretchableNormalImage = [normalImage resizableImageWithCapInsets:inset];
        [btnRes setBackgroundImage:stretchableNormalImage forState:UIControlStateNormal];
        btnRes.tag = 102;
        [btnRes addTarget:self action:@selector(btnRegis_Tapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnRes];
    }
    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:100];
    UISwitch *switchAllow = (UISwitch*)[cell.contentView viewWithTag:101];
    UIButton *btnRes = (UIButton*)[cell.contentView viewWithTag:102];
    if (indexPath.section > self.dataSources.count) {
        return cell;
    }
    NSArray *arr = [self.dataSources objectAtIndex:indexPath.section];
    if (indexPath.row > arr.count) {
        return cell;
    }
    if (indexPath.section == 0) {
        NSString *lb = @"Tắt quảng cáo";
        cell.textLabel.text = lb;
        switchAllow.hidden = NO;
        btnRes.hidden = YES;
    }else{
        switchAllow.hidden = YES;
        btnRes.hidden = NO;
        if (APPDELEGATE.user.powerUser) {
            cell.textLabel.text = APPDELEGATE.user.expire;
            [btnRes setTitle:@"Gia hạn" forState:UIControlStateNormal];
        }else{
            cell.textLabel.text = @"Bạn chưa phải Power User";
            [btnRes setTitle:@"Đăng kí" forState:UIControlStateNormal];
        }
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.textColor = RGB(68, 68, 68);
    [imageView setImage:[self cellBackgroundForRowAtIndexPath:indexPath]];
    
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        if (APPDELEGATE.user.powerUser) {
            return @"Ngày hết hạn Power User";
        }
        return @"Đăng ký Power User";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
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
- (IBAction)btnBack_Tapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)switchAllow_Changed:(UISwitch*)sw{
    BOOL isOn = sw.isOn;
    if (isOn&&!APPDELEGATE.user.powerUser) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"NhacCuaTui"
                                                            message:[NSString stringWithFormat:@"Để tắt quảng cáo, hãy đăng ký Power User. Soạn NCT %@ gửi đến 8736 để đăng ký Power User 3 tháng. Phí 15.000 VNĐ. Nếu bạn đã đăng ký Power User, bạn cần đăng xuất và đăng nhập lại để cập nhật tài khoản.", APPDELEGATE.user.userName]
                                                           delegate:self
                                                  cancelButtonTitle:OK_TITLE
                                                  otherButtonTitles:CANCEL_TITLE,nil];
        
        [alertView show];
        [sw setOn:NO];
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:sw.isOn] forKey:SETTING_ADS_ON_OFF];
    [defaults synchronize];
}

- (BOOL)isOffShowADS{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:SETTING_ADS_ON_OFF]) {
        BOOL isOn = [[defaults objectForKey:SETTING_ADS_ON_OFF] boolValue];
        return isOn;
    }
    return NO;
}

- (void)btnRegis_Tapped:(UIButton*)sender {
    if (APPDELEGATE.user.powerUser) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"NhacCuaTui"
                                                            message:[NSString stringWithFormat:@"Để gia hạn Power User. Soạn NCT %@ gửi đến 8736 để gia hạn Power User 3 tháng. Phí 15.000 VNĐ. Nếu bạn đã gia hạn Power User, bạn cần đăng xuất và đăng nhập lại để cập nhật tài khoản.", APPDELEGATE.user.userName]
                                                           delegate:self
                                                  cancelButtonTitle:OK_TITLE
                                                  otherButtonTitles:CANCEL_TITLE,nil];
        
        [alertView show];
    }else{
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"NhacCuaTui"
                                                            message:[NSString stringWithFormat:@"Để tắt quảng cáo, hãy đăng ký Power User. Soạn NCT %@ gửi đến 8736 để đăng ký Power User 3 tháng. Phí 15.000 VNĐ. Nếu bạn đã đăng ký Power User, bạn cần đăng xuất và đăng nhập lại để cập nhật tài khoản.", APPDELEGATE.user.userName]
                                                           delegate:self
                                                  cancelButtonTitle:OK_TITLE
                                                  otherButtonTitles:CANCEL_TITLE,nil];
        
        [alertView show];
    }
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
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass != nil)
    {
        if ([messageClass canSendText])
        {
            [self displaySMSComposerSheet];
            return;
        }
    }
    NSString *message = @"Thiết bị không hỗ trợ chức năng gửi tin nhắn SMS";
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
    picker.recipients = [NSArray arrayWithObjects:@"8736", nil] ;
    picker.body = [NSString stringWithFormat:@"NCT %@ ", APPDELEGATE.user.userName];
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
