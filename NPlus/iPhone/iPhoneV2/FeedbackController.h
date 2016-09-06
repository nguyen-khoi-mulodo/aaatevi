//
//  FeedbackController.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/19/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "BaseVC.h"

@interface FeedbackController : BaseVC

@property (weak, nonatomic) IBOutlet UILabel *lblRequired;
@property (weak, nonatomic) IBOutlet UITextView *txtDesc;
@property (weak, nonatomic) IBOutlet UITextField *txtNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *viewButton;

@end
