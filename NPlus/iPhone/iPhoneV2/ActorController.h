//
//  ActorController.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/13/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "HomeVC.h"

@interface ActorController : HomeVC 
@property (weak, nonatomic) IBOutlet UIView *viewImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgCover;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (strong, nonatomic) IBOutlet UIView *viewInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblFullName;
@property (weak, nonatomic) IBOutlet UILabel *lblFullName1;

@property (weak, nonatomic) IBOutlet UILabel *lblBirthday;
@property (weak, nonatomic) IBOutlet UILabel *lblBirthday1;

@property (weak, nonatomic) IBOutlet UILabel *lblNational;
@property (weak, nonatomic) IBOutlet UILabel *lblNational1;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UILabel *lblFullDes;

@property (strong, nonatomic) IBOutlet UIScrollView *viewFullInfo;


@property (weak, nonatomic) IBOutlet UITableView *tbInfo;
@property (strong, nonatomic) Artist *artist;

@end
