//
//  VideoHotCell.h
//  NPlus
//
//  Created by Vo Chuong Thien on 1/21/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Season.h"

@interface SeasonItemCell : UITableViewCell


@property (nonatomic, weak) IBOutlet UIImageView* thumbImage;
@property (nonatomic, weak) IBOutlet UILabel* lbTitle;
@property (nonatomic, weak) IBOutlet UILabel* lbVideos;

- (void) setContentWithSeason:(Season*) season;

@end
