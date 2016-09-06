//
//  FeedbackController.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/19/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "FeedbackController.h"
#import "MyButton.h"
#import "Feedback.h"
#import "MyNavigationItem.h"

@interface FeedbackController () <UITextViewDelegate,UITextFieldDelegate>{
    Feedback *feedback;
    IBOutlet UITapGestureRecognizer *gestuer;
    __weak IBOutlet UIView *viewGesture;
    MyNavigationItem *myNavi;
    short feedbackId;
}

@end

@implementation FeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    myNavi = [[MyNavigationItem alloc] initWithController:self type:9];
    _btnSend.layer.cornerRadius = 5;
    _btnSend.clipsToBounds = YES;
    _txtDesc.clipsToBounds = YES;
    _txtDesc.layer.cornerRadius = 3;
    _txtDesc.layer.borderColor = UIColorFromRGB(0xf0f0f0).CGColor;
    _txtDesc.layer.borderWidth = 1;
    _lblRequired.textColor = UIColorFromRGB(0xFF4040);
    [self loadFeedBack];
    [viewGesture addGestureRecognizer:gestuer];
    viewGesture.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Góp ý - báo lỗi";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_scrollView setContentSize:CGSizeMake(SCREEN_SIZE.width, _btnSend.frame.origin.y + 100)];
//    _txtNumber.clipsToBounds = YES;
//    _txtNumber.layer.cornerRadius = 3;
//    _txtNumber.layer.borderColor = UIColorFromRGB(0xf0f0f0).CGColor;
//    _txtNumber.layer.borderWidth = 1;
    _txtNumber.borderStyle = UITextBorderStyleRoundedRect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadFeedBack {
    [[APIController sharedInstance]getFeedbackObjectCompleted:^(int code, NSArray *results) {
        if (results) {
            self.dataSources = (NSMutableArray*)results;
            [self updateFeedbackButton:results];
        }
    } failed:^(NSError *error) {
        
    }];
}

- (void)updateFeedbackButton:(NSArray*)arrayFeedback {
    if (arrayFeedback.count >= 6) {
        for (int i = 0; i < 6; i++) {
            Feedback *fb = [arrayFeedback objectAtIndex:i];
            MyButton *button = [[MyButton alloc]init];
            button.tag = i;
            [button setTitle: fb.title forState:UIControlStateNormal];
            [button addTarget:self action:@selector(btnFeedbackTaaped:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:UIColorFromRGB(0xa4a4a4) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont fontWithName:kFontRegular size:13];
            CGFloat w = (SCREEN_SIZE.width - 52)/2;
            CGFloat x = i%2==0 ? 10 : 30 + w;
            CGFloat h = 40;
            CGFloat y = 6;
            if (i == 2 || i == 3) {
                y = 62;
            } else if (i == 4 || i == 5) {
                y = 118;
            }
            button.frame = CGRectMake(x, y,w ,h);
            [_viewButton addSubview:button];
            if (i == 5) {
                button.selected = YES;
            }
        }
    }
}

- (void)btnFeedbackTaaped:(id)sender {
    _lblRequired.textColor = UIColorFromRGB(0x212121);
    MyButton *myBtn = (MyButton*)sender;
    for (UIView *view in _viewButton.subviews) {
        if ([view isKindOfClass:[MyButton class]]) {
            MyButton *btn = (MyButton*)view;
            if ([btn isEqual:myBtn]) {
                if (!btn.selected) {
                    myBtn.selected = YES;
                }
            } else {
                btn.selected = NO;
            }
        }
    }
    if (myBtn.selected) {
        feedback = [self.dataSources objectAtIndex:myBtn.tag];
        _txtDesc.text = feedback.title;
    }
    
}
- (IBAction)gestureAction:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (IBAction)btnSendTapped:(id)sender {
    if (!_txtNumber.text) {
        _txtNumber.text = @"";
    }
    if ([_txtDesc.text isEqualToString:@""]) {
        return;
    }
    NSString *trimmedKeyword = [_txtDesc.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([trimmedKeyword isEqualToString:@""]) {
        return;
    }
    if (!feedback) {
        feedback = [[Feedback alloc]init];
        feedback.feedbackId = 5;
    }
    [[APIController sharedInstance]userFeedbackWithId:feedback.feedbackId content:_txtDesc.text phone:_txtNumber.text completed:^(int code, BOOL result) {
        if (result) {
            [APPDELEGATE showToastWithMessage:@"Cảm ơn bạn đã gửi góp ý báo lỗi!" position:@"top" type:doneImage];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark - UITextView

- (void)textViewDidBeginEditing:(UITextView *)textView {
    viewGesture.hidden = NO;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    viewGesture.hidden = YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    NSString *trimmedKeyword = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([trimmedKeyword isEqualToString:@""]) {
        _lblRequired.textColor = UIColorFromRGB(0xFF4040);
    } else {
        _lblRequired.textColor = UIColorFromRGB(0x212121);
    }
}

#pragma mark - UITextFiled 
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    viewGesture.hidden = NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    viewGesture.hidden = YES;
}
@end
