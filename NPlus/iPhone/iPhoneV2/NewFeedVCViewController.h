//
//  NewFeedVCViewController.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 7/7/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "HomeVC.h"

@interface NewFeedVCViewController : BaseVC
@property (weak, nonatomic) IBOutlet UITableView *tbNewFeed;
@property (weak, nonatomic) IBOutlet UIView *viewNoData;
@property (weak, nonatomic) IBOutlet UIImageView *imvError;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property (weak, nonatomic) IBOutlet UIButton *btnsignIn;
@property (assign, nonatomic) BOOL isNew;
@property (weak, nonatomic) IBOutlet UIView *viewNoConnection;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;

@end
