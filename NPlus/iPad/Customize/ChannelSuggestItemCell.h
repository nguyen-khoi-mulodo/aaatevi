//
//  VideoHotCell.h
//  NPlus
//
//  Created by Vo Chuong Thien on 1/21/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelSuggestItemCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView* thumbImage;
@property (nonatomic, weak) IBOutlet UILabel* lbTitle;
@property (nonatomic, weak) IBOutlet UILabel* lbRating;
@property (nonatomic, weak) IBOutlet UILabel* lbUsersView;

@property (nonatomic, weak) IBOutlet UIView* vFollow;
@property (nonatomic, weak) IBOutlet UIView* vRating;
- (void) setContentWithChannel:(Channel*) channel;
@end
