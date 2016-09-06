//
//  SettingController.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/17/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "BaseVC.h"

@interface SettingController : BaseVC

@property (weak, nonatomic) IBOutlet UITableView *tbSetting;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;
@property (strong, nonatomic) IBOutlet UIView *viewFooter;

@end
