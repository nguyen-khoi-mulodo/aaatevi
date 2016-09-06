//
//  CuaTuiVC.h
//  NPlus
//
//  Created by Anh Le Duc on 7/29/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "BaseVC.h"

@interface CuaTuiVC : BaseVC
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UICollectionView *cvMain;
@property (weak, nonatomic) IBOutlet UIButton *btnShop;
@property (weak, nonatomic) IBOutlet UIButton *btnSetting;
@property (weak, nonatomic) IBOutlet UIButton *btnInfoUser;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (nonatomic, strong) NSMutableArray *pages;
@property (weak, nonatomic) IBOutlet UIButton *btnDownload;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
- (IBAction)btnLogin_Tapped:(id)sender;
- (IBAction)btnDownload_Tapped:(id)sender;
- (IBAction)btnSetting_Tapped:(id)sender;

@end
