//
//  DetailController.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/11/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "HomeVC.h"
#import "DetailInfoTableViewCell.h"
#import "UILabelViewFlowLayout.h"

@interface DetailController : HomeVC <UITableViewDelegate,UITableViewDataSource,DetailInfoCellDelegate,GenreTagViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgThumb;
@property (weak, nonatomic) IBOutlet UITableView *tbInfo;
@property (strong, nonatomic) IBOutlet UIView *headerChannel;
@property (strong, nonatomic) IBOutlet UIView *viewInfo;


@property (strong, nonatomic) IBOutlet UIView *headerInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblRating;
@property (weak, nonatomic) IBOutlet UILabel *lblFollow;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *lblView;
@property (weak, nonatomic) IBOutlet UILabel *lblChannelName;

@property (weak, nonatomic) IBOutlet UILabel *lblDirectorName;
@property (weak, nonatomic) IBOutlet UILabel *lblBroadcast;
@property (weak, nonatomic) IBOutlet UILabel *lblCountry;
@property (weak, nonatomic) IBOutlet UILabel *lblProducer;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblNameScroll;
@property (weak, nonatomic) IBOutlet UILabel *lblViewCountScroll;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelScroll;
@property (weak, nonatomic) IBOutlet UILabel *lblDesrScroll;


@property (strong, nonatomic) Channel *channel;

@end
