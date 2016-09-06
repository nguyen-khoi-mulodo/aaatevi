//
//  InfoVC.h
//  NPlus
//
//  Created by Anh Le Duc on 11/12/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "BaseVC.h"

@interface InfoVC : BaseVC
@property (weak, nonatomic) IBOutlet UILabel *lbDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnThoaThuan;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnSupport;
@property (weak, nonatomic) IBOutlet UILabel *lbLienHe;
- (IBAction)btnSupport_Tapped:(id)sender;
- (IBAction)btnBack_Tapped:(id)sender;

@end
