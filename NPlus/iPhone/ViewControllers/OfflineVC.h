//
//  OfflineVC.h
//  NPlus
//
//  Created by Anh Le Duc on 7/29/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "BaseVC.h"

@interface OfflineVC : BaseVC
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UITableView *tbMain;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIView *viewMenu;
@property (weak, nonatomic) IBOutlet UIView *viewSeparator;
@property (weak, nonatomic) IBOutlet UIView *viewSeparator2;
@property (weak, nonatomic) IBOutlet UIView *viewSeparator3;
@property (weak, nonatomic) IBOutlet UIButton *btnDownloaded;
@property (weak, nonatomic) IBOutlet UIButton *btnDownloading;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (strong, nonatomic) IBOutlet UIView *viewEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckAll;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIView *viewLeft;
@property (weak, nonatomic) IBOutlet UIView *viewRight;

@property (strong, nonatomic) IBOutlet UIView *viewDiskSpace;
@property (weak, nonatomic) IBOutlet UILabel *lbInfoSpace;
@property (weak, nonatomic) IBOutlet UIProgressView *propressSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewDiskSpace_Bottom;


- (IBAction)btnBack_Tapped:(id)sender;
- (IBAction)btnDownloaded_Tapped:(id)sender;
- (IBAction)btnDownloading_Tapped:(id)sender;
- (IBAction)btnEdit_Tapped:(id)sender;
- (IBAction)btnCheckAll_Tapped:(id)sender;
- (IBAction)btnDelete_Tapped:(id)sender;

@end
