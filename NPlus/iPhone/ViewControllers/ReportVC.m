//
//  ReportVC.m
//  NPlus
//
//  Created by Anh Le Duc on 11/12/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "ReportVC.h"

@interface ReportVC ()

@end

@implementation ReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"personal_bg_header"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    }
    UIBarButtonItem *barStore = [[UIBarButtonItem alloc] initWithCustomView:_btnStore];
    UIBarButtonItem *barBack = [[UIBarButtonItem alloc] initWithCustomView:_btnBack];
    self.navigationItem.rightBarButtonItem = barStore;
    self.navigationItem.leftBarButtonItem = barBack;
    self.view.backgroundColor = BACKGROUND_COLOR;
    [_btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_btnBack setImage:imageNameWithMaskWhiteColor(@"icon_back") forState:UIControlStateNormal];
    [_btnBack setImage:imageNameWithMaskWhiteColor(@"icon_back") forState:UIControlStateHighlighted];
    
    UIImage *background = [UIImage imageNamed:@"theloai_cell_group"];
    UIEdgeInsets insets = UIEdgeInsetsMake(8, 12, 8, 12);
    UIImage *stretchableImage = [background resizableImageWithCapInsets:insets];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _mainView.frame.size.width, _mainView.frame.size.height)];
    imgView.image = stretchableImage;
    [_mainView insertSubview:imgView atIndex:0];
    _mainView.backgroundColor = [UIColor clearColor];
    UIImage *normalImage = [UIImage imageNamed:@"bg_btn"];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 20, 0, 20);
    UIImage *stretchableNormalImage = [normalImage resizableImageWithCapInsets:inset];
    [_btnSubmit setBackgroundImage:stretchableNormalImage forState:UIControlStateNormal];
    
    _txtEmail.layer.borderWidth = 0.5f;
    _txtEmail.layer.borderColor = RGB(226, 226, 226).CGColor;
    _txtEmail.layer.cornerRadius = 2.0f;
    _txtEmail.backgroundColor = RGB(242, 244, 245);
    
    _tvMessage.layer.borderWidth = 0.5f;
    _tvMessage.layer.borderColor = RGB(226, 226, 226).CGColor;
    _tvMessage.layer.cornerRadius = 2.0f;
    _tvMessage.backgroundColor = RGB(242, 244, 245);
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

- (IBAction)btnBack_Tapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnStore_Tapped:(id)sender {
}

- (IBAction)btnSubmit_Tapped:(id)sender {
}
@end
