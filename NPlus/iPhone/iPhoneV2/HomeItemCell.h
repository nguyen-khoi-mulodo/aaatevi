//
//  HomeItemCell.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/25/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeItemCellDelegate <NSObject>

- (void)itemTapped:(id)object;

@end

@interface HomeItemCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;

@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;

@property (weak, nonatomic) IBOutlet UILabel *subTitle1;
@property (weak, nonatomic) IBOutlet UILabel *subTitle2;

@property (weak, nonatomic) IBOutlet UIImageView *iconView1;
@property (weak, nonatomic) IBOutlet UIImageView *iconView2;

@property (weak, nonatomic) IBOutlet UILabel *lblView1;
@property (weak, nonatomic) IBOutlet UILabel *lblView2;

@property (weak, nonatomic) IBOutlet UIView *gradientView;

@property (weak, nonatomic) IBOutlet UILabel *lblDuration1;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration2;

@property (weak, nonatomic) IBOutlet UILabel *lblRating1;


@property (weak, nonatomic) IBOutlet UIButton *btnItem1;
@property (weak, nonatomic) IBOutlet UIButton *btnItem2;
@property (weak, nonatomic) IBOutlet UILabel *lblRating2;
@property (weak, nonatomic) IBOutlet UIImageView *imgTransfer;

@property (weak, nonatomic) IBOutlet UIImageView *iconHD1;
@property (weak, nonatomic) IBOutlet UIImageView *iconHD2;

@property (strong, nonatomic) Video *video1;
@property (strong, nonatomic) Video *video2;

@property (strong, nonatomic) Channel *channel1;
@property (strong, nonatomic) Channel *channel2;

@property (assign, nonatomic) TypeCell typeCell;

@property (strong, nonatomic) id<HomeItemCellDelegate> delegate;

- (void)loadContentViewWithType:(TypeCell)type;

@end
