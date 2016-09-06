//
//  ReportVC.h
//  NPlus
//
//  Created by Anh Le Duc on 11/12/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "BaseVC.h"

@interface ReportVC : BaseVC
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIButton *btnStore;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollMain;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextView *tvMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
- (IBAction)btnBack_Tapped:(id)sender;
- (IBAction)btnStore_Tapped:(id)sender;
- (IBAction)btnSubmit_Tapped:(id)sender;

@end
