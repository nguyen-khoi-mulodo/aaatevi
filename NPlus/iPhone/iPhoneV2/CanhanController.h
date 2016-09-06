//
//  CanhanController.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/27/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "BaseVC.h"
#import "HomeHeaderSection.h"
#import "LocalNotif.h"

@interface CanhanController : BaseVC <UITableViewDelegate,UITableViewDataSource,HomeHeaderSectionDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnSetting;
@property (weak, nonatomic) IBOutlet UIButton *btnWatchLater;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UIButton *btnDownload;
@property (weak, nonatomic) IBOutlet UITableView *tbMain;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;



@end
