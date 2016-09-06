//
//  LoginAlertVC_iPad.m
//  NPlus
//
//  Created by Vo Chuong Thien on 4/8/15.
//  Copyright (c) 2015 TEVI Team. All rights reserved.
//

#import "LoginAlertVC_iPad.h"


@interface LoginAlertVC_iPad ()

@end

@implementation LoginAlertVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    loginAlertView.layer.cornerRadius = 10.0f;
    loginAlertView.layer.masksToBounds = YES;
    
    [lbTitleHeader setFont:[UIFont fontWithName:kFontSemibold size:17.0f]];
    [lbNotifLogin setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapClose:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleTapClose: (UITapGestureRecognizer *)recognizer
{
    [self hideLoginAlert];
}

- (void) hideLoginAlert{
    [self.view removeFromSuperview];
}

// Implement the UIGestureRecognizerDelegate method
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // Determine if the touch is inside the custom subview
    if ([touch view] == loginAlertView){
        // If it is, prevent all of the delegate's gesture recognizers
        // from receiving the touch
        return NO;
    }
    return YES;
}

- (IBAction) doLogin:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginWithTask:)]) {
        [self.delegate loginWithTask:self.task];
    }
    
}

-(void)loginSuccessWithTask:(NSString *)task{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginSuccessWithTask:)]) {
        [self.delegate loginSuccessWithTask:task];
    }
}

- (IBAction) doClose:(id)sender{
    [self hideLoginAlert];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
