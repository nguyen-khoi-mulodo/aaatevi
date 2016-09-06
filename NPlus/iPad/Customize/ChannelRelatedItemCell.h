//
//  VideoHotCell.h
//  NPlus
//
//  Created by Vo Chuong Thien on 1/21/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelRelatedItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView* mContentView;
@property (nonatomic, weak) IBOutlet UIImageView* thumbImage;
@property (nonatomic, weak) IBOutlet UILabel* lbTitle;
@property (nonatomic, weak) IBOutlet UILabel* lbSubTitle;
@property (nonatomic, weak) IBOutlet UILabel* lbTime;
@property (nonatomic, weak) IBOutlet UIImageView* imvHD;

- (void) setContent:(Video*) video;

- (void) commonInit;
@end
