//
//  ChannelHeaderCell.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 7/7/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Channel.h"

@interface ChannelHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imvThumb;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowNum;


@property (strong, nonatomic) Channel *channel;
- (void)configCell;

@end
